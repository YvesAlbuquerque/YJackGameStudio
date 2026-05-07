# Validation Evidence Packet: unity-yjackcore

> **Scope type**: unity-yjackcore  
> **Task / story / gate**: AUTO-010 pilot (YJackCore-backed Unity task)  
> **Date**: 2026-05-07  
> **Agent**: copilot  
> **Commit / ref**: local

---

## Scope and Change Type

- **Changed files**:
  - `.agents/docs/templates/yjackcore-unity-manual-validation.md`
  - `.agents/docs/autonomous-validation-evidence.md`
- **Change summary**:
  - Added Unity manual validation template for scene/prefab/package checks and linked it to autonomous evidence standards.

---

## Checks Run (Static + Automated)

| Check | Type | Command / Method | Result | Evidence |
| --- | --- | --- | --- | --- |
| Host/framework routing check | static | Manual file review | PASS | Scope classified as `unity-yjackcore` framework-aligned template work |
| Package boundary integrity check | static | Manual file review | PASS | No edits under `Packages/YJackCore/**` or `Packages/com.ygamedev.yjack/**` |
| YJackCore template sections present | static | Manual file review | PASS | Scene, Prefab, Package sections included |
| Manual Unity checklist attached | static | Manual file review | PASS | `.agents/docs/templates/yjackcore-unity-manual-validation.md` included in this scope |

---

## Checks Unavailable

| Check | Why unavailable | Risk | Follow-up required |
| --- | --- | --- | --- |
| Unity Editor domain reload | Unity Editor unavailable in this environment | HIGH | Owner runs manual validation checklist |
| Play Mode scene behavior | Requires Unity runtime + scene execution | HIGH | Owner runs manual validation checklist |
| UPM resolution in Editor | Requires Unity Package Manager context | MEDIUM | Owner confirms in Unity Editor |

---

## Manual Validation Still Required

| Validation item | Reason manual | Owner confirmation status |
| --- | --- | --- |
| Scene validation checklist | Unity Editor required | Pending |
| Prefab validation checklist | Inspector + serialized object checks required | Pending |
| Package validation checklist | UPM and build checks require Unity context | Pending |

---

## Verdict and Escalation

- **Overall verdict**: BLOCKED
- **Escalation required**: Yes
- **Escalation note**: Unity owner/manual execution is required before claiming full validation.
