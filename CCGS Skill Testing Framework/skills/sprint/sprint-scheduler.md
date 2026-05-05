# Skill Test Spec: /sprint-scheduler

## Skill Summary

`/sprint-scheduler` is the autonomous upgrade to `/sprint-plan`. It reads the
dependency graph, work contracts (GitHub issues or YAML files), and autonomy
configuration to propose a sprint schedule based on priority, dependencies,
effort, parallel execution safety, and autonomy mode boundaries. Respects the
write-set collision protocol and YJackCore manual validation requirements.
Produces machine-readable YAML schedule and human-readable sprint plan.

---

## Static Assertions (Structural)

Verified automatically by `/skill-test static` — no fixture needed.

- [ ] Has required frontmatter fields: `name`, `description`, `argument-hint`, `user-invocable`, `allowed-tools`
- [ ] Has ≥6 phase headings
- [ ] Contains verdict keywords: COMPLETE, BLOCKED, DRY_RUN_COMPLETE
- [ ] Contains "May I write" language (skill writes sprint schedule files)
- [ ] References `.agents/scripts/check-write-sets.sh` for collision detection
- [ ] References `production/dependency-graph.yml` for dependency ordering
- [ ] References `production/autonomy-config.md` for mode detection

---

## Test Cases

### Case 1: Happy Path — Autonomous scheduling in SUPERVISED mode

**Fixture:**
- `production/autonomy-config.md` exists with mode `SUPERVISED`
- `production/dependency-graph.yml` contains 5 contracts:
  - 3 with `status: approved`, all dependencies satisfied, no collisions
  - 1 with `status: approved`, dependency not validated (blocked)
  - 1 with `status: validated` (not eligible)
- `production/milestones/milestone-02.md` exists with capacity `10 days`
- All approved contracts have `risk_tier: LOW` or `MEDIUM`
- `.agents/scripts/check-write-sets.sh` exits with code 0 (no collisions)

**Input:** `/sprint-scheduler`

**Expected behavior:**
1. Skill reads autonomy config → detects SUPERVISED mode
2. Skill reads dependency graph → finds 3 ready contracts
3. Skill runs write-set collision check script → no collisions found
4. Skill prioritizes contracts by priority tier, YJackCore layer, effort
5. Skill assigns contracts to agent lanes (e.g., `team:combat`, `team:ui`)
6. Skill generates YAML schedule with 3 contracts in `lanes` section
7. Skill detects 1 contract is dependency-blocked → moves to `not_ready` section
8. Skill checks risk tier: all are LOW or MEDIUM in SUPERVISED mode
   - LOW contracts auto-approved
   - MEDIUM contracts escalate to owner
9. Skill asks: "May I write the sprint schedule to production/sprints/schedule-sprint-NNN.yml?"
10. User approves; files are written

**Assertions:**
- [ ] Autonomy mode is correctly detected from config
- [ ] Only `approved` contracts with satisfied dependencies are scheduled
- [ ] Dependency-blocked contracts appear in `not_ready` section, not `lanes`
- [ ] Write-set collision check script is called before scheduling
- [ ] Contracts are sorted by priority tier → YJackCore layer → effort
- [ ] YAML schedule matches schema (schema_version, sprint, lanes, deferred, not_ready, summary)
- [ ] Human-readable sprint plan is also generated at `production/sprints/sprint-NNN.md`
- [ ] `production/sprint-status.yaml` is written with story entries
- [ ] Verdict is COMPLETE after successful write

---

### Case 2: Write-Set Collision Detected — Contracts blocked

**Fixture:**
- `production/dependency-graph.yml` contains 4 contracts:
  - STORY-A: `approved`, `write_set: [src/systems/crafting/RecipeResolver.cs]`
  - STORY-B: `approved`, `write_set: [src/systems/crafting/]`
  - STORY-C: `approved`, `write_set: [src/ui/CraftingPanel.cs]`
  - STORY-D: `approved`, `write_set: [design/systems/crafting.md]`
- `.agents/scripts/check-write-sets.sh` exits with code 1 and outputs collision between STORY-A and STORY-B

**Input:** `/sprint-scheduler`

**Expected behavior:**
1. Skill reads dependency graph → finds 4 approved contracts
2. Skill runs collision check → detects STORY-A ↔ STORY-B collision
3. Skill marks both STORY-A and STORY-B as `COLLISION_BLOCKED`
4. Skill schedules STORY-C and STORY-D (no collisions)
5. Skill generates schedule with:
   - `lanes`: STORY-C, STORY-D
   - `collision_blocked`: STORY-A, STORY-B with collision reason
6. Skill escalates to owner: "2 contracts blocked by write-set collision. Resolve before scheduling."

**Assertions:**
- [ ] Collision check script is called
- [ ] Collisions are detected and flagged
- [ ] Conflicting contracts appear in `collision_blocked` section, not `lanes`
- [ ] Non-conflicting contracts are still scheduled
- [ ] Collision reason is included in the blocked entry
- [ ] Skill does not attempt to auto-resolve collisions (always escalates)

---

### Case 3: YJackCore Package Boundary — HIGH risk escalation

**Fixture:**
- `production/autonomy-config.md` contains mode `AUTONOMOUS`
- `production/dependency-graph.yml` contains 2 contracts:
  - STORY-E: `approved`, `risk_tier: MEDIUM`, `yjackcore.package_boundary: false`
  - STORY-F: `approved`, `risk_tier: HIGH`, `yjackcore.package_boundary: true`
- `.yjack-workspace.json` exists at project root with `layout: upm`

**Input:** `/sprint-scheduler`

**Expected behavior:**
1. Skill reads autonomy config → AUTONOMOUS mode
2. Skill reads dependency graph → 2 approved contracts
3. Skill detects STORY-F has `yjackcore.package_boundary: true` → HIGH risk
4. Skill flags STORY-F: "⚠️ HIGH coordination risk — YJackCore package boundary"
5. Skill generates schedule with STORY-E and STORY-F in `lanes`
6. Skill escalates to owner (HIGH risk present, always escalates regardless of mode):
   "⚠️ APPROVAL REQUIRED [Sprint Schedule — AUTONOMOUS]
    - 1 contract touches YJackCore package boundaries
    - 1 contract has HIGH risk tier"
7. User approves; files are written

**Assertions:**
- [ ] YJackCore package boundary is detected from contract metadata
- [ ] Contract is flagged with HIGH coordination risk note
- [ ] Skill escalates to owner regardless of AUTONOMOUS mode
- [ ] Skill never auto-approves YJackCore package boundary tasks
- [ ] Flag appears in the YAML schedule under `flags` for the contract

---

### Case 4: Capacity Exceeded — Contracts deferred

**Fixture:**
- `production/milestones/milestone-02.md` exists with capacity `6 days`
- `production/dependency-graph.yml` contains 5 approved contracts:
  - 3 Must Have contracts totaling 5 days
  - 2 Should Have contracts totaling 3 days
- All contracts have satisfied dependencies and no collisions

**Input:** `/sprint-scheduler`

**Expected behavior:**
1. Skill reads milestone capacity → 6 days available
2. Skill groups contracts by priority tier
3. Skill schedules all 3 Must Have contracts (5 days total, within capacity)
4. Skill attempts to schedule Should Have contracts → exceeds capacity
5. Skill defers the 2 Should Have contracts to `deferred` section
6. Skill generates schedule:
   - `lanes`: 3 Must Have contracts (5 days)
   - `deferred`: 2 Should Have contracts with reason "Exceeds sprint capacity"
7. Skill presents to owner: "2 contracts deferred due to capacity"

**Assertions:**
- [ ] Must Have contracts are scheduled first
- [ ] Should Have contracts are deferred when capacity is exceeded
- [ ] Deferred contracts appear in `deferred` section with reason
- [ ] Total scheduled effort does not exceed sprint capacity
- [ ] Summary section shows correct counts: scheduled, deferred

---

### Case 5: Dependency Blocked — Contracts not ready

**Fixture:**
- `production/dependency-graph.yml` contains 3 contracts:
  - STORY-G: `approved`, dependencies: [{ contract_id: STORY-H, status: in_progress }]
  - STORY-H: `in_progress` (not validated or closed)
  - STORY-I: `approved`, dependencies: [] (ready)

**Input:** `/sprint-scheduler`

**Expected behavior:**
1. Skill reads dependency graph
2. Skill checks STORY-G dependencies → STORY-H is `in_progress` (not satisfied)
3. Skill marks STORY-G as `NOT_READY`
4. Skill checks STORY-I dependencies → none → `READY`
5. Skill generates schedule:
   - `lanes`: STORY-I
   - `not_ready`: STORY-G with blocked_by "Dependency STORY-H not validated"
6. Skill notes: "1 contract not ready (dependency blocked)"

**Assertions:**
- [ ] Dependency check correctly identifies unsatisfied dependencies
- [ ] Contracts with unsatisfied dependencies appear in `not_ready` section
- [ ] Blocked reason references the blocking contract
- [ ] Only contracts with all dependencies `validated` or `closed` are scheduled

---

### Case 6: Dry Run Mode — No files written

**Fixture:**
- Same as Case 1 (happy path)

**Input:** `/sprint-scheduler --dry-run`

**Expected behavior:**
1. Skill performs all scheduling logic (Phases 1-5)
2. Skill generates the YAML schedule in memory
3. Skill outputs the schedule to stdout
4. Skill does NOT write any files
5. Skill does NOT update dependency graph
6. Skill does NOT ask for write approval
7. Verdict: **DRY_RUN_COMPLETE** — schedule generated but not written

**Assertions:**
- [ ] All scheduling logic runs normally
- [ ] Schedule is generated and output to stdout
- [ ] No Write or Edit tool calls are made
- [ ] Verdict is DRY_RUN_COMPLETE, not COMPLETE
- [ ] Output includes full YAML schedule for review

---

### Case 7: Manual Validation Required — Unity tasks flagged

**Fixture:**
- `production/dependency-graph.yml` contains 2 contracts:
  - STORY-J: `approved`, `manual_checks: ["Owner verifies Play Mode behavior"]`
  - STORY-K: `approved`, `yjackcore.layer: PlayerLayer`, `manual_checks: []`

**Input:** `/sprint-scheduler`

**Expected behavior:**
1. Skill reads contracts
2. Skill detects STORY-J has non-empty `manual_checks` → flag "⚠️ Manual validation required"
3. Skill detects STORY-K has `yjackcore.layer: PlayerLayer` → flag "⚠️ Unity validation required"
4. Skill schedules both contracts but includes flags in the YAML schedule
5. Skill notes in approval prompt:
   "2 contracts require manual validation
    Owner sign-off needed after implementation"

**Assertions:**
- [ ] Manual validation requirements are detected from `manual_checks`
- [ ] YJackCore layer tasks are flagged for Unity validation
- [ ] Flags appear in the YAML schedule under `flags` for each contract
- [ ] Approval prompt notes manual validation count
- [ ] Contracts are still scheduled (not blocked), but flagged for owner awareness

---

### Case 8: GUIDED Mode — All decisions escalate

**Fixture:**
- `production/autonomy-config.md` contains mode `GUIDED`
- Same contracts as Case 1 (3 approved, all LOW risk)

**Input:** `/sprint-scheduler`

**Expected behavior:**
1. Skill reads autonomy config → GUIDED mode
2. Skill generates schedule normally
3. Skill escalates to owner regardless of risk tier (GUIDED = ask first for everything):
   "⚠️ APPROVAL REQUIRED [Sprint Schedule — GUIDED]"
4. User approves; files are written

**Assertions:**
- [ ] GUIDED mode is detected
- [ ] Skill escalates to owner even for LOW risk contracts
- [ ] Approval prompt includes mode name
- [ ] Verdict is COMPLETE after owner approval

---

## Protocol Compliance

- [ ] Shows the full schedule (or summary) before asking to write
- [ ] Always asks "May I write" before writing sprint schedule files
- [ ] Calls `.agents/scripts/check-write-sets.sh` before scheduling
- [ ] Respects autonomy mode boundaries (escalates per mode)
- [ ] Never auto-resolves write-set collisions (always escalates)
- [ ] Never auto-approves YJackCore package boundary tasks
- [ ] Verdict is clearly stated at the end of the skill output
- [ ] Dry-run mode produces output without writing files

---

## Coverage Notes

- The case where GitHub issues and YAML files both exist for the same contract is
  not explicitly tested; behavior follows the authoritative source rule (GitHub
  issue wins).
- YJackCore layer sequencing (GameLayer → LevelLayer → etc.) is not explicitly
  tested but is specified in the skill; can be added as a sorting validation case.
- The case where all contracts are blocked is not tested; behavior is: schedule
  is empty, no lanes, all contracts in `not_ready` or `collision_blocked` sections.
