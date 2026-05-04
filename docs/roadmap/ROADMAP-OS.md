# Game Studio Roadmap OS

**Version:** 1.0  
**Last Updated:** 2026-05-04  
**Source:** [AUTO-003] from `docs/AUTONOMOUS_GAME_STUDIO_ROADMAP.md`

---

## Overview

The Roadmap OS is the operating-system layer that keeps `docs/AUTONOMOUS_GAME_STUDIO_ROADMAP.md`
in sync with GitHub issue state. It provides:

- A **task file schema** that agents and owners can parse and validate.
- **Validation and generation scripts** that check task files and push them to GitHub as issues.
- **Duplicate-safe issue creation** so the same task is never opened twice.
- **L/XL decomposition rules** that prevent large tasks from being implemented as monoliths.
- A **planning-first Phase 1 protocol** for extra-large work items.

---

## Directory Structure

```
docs/roadmap/
  ROADMAP-OS.md          This file — operating model documentation
  task-schema.yaml       Field constraints for all task types
  tasks/
    autonomous/          AUTO-XXX tasks from the roadmap
    bugs/                BUG-XXX defect tasks
    improvements/        IMP-XXX improvement tasks
    features/            FEAT-XXX feature request tasks
  scripts/
    validate.py          Validates task files against the schema
    generate-issues.py   Creates GitHub Issues from task files (duplicate-safe)
```

---

## Task File Schema

Every task is a YAML file. The full field constraints live in `task-schema.yaml`.

### Required Fields

| Field | Type | Description |
|-------|------|-------------|
| `id` | string | Unique task identifier. Format: `AUTO-NNN`, `BUG-NNN`, `IMP-NNN`, `FEAT-NNN` |
| `type` | enum | `autonomous` \| `bug` \| `improvement` \| `feature` |
| `title` | string | Short human-readable title |
| `subsystem` | string | Component or subsystem this task belongs to |
| `priority` | enum | `P1` (critical) \| `P2` (important) \| `P3` (nice-to-have) |
| `effort` | enum | `S` \| `M` \| `L` \| `XL` — see [Effort Sizing](#effort-sizing) |
| `status` | enum | Lifecycle state — see [Lifecycle States](#lifecycle-states) |
| `description` | string | Full description of the task |

### Optional Fields

| Field | Type | Description |
|-------|------|-------------|
| `notes` | string | Additional context, constraints, or caveats |
| `github_issue` | integer or null | GitHub issue number once created |
| `labels` | list of strings | Labels to apply when creating the GitHub issue |
| `dependencies` | list of strings | IDs of tasks this task depends on |
| `acceptance_criteria` | list of strings | Checklist items that must pass before closing |
| `artifacts` | list of strings | Expected output files or documents |
| `parent_id` | string | ID of the parent task (set on subtasks produced by L/XL decomposition) |
| `subtasks` | list of strings | IDs of child tasks (set on L/XL parent tasks after decomposition) |

### Minimal Valid Example

```yaml
id: "FEAT-001"
type: feature
title: "Add player inventory system"
subsystem: gameplay
priority: P2
effort: L
status: PROPOSED
description: >
  Implement a grid-based inventory UI that supports item stacking,
  drag-and-drop reordering, and equipment slot assignment.
```

---

## ID Conventions

| Type | Prefix | Sequence | Example |
|------|--------|----------|---------|
| Autonomous roadmap items | `AUTO-` | Zero-padded 3 digits | `AUTO-003` |
| Bug defects | `BUG-` | Zero-padded 3 digits | `BUG-001` |
| Improvements | `IMP-` | Zero-padded 3 digits | `IMP-001` |
| Feature requests | `FEAT-` | Zero-padded 3 digits | `FEAT-001` |

IDs are **immutable** once created. Never reuse a closed task's ID.

> **Autonomous vs. other subtasks:** `AUTO-NNN` items do not use letter suffixes.
> When an autonomous task is decomposed, each sub-item receives a new `AUTO-NNN`
> number. Bug, improvement, and feature subtasks may append a lowercase letter
> suffix (e.g., `IMP-003a`, `IMP-003b`) to identify them as sub-tasks of `IMP-003`.

---

## Lifecycle States

```
PROPOSED → APPROVED → IN_PROGRESS → VALIDATED → CLOSED
                    ↘ BLOCKED ↗
```

| State | Meaning |
|-------|---------|
| `PROPOSED` | Task has been identified; not yet reviewed by the owner |
| `APPROVED` | Owner has reviewed and approved the task for scheduling |
| `IN_PROGRESS` | An agent or the owner is actively working on the task |
| `BLOCKED` | Work has started but is blocked; `notes` must explain the blocker |
| `VALIDATED` | All acceptance criteria have been verified |
| `CLOSED` | Task is complete and archived; `github_issue` should reference the closed issue |

### Status Transition Rules

- Only the owner may move a task from `PROPOSED` → `APPROVED`.
- Agents in `SUPERVISED` or `AUTONOMOUS` mode may move a task to `IN_PROGRESS` once it is `APPROVED`.
- Moving a task to `VALIDATED` or `CLOSED` always requires validation evidence or owner approval.
- A task may be moved back to `BLOCKED` from `IN_PROGRESS` at any time if a blocker emerges.

---

## Effort Sizing

| Size | Label | Rough Scope | Action Required |
|------|-------|-------------|-----------------|
| Small | `S` | < 1 day | Implement directly |
| Medium | `M` | 1–3 days | Implement directly |
| Large | `L` | 3–5 days | **Must decompose before starting** — see [L Decomposition](#l-decomposition) |
| Extra Large | `XL` | > 5 days | **Must go through Phase 1 Planning** — see [XL Phase 1 Planning](#xl-phase-1-planning) |

### L Decomposition

A task rated **L** is too large to implement as a single unit. Before any implementation
begins, the task must be decomposed into 2–4 subtasks, each rated **S** or **M**.

**Decomposition Protocol:**

1. Add a `subtasks` list to the parent task file with the planned sub-IDs.
2. Create one YAML file per subtask in the same `tasks/<type>/` directory.
3. Set `parent_id` in each subtask to the parent ID.
4. Each subtask must have its own `acceptance_criteria`.
5. The parent task status moves to `IN_PROGRESS` only after subtasks are `APPROVED`.
6. The parent task moves to `VALIDATED` only after all subtasks are `VALIDATED`.

**Example parent (before decomposition):**

```yaml
id: "IMP-003"
type: improvement
title: "Refactor skill loading pipeline"
subsystem: skills
priority: P2
effort: L         # Requires decomposition
status: APPROVED
description: >
  Refactor the skill loading pipeline to support lazy loading
  and improve startup time.
```

**After decomposition, add to the parent:**

```yaml
subtasks:
  - "IMP-003a"
  - "IMP-003b"
  - "IMP-003c"
```

**Subtask example:**

```yaml
id: "IMP-003a"
type: improvement
title: "Refactor skill loading pipeline — audit current loader"
subsystem: skills
priority: P2
effort: S
status: APPROVED
parent_id: "IMP-003"
description: >
  Audit the existing skill loader, document current load sequence,
  and identify hot spots.
acceptance_criteria:
  - "Load sequence diagram exists in docs/roadmap/plans/IMP-003-decomp.md"
  - "At least two performance hot spots are identified and documented"
```

### XL Phase 1 Planning

A task rated **XL** is too complex even to decompose without first doing a planning pass.
XL tasks must go through a two-phase lifecycle:

**Phase 1 — Planning (required before decomposition):**

1. Create a planning document at `docs/roadmap/plans/<task-id>-plan.md`.
2. The planning document must contain:
   - Problem statement and scope boundaries
   - Architecture impact assessment
   - Risk tier classification
   - Proposed decomposition into L-or-smaller subtasks (2–6 recommended)
   - Owner approval section
3. The parent task status stays `PROPOSED` until the owner approves the plan.
4. Once the plan is approved by the owner, set status to `APPROVED` and proceed with L decomposition as above.

**Phase 2 — Decomposition and execution:** follows the L Decomposition protocol above.

**Planning document template path:** `docs/roadmap/plans/<task-id>-plan.md`

```markdown
# Plan: <task-id> — <title>

## Problem Statement
...

## Scope Boundaries
...

## Architecture Impact
...

## Risk Tier
LOW / MEDIUM / HIGH

## Proposed Decomposition

| Sub-ID | Title | Effort | Risk |
|--------|-------|--------|------|
| ...    | ...   | S/M/L  | ...  |

## Owner Approval

- [ ] Plan reviewed
- [ ] Decomposition approved
- Approved by: [owner]
- Date: [YYYY-MM-DD]
```

---

## GitHub Issue Sync

### Principles

1. Every task file that reaches `APPROVED` status should have a corresponding GitHub issue.
2. The `github_issue` field stores the issue number once created; this prevents duplicate creation.
3. The roadmap document (`docs/AUTONOMOUS_GAME_STUDIO_ROADMAP.md`) is the **human-readable** source of truth.
4. The YAML task files in `docs/roadmap/tasks/` are the **machine-readable** source of truth.
5. GitHub issue state is the **live execution** layer; task files track canonical planning state.

### Issue Title Format

GitHub issues are titled:

```
[<id>] <title>
```

Example: `[AUTO-003] Game Studio Roadmap OS`

The `[<id>]` prefix enables duplicate detection: the generation script searches for open
and closed issues whose titles start with `[<id>]`. If one is found, the script skips
creation and logs the existing issue URL.

### Creating Issues

Use the generation script:

```bash
# Dry run — shows what would be created without touching GitHub
python3 docs/roadmap/scripts/generate-issues.py --dry-run

# Create issues for all APPROVED tasks that don't have a github_issue yet
python3 docs/roadmap/scripts/generate-issues.py

# Create issues for a specific task type only
python3 docs/roadmap/scripts/generate-issues.py --type autonomous

# Create issues for a single task
python3 docs/roadmap/scripts/generate-issues.py --id AUTO-003
```

### Validating Task Files

Run before any issue creation or PR merge:

```bash
python3 docs/roadmap/scripts/validate.py
```

Exit code 0 means all task files pass validation. Non-zero exit means validation
errors were found; the script prints each error with the offending file and field.

---

## Registering New Roadmap Items

### Adding an AUTO Item

1. Choose the next available `AUTO-NNN` ID.
2. Create `docs/roadmap/tasks/autonomous/AUTO-NNN.yaml` using the schema.
3. Add an entry to the `docs/AUTONOMOUS_GAME_STUDIO_ROADMAP.md` table of contents
   and work items section.
4. Set status to `PROPOSED`.
5. Open a PR for owner review.

> **Ownership rule:** Only the owner or an explicitly authorized agent may set
> status from `PROPOSED` → `APPROVED`.

### Adding a Bug, Improvement, or Feature

1. Choose the next available `BUG-NNN`, `IMP-NNN`, or `FEAT-NNN` ID.
2. Create the YAML file in the appropriate `tasks/<type>/` directory.
3. Status defaults to `PROPOSED`.
4. The generation script will create the GitHub issue once the owner sets it to `APPROVED`.

### Marking Items Complete

1. Set `status: VALIDATED` (or `CLOSED`) in the YAML file.
2. Set `github_issue` to the issue number.
3. Close the corresponding GitHub issue.
4. For `AUTO-*` items, update the roadmap document to reflect completion.

---

## Proposing New Roadmap Items (Agent Protocol)

Agents may propose new roadmap items, but may not self-approve them.

**Protocol:**

1. Agent creates a task YAML file with `status: PROPOSED`.
2. Agent opens a GitHub issue using the generation script in dry-run mode and
   shows the owner the preview.
3. Agent asks the owner: *"I've proposed [task-id] — [title]. Shall I create
   the GitHub issue and add it to the roadmap?"*
4. Owner approves → agent creates the issue and updates the roadmap doc.
5. Owner rejects → agent discards the draft YAML file.

This ensures no unsanctioned items enter the roadmap backlog.

---

## Roadmap Sync Protocol

When the owner or an agent updates a task's status, the following artifacts must
be kept in sync:

| Artifact | Update required |
|----------|-----------------|
| `docs/roadmap/tasks/<type>/<id>.yaml` | Always — source of truth |
| `docs/AUTONOMOUS_GAME_STUDIO_ROADMAP.md` | For `AUTO-*` items: update status badge or note |
| GitHub issue | Close or label if status moves to `VALIDATED`/`CLOSED` |
| `production/session-state/active.md` | Log the state change for audit |

---

## YJackCore Alignment

The Roadmap OS does not import or depend on YJackCore runtime code. It is a
workflow-layer system. However, all `AUTO-*` tasks that touch YJackCore paths
must respect the following constraints:

- Tasks touching `Packages/YJackCore/**` carry risk tier `HIGH`.
- Such tasks must set `labels: [yjackcore, high-risk]` in their YAML files.
- The generation script will apply these labels automatically when it detects
  the `yjackcore` label.

See `.agents/docs/autonomy-modes.md` § "YJackCore Alignment" for the full
constraint set.

---

## Reference

| File | Purpose |
|------|---------|
| `docs/roadmap/task-schema.yaml` | Machine-readable field constraints |
| `docs/roadmap/scripts/validate.py` | Task file validation |
| `docs/roadmap/scripts/generate-issues.py` | GitHub Issue generation |
| `docs/AUTONOMOUS_GAME_STUDIO_ROADMAP.md` | Human-readable roadmap |
| `.agents/docs/autonomy-modes.md` | Risk tier and autonomy mode reference |
| `production/autonomy-config.md` | Active autonomy mode |
