---
name: qa-evidence-aggregate
description: "Aggregate QA evidence tasks into sprint or milestone sign-off reports. Reads all evidence task results, groups by sprint or milestone, applies verdict rules (BLOCKING vs ADVISORY), and produces a structured sign-off document. Feeds /gate-check and owner dashboard."
argument-hint: "[sprint-[id] | milestone-[id] | gate: gate-name]"
user-invocable: true
allowed-tools: Read, Glob, Grep, Write, AskUserQuestion
agent: qa-lead
---

# QA Evidence Aggregation

This skill collects all QA evidence task results for a sprint, milestone, or specific
gate, applies verdict rules based on BLOCKING vs ADVISORY gate levels, and produces
a structured sign-off report that feeds `/gate-check` and `/owner-dashboard`.

Run this after QA execution is complete (all or most evidence tasks have a result)
and before advancing through a validation gate.

**Output:** `production/qa/qa-signoff-[scope]-[date].md` (sprint sign-off)
**Output:** `production/qa/milestone-[milestone]-evidence.md` (milestone evidence)
**Output:** `production/qa/gate-[gate]-evidence-[date].md` (gate-specific evidence)

---

## Phase 1: Parse Scope

**Argument:** `$ARGUMENTS` (blank = ask user via AskUserQuestion)

Determine aggregation scope:

- **`sprint-[id]`** — aggregate all evidence tasks tagged with this sprint ID
- **`milestone-[id]`** — aggregate all evidence tasks tagged with this milestone ID
- **`gate: [gate-name]`** — aggregate all evidence for a specific gate (`story-done`, `smoke-check`, `team-qa`, `gate-check`, `release`)
- **No argument** — use `AskUserQuestion`:
  - "What scope should I aggregate QA evidence for?"
  - Options: "Current sprint", "Specific milestone", "Specific gate", "All unresolved evidence"

After resolving scope, report: "Aggregating QA evidence for [scope]. Loading evidence tasks..."

---

## Phase 2: Load Evidence Tasks

**Option A: GitHub Issues**

If evidence tasks are stored as GitHub issues:

```bash
gh issue list --label "domain:qa,type:validation" --json number,title,labels,body --state all
```

Parse each issue:
- Extract `task_id`, `task_type`, `status`, `result`, `sprint`, `milestone`, and `gate` from issue body/frontmatter
- Extract `acceptance_criteria`, `story_ref`, `bug_filed` from body
- Group by `task_type` and `status`

**Option B: YAML Files**

If evidence tasks are stored in `production/qa/evidence-tasks/`:

```bash
glob "production/qa/evidence-tasks/*.yml"
```

For each YAML file:
- Parse `sprint`, `milestone`, or `gate` field to match scope
- Extract `task_type`, `status`, `result`, `bug_filed`
- Group by `task_type` and `status`

**Option C: Markdown Files**

If evidence tasks are stored as markdown:

```bash
glob "production/qa/evidence-tasks/*.md"
```

Parse each file:
- Extract metadata from frontmatter or header
- Match scope filter
- Group by type and status

---

## Phase 3: Calculate Verdict by Type

For each task type, count results:

| Task Type | Gate Level | Total | Assigned | In Progress | Pass | Fail | Blocked | Deferred |
|---|---|---|---|---|---|---|---|---|
| unit-test | BLOCKING | [N] | [N] | [N] | [N] | [N] | [N] | [N] |
| integration-test | BLOCKING | [N] | [N] | [N] | [N] | [N] | [N] | [N] |
| visual-evidence | ADVISORY | [N] | [N] | [N] | [N] | [N] | [N] | [N] |
| ui-evidence | ADVISORY | [N] | [N] | [N] | [N] | [N] | [N] | [N] |
| smoke-check | ADVISORY | [N] | [N] | [N] | [N] | [N] | [N] | [N] |
| playtest-session | ADVISORY | [N] | [N] | [N] | [N] | [N] | [N] | [N] |
| release-check | BLOCKING | [N] | [N] | [N] | [N] | [N] | [N] | [N] |

---

## Phase 4: Apply Verdict Rules

### Sprint-Level Verdict (for `/team-qa` sign-off)

**APPROVED** if ALL of:
- All BLOCKING tasks (unit-test, integration-test, and release-check when present) are `pass`
- No S1 or S2 bugs filed from evidence tasks
- All `assigned` and `in_progress` BLOCKING tasks are zero (all complete)

**APPROVED WITH CONDITIONS** if ALL of:
- All BLOCKING tasks are `pass` or `deferred` (with owner approval)
- ADVISORY tasks may have `fail` or `blocked` results (documented as conditions)
- Only S3 or S4 bugs filed from evidence tasks

**NOT APPROVED** if ANY of:
- Any BLOCKING task is `fail` or `blocked` without owner waiver
- Any S1 or S2 bug filed from evidence tasks
- BLOCKING tasks still `assigned` or `in_progress` (QA execution incomplete)

### Milestone-Level Verdict (for `/gate-check`)

**PASS** if ALL of:
- All BLOCKING evidence tasks are `pass`
- No unresolved BLOCKING tasks remain

**CONCERNS** if ALL of:
- All BLOCKING tasks `pass`
- ADVISORY tasks have `fail`, `blocked`, or `deferred` results (noted as concerns)

**FAIL** if ANY of:
- Any BLOCKING task is `fail` or `blocked`

### Gate-Specific Verdict

For each gate (`story-done`, `smoke-check`, `team-qa`, `gate-check`, `release`):

Filter evidence tasks by `gate` field, then apply the appropriate verdict rules above.

---

## Phase 5: Collect Bug References

For all tasks with `result: fail` and a `bug_filed` ID:

1. Group bugs by severity (from bug file or GitHub issue labels)
2. Produce a bug summary table:

| Bug ID | Story | Severity | Status | Evidence Task | Description |
|--------|-------|----------|--------|---------------|-------------|
| BUG-042 | Story-012 | S2 | Open | QA-005 | Damage calculation off by 10% |
| BUG-043 | Story-013 | S4 | Open | QA-008 | Visual jitter in menu transition |

**Impact on verdict**:
- S1 or S2 open → NOT APPROVED / FAIL
- S3 or S4 open → APPROVED WITH CONDITIONS / CONCERNS

---

## Phase 6: Identify Unverifiable Criteria

Scan all evidence tasks for:
- `status: blocked` with `failure_reason` containing "unverifiable" or "manual confirmation required"
- `status: deferred` with notes about subjective quality or environment constraints

Produce an unverifiable criteria table:

| Story | AC ID | Task ID | Why Unverifiable | Impact | Owner Decision |
|-------|-------|---------|------------------|--------|----------------|
| Story-042 | AC-3 | QA-007 | Subjective "feel" assessment | ADVISORY | Deferred to playtest |
| Story-043 | AC-5 | QA-009 | Unity Play Mode required | BLOCKING | Owner confirmed manually (2026-05-08) |

**Impact**:
- BLOCKING unverifiable without owner confirmation → contributes to NOT APPROVED / FAIL
- BLOCKING unverifiable WITH owner confirmation → PASS with note
- ADVISORY unverifiable → CONCERNS with note

---

## Phase 7: Generate Sign-Off Report

Assemble the full report using this structure:

```markdown
# QA Sign-Off Report: [Scope]
**Date**: [date]
**Scope**: [sprint-03 | milestone-mvp | gate-team-qa]
**QA Lead Sign-Off**: [pending | approved | not approved]

---

## Executive Summary

- **Total Evidence Tasks**: [N]
- **BLOCKING Tasks**: [N] — [N] pass, [N] fail, [N] blocked
- **ADVISORY Tasks**: [N] — [N] pass, [N] fail, [N] blocked
- **Bugs Filed**: [N] — [N] S1/S2, [N] S3/S4
- **Unverifiable Criteria**: [N] BLOCKING, [N] ADVISORY

---

## Evidence Task Summary by Type

| Task Type | Gate Level | Total | Pass | Fail | Blocked | Deferred | Result |
|-----------|-----------|-------|------|------|---------|----------|--------|
| unit-test | BLOCKING | [N] | [N] | [N] | [N] | [N] | [ALL PASS / HAS FAILURES] |
| integration-test | BLOCKING | [N] | [N] | [N] | [N] | [N] | [ALL PASS / HAS FAILURES] |
| visual-evidence | ADVISORY | [N] | [N] | [N] | [N] | [N] | [ALL PASS / HAS FAILURES] |
| ui-evidence | ADVISORY | [N] | [N] | [N] | [N] | [N] | [ALL PASS / HAS FAILURES] |
| smoke-check | ADVISORY | [N] | [N] | [N] | [N] | [N] | [ALL PASS / HAS FAILURES] |

---

## Bugs Found

| Bug ID | Story | Severity | Status | Evidence Task | Description | Impact |
|--------|-------|----------|--------|---------------|-------------|--------|
| BUG-042 | Story-012 | S2 | Open | QA-005 | [description] | BLOCKING |
| BUG-043 | Story-013 | S4 | Open | QA-008 | [description] | ADVISORY |

**S1/S2 bugs**: [N] — must be resolved before advancement
**S3/S4 bugs**: [N] — may be deferred to polish or noted as conditions

---

## Unverifiable Criteria

Acceptance criteria that could not be verified autonomously:

| Story | AC ID | Task ID | Why Unverifiable | Impact | Owner Decision |
|-------|-------|---------|------------------|--------|----------------|
| Story-042 | AC-3 | QA-007 | Subjective "feel" | ADVISORY | Deferred to playtest |
| Story-043 | AC-5 | QA-009 | Unity Play Mode | BLOCKING | Owner confirmed (2026-05-08) |

**BLOCKING unverifiable criteria without owner confirmation prevent APPROVED verdict.**

---

## Evidence Task Details

### BLOCKING Tasks

| Task ID | Story | Type | Status | Result | Evidence Artifact | Bug Filed |
|---------|-------|------|--------|--------|-------------------|-----------|
| QA-001 | Story-012 | unit-test | pass | PASS | tests/unit/combat/... | — |
| QA-002 | Story-013 | integration-test | fail | FAIL | production/qa/evidence/... | BUG-042 |

### ADVISORY Tasks

| Task ID | Story | Type | Status | Result | Evidence Artifact | Bug Filed |
|---------|-------|------|--------|--------|-------------------|-----------|
| QA-005 | Story-014 | visual-evidence | pass | PASS | production/qa/evidence/... | — |
| QA-006 | Story-015 | ui-evidence | pass | PASS | production/qa/evidence/... | — |

---

## Verdict: [APPROVED | APPROVED WITH CONDITIONS | NOT APPROVED]

[Apply verdict rules from Phase 4]

**Verdict Rationale**:
[Explain which conditions led to this verdict]

**Conditions** (if APPROVED WITH CONDITIONS):
- [List what must be tracked or noted, e.g., "S3/S4 bugs deferred to polish"]
- [List ADVISORY failures or blockers]

**Blockers** (if NOT APPROVED):
- [List specific BLOCKING failures or open S1/S2 bugs]
- [List BLOCKING unverifiable criteria without owner confirmation]

---

## Next Steps

[Based on verdict:]

**If APPROVED**:
- Build is ready for the next phase
- Run `/gate-check` to validate phase advancement
- Close all evidence tasks with `status: pass`

**If APPROVED WITH CONDITIONS**:
- Track conditions in production/qa/conditions-tracker.md
- S3/S4 bugs may be deferred to polish phase
- ADVISORY failures noted for follow-up
- May proceed with owner acknowledgment of conditions

**If NOT APPROVED**:
- Resolve all BLOCKING failures and S1/S2 bugs
- Re-run failed evidence tasks after fixes
- Re-run `/qa-evidence-aggregate [scope]` after resolution
- Do not advance to next phase until verdict is APPROVED
```

Ask: "May I write this QA sign-off report to `production/qa/qa-signoff-[scope]-[date].md`?"

Write only after approval.

---

## Phase 8: Update Evidence Task Statuses

After writing the sign-off report:

1. For all tasks with `status: pass` → mark as `closed` (if using GitHub issues) or archive (if files)
2. For all tasks with `status: fail` → keep open until bug is resolved
3. For all tasks with `status: blocked` → surface to owner for decision (resolve or defer)
4. Update the master tracker (`evidence-tracking-[scope]-[date].md`) with final status counts

Ask: "May I update evidence task statuses to reflect aggregation results?"

Update only after approval.

---

## Collaborative Protocol

- **Never write the sign-off report without asking** — Phase 7 requires explicit approval
- **Verdict rules are deterministic** — do not override verdict based on subjective assessment
- **BLOCKING failures always block** — do not downgrade a BLOCKING task to ADVISORY
- **Unverifiable criteria must be surfaced** — do not silently skip or assume PASS
- Use `AskUserQuestion` for scope selection when no argument provided
- Keep all other phases non-interactive — present findings, then ask once to approve the write

---

## Output

"QA evidence aggregated for [scope].
Verdict: [APPROVED | APPROVED WITH CONDITIONS | NOT APPROVED]
Sign-off report written to `production/qa/qa-signoff-[scope]-[date].md`.

Next: [based on verdict — advance to gate-check, resolve blockers, or track conditions]"
