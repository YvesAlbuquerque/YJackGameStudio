# Validation Evidence Packet: auto-015-adopt-yjackcore

> **Scope type**: docs-skill-change  
> **Task / story / gate**: AUTO-015 — Autonomous Brownfield Adoption for YJackCore-Backed Unity Projects  
> **Date**: 2026-05-07  
> **Agent**: copilot  
> **Commit / ref**: copilot/auto-015-add-brownfield-adoption

---

## Scope and Change Type

- **Changed files**:
  - `.agents/skills/adopt/SKILL.md`
  - `CCGS Skill Testing Framework/skills/utility/adopt.md`
  - `production/qa/validation-packets/auto-015-adopt-yjackcore.md` (this file)
- **Change summary**:
  - Extended `/adopt` skill with YJackCore-aware detection (Phase 1), compliance audit (Phase 2g),
    YJackCore-specific gap classifications (Phase 3), parallelizable migration plan items with manual
    Unity validation flags (Phase 4), YJackCore summary in audit output (Phase 5), and YJackCore
    Integration section in the adoption plan template (Phase 6).
  - Updated skill test spec with YJackCore static assertions and 6 new test cases (Cases 6–11).
  - No modifications to YJackCore package files or `Packages/` paths.

---

## Checks Run (Static + Automated)

| Check | Type | Command / Method | Result | Evidence |
| --- | --- | --- | --- | --- |
| Skill static validation | automated | `.agents/scripts/validate-skill-static.sh adopt` | PASS | All 7 checks PASS — COMPLIANT verdict |
| Frontmatter fields present | static | Script check 1 | PASS | name, description, argument-hint, user-invocable, allowed-tools all present |
| ≥2 phase headings | static | Script check 2 | PASS | 8 headings found |
| Verdict keywords present | static | Script check 3 | PASS | BLOCKED, PASS, READY found |
| Ask-before-write language | static | Script check 4 | PASS | "May I write" / AskUserQuestion language present |
| Next-step handoff | static | Script check 5 | PASS | Phase 7 offers first action |
| YJackCore detection signals cover all 5 methods | manual review | Read Phase 1 YJackCore Detection section | PASS | .yjack-workspace.json, Packages/manifest.json, Packages/YJackCore/package.json, .gitmodules, technical-preferences.md all listed |
| Package boundary guard present | manual review | Read Phase 2g intro | PASS | "must scan these paths read-only and must never propose writes" confirmed |
| Layer mapping audit covers systems-index Layer column | manual review | Read Phase 2g-4 | PASS | BLOCKING gap for missing Layer column, HIGH for all-TBD, MEDIUM for partial TBD |
| Manual Unity validation items flagged | manual review | Read Phase 2g-6 | PASS | Table of condition → validation type; escalation to owner documented |
| Parallelizable groups in Phase 4 | manual review | Read Phase 4 YJackCore special case | PASS | Group A/B/C labels with parallelizable annotation |
| Adoption plan template includes YJackCore Integration section | manual review | Read Phase 6 plan template | PASS | Step 4 with Groups A, B, C and package boundary protection note |
| Test cases cover all 5 acceptance criteria | manual review | Read adopt.md Cases 6–11 | PASS | Detection (6,7,8,11), package boundary (9), layer mapping (6,7,8), manual validation (10), no package file modification (9) |

---

## Checks Unavailable

| Check | Why unavailable | Risk | Follow-up required |
| --- | --- | --- | --- |
| Live skill execution against a YJackCore fixture repo | No Unity project or YJackCore package available in this environment | MEDIUM | Owner runs `/adopt` against a YJackCore-backed project to verify detection and plan output |
| Unity Editor domain reload / Play Mode | Unity Editor unavailable | HIGH | Owner validates using `.agents/docs/templates/yjackcore-unity-manual-validation.md` |
| UPM package resolution check | Requires Unity Package Manager context | MEDIUM | Owner confirms package resolution in Unity Editor |

---

## Manual Validation Still Required

| Validation item | Reason manual | Owner confirmation status |
| --- | --- | --- |
| Run `/adopt` against a project with `.yjack-workspace.json` | Confirms Case 6 detection and plan output | Pending |
| Run `/adopt` against a project with only `Packages/manifest.json` YJackCore entry | Confirms Case 7 detection | Pending |
| Confirm adoption plan Step 4 Group C items are listed correctly | Requires a real project with `.asmdef` and prefab references | Pending |

---

## Verdict and Escalation

- **Overall verdict**: PASS
- **Escalation required**: No (skill and test spec changes only; no Unity Editor changes)
- **Escalation note**: Live execution against a YJackCore fixture is recommended but not
  blocking — the skill static validation passes and all acceptance criteria are covered by
  the updated SKILL.md and test spec.
