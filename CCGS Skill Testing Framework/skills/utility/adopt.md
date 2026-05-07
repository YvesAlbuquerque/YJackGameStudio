# Skill Test Spec: /adopt

## Skill Summary

`/adopt` audits an existing project's artifacts — GDDs, ADRs, stories, infrastructure
files, and `technical-preferences.md` — for format compliance with the template's
skill pipeline. It classifies every gap by severity (BLOCKING / HIGH / MEDIUM / LOW),
composes a numbered, ordered migration plan, and writes it to `docs/adoption-plan-[date].md`
after explicit user approval via `AskUserQuestion`.

When a YJackCore-backed Unity project is detected, the skill additionally audits workspace
manifest completeness, layer mapping in the systems index, framework integration docs, package
boundary integrity, and flags items that require manual Unity validation.

This skill is distinct from `/project-stage-detect` (which checks what exists).
`/adopt` checks whether what exists will actually work with the template's skills.

No director gates apply. The skill does NOT invoke any director agents.

---

## Static Assertions (Structural)

Verified automatically by `/skill-test static` — no fixture needed.

- [ ] Has required frontmatter fields: `name`, `description`, `argument-hint`, `user-invocable`, `allowed-tools`
- [ ] Has ≥2 phase headings
- [ ] Contains severity tier keywords: BLOCKING, HIGH, MEDIUM, LOW
- [ ] Contains "May I write" or `AskUserQuestion` language before writing the adoption plan
- [ ] Has a next-step handoff at the end (e.g., offering to fix the highest-priority gap immediately)
- [ ] Contains YJackCore detection logic referencing `.yjack-workspace.json`, `Packages/manifest.json`, and `technical-preferences.md`
- [ ] Phase 2g YJackCore Compliance Audit section is present with package boundary guard
- [ ] Adoption plan template includes YJackCore Integration section with Group A/B/C structure

---

## Director Gate Checks

None. `/adopt` is a brownfield audit utility. No director gates apply.

---

## Test Cases

### Case 1: Happy Path — All GDDs compliant, no gaps, COMPLIANT

**Fixture:**
- `design/gdd/` contains 3 GDD files; each has all 8 required sections with content
- `docs/architecture/adr-0001.md` exists with `## Status`, `## Engine Compatibility`,
  and all other required sections
- `production/stage.txt` exists
- `docs/architecture/tr-registry.yaml` and `docs/architecture/control-manifest.md` exist
- Engine configured in `technical-preferences.md`

**Input:** `/adopt`

**Expected behavior:**
1. Skill emits "Scanning project artifacts..." then reads all artifacts silently
2. Reports detected phase, GDD count, ADR count, story count
3. Phase 2 audit: all 3 GDDs have all 8 sections, Status field present and valid
4. ADR audit: all required sections present
5. Infrastructure audit: all critical files exist
6. Phase 3: zero BLOCKING, zero HIGH, zero MEDIUM, zero LOW gaps
7. Summary reports: "No blocking gaps — this project is template-compatible"
8. Uses `AskUserQuestion` to ask about writing the plan; user selects write
9. Adoption plan is written to `docs/adoption-plan-[date].md`
10. Phase 7 offers next action: no blocking gaps, offers options for next steps

**Assertions:**
- [ ] Skill reads silently before presenting any output
- [ ] "Scanning project artifacts..." appears before the silent read phase
- [ ] Gap counts show 0 BLOCKING, 0 HIGH, 0 MEDIUM (or only LOW)
- [ ] `AskUserQuestion` is used before writing the adoption plan
- [ ] Adoption plan file is written to `docs/adoption-plan-[date].md`
- [ ] Phase 7 offers a specific next action (not just a list)

---

### Case 2: Non-Compliant Documents — GDDs missing sections, NEEDS MIGRATION

**Fixture:**
- `design/gdd/` contains 2 GDD files:
  - `combat.md` — missing `## Acceptance Criteria` and `## Formulas` sections
  - `movement.md` — all 8 sections present
- One ADR (`adr-0001.md`) is missing `## Status` section
- `docs/architecture/tr-registry.yaml` does not exist

**Input:** `/adopt`

**Expected behavior:**
1. Skill scans all artifacts
2. Phase 2 audit finds:
   - `combat.md`: 2 missing sections (Acceptance Criteria, Formulas)
   - `adr-0001.md`: missing `## Status` — BLOCKING impact
   - `tr-registry.yaml`: missing — HIGH impact
3. Phase 3 classifies:
   - BLOCKING: `adr-0001.md` missing `## Status` (story-readiness silently passes)
   - HIGH: `tr-registry.yaml` missing; `combat.md` missing Acceptance Criteria (can't generate stories)
   - MEDIUM: `combat.md` missing Formulas
4. Phase 4 builds ordered migration plan:
   - Step 1 (BLOCKING): Add `## Status` to `adr-0001.md` — command: `/architecture-decision retrofit`
   - Step 2 (HIGH): Run `/architecture-review` to bootstrap tr-registry.yaml
   - Step 3 (HIGH): Add Acceptance Criteria to `combat.md` — command: `/design-system retrofit`
   - Step 4 (MEDIUM): Add Formulas to `combat.md`
5. Gap Preview shows BLOCKING items as bullets (actual file names), HIGH/MEDIUM as counts
6. `AskUserQuestion` asks to write the plan; writes after approval
7. Phase 7 offers to fix the highest-priority gap (ADR Status) immediately

**Assertions:**
- [ ] BLOCKING gaps are listed as explicit file-name bullets in the Gap Preview
- [ ] HIGH and MEDIUM shown as counts in Gap Preview
- [ ] Migration plan items are in BLOCKING-first order
- [ ] Each plan item includes the fix command or manual steps
- [ ] `AskUserQuestion` is used before writing
- [ ] Phase 7 offers to immediately retrofit the first BLOCKING item

---

### Case 3: Mixed State — Some docs compliant, some not, partial report

**Fixture:**
- 4 GDD files: 2 fully compliant, 2 with gaps (one missing Tuning Knobs, one missing Edge Cases)
- ADRs: 3 files — 2 compliant, 1 missing `## ADR Dependencies`
- Stories: 5 files — 3 have TR-ID references, 2 do not
- Infrastructure: all critical files present; `technical-preferences.md` fully configured

**Input:** `/adopt`

**Expected behavior:**
1. Skill audits all artifact types
2. Audit summary shows totals: "4 GDDs (2 fully compliant, 2 with gaps); 3 ADRs
   (2 fully compliant, 1 with gaps); 5 stories (3 with TR-IDs, 2 without)"
3. Gap classification:
   - No BLOCKING gaps
   - HIGH: 1 ADR missing `## ADR Dependencies`
   - MEDIUM: 2 GDDs with missing sections; 2 stories missing TR-IDs
   - LOW: none
4. Migration plan lists HIGH gap first, then MEDIUM gaps in order
5. Note included: "Existing stories continue to work — do not regenerate stories
   that are in progress or done"
6. `AskUserQuestion` to write plan; writes after approval

**Assertions:**
- [ ] Per-artifact compliance tallies are shown (N compliant, M with gaps)
- [ ] Existing story compatibility note is included in the plan
- [ ] No BLOCKING gaps results in no BLOCKING section in migration plan
- [ ] HIGH gap precedes MEDIUM gaps in plan ordering
- [ ] `AskUserQuestion` is used before writing

---

### Case 4: No Artifacts Found — Fresh project, guidance to run /start

**Fixture:**
- Repository has no files in `design/gdd/`, `docs/architecture/`, `production/epics/`
- `production/stage.txt` does not exist
- `src/` directory does not exist or has fewer than 10 files
- No game-concept.md, no systems-index.md

**Input:** `/adopt`

**Expected behavior:**
1. Phase 1 existence check finds no artifacts
2. Skill infers "Fresh" — no brownfield work to migrate
3. Uses `AskUserQuestion`:
   - "This looks like a fresh project — no existing artifacts found. `/adopt` is for
     projects with work to migrate. What would you like to do?"
   - Options: "Run `/start`", "My artifacts are in a non-standard location", "Cancel"
4. Skill stops — does not proceed to audit regardless of user selection

**Assertions:**
- [ ] `AskUserQuestion` is used (not a plain text message) when no artifacts are found
- [ ] `/start` is presented as a named option
- [ ] Skill stops after the question — no audit phases run
- [ ] No adoption plan file is written

---

### Case 5: Director Gate Check — No gate; adopt is a utility audit skill

**Fixture:**
- Project with a mix of compliant and non-compliant GDDs

**Input:** `/adopt`

**Expected behavior:**
1. Skill completes full audit and produces migration plan
2. No director agents are spawned at any point
3. No gate IDs (CD-*, TD-*, AD-*, PR-*) appear in output
4. No `/gate-check` is invoked during the skill run

**Assertions:**
- [ ] No director gate is invoked
- [ ] No gate skip messages appear
- [ ] Skill reaches plan-writing or cancellation without any gate verdict

---

## Protocol Compliance

- [ ] Emits "Scanning project artifacts..." before silent read phase
- [ ] Reads all artifacts silently before presenting any results
- [ ] Shows Adoption Audit Summary and Gap Preview before asking to write
- [ ] Uses `AskUserQuestion` before writing the adoption plan file
- [ ] Adoption plan written to `docs/adoption-plan-[date].md` — not to any other path
- [ ] Migration plan items ordered: BLOCKING first, HIGH second, MEDIUM third, LOW last
- [ ] Phase 7 always offers a single specific next action (not a generic list)
- [ ] Never regenerates existing artifacts — only fills gaps in what exists
- [ ] Does not invoke director gates at any point
- [ ] When YJackCore is detected, adoption plan summary includes YJackCore detection method and protected package paths
- [ ] When YJackCore is detected, adoption plan includes Step 4 YJackCore Integration with Group A/B/C structure
- [ ] Manual Unity validation items are always placed in Group C and flagged with ⚠️ note
- [ ] Package boundary violations (framework changes) are called out as separate work items, not included in host-game plan

---

## Test Cases — YJackCore

### Case 6: YJackCore Detection — `.yjack-workspace.json` present

**Fixture:**
- Standard brownfield project with GDDs and ADRs
- `.yjack-workspace.json` present at project root with `layout: submodule`, `packageName: com.ygamedev.yjack`,
  `version: 1.6.0`, `unityVersion: 6000.0`
- `design/gdd/systems-index.md` exists but has no `Layer` column
- `.agents/docs/technical-preferences.md` has `## Framework Integration` with `Framework: YJackCore`

**Input:** `/adopt`

**Expected behavior:**
1. Phase 1 YJackCore detection triggers via `.yjack-workspace.json`
2. Skill emits: "YJackCore detected via .yjack-workspace.json. Package path(s) protected: [paths]."
3. Phase 2g audit runs:
   - 2g-1: `.yjack-workspace.json` found with required fields — PASS
   - 2g-2: `## Framework Integration` found with `Framework: YJackCore` — PASS
   - 2g-4: `Layer` column missing from systems-index — **BLOCKING** gap
4. Adoption Audit Summary includes:
   - "YJackCore: detected via .yjack-workspace.json"
   - YJackCore BLOCKING: 1
5. Migration plan includes Step 4 YJackCore Integration:
   - Group B: "Add Layer column to systems-index.md" as a separate actionable item

**Assertions:**
- [ ] YJackCore detected line appears in skill output before the summary
- [ ] BLOCKING gap from missing Layer column is listed in Gap Preview as a named item
- [ ] Adoption plan includes "Step 4: YJackCore Integration" section
- [ ] Group B item for Layer column includes time estimate and checkbox
- [ ] Package paths are listed as protected in the adoption plan header

---

### Case 7: YJackCore Detection — `Packages/manifest.json` only

**Fixture:**
- `.yjack-workspace.json` absent
- `Packages/manifest.json` exists and contains `"com.ygamedev.yjack": "1.6.0"`
- `.agents/docs/technical-preferences.md` has NO `## Framework Integration` section
- `design/gdd/systems-index.md` has a `Layer` column with all rows populated

**Input:** `/adopt`

**Expected behavior:**
1. Phase 1 YJackCore detection triggers via `Packages/manifest.json`
2. Skill emits: "YJackCore detected via Packages/manifest.json."
3. Phase 2g audit:
   - 2g-1: `.yjack-workspace.json` missing — **HIGH** gap
   - 2g-2: `## Framework Integration` absent — **HIGH** gap
   - 2g-4: `Layer` column present with valid values — PASS
4. Summary shows:
   - "YJackCore: detected via Packages/manifest.json"
   - YJackCore HIGH: 2
5. Adoption plan Step 4 Group A includes:
   - A1: Create `.yjack-workspace.json`
   - A2: Add `## Framework Integration` to `technical-preferences.md`

**Assertions:**
- [ ] YJackCore detected via Packages/manifest.json is reported
- [ ] Missing `.yjack-workspace.json` classified as HIGH (not BLOCKING)
- [ ] Missing `## Framework Integration` classified as HIGH
- [ ] Group A lists both items as independently actionable (parallelizable label present)
- [ ] No YJackCore BLOCKING gaps — systems-index Layer column is compliant

---

### Case 8: YJackCore Detection — technical-preferences only (no workspace file or manifest)

**Fixture:**
- `.yjack-workspace.json` absent
- `Packages/manifest.json` absent
- `.agents/docs/technical-preferences.md` contains `- **Framework**: YJackCore`
- `design/gdd/systems-index.md` has `Layer` column; 3 of 5 rows are `[TBD]`
- 2 GDDs have no YJackCore layer declaration
- `docs/framework/yjackcore-integration.md` missing

**Input:** `/adopt`

**Expected behavior:**
1. Phase 1 detection triggers via `technical-preferences.md`
2. Phase 2g audit:
   - 2g-1: `.yjack-workspace.json` missing — HIGH
   - 2g-3: `docs/framework/yjackcore-integration.md` missing — MEDIUM
   - 2g-4: Layer column present, 3 rows `[TBD]` — MEDIUM (each row as a gap)
   - 2g-4: 2 GDDs missing layer declaration — MEDIUM each
3. No BLOCKING YJackCore gaps
4. Adoption plan includes all MEDIUM items in Group B

**Assertions:**
- [ ] YJackCore detected via technical-preferences is reported
- [ ] Per-row `[TBD]` items listed as distinct MEDIUM gaps
- [ ] `docs/framework/yjackcore-integration.md` gap includes creation command pointing to bootstrap template
- [ ] Group B lists items as parallelizable with Group A

---

### Case 9: YJackCore Package Boundary Violation Detected

**Fixture:**
- `.yjack-workspace.json` present (valid)
- `src/systems/GameManager.cs` contains the string `Packages/YJackCore/Runtime/Core`
  (direct internal path reference)
- `design/gdd/systems-index.md` has `Layer` column with all rows populated

**Input:** `/adopt`

**Expected behavior:**
1. Phase 2g-5 package boundary grep finds the internal path reference in `src/`
2. Gap classified as **HIGH** — host code coupled to YJackCore internals
3. Gap preview shows: "`src/systems/GameManager.cs`: direct YJackCore internal path reference (boundary violation)"
4. Migration plan item explains the violation and recommends replacing with the public API surface
5. No plan item proposes modifying any file under `Packages/YJackCore/**`

**Assertions:**
- [ ] Package boundary violation is detected and classified as HIGH
- [ ] The offending file and path are named explicitly in the Gap Preview
- [ ] Migration plan item recommends using public API surface — not patching YJackCore internals
- [ ] No suggested fix modifies any file under `Packages/YJackCore/**` or `Packages/com.ygamedev.yjack/**`

---

### Case 10: YJackCore Manual Unity Validation Items Flagged

**Fixture:**
- `.yjack-workspace.json` present with `layout: submodule`
- `src/` contains `.asmdef` files referencing YJackCore assemblies
- GDDs reference prefab and ScriptableObject assets
- A story references YJackCore ViewLayer components

**Input:** `/adopt`

**Expected behavior:**
1. Phase 2g-6 flags:
   - Domain reload check (`.asmdef` files detected)
   - Play Mode scene wiring (prefab/ScriptableObject references in GDDs)
   - UI rendering + input routing (ViewLayer story reference)
   - Package Manager resolution (submodule layout)
2. Adoption plan Step 4 Group C includes one entry per flagged item
3. Each Group C entry is marked: "⚠️ Requires manual Unity validation — owner must
   confirm in Unity Editor"
4. The plan references `.agents/docs/templates/yjackcore-unity-manual-validation.md`

**Assertions:**
- [ ] Manual validation items appear exclusively in Group C (not mixed into Groups A or B)
- [ ] ⚠️ marker is present on each Group C entry
- [ ] Reference to `yjackcore-unity-manual-validation.md` template is included
- [ ] Adoption Audit Summary shows "Manual Unity validation required: [N items]"
- [ ] These items do not auto-mark as BLOCKING (they are informational flags, not format gaps)

---

### Case 11: YJackCore Not Detected — Standard Audit Runs Unchanged

**Fixture:**
- Standard brownfield project (GDDs, ADRs, stories)
- No `.yjack-workspace.json`
- No YJackCore references in `Packages/manifest.json` (or manifest absent)
- `technical-preferences.md` has no `## Framework Integration` section
- `Packages/YJackCore/` does not exist

**Input:** `/adopt`

**Expected behavior:**
1. Phase 1 YJackCore detection finds no signals — `yjackcore_detected: false`
2. Phase 2g is skipped entirely
3. No YJackCore line in the Adoption Audit Summary
4. No "Step 4: YJackCore Integration" section in the adoption plan
5. Standard audit proceeds and completes with standard gap classification

**Assertions:**
- [ ] No YJackCore detection message appears in output
- [ ] Phase 2g is not executed (no 2g gap items appear)
- [ ] Adoption plan has no YJackCore section
- [ ] Standard audit behavior is unchanged compared to pre-YJackCore version

---

## Coverage Notes

- The `gdds`, `adrs`, `stories`, and `infra` argument modes narrow the audit scope;
  each follows the same pattern as the full audit but limited to that artifact type.
  Not separately fixture-tested here.
- The systems-index.md parenthetical status value check (BLOCKING) is a special case
  that triggers an immediate fix offer before writing the plan; not separately tested.
- The review-mode.txt prompt (Phase 6b) runs after plan writing if `production/review-mode.txt`
  does not exist; not separately tested here.
- YJackCore detection via git submodule (`.gitmodules` containing `YJackCore`) follows
  the same pattern as Case 7 (detection method recorded, Phase 2g runs); not separately
  fixture-tested here.
