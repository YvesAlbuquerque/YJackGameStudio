---
name: adopt
description: "Brownfield onboarding — audits existing project artifacts for template format compliance (not just existence), classifies gaps by impact, and produces a numbered migration plan. Run this when joining an in-progress project or upgrading from an older template version. Distinct from /project-stage-detect (which checks what exists) — this checks whether what exists will actually work with the template's skills."
argument-hint: "[focus: full | gdds | adrs | stories | infra]"
user-invocable: true
allowed-tools: Read, Glob, Grep, Write, AskUserQuestion
agent: technical-director
---

# Adopt — Brownfield Template Adoption

This skill audits an existing project's artifacts for **format compliance** with
the template's skill pipeline, then produces a prioritised migration plan.

**This is not `/project-stage-detect`.**
`/project-stage-detect` answers: *what exists?*
`/adopt` answers: *will what exists actually work with the template's skills?*

A project can have GDDs, ADRs, and stories — and every format-sensitive skill
will still fail silently or produce wrong results if those artifacts are in the
wrong internal format.

**Output:** `docs/adoption-plan-[date].md` — a persistent, checkable migration plan.

**Argument modes:**

**Audit mode:** `$ARGUMENTS[0]` (blank = `full`)

- **No argument / `full`**: Complete audit — all artifact types
- **`gdds`**: GDD format compliance only
- **`adrs`**: ADR format compliance only
- **`stories`**: Story format compliance only
- **`infra`**: Infrastructure artifact gaps only (registry, manifest, sprint-status, stage.txt)

---

## Phase 1: Detect Project State

Emit one line before reading: `"Scanning project artifacts..."` — this confirms the
skill is running during the silent read phase.

Then read silently before presenting anything else.

### Existence check
- `production/stage.txt` — if present, read it (authoritative phase)
- `design/gdd/game-concept.md` — concept exists?
- `design/gdd/systems-index.md` — systems index exists?
- Count GDD files: `design/gdd/*.md` (excluding game-concept.md and systems-index.md)
- Count ADR files: `docs/architecture/adr-*.md`
- Count story files: `production/epics/**/*.md` (excluding EPIC.md)
- `.agents/docs/technical-preferences.md` — engine configured?
- `docs/engine-reference/` — engine reference docs present?
- Glob `docs/adoption-plan-*.md` — note the filename of the most recent prior plan if any exist

### YJackCore Detection

After the existence check, detect whether the project is YJackCore-backed. Treat the project
as YJackCore-backed (`yjackcore_detected: true`) if **any** of the following are true:

- `.yjack-workspace.json` is present at the project root
- `Packages/manifest.json` contains `com.ygamedev.yjack` or `YJackCore`
- `Packages/YJackCore/package.json` exists
- `.gitmodules` contains a reference to `YJackCore` (git submodule detection)
- `.agents/docs/technical-preferences.md` contains `- **Framework**: YJackCore`

Record the detection method and the detected package path(s) for use in later phases.

If `yjackcore_detected` is true:
- Read `.agents/docs/yjackcore-authority.md` and `.agents/docs/yjackcore-support.md`.
- Record all YJackCore package paths as **protected** (e.g. `Packages/YJackCore/`,
  `Packages/com.ygamedev.yjack/`). All audit phases must scan these paths read-only
  and must never propose writes to them without explicit owner authorization.
- Emit: "YJackCore detected via [method]. Package path(s) protected: [paths]."

### Infer phase (if no stage.txt)
Use the same heuristic as `/project-stage-detect`:
- 10+ source files in `src/` → Production
- Stories in `production/epics/` → Pre-Production
- ADRs exist → Technical Setup
- systems-index.md exists → Systems Design
- game-concept.md exists → Concept
- Nothing → Fresh (not a brownfield project — suggest `/start`)

If the project appears fresh (no artifacts at all), use `AskUserQuestion`:
- "This looks like a fresh project — no existing artifacts found. `/adopt` is for
  projects with work to migrate. What would you like to do?"
  - "Run `/start` — begin guided first-time onboarding"
  - "My artifacts are in a non-standard location — help me find them"
  - "Cancel"

Then stop — do not proceed with the audit regardless of which option the user picks
(each option leads to a different skill or manual investigation).

Report: "Detected phase: [phase]. Found: [N] GDDs, [M] ADRs, [P] stories."

---

## Phase 2: Format Audit

For each artifact type in scope (based on argument mode), check not just that
the file exists but that it contains the internal structure the template requires.

### 2a: GDD Format Audit

For each GDD file found, check for the 8 required sections by scanning headings:

| Required Section | Heading pattern to look for |
|---|---|
| Overview | `## Overview` |
| Player Fantasy | `## Player Fantasy` |
| Detailed Rules / Design | `## Detailed` or `## Core Rules` or `## Detailed Design` |
| Formulas | `## Formulas` or `## Formula` |
| Edge Cases | `## Edge Cases` |
| Dependencies | `## Dependencies` or `## Depends` |
| Tuning Knobs | `## Tuning` |
| Acceptance Criteria | `## Acceptance` |

For each GDD, record:
- Which sections are present
- Which sections are missing
- Whether it has any content in present sections or just placeholder text
  (`[To be designed]` or equivalent)

Also check: does each GDD have a `**Status**:` field in its header block?
Valid values: `In Design`, `Designed`, `In Review`, `Approved`, `Needs Revision`.

### 2b: ADR Format Audit

For each ADR file found, check for these critical sections:

| Section | Impact if missing |
|---|---|
| `## Status` | **BLOCKING** — `/story-readiness` ADR status check silently passes everything |
| `## ADR Dependencies` | HIGH — dependency ordering in `/architecture-review` breaks |
| `## Engine Compatibility` | HIGH — post-cutoff API risk is unknown |
| `## GDD Requirements Addressed` | MEDIUM — traceability matrix loses coverage |
| `## Performance Implications` | LOW — not pipeline-critical |

For each ADR, record: which sections present, which missing, current Status value
if the Status section exists.

### 2c: systems-index.md Format Audit

If `design/gdd/systems-index.md` exists:

1. **Parenthetical status values** — Grep for any Status cell containing
   parentheses: `"Needs Revision ("`, `"In Progress ("`, etc.
   These break exact-string matching in `/gate-check`, `/create-stories`,
   and `/architecture-review`. **BLOCKING.**

2. **Valid status values** — check that Status column values are only from:
   `Not Started`, `In Progress`, `In Review`, `Designed`, `Approved`, `Needs Revision`
   Flag any unrecognised values.

3. **Column structure** — check that the table has at minimum: System name,
   Layer, Priority, Status columns. Missing columns degrade skill functionality.

### 2d: Story Format Audit

For each story file found:

- **`Manifest Version:` field** — present in story header? (LOW — auto-passes if absent)
- **TR-ID reference** — does story contain `TR-[a-z]+-[0-9]+` pattern? (MEDIUM — no staleness tracking)
- **ADR reference** — does story reference at least one ADR? (check for `ADR-` pattern)
- **Status field** — present and readable?
- **Acceptance criteria** — does the story have a checkbox list (`- [ ]`)?

### 2e: Infrastructure Audit

| Artifact | Path | Impact if missing |
|---|---|---|
| TR registry | `docs/architecture/tr-registry.yaml` | HIGH — no stable requirement IDs |
| Control manifest | `docs/architecture/control-manifest.md` | HIGH — no layer rules for stories |
| Manifest version stamp | In manifest header: `Manifest Version:` | MEDIUM — staleness checks blind |
| Sprint status | `production/sprint-status.yaml` | MEDIUM — `/sprint-status` falls back to markdown |
| Stage file | `production/stage.txt` | MEDIUM — phase auto-detect unreliable |
| Engine reference | `docs/engine-reference/[engine]/VERSION.md` | HIGH — ADR engine checks blind |
| Architecture traceability | `docs/architecture/architecture-traceability.md` | MEDIUM — no persistent matrix |

### 2f: Technical Preferences Audit

Read `.agents/docs/technical-preferences.md`. Check each field for `[TO BE CONFIGURED]`:
- Engine, Language, Rendering, Physics → HIGH if unconfigured (ADR skills fail)
- Naming conventions → MEDIUM
- Performance budgets → MEDIUM
- Forbidden Patterns, Allowed Libraries → LOW (starts empty by design)

### 2g: YJackCore Compliance Audit

*Skip this section if `yjackcore_detected` is `false`.*

Read `.agents/docs/yjackcore-authority.md` and `.agents/docs/yjackcore-support.md` before
performing this audit. This section audits host-game compliance with YJackCore conventions
and never proposes modifications to files under `Packages/YJackCore/**` or
`Packages/com.ygamedev.yjack/**`.

#### 2g-1: Workspace Manifest

Check for `.yjack-workspace.json` at the project root:
- Missing: **HIGH** gap — agents cannot reliably resolve package paths across layouts
- Present: verify required fields (`layout`, `packageName`, `version`, `unityVersion`) are
  populated and not placeholder text. Each missing required field → **MEDIUM** gap.

#### 2g-2: Framework Integration in Technical Preferences

Check `.agents/docs/technical-preferences.md` for a `## Framework Integration` section:

| Field | Impact if missing |
|---|---|
| `Framework:` set to `YJackCore` | HIGH — YJackCore routing skipped by agent skills |
| `Framework Source:` | MEDIUM — package path resolution unreliable |
| `Framework Version:` | MEDIUM — version drift risk; ADR engine checks may mismatch |
| `Framework Docs:` and `Framework Rules:` | LOW — reference links only |
| `Workspace Manifest:` pointing to `.yjack-workspace.json` | LOW — can be inferred |

#### 2g-3: Framework Integration Notes

Check for `docs/framework/yjackcore-integration.md`:
- Missing entirely: **MEDIUM** — no layer ownership record; GDD authors lack routing guidance
- Present but missing `## Layer Ownership` section: **MEDIUM**
- Present but missing `## Ownership Boundary` section: **LOW**

#### 2g-4: Systems Index Layer Mapping

If `design/gdd/systems-index.md` exists, check whether the table contains a `Layer` column
with YJackCore layer values:
- `Layer` column missing entirely: **BLOCKING** — stories cannot be layer-routed; all
  YJackCore-aware skills will assign incorrect layer ownership, potentially placing
  host-game code in framework-owned layers (e.g. GameLayer) or missing Shared placement
- `Layer` column present but all rows are empty or `[TBD]`: **HIGH** — routing data absent
- `Layer` column present with at least some valid values: PASS (record which rows are still
  `[TBD]` as **MEDIUM** gaps)

Valid layer values for host-game systems: `GameLayer`, `LevelLayer`, `SceneLayer`,
`PlayerLayer`, `CoreLayer`, `ViewLayer`, `Shared`, `host-only`.

The value `framework-change` is reserved for work items that require modifying the
YJackCore package itself. Do not assign it to rows in `design/gdd/systems-index.md`;
instead, record such items as separate, owner-authorized framework work items (see
Phase 4 special case).

For each GDD file, grep for any of the valid layer names or the word `layer`:
- No layer declaration found: **MEDIUM** — story generation will not include layer context

#### 2g-5: Package Boundary Integrity

Grep `src/` for hard-coded internal YJackCore package paths
(`Packages/YJackCore/Runtime`, `Packages/com.ygamedev.yjack/Runtime`):
- Any match: **HIGH** — host code is coupled to YJackCore internals, creating fragile boundary

This is a read-only audit. Do not propose modifications to any file under
`Packages/YJackCore/**` or `Packages/com.ygamedev.yjack/**`.

#### 2g-6: Manual Unity Validation Items

Flag the following conditions as requiring **manual Unity validation** (owner must confirm
in the Unity Editor — agents cannot autonomously verify these):

| Condition detected | Validation required |
|---|---|
| YJackCore detected and `src/` has `.asmdef` files | Domain reload + compile symbol check |
| GDDs reference prefabs or ScriptableObject assets | Play Mode scene wiring |
| Stories reference YJackCore ViewLayer components | UI rendering + input routing |
| `.yjack-workspace.json` `layout` is `submodule` | Package Manager resolution check |

Record every flagged manual validation item — they will appear in the adoption plan output.

---

## Phase 3: Classify and Prioritise Gaps

Organise every gap found across all audits into four severity tiers:

**BLOCKING** — Will cause template skills to silently produce wrong results *right now*.
Examples: ADR missing Status field, systems-index parenthetical status values,
engine not configured when ADRs exist.

**If `yjackcore_detected` is true**, add to BLOCKING:
- `design/gdd/systems-index.md` exists but `Layer` column is entirely missing

**HIGH** — Will cause stories to be generated with missing safety checks, or
infrastructure bootstrapping will fail.
Examples: ADRs missing Engine Compatibility, GDDs missing Acceptance Criteria
(stories can't be generated from them), tr-registry.yaml missing.

**If `yjackcore_detected` is true**, add to HIGH:
- `.yjack-workspace.json` missing (package path resolution unreliable)
- `## Framework Integration` section absent from `technical-preferences.md`
- `Layer` column present in systems-index but all rows have empty or `[TBD]` values
- `src/` code directly references YJackCore internal paths (boundary violation)

**MEDIUM** — Degrades quality and pipeline tracking but does not break functionality.
Examples: GDDs missing Tuning Knobs or Formulas sections, stories missing TR-IDs,
sprint-status.yaml missing.

**If `yjackcore_detected` is true**, add to MEDIUM:
- `.yjack-workspace.json` present but missing required fields
- `Framework Source:` or `Framework Version:` missing from technical preferences
- `docs/framework/yjackcore-integration.md` missing or missing `## Layer Ownership`
- Individual systems-index rows with `[TBD]` layer values
- GDDs with no YJackCore layer declaration

**LOW** — Retroactive improvements that are nice-to-have but not urgent.
Examples: Stories missing Manifest Version stamps, GDDs missing Open Questions section.

**If `yjackcore_detected` is true**, add to LOW:
- `Framework Docs:`, `Framework Rules:`, or `Workspace Manifest:` fields missing from
  technical preferences
- `## Ownership Boundary` section missing from `docs/framework/yjackcore-integration.md`

Count totals per tier. If zero BLOCKING and zero HIGH gaps: report that the project
is template-compatible and only advisory improvements remain.

---

## Phase 4: Build the Migration Plan

Compose a numbered, ordered action plan. Ordering rules:
1. BLOCKING gaps first (must fix before any pipeline skill runs reliably)
2. HIGH gaps next, infrastructure before GDD/ADR content (bootstrapping needs correct formats)
3. MEDIUM gaps ordered: GDD gaps before ADR gaps before story gaps (stories depend on GDDs and ADRs)
4. LOW gaps last

For each gap, produce a plan entry with:
- A clear problem statement (one sentence, no jargon)
- The exact command to fix it, if a skill handles it
- Manual steps if it requires direct editing
- A time estimate (rough: 5 min / 30 min / 1 session)
- A checkbox `- [ ]` for tracking

**Special case — systems-index parenthetical status values:**
This is always the first item if present. Show the exact values that need changing
and the exact replacement text. Offer to fix this immediately before writing the plan.

**Special case — ADRs missing Status field:**
For each affected ADR, the fix is:
`/architecture-decision retrofit docs/architecture/adr-[NNNN]-[slug].md`
List each ADR as a separate checkable item.

**Special case — GDDs missing sections:**
For each affected GDD, list which sections are missing and the fix:
`/design-system retrofit design/gdd/[filename].md`

**Special case — YJackCore migration (only if `yjackcore_detected` is true):**

Insert a **YJackCore Integration** section in the plan after infrastructure bootstrap steps.
Every YJackCore gap item must be a separate, independently-actionable entry. Identify and
label items that can be executed in parallel:

- **Group A — Workspace & Config** *(parallelizable with Group B)*:
  - Create or repair `.yjack-workspace.json` from
    `.agents/docs/templates/yjack-workspace.json`
  - Add or repair `## Framework Integration` section in
    `.agents/docs/technical-preferences.md`

- **Group B — Design Docs** *(parallelizable with Group A)*:
  - Add `Layer` column to `design/gdd/systems-index.md` with valid YJackCore layer values
  - Add YJackCore layer ownership declaration to each GDD lacking one
  - Create `docs/framework/yjackcore-integration.md` from
    `.agents/docs/templates/yjackcore-unity-bootstrap.md` section 4

- **Group C — Manual Unity Validation** *(always sequential; owner-only)*:
  - For each manual validation item flagged in Phase 2g-6, list a separate entry with:
    > ⚠️ **Requires manual Unity validation** — owner must confirm in Unity Editor
    > before marking Done. Use the checklist at
    > `.agents/docs/templates/yjackcore-unity-manual-validation.md`.

For any gap that can only be resolved by modifying framework package files, **do not include
it in the host-game adoption plan**. Instead, call it out explicitly:
> ⚠️ **Framework package change required** — create a separate work item with explicit
> owner authorization and follow the YJackCore repository's own `AGENTS.md` for package
> boundary rules.

**Infrastructure bootstrap ordering** — always present in this sequence:
1. Fix ADR formats first (registry depends on reading ADR Status fields)
2. Run `/architecture-review` → bootstraps `tr-registry.yaml`
3. Run `/create-control-manifest` → creates manifest with version stamp
4. Run `/sprint-plan update` → creates `sprint-status.yaml`
5. Run `/gate-check [phase]` → writes `stage.txt` authoritatively

**Existing stories** — note explicitly:
> "Existing stories continue to work with all template skills — all new format
> checks auto-pass when the fields are absent. They won't benefit from TR-ID
> staleness tracking or manifest version checks until they're regenerated. This
> is intentional: do not regenerate stories that are already in progress."

---

## Phase 5: Present Summary and Ask to Write

Present a compact summary before writing:

```
## Adoption Audit Summary
Phase detected: [phase]
Engine: [configured / NOT CONFIGURED]
YJackCore: [detected via <method> / not detected]
GDDs audited: [N] ([X] fully compliant, [Y] with gaps)
ADRs audited: [N] ([X] fully compliant, [Y] with gaps)
Stories audited: [N]

Gap counts:
  BLOCKING: [N] — template skills will malfunction without these fixes
  HIGH:     [N] — unsafe to run /create-stories or /story-readiness
  MEDIUM:   [N] — quality degradation
  LOW:      [N] — optional improvements

[If yjackcore_detected is true:]
YJackCore gaps:
  BLOCKING: [N]  HIGH: [N]  MEDIUM: [N]  LOW: [N]
  Manual Unity validation required: [N items]
  Protected package paths: [list]

Estimated remediation: [X blocking items × ~Y min each = roughly Z hours]

Verdict: READY (no BLOCKING or HIGH gaps)
  — or —
Verdict: BLOCKED ([N] BLOCKING gap(s) must be resolved before pipeline skills run reliably)
```

Before asking to write, show a **Gap Preview**:
- List every BLOCKING gap as a one-line bullet describing the actual problem
  (e.g. `systems-index.md: 3 rows have parenthetical status values`,
  `adr-0002.md: missing ## Status section`). No counts — show the actual items.
- Show HIGH / MEDIUM / LOW as counts only (e.g. `HIGH: 4, MEDIUM: 2, LOW: 1`).

This gives the user enough context to judge scope before committing to writing the file.

If a prior adoption plan was detected in Phase 1, add a note:
> "A previous plan exists at `docs/adoption-plan-[prior-date].md`. The new plan will
> reflect current project state — it does not diff against the prior run."

Use `AskUserQuestion`:
- "Ready to write the migration plan?"
  - "Yes — write `docs/adoption-plan-[date].md`"
  - "Show me the full plan preview first (don't write yet)"
  - "Cancel — I'll handle migration manually"

If the user picks "Show me the full plan preview", output the complete plan as a
fenced markdown block. Then ask again with the same three options.

---

## Phase 6: Write the Adoption Plan

If approved, write `docs/adoption-plan-[date].md` with this structure:

```markdown
# Adoption Plan

> **Generated**: [date]
> **Project phase**: [phase]
> **Engine**: [name + version, or "Not configured"]
> **YJackCore**: [detected via <method> + version, or "Not detected"]
> **Template version**: v1.0+

Work through these steps in order. Check off each item as you complete it.
Re-run `/adopt` anytime to check remaining gaps.

---

## Step 1: Fix Blocking Gaps

[One sub-section per blocking gap with problem, fix command, time estimate, checkbox]

---

## Step 2: Fix High-Priority Gaps

[One sub-section per high gap]

---

## Step 3: Bootstrap Infrastructure

### 3a. Register existing requirements (creates tr-registry.yaml)
Run `/architecture-review` — even if ADRs already exist, this run bootstraps
the TR registry from your existing GDDs and ADRs.
**Time**: 1 session (review can be long for large codebases)
- [ ] tr-registry.yaml created

### 3b. Create control manifest
Run `/create-control-manifest`
**Time**: 30 min
- [ ] docs/architecture/control-manifest.md created

### 3c. Create sprint tracking file
Run `/sprint-plan update`
**Time**: 5 min (if sprint plan already exists as markdown)
- [ ] production/sprint-status.yaml created

### 3d. Set authoritative project stage
Run `/gate-check [current-phase]`
**Time**: 5 min
- [ ] production/stage.txt written

---

## Step 4: YJackCore Integration

*(Include this section only if YJackCore was detected)*

> **Package paths protected** (never modify from host-game tasks):
> [list protected paths, e.g. `Packages/YJackCore/**`]
>
> Any gap resolved only by editing framework package files must be tracked as a
> separate work item with explicit owner authorization.

### Group A — Workspace & Config *(run in parallel with Group B)*

[One entry per workspace/config gap. Example:]

#### A1. Create `.yjack-workspace.json`
**Problem**: Package path layout is unrecorded; agents fall back to guesswork.
**Fix**: Copy `.agents/docs/templates/yjack-workspace.json`, choose the matching layout
block, and fill in `version`, `unityVersion`, and `packagePath`.
**Time**: 15 min
- [ ] `.yjack-workspace.json` created and populated

#### A2. Add Framework Integration to technical preferences
**Problem**: `## Framework Integration` section absent; YJackCore routing is skipped.
**Fix**: Add the section from `.agents/docs/templates/yjackcore-unity-bootstrap.md`
section 3 to `.agents/docs/technical-preferences.md`.
**Time**: 10 min
- [ ] `## Framework Integration` section populated

### Group B — Design Docs *(run in parallel with Group A)*

[One entry per design-doc gap. Example:]

#### B1. Add Layer column to systems-index.md
**Problem**: `design/gdd/systems-index.md` has no `Layer` column; story routing is broken.
**Fix**: Add a `Layer` column to the systems table. Valid host-game values: `GameLayer`,
`LevelLayer`, `SceneLayer`, `PlayerLayer`, `CoreLayer`, `ViewLayer`, `Shared`, `host-only`.
Do not use `framework-change` in this table — any system requiring framework package
changes must be tracked as a separate, owner-authorized framework work item.
**Time**: 30 min (one row per system)
- [ ] `Layer` column added with valid values for all MVP systems

#### B2. Add YJackCore layer declarations to GDDs
**Problem**: GDDs do not declare their owning YJackCore layer; stories lack routing context.
**Fix**: Add a `**YJackCore Layer**:` field in each GDD Overview section.
**Time**: 10 min per GDD
[One checkbox per affected GDD]

#### B3. Create framework integration notes
**Problem**: `docs/framework/yjackcore-integration.md` is missing.
**Fix**: Copy section 4 from `.agents/docs/templates/yjackcore-unity-bootstrap.md` to
`docs/framework/yjackcore-integration.md` and fill in the workspace details.
**Time**: 20 min
- [ ] `docs/framework/yjackcore-integration.md` created

### Group C — Manual Unity Validation *(owner-only; sequential after Groups A & B)*

> ⚠️ These items require the Unity Editor. Agents cannot confirm them.
> Use the checklist at `.agents/docs/templates/yjackcore-unity-manual-validation.md`.

[One entry per flagged manual validation item, e.g.:]

#### C1. Confirm domain reload after asmdef changes
**Validation type**: Domain reload (script compilation)
**Why manual**: Requires Unity Editor with project loaded
- [ ] Owner confirms domain reload succeeded with no compile errors

---

## Step 5: Medium-Priority Gaps

[One sub-section per medium gap]

---

## Step 6: Optional Improvements

[One sub-section per low gap]

---

## What to Expect from Existing Stories

Existing stories continue to work with all template skills. New format checks
(TR-ID validation, manifest version staleness) auto-pass when the fields are
absent — so nothing breaks. They won't benefit from staleness tracking until
regenerated. Do not regenerate stories that are in progress or done.

---

## Re-run

Run `/adopt` again after completing Step 3 to verify all blocking and high gaps
are resolved. The new run will reflect the current state of the project.
```

---

## Phase 6b: Set Review Mode

After writing the adoption plan (or if the user cancels writing), check whether
`production/review-mode.txt` exists.

**If it exists**: Read it and note the current mode — "Review mode is already set to `[current]`." — skip the prompt.

**If it does not exist**: Use `AskUserQuestion`:

- **Prompt**: "One more setup step: how much design review would you like as you work through the workflow?"
- **Options**:
  - `Full` — Director specialists review at each key workflow step. Best for teams, learning the workflow, or when you want thorough feedback on every decision.
  - `Lean (recommended)` — Directors only at phase gate transitions (/gate-check). Skips per-skill reviews. Balanced for solo devs and small teams.
  - `Solo` — No director reviews at all. Maximum speed. Best for game jams, prototypes, or if reviews feel like overhead.

Write the choice to `production/review-mode.txt` immediately after selection — no separate "May I write?" needed:
- `Full` → write `full`
- `Lean (recommended)` → write `lean`
- `Solo` → write `solo`

Create the `production/` directory if it does not exist.

---

## Phase 7: Offer First Action

After writing the plan, don't stop there. Pick the single highest-priority gap
and offer to handle it immediately using `AskUserQuestion`. Choose the first
branch that applies:

**If there are parenthetical status values in systems-index.md:**
Use `AskUserQuestion`:
- "The most urgent fix is `systems-index.md` — [N] rows have parenthetical status
  values (e.g. `Needs Revision (see notes)`) that break /gate-check,
  /create-stories, and /architecture-review right now. I can fix these in-place."
  - "Fix it now — edit systems-index.md"
  - "I'll fix it myself"
  - "Done — leave me with the plan"

**If ADRs are missing `## Status` (and no parenthetical issue):**
Use `AskUserQuestion`:
- "The most urgent fix is adding `## Status` to [N] ADR(s): [list filenames].
  Without it, /story-readiness silently passes all ADR checks. Start with
  [first affected filename]?"
  - "Yes — retrofit [first affected filename] now"
  - "Retrofit all [N] ADRs one by one"
  - "I'll handle ADRs myself"

**If GDDs are missing Acceptance Criteria (and no blocking issues above):**
Use `AskUserQuestion`:
- "The most urgent gap is missing Acceptance Criteria in [N] GDD(s):
  [list filenames]. Without them, /create-stories can't generate stories.
  Start with [highest-priority GDD filename]?"
  - "Yes — add Acceptance Criteria to [GDD filename] now"
  - "Do all [N] GDDs one by one"
  - "I'll handle GDDs myself"

**If no BLOCKING or HIGH gaps exist:**
Use `AskUserQuestion`:
- "No blocking gaps — this project is template-compatible. What next?"
  - "Walk me through the medium-priority improvements"
  - "Run /project-stage-detect for a broader health check"
  - "Done — I'll work through the plan at my own pace"

---

## Collaborative Protocol

1. **Read silently** — complete the full audit before presenting anything
2. **Show the summary first** — let the user see scope before asking to write
3. **Ask before writing** — always confirm before creating the adoption plan file
4. **Offer, don't force** — the plan is advisory; the user decides what to fix and when
5. **One action at a time** — after handing off the plan, offer one specific next step,
   not a list of six things to do simultaneously
6. **Never regenerate existing artifacts** — only fill gaps in what exists;
   do not rewrite GDDs, ADRs, or stories that already have content
