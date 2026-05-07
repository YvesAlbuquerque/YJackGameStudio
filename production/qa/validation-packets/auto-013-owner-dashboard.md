# Validation Test Scenario — AUTO-013 Owner Dashboard

**Test ID:** VAL-AUTO-013
**Date:** 2026-05-07
**Validator:** Owner
**Scope:** Owner dashboard skill and autonomous status reporting

---

## Test Objective

Validate that the owner-dashboard skill meets all acceptance criteria from AUTO-013:
- Shows active issues, blocked issues, validation debt, decisions needed, and risks
- Separates facts from recommendations
- Includes what agents can do next without owner input and what needs owner decision
- Can be generated from issues and production state
- Does not require reading every agent transcript

---

## Test Environment

**Repository State:**
- Branch: `claude/auto-013-add-owner-dashboard`
- Autonomy Mode: GUIDED (from `production/autonomy-config.md`)
- Active Sprint: None
- GitHub API: May be unavailable (test fallback to local data)

**Prerequisites:**
1. Owner-dashboard skill files exist at `.agents/skills/owner-dashboard/`
2. Dashboard template exists at `.agents/docs/templates/owner-dashboard.md`
3. Sample dashboard exists at `production/dashboard-sample.md`

---

## Test Cases

### Test Case 1: Skill File Structure

**Action:** Verify skill file completeness

**Validation Steps:**
1. Read `.agents/skills/owner-dashboard/SKILL.md`
2. Confirm frontmatter includes: name, description, argument-hint, user-invocable, allowed-tools, model
3. Confirm all 13 phases are present (Read autonomy config → Output format)
4. Confirm YJackCore integration section (§13) is present
5. Confirm related skills section lists sprint-status, gate-check, project-stage-detect, milestone-review

**Expected Result:** All sections present and complete

**Actual Result:** [Owner fills in]

**Pass/Fail:** [Owner fills in]

---

### Test Case 2: Template Structure — Facts vs. Recommendations

**Action:** Verify dashboard template separates facts from recommendations

**Validation Steps:**
1. Read `.agents/docs/templates/owner-dashboard.md`
2. Confirm **Facts** section contains only objective measurements (active issues, blocked issues, validation debt)
3. Confirm **Facts** section includes disclaimer: "This section contains objective measurements and current state, not interpretations or recommendations"
4. Confirm **Recommendations** section is a separate top-level section
5. Confirm recommendations section states: "Exactly one concrete recommendation, or 'No action needed.'"
6. Confirm no subjective judgments appear in Facts section (e.g., "good progress" or "behind schedule")

**Expected Result:** Clear separation; facts are objective; recommendations are prescriptive

**Actual Result:** [Owner fills in]

**Pass/Fail:** [Owner fills in]

---

### Test Case 3: Autonomous Next Actions vs. Owner Decisions

**Action:** Verify dashboard distinguishes autonomous actions from owner decisions

**Validation Steps:**
1. Read template sections: **Autonomous Next Actions** and **Owner Decisions Needed**
2. Confirm Autonomous Next Actions section explains autonomy mode impact:
   - GUIDED: no autonomous actions
   - SUPERVISED: LOW-risk items
   - AUTONOMOUS: LOW and MEDIUM-risk items
3. Confirm Owner Decisions Needed section includes:
   - What needs deciding
   - Why it's blocked
   - Impact if delayed
   - Suggested deadline
4. Confirm the two sections are mutually exclusive (no item appears in both)

**Expected Result:** Clear distinction; autonomy boundary respected

**Actual Result:** [Owner fills in]

**Pass/Fail:** [Owner fills in]

---

### Test Case 4: YJackCore Validation Debt Tracking

**Action:** Verify YJackCore-specific validation debt is tracked

**Validation Steps:**
1. Confirm template includes **YJackCore Status** section
2. Confirm section is conditional: "Included only when technical-preferences.md Framework field = 'YJackCore'"
3. Confirm section tracks:
   - Package boundary writes (pending owner review)
   - Host-game wiring (in progress)
   - Manual Unity validation required (count)
   - Validation debt breakdown by layer (GameLayer, ViewLayer, etc.)
   - Manual validation types (domain reload, Play Mode, build, Odin Inspector)
4. Confirm skill specification (§4) explains YJackCore validation debt detection

**Expected Result:** YJackCore validation debt fully specified; conditional on Framework detection

**Actual Result:** [Owner fills in]

**Pass/Fail:** [Owner fills in]

---

### Test Case 5: Generation Without Transcripts

**Action:** Verify dashboard can be generated from structured data only

**Validation Steps:**
1. Review skill data sources (§2, §3, §4):
   - GitHub issues (via `gh issue list`)
   - `production/dependency-graph.yml`
   - `production/session-state/handoff-*.md`
   - `production/qa/validation-packets/*.md`
   - `production/autonomy-config.md`
   - `.agents/docs/technical-preferences.md`
2. Confirm NO data source requires reading chat transcripts or session logs
3. Confirm fallback strategy when GitHub API unavailable (§12)
4. Confirm handoff files provide agent context without transcript parsing

**Expected Result:** All data from structured files; no transcript dependency

**Actual Result:** [Owner fills in]

**Pass/Fail:** [Owner fills in]

---

### Test Case 6: Sample Dashboard Accuracy

**Action:** Verify sample dashboard follows template format

**Validation Steps:**
1. Read `production/dashboard-sample.md`
2. Confirm all required sections present:
   - Summary (5 key metrics)
   - Facts (active issues, blocked issues, validation debt)
   - Autonomous Next Actions
   - Owner Decisions Needed
   - Risks (HIGH/MEDIUM/LOW)
   - YJackCore Status (conditional)
   - Recommendations (exactly one)
3. Confirm sample uses realistic data (AUTO-013 current state)
4. Confirm facts are objective (no subjective language)
5. Confirm recommendations section has exactly one action

**Expected Result:** Sample follows template exactly; realistic content

**Actual Result:** [Owner fills in]

**Pass/Fail:** [Owner fills in]

---

### Test Case 7: Risk Aggregation

**Action:** Verify risk register summary aggregates from multiple sources

**Validation Steps:**
1. Review skill §7 (Compile risk register summary)
2. Confirm risks aggregated from:
   - Handoff files (§Risk Items section)
   - Blocked issues with unresolved blockers
   - Validation debt (HIGH priority items)
   - Stale in-progress items (>3 days no update)
3. Confirm severity classification (HIGH/MEDIUM/LOW)
4. Confirm sorting: severity first, then impact on current sprint

**Expected Result:** Risks from all specified sources; sorted correctly

**Actual Result:** [Owner fills in]

**Pass/Fail:** [Owner fills in]

---

## Overall Verdict

**Summary:** [Owner fills in — brief assessment of whether AUTO-013 is complete]

**Pass/Fail:** [Owner fills in]

**Blockers:** [Owner fills in — any issues preventing validation]

**Next Steps:** [Owner fills in — e.g., "Merge to main" or "Fix issue X"]

---

## Notes

- This validation does NOT require running the skill against live data (no GitHub issues exist yet for a real game)
- Validation focuses on specification completeness and template correctness
- Live skill execution will be tested when AUTO-014 (risk register) generates real issues
- Sample dashboard serves as proof-of-format; full dashboard tested in production phase

---

## Related Work

- **AUTO-012:** Autonomous memory model (provides handoff files as data source)
- **AUTO-005:** Work contract schema (provides contract status and risk tiers)
- **AUTO-006:** Dependency graph (provides dependency and write-set collision data)
- **AUTO-014:** Risk register (will integrate with dashboard risk section)

---

## Acceptance Criteria Mapping

| Acceptance Criterion | Test Case(s) | Status |
|----------------------|--------------|--------|
| Shows active issues, blocked issues, validation debt, decisions needed, and risks | TC1, TC2, TC6 | [Owner fills in] |
| Separates facts from recommendations | TC2 | [Owner fills in] |
| Includes what agents can do next without owner input and what needs owner decision | TC3 | [Owner fills in] |
| Can be generated from issues and production state | TC5 | [Owner fills in] |
| Does not require reading every agent transcript | TC5 | [Owner fills in] |
| YJackCore alignment: calls out host-game vs. framework work and manual Unity validation debt | TC4 | [Owner fills in] |
