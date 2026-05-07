# Agent Work Contract Schema

**Version:** 1.0  
**Last Updated:** 2026-05-04  
**Source:** [AUTO-005] from `docs/AUTONOMOUS_GAME_STUDIO_ROADMAP.md`

---

## Overview

A **work contract** is the machine-readable unit of autonomous delegation. Every
agent that starts work — whether it is executing a story, a shard, a design task,
or a QA run — must operate against a contract that defines its scope, success
criteria, write boundaries, validation expectations, and handoff requirements.

Work contracts prevent:
- **Scope creep** — agents writing outside their declared boundaries
- **Parallel collisions** — two agents writing the same file simultaneously
- **Invisible blockers** — agents silently completing half a task
- **Missing context** — agents executing without reading required input artifacts

This document defines the schema, lifecycle, status-update protocol, handoff
rules, and parallel-execution constraints for all work contracts.

---

## Schema — Required Fields

Every work contract carries the following fields. All required fields must be
present before a contract advances from `PROPOSED` to `APPROVED`.

### Identity

| Field | Type | Required | Description |
|-------|------|----------|-------------|
| `contract_id` | string | ✅ | Stable identifier. Format: `EPIC-001`, `STORY-014`, `SHARD-007`. Used for all cross-references. |
| `type` | enum | ✅ | `epic` \| `story` \| `shard`. Controls decomposition rules (see §Lifecycle). |
| `status` | enum | ✅ | Current lifecycle state (see §Lifecycle). |
| `owner` | string | ✅ | GitHub username of the person who commissioned this contract and approves its output. |
| `specialist_agent` | string | ✅ | Agent role assigned to execute this contract. Use team-routing values (`team:combat`, `team:qa`, etc.) or a specific agent name from `.agents/agents/`. For the full list of accepted values see the `Specialist Agent` dropdown in `.github/ISSUE_TEMPLATE/agent_work_contract.yml`. Use `other` and record the specific target in `notes`. |

### Intent

| Field | Type | Required | Description |
|-------|------|----------|-------------|
| `owner_goal` | string | ✅ | One sentence: what outcome does the owner want from this contract? Written from the owner's perspective. |
| `success_criteria` | list | ✅ | Verifiable checklist. Each item must be confirmable by an automated test, an agent review, or an explicit owner check. |
| `non_goals` | list | ✅ | Explicit exclusions. Items the owner has decided this contract does **not** cover. Prevents scope creep during execution. |

### Execution Context

| Field | Type | Required | Description |
|-------|------|----------|-------------|
| `dependencies` | list | — | Other contracts that must reach `VALIDATED` or `CLOSED` before this contract may advance to `IN_PROGRESS`. Each entry carries a `contract_id`, human-readable `title`, and current `status`. |
| `write_set` | list | ✅ | Files or directories this contract **exclusively** creates or modifies. Used for collision detection (see §Parallel Execution). No two contracts in parallel may share a write-set entry without explicit owner resolution. |
| `read_context` | list | — | Files the agent must read before starting work. Each entry carries a `path` and an optional `section` (heading or line range). |

### Risk and Approval

| Field | Type | Required | Description |
|-------|------|----------|-------------|
| `risk_tier` | enum | ✅ | `LOW` \| `MEDIUM` \| `HIGH`. Determines approval boundary. See [autonomy-modes.md](autonomy-modes.md). |
| `risk_classes` | list | ✅ | Risk taxonomy tags for this contract. Valid values map to `risk:*` labels from [risk-register-schema.md](risk-register-schema.md). |
| `approval_boundary` | string | ✅ | Plain-text statement of what the agent may execute autonomously vs. what requires owner approval, referencing the active autonomy mode. |
| `escalation_conditions` | list | ✅ | Specific situations that must cause the agent to stop and surface to the owner, regardless of autonomy mode. |
| `risk_register` | list | — | Structured risk entries (`risk_id`, `description`, `risk_class`, `likelihood`, `impact`, `risk_tier`, `owner`, `mitigation`, `status`, `stop_condition`, `owner_approval_trigger`). Required when `risk_classes` contains any `HIGH`-default class; see [risk-register-schema.md §Deterministic Risk Classes](risk-register-schema.md#deterministic-risk-classes). |

### Validation

| Field | Type | Required | Description |
|-------|------|----------|-------------|
| `validation` | object | ✅ | How the agent verifies its own output. Contains: `automated` (commands to run), `agent_review` (bool), `owner_review` (bool), `evidence_path` (where to commit test output). |
| `manual_checks` | list | — | Items that require human or owner validation. Every entry here is implicitly `HIGH` risk and must be escalated. |

### Documentation and Framework Impact

| Field | Type | Required | Description |
|-------|------|----------|-------------|
| `doc_impact` | list | — | Documentation files that must be updated as part of this contract. Each entry carries a `path`, optional `section`, and a brief `change` description. |
| `yjackcore` | object | — | YJackCore layer and boundary metadata (see §YJackCore Fields). Required when the contract touches any YJackCore path or layer. |

### Outputs

| Field | Type | Required | Description |
|-------|------|----------|-------------|
| `outputs` | list | ✅ | Every artifact this contract must produce or update before it may be marked `VALIDATED`. Each entry carries a `path` and `type` (`file`, `test-evidence`, `pr`, `report`). |
| `handoff` | list | ✅ | Conditions that must all be true for ownership to be released. Used to verify the contract is genuinely complete (see §Handoff Protocol). |

### Status Tracking

| Field | Type | Required | Description |
|-------|------|----------|-------------|
| `status_log` | list | — | Append-only log of every state transition. Each entry: `timestamp`, `from`, `to`, `agent`, `note`. Agents write to this section; never delete existing entries. |
| `partial_work` | object | — | If the contract is `BLOCKED`, documents what is complete (`completed` list), what remains (`remaining` list), and what is blocking (`blocked_by` string). Required when transitioning to `BLOCKED`. |

---

## YJackCore Fields

When a contract touches YJackCore paths, the `yjackcore` object carries these sub-fields:

| Field | Type | Description |
|-------|------|-------------|
| `layer` | enum | The YJackCore architectural layer this contract operates in. Valid values: `none`, `GameLayer`, `LevelLayer`, `PlayerLayer`, `CoreLayer`, `ViewLayer`, `Shared`, `host-only`, `framework-change`. |
| `package_boundary` | bool | `true` if the contract writes to `Packages/YJackCore/**` or `Packages/com.ygamedev.yjack/**`. This is always `HIGH` risk. |
| `host_game_separation` | bool | `true` if the contract involves reasoning about the host-game / YJackCore separation boundary. Triggers the YJackCore-aware agent path. |

**Layer guidance:**

| Layer | Write paths | Notes |
|-------|-------------|-------|
| `GameLayer` | `src/` top-level managers, bootstrap, game config | Host-game responsibility |
| `LevelLayer` | `src/levels/`, scene-specific logic | Host-game responsibility |
| `PlayerLayer` | `src/player/`, `src/characters/` | Host-game responsibility |
| `CoreLayer` | `Packages/YJackCore/Runtime/Core/` | Package boundary — HIGH risk |
| `ViewLayer` | `src/ui/`, `src/hud/` | Host-game responsibility for wiring; ViewLayer API is YJackCore |
| `Shared` | `src/shared/`, cross-cutting utilities | Confirm no YJackCore internal coupling |
| `host-only` | `src/**` only; zero YJackCore API contact | Confirm via grep before marking |
| `framework-change` | Any YJackCore package path | Always HIGH risk; always escalates |

When `layer` is not `none` or `host-only`, the agent must read `.agents/docs/yjackcore-support.md`
and verify the correct agent path from `.agents/docs/yjackcore-authority.md` before starting work.

---

## Contract Lifecycle

```
PROPOSED → APPROVED → IN_PROGRESS → VALIDATED → CLOSED
                             ↑             |
                             └─ BLOCKED ───┘
```

### States

The canonical YAML/file value for each state is lowercase snake_case.
The GitHub label equivalent is `status:` + kebab-case.

| Display name | YAML `status` value | GitHub label | Meaning | Who sets it |
|---|---|---|---|---|
| `PROPOSED` | `proposed` | `status:proposed` | Contract created; fields may be incomplete; not yet approved for execution | Author / agent |
| `APPROVED` | `approved` | `status:approved` | All required fields present; owner has approved; ready for agent pickup | Owner |
| `IN_PROGRESS` | `in_progress` | `status:in-progress` | Agent has started work; write-set is locked | Agent (on start) |
| `BLOCKED` | `blocked` | `status:blocked` | Execution halted; `partial_work` must be populated | Agent (on block) |
| `VALIDATED` | `validated` | `status:validated` | All `success_criteria` checked; `handoff` conditions met; validation gate passed | Agent + optional owner |
| `CLOSED` | `closed` | `status:closed` | Contract complete and merged; write-set lock released | Owner or agent (post-merge) |

### Transition Rules

**PROPOSED → APPROVED**
- All required fields are present and valid.
- `write_set` has been checked for collisions with other `APPROVED` or `IN_PROGRESS` contracts (see §Parallel Execution).
- Owner has explicitly approved (via comment, label change, or autonomy-mode auto-approval for MEDIUM risk).

**APPROVED → IN_PROGRESS**
- All `dependencies` are `VALIDATED` or `CLOSED`.
- Agent has read all `read_context` entries.
- No unresolved `HIGH` risks in `risk_register` (`status` must be `RESOLVED` or `ACCEPTED`).
- If waiting on owner risk decision, apply issue label `status:needs-owner` and remain `BLOCKED`.
- Agent writes `IN_PROGRESS` entry to `status_log`.

**IN_PROGRESS → BLOCKED**
- An escalation condition was triggered, or an unresolvable dependency appeared.
- Agent populates `partial_work.completed`, `partial_work.remaining`, and `partial_work.blocked_by`.
- Agent surfaces the block to the owner immediately.

**BLOCKED → IN_PROGRESS**
- Blocker has been resolved (owner decision, dependency closed, etc.).
- Agent writes resolution note to `status_log` and resumes from `partial_work.remaining`.

**IN_PROGRESS → VALIDATED**
- All `success_criteria` checked off.
- All `validation.automated` commands ran and passed.
- `validation.evidence_path` populated with test output.
- `manual_checks` items escalated to owner and all approved.
- `handoff` conditions all true.
- If `validation.owner_review` is true: owner has reviewed and confirmed.

**VALIDATED → CLOSED**
- PR merged or artifact accepted by owner.
- Write-set lock released.
- Downstream contracts that listed this contract as a dependency may now advance.

---

## Status Update Protocol

Agents update contract status by editing the `status_log` section of the
contract file (YAML or GitHub issue front-matter). The log is **append-only**:
never delete or edit existing entries.

### Format

```yaml
status_log:
  - timestamp: "2026-05-04T14:23:00Z"
    from: approved
    to: in_progress
    agent: copilot
    note: "Starting; reading design/systems/crafting.md §3 and src/systems/crafting/RecipeData.cs"
  - timestamp: "2026-05-04T16:45:00Z"
    from: in_progress
    to: blocked
    agent: copilot
    note: "RecipeData schema mismatch found; escalating to owner. partial_work populated."
```

### Agent Responsibilities on Status Change

| Transition | Agent must… |
|------------|-------------|
| → `IN_PROGRESS` | Write log entry; confirm `read_context` read; confirm no write-set collision |
| → `BLOCKED` | Write log entry; populate `partial_work`; surface to owner immediately |
| → `VALIDATED` | Write log entry; confirm all `success_criteria` checked; confirm `evidence_path` populated |
| → any | Never advance status without satisfying the transition rules above |

### Where Status Lives

- **GitHub issue**: update the `status:*` label and append a comment with the status-log entry.
- **YAML file** (`production/contracts/`): edit the `status` field and append to `status_log`.
- **Session state**: always mirror the latest status to `production/session-state/active.md` for audit continuity.

---

## Handoff Protocol

A contract is handed off (transitions to `VALIDATED`) when all conditions in the
`handoff` list are true. The agent is responsible for self-checking every
condition before marking the contract `VALIDATED`.

### Standard Handoff Checklist

Every contract should include at minimum:

```yaml
handoff:
  - All success_criteria checked off
  - All write_set files committed with no uncommitted changes
  - validation.evidence_path populated and committed
  - No linter or build errors introduced by the write_set
  - manual_checks items all escalated and owner-approved
  - status_log updated with VALIDATED entry
```

### Partial Handoff (BLOCKED state)

If a contract is blocked mid-execution, the agent must document partial work
before surfacing the block. This allows a different agent or a resumed session
to continue from where the previous agent stopped.

```yaml
partial_work:
  completed:
    - "RecipeResolver.Resolve() method implemented"
    - "Happy-path unit tests written (12 cases)"
  remaining:
    - "Edge case tests for null ingredient arrays"
    - "PR opening (owner sign-off needed)"
  blocked_by: "RecipeData.IngredientStack schema change required; awaiting owner decision DEC-008"
```

---

## Parallel Execution Rules

### Write-Set Collision Prevention

**Two contracts may not run in parallel if their `write_set` entries overlap.**

Before any contract advances to `IN_PROGRESS`, the agent must check all currently
`APPROVED` and `IN_PROGRESS` contracts for write-set intersections.

```
For each path P in this contract's write_set:
  For each path otherPath in any other contract C where C.status is approved or in_progress:
    If P == otherPath
    OR P is a prefix/ancestor of otherPath  (e.g. P=src/, otherPath=src/player/Controller.gd)
    OR otherPath is a prefix/ancestor of P  (e.g. otherPath=src/, P=src/player/Controller.gd):
      → COLLISION DETECTED between this contract and C
      → Surface to owner; do not advance to IN_PROGRESS
      → Owner must resolve: defer one contract, merge them, or grant explicit parallel write permission
```

Agents cannot unilaterally resolve write-set collisions. All collisions escalate
to the owner regardless of the active autonomy mode.

### Safe Parallel Execution

Two contracts may run in parallel when:
1. Their `write_set` entries do not overlap (no common file, no parent/child directory relationship).
2. Neither contract lists the other as a `dependency`.
3. Neither contract has a `BLOCKED` state that the other would need to resolve.

### Dependency Ordering

```
If contract B lists contract A in its dependencies:
  B may not advance to IN_PROGRESS until A is VALIDATED or CLOSED.
  B may remain APPROVED while waiting for A.
  The agent assigned to B must re-check dependency status before starting.
```

### File Ownership Transfer

When a contract transitions to `CLOSED`:
- Its write-set lock is released.
- Any contract that listed it as a dependency may now be scheduled.
- If a follow-on contract needs to modify the same files, it must declare those
  files in its own `write_set` and receive a new `APPROVED` status before starting.

---

## Storage Formats

### Option A: GitHub Issue with Structured Front-Matter

Work contracts are stored as GitHub issues using the `agent_work_contract` issue
template. The template produces a structured form whose fields map directly to
the schema above. Labels encode `status:*`, `auto:*`, and `type:*` fields for
queryability.

Query examples:

```bash
# All approved contracts ready for agent pickup
gh issue list --label "status:approved"

# All in-progress contracts for parallel collision checking
gh issue list --label "status:in-progress"

# All blocked contracts needing owner resolution
gh issue list --label "status:blocked"
```

### Option B: YAML Files in `production/contracts/`

For contracts that are pre-planned offline or for project-level tracking outside
GitHub, use the YAML template at `.agents/docs/templates/work-contract.yml`.

Naming convention: `production/contracts/<contract_id>.yml`

Example: `production/contracts/STORY-014.yml`

Both formats are valid. A project may use both (GitHub issues for sprint-level
tracking; YAML files for milestone-level pre-planning). When both exist for the
same `contract_id`, the GitHub issue is the authoritative source of truth.

---

## Dependency Cross-Referencing

Each entry in `dependencies` must carry a `contract_id` that maps to a real
GitHub issue number or YAML file. Use the following format:

```yaml
dependencies:
  - contract_id: STORY-012
    title: "Recipe data model"
    github_issue: 42          # optional; the GitHub issue number
    status: validated         # last-known status; agent re-checks on pickup
    required_outputs:
      - src/systems/crafting/RecipeData.cs
```

When the `status` field in a dependency entry is stale (the dependency has since
advanced), the agent updates it in the `status_log` without changing the
dependency entry itself.

---

## Workflow Examples

The following examples rewrite two scenarios from `autonomy-modes.md` as
fully-specified work contracts, confirming no critical execution context is missing.

---

### Example 1 — Design Doc in SUPERVISED Mode

**Original scenario (autonomy-modes.md §Scenario 1):**
Owner sets mode to SUPERVISED and asks the agent to write a GDD for the movement
system.

**Work contract (YAML representation):**

```yaml
contract_id: STORY-GDD-001
type: story
status: approved
owner: "@YvesAlbuquerque"
specialist_agent: copilot

owner_goal: >
  Write the movement system GDD so the team has an approved design reference
  before implementation begins.

success_criteria:
  - "[ ] GDD covers player movement speed, acceleration, and turning radius"
  - "[ ] GDD covers wall-run and double-jump mechanics (if in scope)"
  - "[ ] GDD includes open questions section for unresolved design choices"
  - "[ ] Design review passes with no FAIL verdict"

non_goals:
  - "Implementing any movement code (covered by STORY-IMPL-001)"
  - "Art or animation assets for movement"
  - "Multiplayer sync considerations (deferred)"

dependencies: []

write_set:
  - design/systems/movement.md

read_context:
  - path: design/game-pillars.md
  - path: design/concept.md
    section: "§Movement and Feel"

risk_tier: MEDIUM
approval_boundary: >
  SUPERVISED mode: agent may draft and ask clarifying questions (LOW).
  Writing design/systems/movement.md requires owner approval before the file is written (MEDIUM).

escalation_conditions:
  - "Any movement mechanic that contradicts an approved game pillar"
  - "Scope additions beyond the declared write_set"
  - "Any dependency on an unreviewed external reference"

validation:
  automated: []
  agent_review: true        # /design-review skill
  owner_review: true
  evidence_path: ""         # no test evidence; owner review is the gate

manual_checks:
  - "Owner reads and approves the final GDD draft"

doc_impact:
  - path: design/systems-index.md
    section: "Systems"
    change: "Add movement.md entry"

yjackcore:
  layer: none
  package_boundary: false
  host_game_separation: false

outputs:
  - path: design/systems/movement.md
    type: file

handoff:
  - design/systems/movement.md written and committed
  - /design-review run with PASS or PASS WITH NOTES verdict
  - Owner has approved the GDD in a GitHub comment
  - design/systems-index.md updated
  - status_log updated with VALIDATED entry

status_log:
  - timestamp: "2026-05-04T10:00:00Z"
    from: proposed
    to: approved
    agent: owner
    note: "Owner approved GDD scope after clarification on wall-run mechanic"
  - timestamp: "2026-05-04T10:15:00Z"
    from: approved
    to: in_progress
    agent: copilot
    note: "Starting; reading design/game-pillars.md and design/concept.md §Movement"
```

**What the agent does at each step:**

1. Reads `read_context` — LOW risk, executes.
2. Asks three clarifying questions about scope — LOW risk, executes.
3. Owner answers; agent drafts GDD outline — LOW risk, executes.
4. Before writing the file: escalates to owner per SUPERVISED mode ("May I write to `design/systems/movement.md`?").
5. Owner approves; agent writes the file, logs the write in `status_log`.
6. Agent runs `/design-review` — LOW risk (read-only analysis), executes.
7. Agent updates `doc_impact` target (`systems-index.md`) — MEDIUM risk; asks owner per SUPERVISED mode.
8. Owner approves; agent writes the update.
9. All `handoff` conditions true; agent transitions to `VALIDATED`.

---

### Example 2 — Implementation Story in AUTONOMOUS Mode

**Original scenario (autonomy-modes.md §Scenario 2):**
Owner sets mode to AUTONOMOUS and asks the agent to implement the movement story.

**Work contract (YAML representation):**

```yaml
contract_id: STORY-IMPL-001
type: story
status: approved
owner: "@YvesAlbuquerque"
specialist_agent: copilot

owner_goal: >
  Implement the player movement system so that sprint story-001-player-movement
  is complete and the acceptance criteria are met.

success_criteria:
  - "[ ] Player moves at the speed defined in design/systems/movement.md §Speed"
  - "[ ] Wall-run activates when the player touches a tagged surface at ≥ min_speed"
  - "[ ] Double-jump resets on landing"
  - "[ ] Unit tests cover all three mechanics; coverage ≥ 80%"
  - "[ ] No S1 or S2 bugs in the delivered feature"

non_goals:
  - "Animation blending (covered by STORY-ANIM-001)"
  - "Movement sound effects (covered by STORY-SFX-001)"
  - "Multiplayer replication (deferred)"

dependencies:
  - contract_id: STORY-GDD-001
    title: "Movement system GDD"
    github_issue: 45
    status: validated
    required_outputs:
      - design/systems/movement.md

write_set:
  - src/player/movement/PlayerMovement.gd
  - tests/player/movement/PlayerMovementTests.gd
  - tests/evidence/STORY-IMPL-001/

read_context:
  - path: design/systems/movement.md
  - path: docs/architecture/master-architecture.md
    section: "§Player Systems"
  - path: src/player/PlayerController.gd

risk_tier: HIGH
approval_boundary: >
  AUTONOMOUS mode: LOW and MEDIUM decisions execute automatically.
  Writing to src/ is always HIGH risk — always escalates regardless of mode.
  Opening a PR is always HIGH risk — always escalates.

escalation_conditions:
  - "Any change to src/player/PlayerController.gd (outside declared write_set)"
  - "Any modification to physics constants that affect other systems"
  - "Test failures that cannot be resolved without changing design/systems/movement.md"
  - "Any YJackCore API usage not present in the read_context"

validation:
  automated:
    - "gdscript -s tests/player/movement/PlayerMovementTests.gd"
  agent_review: false
  owner_review: true        # src/ writes always require owner review
  evidence_path: tests/evidence/STORY-IMPL-001/

manual_checks:
  - "Owner reviews implementation approach before src/ files are written"
  - "Owner approves opening the PR"

doc_impact:
  - path: docs/architecture/master-architecture.md
    section: "§Player Systems"
    change: "Note PlayerMovement.gd as the canonical movement component"

yjackcore:
  layer: PlayerLayer
  package_boundary: false
  host_game_separation: true   # PlayerLayer lives in host-game; must not import YJackCore Core

outputs:
  - path: src/player/movement/PlayerMovement.gd
    type: file
  - path: tests/player/movement/PlayerMovementTests.gd
    type: file
  - path: tests/evidence/STORY-IMPL-001/
    type: test-evidence

handoff:
  - All success_criteria checked off
  - All automated validation commands pass
  - tests/evidence/STORY-IMPL-001/ committed with test output
  - Owner has reviewed and approved the implementation
  - PR opened and linked to this issue
  - No linter errors introduced in write_set files
  - doc_impact targets updated
  - status_log updated with VALIDATED entry

status_log:
  - timestamp: "2026-05-04T11:00:00Z"
    from: proposed
    to: approved
    agent: owner
    note: "Owner approved implementation approach and accepted HIGH risk for src/ write"
  - timestamp: "2026-05-04T11:10:00Z"
    from: approved
    to: in_progress
    agent: copilot
    note: "Starting; reading design/systems/movement.md and src/player/PlayerController.gd"
```

**What the agent does at each step:**

1. Reads `read_context` — LOW risk, auto in AUTONOMOUS.
2. Proposes implementation approach — LOW risk, presents to owner.
3. Owner approves approach (required: `manual_checks[0]`); agent logs approval.
4. Creates local branch `feat/player-movement` — MEDIUM risk, auto in AUTONOMOUS, logs it.
5. Before writing `src/player/movement/PlayerMovement.gd`: **HIGH risk hard gate**:
   ```
   ⚠️ APPROVAL REQUIRED [HIGH risk — src/ write]
   Ready to write src/player/movement/PlayerMovement.gd. Shall I proceed?
   ```
6. Owner approves; agent writes the implementation, commits, logs the action.
7. Writes tests — HIGH risk (still `src/` adjacent); follows same escalation pattern.
8. Runs `validation.automated` commands — LOW risk, auto.
9. Commits test evidence to `validation.evidence_path` — MEDIUM risk, auto.
10. Checks `host_game_separation: true` — confirms no YJackCore Core imports in `PlayerMovement.gd`.
11. Updates `doc_impact` target — MEDIUM risk, auto in AUTONOMOUS.
12. All `handoff` conditions met; agent transitions to `VALIDATED`.
13. Proposes opening PR — **HIGH risk, always escalates**.
14. Owner approves; PR opened.

---

## Relationship to Other Schemas

| Schema / Document | Relationship |
|-------------------|--------------|
| [autonomy-modes.md](autonomy-modes.md) | Defines `risk_tier` and `approval_boundary` values |
| [coordination-rules.md](coordination-rules.md) | Defines parallel task protocol and vertical/horizontal delegation |
| [dependency-graph.md](dependency-graph.md) | Extends `dependencies` into a project-wide adjacency list; defines the collision detection algorithm and four-shard simulation |
| [file-ownership-protocol.md](file-ownership-protocol.md) | File ownership and read-only consultation rules; Unity `.meta` and YJackCore boundary guidance |
| AUTO-007 Sprint Planner | Consumes `APPROVED` contracts to schedule sprint work; respects the dependency graph |
| `.github/ISSUE_TEMPLATE/agent_work_contract.yml` | GitHub issue form representation of this schema (all types: epic, story, shard) |
| `.github/ISSUE_TEMPLATE/agent_shard.yml` | Shard-level issue form |
| `.agents/docs/templates/work-contract.yml` | Full YAML template for offline contract authoring |
| `production/dependency-graph.yml` | Live project-wide dependency graph; updated by agents as contracts change state |
| `production/session-state/active.md` | Status log mirror for audit continuity |
| `.agents/scripts/check-write-sets.sh` | Pre-flight script that runs the write-set collision algorithm against the dependency graph |
