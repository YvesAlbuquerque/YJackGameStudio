# Autonomous Validation Evidence

This standard defines the minimum evidence packet agents must produce when they
report validation results without implying unrun checks.

## Packet Location

- Default directory: `production/qa/validation-packets/`
- Suggested filename: `validation-[scope]-[YYYY-MM-DD].md`
- Required template: `.agents/docs/templates/validation-evidence-packet.md`

## Required Packet Sections

Every packet must include all sections below:

1. **Scope and Change Type**
2. **Checks Run (Static + Automated)**
3. **Checks Unavailable**
4. **Manual Validation Still Required**
5. **Verdict and Escalation**

Use explicit status keywords: `PASS`, `FAIL`, `WARN`, `NOT RUN`, `BLOCKED`.

## Scope-Specific Required Evidence

| Scope type | Required static checks |
| --- | --- |
| `docs` | File existence + required sections + cross-reference links checked |
| `skills` | `/skill-test static [skill]` (or equivalent structural checks) |
| `hooks` | Script exists, shell syntax check (`bash -n`), executable bit check |
| `unity-yjackcore` | Package boundary check + host/framework routing check + required manual Unity checklist attached |
| `issue-lifecycle` | Parent/child issue mapping, status/label checks, dependency/write-set collision checks |

## Checks Unavailable (Mandatory Logging)

When a check cannot be executed, log:

- check name
- why unavailable (tooling, environment, permissions, etc.)
- impact risk (`LOW`, `MEDIUM`, `HIGH`)
- follow-up owner/manual action needed

## Manual Validation Still Required (Mandatory Logging)

Always list the remaining manual checks that were not autonomously verifiable.

For Unity + YJackCore work, use:

- `.agents/docs/templates/yjackcore-unity-manual-validation.md`

This template includes required owner confirmation checklists for scene, prefab,
and package-level validations.

## Integration Contract

- `/story-done`: include one packet per story completion review.
- `/gate-check`: include one packet per gate verdict, including manual gate items.
- `/team-qa`: include one packet per QA cycle sign-off.

## Pilot Validation Packets

Pilot packets for AUTO-010 live in:

- `production/qa/validation-packets/pilot-docs-change.md`
- `production/qa/validation-packets/pilot-skill-change.md`
- `production/qa/validation-packets/pilot-yjackcore-unity-task.md`
