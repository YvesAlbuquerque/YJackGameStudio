# QA Evidence Task: [Task ID]

> **Task Type**: [unit-test | integration-test | visual-evidence | ui-evidence | smoke-check | playtest-session | release-check]
> **Story**: `[story file path or ID]`
> **Status**: [assigned | in_progress | pass | fail | blocked | deferred]
> **Assigned To**: [qa-tester role or name]
> **Date Created**: [YYYY-MM-DD]
> **Gate**: [story-done | smoke-check | team-qa | gate-check | release]

---

## Test Scope

**Acceptance Criteria Covered**: [AC-1, AC-2, AC-3]

**Test Description**:
[One paragraph: what behavior is being validated and what success looks like]

**Expected Result**:
[Clear pass condition for this evidence task]

---

## Preconditions

- [Build requirement, e.g., "Build from commit abc123"]
- [Environment requirement, e.g., "Test data seeded"]
- [Platform/hardware, e.g., "Windows 11, GTX 1080"]

If none: *No special preconditions required.*

---

## Execution

### Automated Test (if applicable)

**Test File**: `[path to test file]`
**Validation Command**: `[command to run test]`
**Test Framework**: [GDUnit4 | Unity Test Runner | UE Automation | etc.]

### Manual Steps (if applicable)

1. [Step 1 — numbered, unambiguous actions]
2. [Step 2]
3. [Step 3]

---

## Results

**Result**: [PASS | FAIL | BLOCKED | NOT_RUN]
**Actual Result**: [What actually happened — required when FAIL]
**Failure Reason**: [Root cause — required when FAIL]
**Bug Filed**: [BUG-NNN if defect found]

### Evidence Artifacts

| File | Type | Description | AC Covered |
|------|------|-------------|------------|
| `[filename]` | screenshot | [what it shows] | AC-1 |
| `[filename]` | video | [what it demonstrates] | AC-2 |
| `[test-output.txt]` | log | [test execution log] | All |

Store artifacts in: `production/qa/evidence/[story-slug]/`

---

## Acceptance Criteria Verification

| AC ID | Criterion (from story) | Verified? | Evidence | Notes |
|-------|----------------------|-----------|----------|-------|
| AC-1 | [exact criterion text] | ✅ PASS / ❌ FAIL / ⏸ DEFERRED | [artifact or test name] | [observations] |
| AC-2 | [exact criterion text] | ✅ PASS / ❌ FAIL / ⏸ DEFERRED | [artifact or test name] | |

---

## Sign-Offs (for manual evidence tasks)

Required approvals before this evidence can be marked `pass`:

| Role | Name | Date | Approved |
|------|------|------|----------|
| QA Tester (executed) | | | [ ] |
| QA Lead (reviewed) | | | [ ] |
| Designer / Art Lead / UX Lead (if Visual/Feel or UI) | | | [ ] |

**Sign-off rule**: Visual/Feel and UI evidence require designer/lead approval. All evidence requires qa-lead approval.

---

## Aggregation Metadata

- **Sprint**: [sprint-03]
- **Milestone**: [mvp-alpha]
- **Aggregation Group**: [sprint-03-logic-tests]

This evidence contributes to: [qa-signoff-sprint-03-2026-05-08.md | milestone-mvp-alpha-evidence.md]

---

## Notes

[Any additional context, special setup instructions, or agent observations]

---

## Status Log

| Timestamp | From | To | Agent | Note |
|-----------|------|----|-------|------|
| 2026-05-08T10:00:00Z | assigned | in_progress | qa-tester | Starting test execution |
| 2026-05-08T11:30:00Z | in_progress | pass | qa-tester | All AC verified; evidence committed |

---

*Template: `.agents/docs/templates/qa-evidence-task.md`*
*Schema: `.agents/docs/qa-evidence-task-schema.md`*
*Location: `production/qa/evidence-tasks/[task-id].md`*
