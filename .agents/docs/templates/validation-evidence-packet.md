# Validation Evidence Packet: [scope]

> **Scope type**: [docs | skills | hooks | unity-yjackcore | issue-lifecycle]  
> **Task / story / gate**: [identifier]  
> **Date**: [YYYY-MM-DD]  
> **Agent**: [name]  
> **Commit / ref**: [sha or branch]

---

## Scope and Change Type

- **Changed files**:
  - [path]
- **Change summary**:
  - [summary]

---

## Checks Run (Static + Automated)

| Check | Type | Command / Method | Result | Evidence |
| --- | --- | --- | --- | --- |
| [check-name] | [static/automated] | `[command]` | PASS / CONCERNS / FAIL / WARN / NOT RUN / BLOCKED | [output/file] |

---

## Checks Unavailable

| Check | Why unavailable | Risk | Follow-up required |
| --- | --- | --- | --- |
| [check-name] | [reason] | LOW / MEDIUM / HIGH | [owner/manual action] |

If none: `None`.

---

## Manual Validation Still Required

| Validation item | Reason manual | Owner confirmation status |
| --- | --- | --- |
| [item] | [cannot be automated] | Pending / Confirmed |

If none: `None`.

---

## Risk Register Review

| Risk ID | Class | Tier | Status | Escalation label | Owner decision required? |
| --- | --- | --- | --- | --- | --- |
| [RISK-0001] | [risk:architecture] | LOW / MEDIUM / HIGH | OPEN / MITIGATING / RESOLVED / ACCEPTED | `status:needs-owner` / `status:blocked` / `None` | Yes / No |

If none: `None`.

---

## Verdict and Escalation

- **Overall verdict**: PASS / CONCERNS / FAIL / BLOCKED
- **Escalation required**: Yes / No
- **Escalation note**: [what owner must decide]
