# QA Evidence Task Schema

**Version:** 1.0
**Last Updated:** 2026-05-08
**Source:** [AUTO-018] from `docs/AUTONOMOUS_GAME_STUDIO_ROADMAP.md`

---

## Overview

A **QA evidence task** is a unit of test verification work that can be assigned to a
qa-tester agent, executed independently, and aggregated into sprint or milestone
sign-off reports. Evidence tasks make QA scalable across parallel autonomous agents
while maintaining traceability to story acceptance criteria and validation gates.

Evidence tasks complement work contracts: a story contract declares what to build;
evidence tasks declare how to verify it was built correctly.

---

## Task Types by Story Type

Every story type has a corresponding evidence task type with specific artifact requirements:

| Story Type | Evidence Task Type | Artifacts Required | Gate Level |
|---|---|---|---|
| **Logic** | `unit-test` | Automated unit test file in `tests/unit/[system]/` — must pass | BLOCKING |
| **Integration** | `integration-test` | Integration test OR documented playtest in `production/qa/evidence/` | BLOCKING |
| **Visual/Feel** | `visual-evidence` | Screenshot + sign-off in `production/qa/evidence/` | ADVISORY |
| **UI** | `ui-evidence` | Manual walkthrough doc OR interaction test in `production/qa/evidence/` | ADVISORY |
| **Config/Data** | `smoke-check` | Smoke check pass report in `production/qa/smoke-*.md` | ADVISORY |
| **Playtest** | `playtest-session` | Structured playtest report in `production/qa/playtests/` | ADVISORY |
| **Release** | `release-check` | Release checklist completion in `production/releases/` | BLOCKING |

---

## Schema — Required Fields

### Identity

| Field | Type | Required | Description |
|-------|------|----------|-------------|
| `task_id` | string | ✅ | Unique identifier. Format: `QA-[NNN]` or `QA-[story-slug]-[type]` |
| `task_type` | enum | ✅ | Evidence type from table above: `unit-test`, `integration-test`, `visual-evidence`, `ui-evidence`, `smoke-check`, `playtest-session`, `release-check` |
| `status` | enum | ✅ | `assigned`, `in_progress`, `pass`, `fail`, `blocked`, `deferred` |
| `story_ref` | string | ✅ | Story contract ID or file path this evidence validates |
| `assigned_to` | string | ✅ | Agent role (`qa-tester`, `qa-lead`) or owner username |

### Test Scope

| Field | Type | Required | Description |
|-------|------|----------|-------------|
| `acceptance_criteria` | list | ✅ | AC IDs from the story this task covers (e.g., `AC-1`, `AC-2`) |
| `test_description` | string | ✅ | One paragraph: what behaviour is being validated |
| `preconditions` | list | — | Game state, build requirements, platform constraints |
| `expected_result` | string | ✅ | Clear pass condition for this evidence task |

### Execution

| Field | Type | Required | Description |
|-------|------|----------|-------------|
| `test_file` | string | — | Path to automated test file (for `unit-test`, `integration-test`) |
| `evidence_artifact` | string | — | Path to evidence document (for `visual-evidence`, `ui-evidence`, `playtest-session`) |
| `validation_command` | string | — | Command to execute automated test (e.g., `godot --headless --script tests/...`) |
| `manual_steps` | list | — | Numbered steps for manual verification tasks |

### Results

| Field | Type | Required | Description |
|-------|------|----------|-------------|
| `result` | enum | — | `PASS`, `FAIL`, `BLOCKED`, `NOT_RUN`. Required when `status` is `pass`, `fail`, or `blocked`. |
| `actual_result` | string | — | What actually happened (required when `result` is `FAIL`) |
| `failure_reason` | string | — | Root cause (required when `result` is `FAIL`) |
| `bug_filed` | string | — | Bug ID if a defect was found (e.g., `BUG-042`) |
| `sign_offs` | list | — | Required approvals: `{role, name, approved, date}` |

### Aggregation

| Field | Type | Required | Description |
|-------|------|----------|-------------|
| `sprint` | string | — | Sprint ID this task belongs to (for sprint-level aggregation) |
| `milestone` | string | — | Milestone ID (for milestone-level aggregation) |
| `gate` | enum | — | Which gate this evidence feeds: `story-done`, `smoke-check`, `team-qa`, `gate-check`, `release` |
| `gate_level_override` | enum | — | Optional override for effective gate level: `BLOCKING` or `ADVISORY` (defaults from `task_type`) |
| `aggregation_group` | string | — | Logical grouping key for batching related evidence (e.g., `sprint-03-logic-tests`) |

### Audit Trail (Optional)

| Field | Type | Required | Description |
|-------|------|----------|-------------|
| `status_log` | list | — | Append-only transition history entries: `{timestamp, from, to, agent, note}` |

---

## Task Lifecycle

```
ASSIGNED → IN_PROGRESS → PASS / FAIL / BLOCKED
                              ↓
                         [aggregated into sign-off]
```

### States

| State | Meaning | Who sets it |
|---|---|---|
| `assigned` | Task created and assigned; not yet started | qa-lead |
| `in_progress` | Agent is executing the test or collecting evidence | qa-tester |
| `pass` | Evidence collected; all acceptance criteria verified | qa-tester |
| `fail` | Evidence shows acceptance criteria NOT met; bug filed | qa-tester |
| `blocked` | Cannot execute due to missing dependency or environment issue | qa-tester |
| `deferred` | Explicitly postponed (e.g., playtest deferred to next sprint) | qa-lead or owner |

### Transition Rules

**ASSIGNED → IN_PROGRESS**
- Agent has read the story file and extracted acceptance criteria
- All `preconditions` are met (build exists, environment configured)
- No blocking dependencies

**IN_PROGRESS → PASS**
- All `acceptance_criteria` IDs validated
- `evidence_artifact` created and committed (if required)
- `test_file` passes (if automated)
- All `sign_offs` collected (if required)

**IN_PROGRESS → FAIL**
- One or more acceptance criteria NOT met
- `actual_result` and `failure_reason` documented
- Bug filed via `/bug-report` and `bug_filed` ID recorded

**IN_PROGRESS → BLOCKED**
- Precondition not met (build broken, dependency missing)
- Environment issue prevents execution
- Blocker documented in task notes

---

## Storage Formats

### Option A: GitHub Issue with existing label taxonomy

Use `.github/ISSUE_TEMPLATE/qa_evidence_task.yml` (to be created).

Use repository-standard labels and keep evidence metadata in the issue body/template:
- `domain:qa` — base QA scope
- `type:validation` — validation artifact classification
- `status:in-progress` / `status:blocked` / `status:deferred` — coarse workflow state

Issue body fields encode:
- `task_type`, `status`, `gate`, `sprint`, `milestone`, `story_ref`, `result`

Query examples:

```bash
# All QA validation tasks (filter assigned in body field)
gh issue list --label "domain:qa,type:validation"

# All failing evidence tasks (bugs to file)
gh issue list --label "domain:qa,type:validation" --search "result: FAIL"

# All evidence for smoke-check gate
gh issue list --label "domain:qa,type:validation" --search "gate: smoke-check"
```

### Option B: YAML in `production/qa/evidence-tasks/`

For offline planning or batch evidence generation, use YAML template at
`.agents/docs/templates/qa-evidence-task.yml`.

Naming: `production/qa/evidence-tasks/[task_id].yml`

Example: `production/qa/evidence-tasks/QA-001-unit-damage-calc.yml`

---

## Aggregation Protocol

Evidence tasks aggregate into gate reports using these grouping keys:

### Sprint-Level Aggregation (for `/team-qa` sign-off)

Group by: `sprint` field

Produces: `production/qa/qa-signoff-[sprint]-[date].md`

Verdict rules:
- **APPROVED**: all BLOCKING tasks PASS; no S1/S2 bugs
- **APPROVED WITH CONDITIONS**: ADVISORY tasks have notes; S3/S4 bugs open
- **NOT APPROVED**: any BLOCKING task FAIL or BLOCKED; S1/S2 bugs open

### Milestone-Level Aggregation (for `/gate-check`)

Group by: `milestone` field

Produces: `production/qa/milestone-[milestone]-evidence.md`

Verdict rules:
- **PASS**: all BLOCKING evidence tasks PASS
- **CONCERNS**: ADVISORY tasks have gaps or notes
- **FAIL**: any BLOCKING task FAIL

### Gate-Specific Aggregation

Filter by: `gate` field

Each gate skill consumes only the evidence tasks tagged for that gate:

| Gate Skill | Gate Filter | Evidence Types Consumed |
|---|---|---|
| `/story-done` | `gate:story-done` | `unit-test`, `integration-test`, `visual-evidence`, `ui-evidence` for that story only |
| `/smoke-check` | `gate:smoke-check` | `smoke-check` tasks for the sprint |
| `/team-qa` | `gate:team-qa` | All evidence types for the sprint |
| `/gate-check` | `gate:gate-check` | All BLOCKING evidence for the milestone |
| `/release-checklist` | `gate:release` | `release-check` tasks |

---

## Parallel Execution Safety

Multiple qa-tester agents can execute evidence tasks in parallel if:

1. Their `evidence_artifact` paths do not overlap (different files/directories)
2. Their `test_file` paths do not overlap
3. Neither task is marked `blocked` by the other

Collision check: same `write_set` logic as work contracts applies to `evidence_artifact`
and `test_file` paths.

---

## YJackCore Unity Manual Validation

For evidence tasks targeting Unity + YJackCore stories, include the manual validation
checklist from `.agents/docs/templates/yjackcore-unity-manual-validation.md` in the
`manual_steps` field or attach as a required artifact.

Required confirmations:
- Domain reload (script compilation) — requires Unity Editor
- Play Mode behavior — requires Unity Play Mode execution
- Package Manager resolution — requires UPM resolver
- Compile symbol branches — requires Editor build with module flags
- Odin Inspector rendering — requires Editor with Odin installed
- `.meta` file integrity — risk of Unity re-importing
- Asset database refresh — requires Editor asset import pipeline

Gate-level precedence is deterministic:
1. `gate_level_override` (if present) decides effective level.
2. Otherwise default level comes from `task_type` in the Task Types table.

For Unity + YJackCore evidence tasks, set `gate_level_override: ADVISORY` by default.
If a gate must block, owner/qa-lead explicitly sets `gate_level_override: BLOCKING`.

---

## Unverifiable Criteria Handling

When an acceptance criterion cannot be verified autonomously:

1. Agent creates an evidence task with `status: blocked` or `status: deferred`
2. Agent documents why verification is impossible (tooling, environment, subjective quality)
3. Agent surfaces to owner: "AC-3 requires manual playtest — cannot verify autonomously"
4. Owner decides: defer to later gate, accept as untested, or provide manual confirmation

These unverifiable tasks feed `/owner-dashboard` with a clear count and impact assessment.

---

## Template Location

`.agents/docs/templates/qa-evidence-task.yml` — full YAML schema template
`.agents/docs/templates/qa-evidence-task.md` — markdown report template for manual evidence
`.github/ISSUE_TEMPLATE/qa_evidence_task.yml` — GitHub issue form (to be created)

---

## Relationship to Other Schemas

| Schema / Document | Relationship |
|-------------------|--------------|
| [work-contract-schema.md](work-contract-schema.md) | Evidence tasks validate story contracts |
| [autonomous-validation-evidence.md](autonomous-validation-evidence.md) | Evidence tasks produce validation packets |
| [coding-standards.md](coding-standards.md) | Test Evidence by Story Type table defines evidence requirements |
| `/team-qa` skill | Generates evidence tasks for all stories in scope |
| `/story-done` skill | Checks for required evidence before marking story complete |
| `/gate-check` skill | Aggregates evidence to produce gate verdict |
| `/owner-dashboard` skill | Surfaces unverifiable criteria and manual check counts |
