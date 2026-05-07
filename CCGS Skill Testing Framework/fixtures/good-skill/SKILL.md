---
name: good-skill
description: "A well-formed skill fixture used by validate-skill-static.sh CI tests. All 7 static checks must PASS."
argument-hint: "check | report [--verbose]"
user-invocable: true
allowed-tools: Read, Glob, Grep
---

# Good Skill Fixture

This file is an intentionally valid skill used as a positive test fixture
for `.agents/scripts/validate-skill-static.sh` and the
`.github/workflows/skill-catalog-ci.yml` CI workflow.

All 7 static checks must return PASS or at worst WARN for this fixture.

---

## Phase 1: Parse Arguments

Read the first argument to determine mode:

- `check` → run the structural analysis
- `report` → produce a summary report

If no argument is provided, default to `check` mode.

---

## Phase 2: Analysis

Analyse the target document according to the selected mode.

Before writing any output file, confirm with the user:
"May I write the results to `output/report.md`?"

If the user declines, print the findings to the console only.

---

## Phase 3: Report

Produce a structured summary of findings. Each finding must carry one of
these verdicts: PASS, FAIL, or CONCERNS.

If all checks pass, output: `Overall: PASS`
If any check fails, output: `Overall: FAIL`

---

## Phase 4: Recommended Next Steps

- Run `/skill-test static good-skill` to confirm structural compliance.
- Run `/skill-test spec good-skill` once a spec file has been written.
