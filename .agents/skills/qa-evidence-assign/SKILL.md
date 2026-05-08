---
name: qa-evidence-assign
description: "Generate and assign QA evidence tasks for a sprint or feature. Reads story files, creates one evidence task per story based on story type, assigns tasks to qa-tester lanes, and produces a master evidence tracking document. Run after stories are implemented and before QA execution begins."
argument-hint: "[sprint | feature: system-name | story: path]"
user-invocable: true
allowed-tools: Read, Glob, Grep, Write, AskUserQuestion
agent: qa-lead
---

# QA Evidence Assignment

This skill converts a set of stories into independent QA evidence tasks that can be
executed in parallel by qa-tester agents. It reads story acceptance criteria,
classifies each story by type, generates the appropriate evidence task for each,
and produces a master tracking document.

Run this after story implementation is complete and before running `/team-qa` or
distributed QA execution.

**Output:** `production/qa/evidence-tasks/` (individual task files or GitHub issues)
**Output:** `production/qa/evidence-tracking-[scope]-[date].md` (master tracker)

---

## Phase 1: Parse Scope

**Argument:** `$ARGUMENTS` (blank = ask user via AskUserQuestion)

Determine scope using the same logic as `/qa-plan`:

- **`sprint`** — read the most recent sprint file in `production/sprints/`, extract all story file paths
- **`feature: [system-name]`** — glob `production/epics/*/story-*.md`, filter by system name
- **`story: [path]`** — validate path and load single story
- **No argument** — use `AskUserQuestion` with options: "Current sprint", "Specific feature", "Specific story"

After resolving scope, report: "Generating QA evidence tasks for [N] stories in [scope]."

If a story file is missing, note as MISSING and continue with remaining stories.

---

## Phase 2: Load Stories and Classify

For each story file in scope:

1. Read the full file and extract:
   - Story ID and title
   - **Story Type** field (Logic, Integration, Visual/Feel, UI, Config/Data, Playtest, Release)
   - **Acceptance Criteria** — complete list with IDs
   - **Test Evidence** section — expected test file path or evidence document path
   - **GDD reference** — for context
   - **System** — from file path or header

2. Classify the story type (if not explicitly set in the file):
   - Use the same classification logic from `/qa-plan` Phase 3
   - Assign primary type based on acceptance criteria content

3. Produce a classification summary table before proceeding to Phase 3

---

## Phase 3: Generate Evidence Tasks

For each story, create one evidence task based on its Story Type:

### Logic Stories → unit-test Evidence Task

```yaml
task_id: "QA-[NNN]-[story-slug]"
task_type: "unit-test"
status: "assigned"
story_ref: "[story file path]"
assigned_to: "qa-tester"
acceptance_criteria: [extracted AC IDs]
test_description: "[Story title] — verify all formulas and state transitions"
expected_result: "Unit tests pass; coverage ≥ 80%"
test_file: "[path from story Test Evidence section or inferred from system]"
validation_command: "[engine-specific test command]"
gate: "story-done"
```

**Gate level**: BLOCKING

### Integration Stories → integration-test Evidence Task

```yaml
task_type: "integration-test"
test_description: "[Story title] — verify multi-system interaction"
expected_result: "Integration test passes OR playtest document confirms AC"
test_file: "[path from Test Evidence section]"
# OR if no automated test:
evidence_artifact: "production/qa/evidence/[story-slug]-integration.md"
manual_steps: [extracted from AC]
gate: "story-done"
```

**Gate level**: BLOCKING

### Visual/Feel Stories → visual-evidence Evidence Task

```yaml
task_type: "visual-evidence"
test_description: "[Story title] — capture visual behavior and feel"
expected_result: "Screenshots show correct visual output; sign-off obtained"
evidence_artifact: "production/qa/evidence/[story-slug]-visual.md"
manual_steps:
  - "Launch game and navigate to [feature]"
  - "Capture screenshots of [specific states from AC]"
  - "Verify against GDD visual spec"
sign_offs:
  - role: "art-lead" OR "designer" (depending on AC focus)
  - role: "qa-lead"
gate: "team-qa"
```

**Gate level**: ADVISORY

### UI Stories → ui-evidence Evidence Task

```yaml
task_type: "ui-evidence"
test_description: "[Story title] — verify UI interaction and layout"
expected_result: "Walkthrough confirms all UI elements function correctly"
evidence_artifact: "production/qa/evidence/[story-slug]-ui.md"
manual_steps: [extracted from AC — each AC becomes a walkthrough step]
sign_offs:
  - role: "ux-designer" OR "designer"
  - role: "qa-lead"
gate: "team-qa"
```

**Gate level**: ADVISORY

### Config/Data Stories → smoke-check Evidence Task

```yaml
task_type: "smoke-check"
test_description: "[Story title] — spot-check tuned values in-game"
expected_result: "Values match config; no gameplay breakage"
evidence_artifact: "production/qa/smoke-[date].md"
manual_steps:
  - "Run /smoke-check sprint"
  - "Verify [specific config value] appears correctly in-game"
gate: "smoke-check"
```

**Gate level**: ADVISORY

### Playtest Stories → playtest-session Evidence Task

```yaml
task_type: "playtest-session"
test_description: "[Story title] — validate player-facing behavior in live play"
expected_result: "Playtest report confirms AC outcomes and records observations"
evidence_artifact: "production/qa/playtests/[story-slug]-playtest.md"
manual_steps:
  - "Run /playtest-report for this story scope"
  - "Capture tester notes, issues, and sentiment"
gate: "team-qa"
```

**Gate level**: ADVISORY

### Release Stories → release-check Evidence Task

```yaml
task_type: "release-check"
test_description: "[Story title] — verify release-readiness requirements"
expected_result: "Release checklist items tied to AC are complete"
evidence_artifact: "production/releases/release-checklist-[date].md"
manual_steps:
  - "Validate AC-linked release checklist entries"
  - "Confirm rollout blockers are documented"
gate: "release"
```

**Gate level**: BLOCKING

---

## Phase 4: Assign to QA Lanes

Each evidence task is assigned to a qa-tester agent lane. Lanes are logical groups
that can run in parallel.

**Lane assignment strategy**:

1. **unit-test**, **integration-test**, and **release-check** tasks (BLOCKING) → high-priority lane
2. **visual-evidence**, **ui-evidence**, and **playtest-session** tasks (ADVISORY) → medium-priority lane
3. **smoke-check** tasks (ADVISORY) → low-priority lane (batched together)

Present the lane assignment table:

| Lane | Task Count | Task Type | Execution Mode |
|------|-----------|-----------|----------------|
| High Priority | [N] | unit-test, integration-test, release-check | Parallel (collision-checked) |
| Medium Priority | [N] | visual-evidence, ui-evidence, playtest-session | Parallel (collision-checked) |
| Low Priority | [N] | smoke-check | Batched (single agent) |

---

## Phase 5: Write Evidence Task Files

For each generated evidence task:

1. Choose storage format:
   - **GitHub Issue** (recommended for active sprints): create issue using template
   - **YAML file** (for offline planning): write to `production/qa/evidence-tasks/[task-id].yml`
   - **Markdown file** (for manual tracking): write to `production/qa/evidence-tasks/[task-id].md`

2. Use `AskUserQuestion` to confirm format choice:
   ```
   question: "How should evidence tasks be stored?"
   options:
     - "GitHub issues (recommended — enables parallel execution tracking)"
     - "YAML files (for offline planning or export)"
     - "Markdown files (for manual review)"
   ```

3. If GitHub issues:
    - Use `gh issue create --template qa_evidence_task` (when template exists)
    - Apply existing labels: `domain:qa`, `type:validation`, `status:in-progress`
    - Store `task_type`, `status`, `gate`, `sprint`, and `milestone` in issue body/frontmatter fields
    - Status precedence rule: body `status` is authoritative for reads/aggregation; labels are informational and must be synchronized to body status at the next task-status update
    - If template does not exist, write YAML files instead and note template creation needed

4. If YAML or Markdown:
   - Write all files to `production/qa/evidence-tasks/`
   - Use naming: `[task-id]-[story-slug].[yml|md]`

Ask before writing: "May I write [N] evidence task files to `production/qa/evidence-tasks/`?"

Write only after approval.

---

## Phase 6: Generate Master Tracking Document

Produce a master evidence tracker that qa-lead and owner use to monitor QA progress:

```markdown
# QA Evidence Tracking: [Scope]
**Date**: [date]
**Total Tasks**: [N]
**Scope**: [sprint-03 | feature-combat | story-XYZ]

---

## Task Summary by Type

| Task Type | Count | BLOCKING | ADVISORY | Assigned | In Progress | Pass | Fail | Blocked |
|-----------|-------|----------|----------|----------|-------------|------|------|---------|
| unit-test | [N] | ✅ | | [N] | [N] | [N] | [N] | [N] |
| integration-test | [N] | ✅ | | [N] | [N] | [N] | [N] | [N] |
| visual-evidence | [N] | | ✅ | [N] | [N] | [N] | [N] | [N] |
| ui-evidence | [N] | | ✅ | [N] | [N] | [N] | [N] | [N] |
| smoke-check | [N] | | ✅ | [N] | [N] | [N] | [N] | [N] |
| playtest-session | [N] | | ✅ | [N] | [N] | [N] | [N] | [N] |
| release-check | [N] | ✅ | | [N] | [N] | [N] | [N] | [N] |

**BLOCKING tasks must all PASS before sprint can close.**
**ADVISORY tasks contribute to sign-off verdict but do not block.**

---

## Evidence Task List

| Task ID | Story | Type | Status | Assigned To | Evidence Artifact | Result |
|---------|-------|------|--------|-------------|-------------------|--------|
| QA-001 | Story: Damage Calculator | unit-test | assigned | qa-tester | tests/unit/combat/... | — |
| QA-002 | Story: UI Menu | ui-evidence | assigned | qa-tester | production/qa/evidence/... | — |

---

## Unverifiable Criteria

Stories with acceptance criteria that cannot be verified autonomously:

| Story | AC ID | Why Unverifiable | Impact | Owner Decision Required |
|-------|-------|------------------|--------|-------------------------|
| [story] | AC-3 | Requires subjective "feel" assessment | ADVISORY | Defer to playtest |
| [story] | AC-5 | Requires Unity Play Mode execution | BLOCKING | Owner must confirm manually |

**Impact**:
- BLOCKING unverifiable → escalate to owner before story can close
- ADVISORY unverifiable → note for polish phase or playtest

---

## Next Steps

1. **Parallel Execution**: Distribute tasks to qa-tester agents (each agent picks a task and updates its YAML/issue status directly)
2. **Progress Tracking**: Update this document as tasks transition to `pass`, `fail`, or `blocked`
3. **Aggregation**: Run `/qa-evidence-aggregate` when all BLOCKING tasks are `pass` to produce sign-off report
4. **Owner Dashboard**: Unverifiable criteria feed `/owner-dashboard` for visibility
```

Ask: "May I write the master tracker to `production/qa/evidence-tracking-[scope]-[date].md`?"

Write only after approval.

---

## Phase 7: Surface Unverifiable Criteria

For any story with acceptance criteria that cannot be verified autonomously (subjective
qualities, Unity Play Mode requirements, platform-specific behavior), create a summary:

```
### Unverifiable Criteria Found

The following acceptance criteria cannot be verified autonomously and require
owner decision or manual confirmation:

- **Story-042, AC-3**: "Animation feels responsive" — subjective quality; defer to playtest
- **Story-043, AC-5**: "Scene wiring correct in Unity" — Unity Play Mode required; owner must confirm
- **Story-044, AC-2**: "Gamepad input on console" — platform-specific; requires console hardware

**Recommendation**:
- BLOCKING unverifiable → owner confirms manually or defers story
- ADVISORY unverifiable → note for later gate (playtest, polish, release)

These criteria feed `/owner-dashboard` and `/gate-check` as manual validation debt.
```

---

## Collaborative Protocol

- **Never write task files without asking** — Phase 5 requires explicit approval
- **Classify conservatively**: when a story is ambiguous, default to BLOCKING evidence type
- **Do not invent test cases** beyond what acceptance criteria support
- Use `AskUserQuestion` for scope selection and storage format
- Surface unverifiable criteria immediately; do not silently skip them
- **YAML vs GitHub issues**: recommend GitHub for active sprints (enables distributed execution tracking); YAML for offline planning or export

---

## Output

"QA evidence tasks generated: [N] total, [N] BLOCKING, [N] ADVISORY.
Master tracker written to `production/qa/evidence-tracking-[scope]-[date].md`.

Next steps:
- Distribute BLOCKING tasks to qa-tester lanes for parallel execution
- Have qa-tester lanes execute assigned tasks and update task status/results in-place (or use team-qa orchestration)
- Run `/qa-evidence-aggregate [scope]` when all BLOCKING tasks complete to produce sign-off report"
