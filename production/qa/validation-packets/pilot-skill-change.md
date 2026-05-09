# Validation Evidence Packet: skills

> **Scope type**: skills  
> **Task / story / gate**: AUTO-010 pilot (skill change)  
> **Date**: 2026-05-07  
> **Agent**: copilot  
> **Commit / ref**: local

---

## Scope and Change Type

- **Changed files**:
  - `.agents/skills/story-done/SKILL.md`
  - `.agents/skills/gate-check/SKILL.md`
  - `.agents/skills/team-qa/SKILL.md`
- **Change summary**:
  - Added required validation packet output steps to story closure, phase gate, and QA workflows.

---

## Checks Run (Static + Automated)

| Check | Type | Command / Method | Result | Evidence |
| --- | --- | --- | --- | --- |
| Skill sections updated | static | Manual review of SKILL.md files | PASS | New "Validation Evidence Packet" sections present |
| Packet schema lint | static | `.agents/scripts/validate-evidence-packet.sh production/qa/validation-packets/pilot-skill-change.md` | PASS | Script output |

---

## Checks Unavailable

| Check | Why unavailable | Risk | Follow-up required |
| --- | --- | --- | --- |
| `/skill-test static` execution in live skill runtime | Runtime command execution is environment/tool dependent | LOW | Run in regular skill execution environment if desired |

---

## Manual Validation Still Required

| Validation item | Reason manual | Owner confirmation status |
| --- | --- | --- |
| Confirm team adoption of new packet step in daily workflow | Process rollout requires human agreement | Pending |

---

## Verdict and Escalation

- **Overall verdict**: CONCERNS
- **Escalation required**: No
- **Escalation note**: Adoption/training confirmation still pending.
