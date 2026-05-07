# Skill Test Spec: /owner-dashboard

## Skill Summary

`/owner-dashboard` generates a concise studio status dashboard for the owner,
separating Facts (objective state) from Recommendations (prescriptive guidance),
and distinguishing Autonomous Next Actions from Owner Decisions Needed.
Data is sourced from GitHub issues, dependency-graph.yml, handoff files, validation
packets, and autonomy-config.md — no agent transcript reading required.
For YJackCore projects the dashboard includes a YJackCore Status section tracking
host-game vs. framework-package work and manual Unity validation debt.
Verdicts: COMPLETE (dashboard written) or BLOCKED (data unavailable).

---

## Static Assertions (Structural)

Verified automatically by `/skill-test static` — no fixture needed.

- [ ] Has required frontmatter fields: `name`, `description`, `argument-hint`, `user-invocable`, `allowed-tools`
- [ ] Has ≥2 phase headings (13 phases: §1 Autonomy config → §13 YJackCore integration)
- [ ] Contains verdict keywords: COMPLETE, BLOCKED
- [ ] Contains "May I write" language (skill writes `production/dashboard.md`)
- [ ] Has a next-step handoff (Related Skills section)

---

## Director Gate Checks

| Gate ID       | Trigger condition                    | Mode guard |
|---------------|--------------------------------------|------------|
| None          | Dashboard is read-only except output | n/a        |

---

## Behaviour Specs

### B-01: Facts/Recommendations Separation

**Given** the skill runs in any autonomy mode  
**When** it writes `production/dashboard.md`  
**Then** objective state appears only in the `## Facts` section  
**And** prescriptive guidance appears only in the `## Recommendations` section  
**And** no subjective language ("good progress", "behind schedule") appears in Facts

### B-02: Autonomy Boundary Compliance

**Given** the active mode is SUPERVISED  
**When** the skill populates Autonomous Next Actions  
**Then** only `auto:low` risk-tier issues appear in that section  
**And** `auto:medium` and `auto:high` issues appear in Owner Decisions Needed

**Given** the active mode is AUTONOMOUS  
**When** the skill populates Autonomous Next Actions  
**Then** `auto:low` and `auto:medium` items may appear in that section  
**And** `auto:high` items always appear in Owner Decisions Needed

### B-03: HIGH-Risk Items Never in Autonomous Next Actions

**Given** any issue has risk tier HIGH  
**When** the dashboard is generated  
**Then** it must NOT appear in Autonomous Next Actions  
**And** it must appear in Owner Decisions Needed

### B-04: YJackCore Conditional Section

**Given** `.agents/docs/technical-preferences.md` Framework field contains "YJackCore"  
**Or** `.yjack-workspace.json` exists at repo root  
**When** the dashboard is generated  
**Then** a `## YJackCore Status` section is included  
**And** it lists host-game vs. framework-package work breakdown  
**And** it lists manual Unity validation debt by layer

**Given** Framework field starts with "[None configured"  
**And** `.yjack-workspace.json` does not exist  
**When** the dashboard is generated  
**Then** the YJackCore Status section is omitted

### B-05: No Transcript Dependency

**Given** chat transcripts or session logs are unavailable  
**When** the skill generates the dashboard  
**Then** it uses only: GitHub issues, dependency-graph.yml, handoff files,
         validation packets, and autonomy-config.md  
**And** a note is added to the dashboard header if the GitHub CLI is unavailable

---

## Edge Cases

- GitHub CLI unavailable → fall back to dependency-graph.yml; note in header
- No handoff files → note "No active handoff records" and recommend `/help`
- No dependency-graph.yml → proceed with handoff + validation packets only; note limitation
- `--verbose` flag → also write `production/dashboard-verbose.md`
- `--include-closed` flag → include issues closed within 7 days in Active Issues table
