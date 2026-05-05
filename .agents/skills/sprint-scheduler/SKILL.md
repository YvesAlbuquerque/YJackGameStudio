---
name: sprint-scheduler
description: "Autonomous sprint planner and issue scheduler. Reads the dependency graph, work contracts (GitHub issues or YAML files), and autonomy configuration to propose a sprint schedule based on priority, dependencies, effort, and parallel execution safety. Respects the write-set collision protocol and YJackCore manual validation requirements. Produces a machine-readable sprint schedule with owner approval required only at sprint boundary."
argument-hint: "[--mode GUIDED|SUPERVISED|AUTONOMOUS] [--dry-run]"
user-invocable: true
allowed-tools: Read, Glob, Grep, Write, Edit, Bash, AskUserQuestion
context: |
  !cat production/dependency-graph.yml 2>/dev/null | head -50
  !cat production/autonomy-config.md 2>/dev/null
  !ls production/contracts/ 2>/dev/null | head -20
---

# Sprint Scheduler — Autonomous Issue Scheduler

This skill upgrades the `/sprint-plan` workflow to operate autonomously within
owner-set approval boundaries. It selects, sequences, and assigns work contracts
to specialist agents based on:

1. **Dependency ordering** — respects the dependency graph
2. **Write-set collision avoidance** — prevents parallel file conflicts
3. **Priority and effort** — balances Must Have / Should Have / Nice to Have
4. **Agent lane capacity** — distributes work across available specialist agents
5. **Autonomy mode boundaries** — escalates MEDIUM/HIGH risk decisions per mode
6. **YJackCore awareness** — flags manual validation and package boundary tasks

The scheduler produces a machine-readable sprint schedule that agents can consume
without manual task decomposition.

---

## Phase 0: Parse Arguments and Load Configuration

1. **Parse arguments:**
   - `--mode <GUIDED|SUPERVISED|AUTONOMOUS>` — override autonomy mode for this run
   - `--dry-run` — generate the schedule but do not write any files

2. **Load autonomy configuration:**
   - Read `production/autonomy-config.md` if it exists
   - Extract the active mode (GUIDED / SUPERVISED / AUTONOMOUS)
   - If `--mode` was passed, use that instead
   - Default to GUIDED if no config exists and no argument provided

3. **Load capacity and constraints:**
   - Read the current milestone from `production/milestones/` to get sprint capacity
   - Read the previous sprint from `production/sprints/` to understand velocity
   - Check for carryover stories from the previous sprint

---

## Phase 1: Collect Work Contracts

Work contracts can be stored in two locations:

1. **GitHub issues** using the `agent_work_contract` template
2. **YAML files** in `production/contracts/`

### Collect from GitHub Issues

Use `Bash` with `gh issue list` to query for approved contracts:

```bash
gh issue list --label "status:approved" --json number,title,labels,body --limit 100
```

Parse each issue to extract:
- `contract_id` (from issue body or labels)
- `title`
- `status` (from labels: `status:approved`, `status:in-progress`, etc.)
- `specialist_agent` (from issue body)
- `write_set` (from issue body)
- `dependencies` (from issue body)
- `risk_tier` (from labels: `auto:low`, `auto:medium`, `auto:high`)
- `yjackcore.layer` and `yjackcore.package_boundary` (if present in issue body)

### Collect from YAML Files

Use `Glob` to find all `.yml` files in `production/contracts/`:

```bash
production/contracts/*.yml
```

Read each file and extract the same fields as above.

### Merge and Deduplicate

- If both a GitHub issue and a YAML file exist for the same `contract_id`, the GitHub issue is authoritative (per work-contract-schema.md §Storage Formats).
- Build a unified list of all approved contracts.

### Filter for Sprint Eligibility

Include only contracts where:
- `status` is `approved` (not `in_progress`, `blocked`, `validated`, or `closed`)
- All `dependencies` are either `validated` or `closed` (check dependency graph)
- No write-set collision with any other `approved` or `in_progress` contract

---

## Phase 2: Dependency Graph and Readiness Check

1. **Read the dependency graph:**
   - Load `production/dependency-graph.yml`
   - Extract the current status of all contracts

2. **For each approved contract, check dependencies:**
   - Look up each entry in the contract's `dependencies` list
   - If any dependency is not `validated` or `closed`, mark the contract as `NOT_READY`
   - If all dependencies are satisfied, mark as `READY`

3. **Run write-set collision check:**
   - Use `.agents/scripts/check-write-sets.sh` to detect collisions:

   ```bash
   .agents/scripts/check-write-sets.sh production/dependency-graph.yml
   ```

   - If the script exits with code 1, collisions were found
   - Read the script output to identify which contracts conflict
   - Mark conflicting contracts as `COLLISION_BLOCKED`

4. **Filter to ready contracts:**
   - Only contracts marked `READY` (dependencies satisfied, no collisions) may be scheduled
   - All others must wait for dependencies to close or collisions to be resolved

---

## Phase 3: Prioritize and Sequence

1. **Group contracts by priority tier:**
   - **Must Have (P0)** — critical path stories from the milestone
   - **Should Have (P1)** — nice-to-have features within sprint capacity
   - **Nice to Have (P2)** — stretch goals or polish tasks

2. **Within each priority tier, sort by:**
   - **YJackCore layer depth** — GameLayer → LevelLayer → PlayerLayer → ViewLayer → Shared
     (deeper layers should be implemented first to establish architectural foundation)
   - **Effort estimate** — smaller tasks first within the same layer (enables faster feedback loops)
   - **Risk tier** — LOW before MEDIUM before HIGH (reduces approval churn)

3. **Assign execution lanes:**
   - Identify all unique `specialist_agent` values in the ready contracts
   - Group contracts by `specialist_agent`
   - This creates parallel execution lanes (e.g., `team:combat`, `team:ui`, `copilot`)

4. **Check lane capacity:**
   - For each lane, sum the `estimate_days` of all assigned contracts
   - Compare to the sprint capacity from the milestone
   - If any lane is over capacity, defer the lowest-priority tasks to `DEFERRED` status

---

## Phase 4: YJackCore and Manual Validation Awareness

For each contract in the schedule:

1. **Check for YJackCore package boundary:**
   - If `yjackcore.package_boundary` is `true`, flag as **HIGH_COORDINATION_RISK**
   - Package boundary tasks require explicit owner authorization regardless of autonomy mode

2. **Check for manual validation requirements:**
   - If `manual_checks` list is non-empty, flag as **MANUAL_VALIDATION_REQUIRED**
   - These tasks cannot be autonomously validated and must pause for owner review

3. **Check for Unity manual validation:**
   - If `yjackcore.layer` is not `none` or `host-only`, the task may require:
     - Unity Play Mode testing
     - Domain reload verification
     - Inspector wiring validation
   - Flag as **UNITY_VALIDATION_REQUIRED**

4. **Add scheduling notes:**
   - For each flagged contract, add a note to the schedule:
     - "⚠️ HIGH coordination risk — YJackCore package boundary"
     - "⚠️ Manual validation required — owner sign-off needed"
     - "⚠️ Unity validation required — cannot be autonomously confirmed"

---

## Phase 5: Generate Sprint Schedule

Produce a machine-readable YAML schedule at `production/sprints/schedule-sprint-NNN.yml`:

```yaml
schema_version: "1.0"
sprint: NNN
generated: "YYYY-MM-DDTHH:MM:SSZ"
generated_by: "sprint-scheduler"
autonomy_mode: "SUPERVISED"  # or GUIDED / AUTONOMOUS
capacity_days: 10
buffer_days: 2
available_days: 8

lanes:
  - agent: "team:combat"
    contracts:
      - contract_id: "STORY-014"
        title: "Player movement implementation"
        priority: must-have
        effort_days: 3
        risk_tier: HIGH
        flags:
          - "Unity validation required"
        dependencies: []

  - agent: "team:ui"
    contracts:
      - contract_id: "STORY-015"
        title: "HUD implementation"
        priority: must-have
        effort_days: 2
        risk_tier: MEDIUM
        flags: []
        dependencies:
          - STORY-014

  - agent: "copilot"
    contracts:
      - contract_id: "STORY-016"
        title: "Balance tuning"
        priority: should-have
        effort_days: 1
        risk_tier: LOW
        flags: []
        dependencies: []

deferred:
  - contract_id: "STORY-017"
    title: "Animation polish"
    priority: nice-to-have
    effort_days: 2
    reason: "Exceeds sprint capacity"

not_ready:
  - contract_id: "STORY-018"
    title: "Multiplayer sync"
    priority: should-have
    blocked_by: "Dependency STORY-012 not validated"

collision_blocked:
  - contract_id: "STORY-019"
    title: "Recipe refactor"
    conflicting_with: "STORY-014"
    reason: "Write-set collision on src/systems/crafting/"

summary:
  total_contracts: 6
  scheduled: 3
  deferred: 1
  not_ready: 1
  collision_blocked: 1
  must_have_count: 2
  should_have_count: 1
  nice_to_have_count: 0
  total_effort_days: 6
  lanes_used: 3
```

---

## Phase 6: Approval and Write

### Escalation Decision

Before writing the schedule, check the autonomy mode and schedule risk tier:

1. **If any contract in the schedule has `risk_tier: HIGH`:**
   - Always escalate to owner regardless of mode
   - Present the full schedule and ask for approval

2. **If all contracts are `risk_tier: MEDIUM` and mode is `AUTONOMOUS`:**
   - Auto-approve and proceed to write

3. **If any contract is `risk_tier: MEDIUM` and mode is `SUPERVISED` or `GUIDED`:**
   - Escalate to owner with the schedule

4. **If all contracts are `risk_tier: LOW` and mode is `SUPERVISED` or `AUTONOMOUS`:**
   - Auto-approve and proceed to write

### Approval Prompt

If escalation is required, present this prompt:

```
⚠️ APPROVAL REQUIRED [Sprint Schedule — <mode>]

Sprint NNN schedule ready:
- <N> contracts scheduled across <M> agent lanes
- <X> Must Have, <Y> Should Have, <Z> Nice to Have
- Total effort: <N> days (capacity: <M> days, buffer: <B> days)

Flags:
- <N> contracts require manual validation
- <N> contracts touch YJackCore package boundaries
- <N> contracts have HIGH risk tier

<N> contracts deferred due to capacity
<N> contracts not ready (dependency blocked)
<N> contracts blocked by write-set collisions

May I write the sprint schedule to:
- production/sprints/schedule-sprint-NNN.yml
- production/sprints/sprint-NNN.md (human-readable version)

Proceed? (yes / no / revise)
```

### Write Files

If approved (or auto-approved per autonomy mode):

1. **Write the YAML schedule:**
   - `production/sprints/schedule-sprint-NNN.yml`

2. **Write a human-readable sprint plan:**
   - `production/sprints/sprint-NNN.md`
   - Use the format from `/sprint-plan` (Phase 2)
   - Include all scheduled contracts in the appropriate priority sections
   - Add a "Deferred" section for capacity-deferred contracts
   - Add a "Blocked" section for dependency-blocked and collision-blocked contracts

3. **Update the dependency graph:**
   - For each scheduled contract, update its status to `approved` (confirmed ready for pickup)
   - For each deferred contract, add a note in the `blocked_by` field
   - Update `last_updated` and `updated_by` in the graph

4. **Log the action:**
   - Append to `production/session-state/active.md`:

   ```markdown
   ## Sprint NNN Scheduled — YYYY-MM-DD HH:MM

   Autonomy mode: <mode>
   Scheduled: <N> contracts across <M> lanes
   Deferred: <N> contracts (capacity)
   Blocked: <N> contracts (dependencies or collisions)

   Owner approval: <auto-approved | explicitly approved>
   ```

---

## Phase 7: Integration with production/sprint-status.yaml

After writing the sprint schedule, also generate or update `production/sprint-status.yaml`
to match the format expected by `/sprint-status`.

Read the YAML schedule and for each contract in the `lanes` section, create a story entry:

```yaml
stories:
  - id: "STORY-014"
    name: "Player movement implementation"
    file: "production/stories/1-movement.md"  # infer from contract write_set or metadata
    priority: must-have
    status: ready-for-dev
    owner: "team:combat"
    estimate_days: 3
    blocker: ""
    completed: ""
```

Ask: "May I also write `production/sprint-status.yaml` to track story status?"

---

## Phase 8: Next Steps

After the sprint schedule is written:

1. **If `--dry-run` was passed:**
   - Output the schedule to stdout
   - Do not write any files
   - Exit with verdict: **DRY_RUN_COMPLETE** — schedule generated but not written

2. **If write succeeded:**
   - Verdict: **COMPLETE** — sprint NNN scheduled
   - Next steps:
     - `/story-readiness <contract-id>` — validate a contract is ready before pickup
     - `/dev-story <contract-id>` — begin implementing the first scheduled contract
     - `/sprint-status` — check progress mid-sprint
     - `.agents/scripts/check-write-sets.sh` — re-run before advancing any contract to `in_progress`

3. **If escalation was required and owner declined:**
   - Verdict: **BLOCKED** — owner declined sprint schedule
   - Prompt: "Would you like me to revise the schedule? (yes / no)"
   - If yes, ask which contracts to defer or which conflicts to resolve, then re-run Phase 3

---

## YJackCore Alignment

For YJackCore-backed projects:

1. **Read YJackCore workspace manifest:**
   - Check for `.yjack-workspace.json` at the project root
   - If present, extract the `layout`, `version`, and `modules` fields
   - Use this to detect YJackCore awareness in contracts

2. **Apply YJackCore scheduling constraints:**
   - Contracts with `yjackcore.layer` not `none` or `host-only` should be sequenced by layer depth
   - GameLayer → LevelLayer → PlayerLayer → ViewLayer → Shared
   - This ensures architectural foundation is implemented before dependent layers

3. **Flag package boundary tasks:**
   - Any contract with `yjackcore.package_boundary: true` is always HIGH risk
   - Always escalates to owner regardless of autonomy mode
   - Never auto-approved, even in AUTONOMOUS mode

4. **Flag manual validation tasks:**
   - Unity Play Mode, domain reload, and Inspector wiring cannot be autonomously confirmed
   - Contracts with `manual_checks` referencing Unity validation are flagged
   - Scheduled with a note: "Owner sign-off required after implementation"

---

## Relationship to Other Skills

| Skill | Relationship |
|-------|--------------|
| `/sprint-plan` | Sprint-scheduler is the autonomous upgrade. Sprint-plan remains for manual sprint authoring. |
| `/sprint-status` | Reads the YAML schedule and `sprint-status.yaml` to report progress. |
| `/story-readiness` | Checks a single contract for readiness. Sprint-scheduler checks all contracts. |
| `/dev-story` | Executes a single contract from the schedule. |
| `/gate-check` | Phase gate validation. Sprint-scheduler respects autonomy mode boundaries but does not invoke gates. |
| `.agents/scripts/check-write-sets.sh` | Pre-flight collision check. Sprint-scheduler calls this script before scheduling. |

---

## Collaborative Protocol

This skill operates within the autonomy mode boundaries defined in
`.agents/docs/autonomy-modes.md`:

- **GUIDED mode:** Every scheduling decision surfaced to owner before writing
- **SUPERVISED mode:** MEDIUM and HIGH risk contracts escalate; LOW auto-approved
- **AUTONOMOUS mode:** LOW and MEDIUM auto-approved; HIGH always escalates

**Hard gates (never bypassed by any mode):**
- Sprint commitment (writing the schedule) is always MEDIUM risk minimum
- Any contract with `risk_tier: HIGH` always escalates
- YJackCore package boundary tasks always escalate
- Write-set collision resolution always escalates

The owner may override the mode at any time:
```
"Set autonomy mode to GUIDED for this session."
"Switch to AUTONOMOUS mode."
```

---

## Validation

To validate the scheduler against a sample backlog:

1. Create test contracts in `production/contracts/` or as GitHub issues
2. Run `./agents/skills/sprint-scheduler/SKILL.md --dry-run`
3. Verify:
   - Dependency ordering is correct (no contract scheduled before its dependencies)
   - Write-set collisions are detected and flagged
   - Priority tiers are respected (Must Have before Should Have before Nice to Have)
   - Lane capacity is not exceeded
   - YJackCore manual validation and package boundary tasks are flagged

**Dependency-safe test:**
- All scheduled contracts have all dependencies `validated` or `closed`
- No contract is scheduled if any dependency is `approved`, `in_progress`, or `blocked`

**Collision-safe test:**
- No two contracts in the `lanes` section have overlapping `write_set` entries
- All collisions are detected and moved to the `collision_blocked` section
