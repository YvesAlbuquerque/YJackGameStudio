# Autonomous Risk Register and Escalation Policy

**Version:** 1.0  
**Last Updated:** 2026-05-07  
**Source:** [AUTO-014] from `docs/AUTONOMOUS_GAME_STUDIO_ROADMAP.md`

---

## Purpose

This document defines deterministic risk classes, stop conditions, and owner-escalation
triggers for autonomous work. It standardizes how risks are recorded, labelled, and
audited across contracts, issue workflows, and validation packets.

---

## Deterministic Risk Classes

Every risk entry must include exactly one primary class from this table.

| Risk Class | Label | Default Tier | Use When |
|---|---|---|---|
| Architecture | `risk:architecture` | MEDIUM | ADR or architecture contract changes may invalidate existing technical decisions. |
| Data Loss | `risk:data-loss` | HIGH | File/history loss, destructive migrations, overwrite risk, save corruption, or irreversible deletes. |
| YJackCore Package Boundary | `risk:yjackcore-boundary` | HIGH | Writes under `Packages/YJackCore/**` or `Packages/com.ygamedev.yjack/**`, asmdef/package boundary changes, compile-symbol behavior changes. |
| Unity Scene/Prefab Wiring | `risk:unity-scene-prefab` | HIGH | Scene, prefab, inspector wiring, or manual Unity validation dependencies. |
| Scope Creep | `risk:scope-creep` | MEDIUM | Requested work exceeds approved contract write_set/non_goals. |
| Legal/Release | `risk:legal-release` | HIGH | Compliance, policy, release gating, certification, or external legal obligations. |
| Monetization | `risk:monetization` | HIGH | Store/payment/economy pricing changes that affect spend or policy compliance. |
| Player Safety | `risk:player-safety` | HIGH | Harmful content exposure, unsafe moderation gaps, or player-protection violations. |

---

## Risk Register Entry Schema

Each risk item tracked in a contract, issue, or packet must include:

- `risk_id` (string, required) — stable id like `RISK-0007`
- `description` (string, required)
- `risk_class` (enum, required) — one class from §Deterministic Risk Classes
- `likelihood` (enum, required) — `LOW | MEDIUM | HIGH`
- `impact` (enum, required) — `LOW | MEDIUM | HIGH`
- `risk_tier` (enum, required) — `LOW | MEDIUM | HIGH`
- `owner` (string, required) — decision owner
- `mitigation` (string, required)
- `status` (enum, required) — `OPEN | MITIGATING | RESOLVED | ACCEPTED`
- `stop_condition` (string, required) — concrete condition that forces execution stop
- `owner_approval_trigger` (string, required) — explicit approval required to proceed
- `issue_labels` (list, required) — includes one `risk:*` label and any escalation status labels

`risk_tier` must be deterministic from class + current context. If uncertain, classify
upward and escalate.

### Tier Derivation Rules

1. Start from the class default tier in §Deterministic Risk Classes.
2. Escalate to `HIGH` if any stop condition in this document is triggered.
3. Escalate one tier when manual verification is unresolved (for example Unity
   scene/prefab validation not confirmed).
4. Never downgrade `HIGH`-default classes below `HIGH` without explicit owner acceptance
   recorded in the risk entry.

---

## Stop Conditions and Owner Approval Triggers

Agents must stop immediately and request owner input when any of the following occurs:

1. A `HIGH` risk item is `OPEN` or `MITIGATING`.
2. Any `risk:yjackcore-boundary` risk appears.
3. Any `risk:unity-scene-prefab` risk appears.
4. A contract proposes writes outside approved `write_set` (`risk:scope-creep`).
5. A manual check required for release/legal/monetization/player safety is unresolved.
6. A potential destructive/data-loss action is required.

Escalation response must follow `.agents/docs/autonomy-modes.md`:
`Stop → Surface → Wait → Record`.

---

## Issue Labels for Escalation

Use these labels when tracking risks in GitHub:

- `status:blocked` — execution blocked by unresolved dependency or risk.
- `status:needs-owner` — agent is waiting for explicit owner decision.
- `risk:architecture`
- `risk:data-loss`
- `risk:yjackcore-boundary`
- `risk:unity-scene-prefab`
- `risk:scope-creep`
- `risk:legal-release`
- `risk:monetization`
- `risk:player-safety`

---

## Integration Requirements

### Agent Work Contracts

- Contracts must declare risk classes relevant to the write scope.
- Contracts with unresolved `HIGH` risks (`status != RESOLVED/ACCEPTED`) must not move to `IN_PROGRESS`.
- Contracts waiting on escalation decisions should apply `status:needs-owner`.

### Validation Evidence Packets

- Validation packets must include risk review outcome and unresolved escalations.
- If manual validation remains for any HIGH risk class, verdict cannot be `PASS`.

---

## Representative Workflow Stop/Escalate Paths

| Workflow | Trigger | Stop Condition | Escalation Path |
|---|---|---|---|
| Architecture decision update | New ADR overrides accepted architecture | `risk:architecture` is OPEN and decision impact is unresolved | Mark `status:needs-owner`, request owner decision before write |
| YJackCore package/asmdef/compile-symbol change | Package boundary or asmdef touched | `risk:yjackcore-boundary` appears | Immediate HIGH escalation; no package write before owner approval |
| Unity scene/prefab wiring | Scene/prefab/inspector or manual Unity verification needed | `risk:unity-scene-prefab` unresolved | Stop implementation; require owner/manual Unity validation confirmation |
| Scope expansion during implementation | Requested output exceeds contract write_set/non_goals | `risk:scope-creep` unresolved | Pause, propose revised contract, wait for owner approval |
| Release/legal/monetization/player safety check | Compliance/safety requirements not validated | `risk:legal-release`, `risk:monetization`, or `risk:player-safety` unresolved | Escalate with explicit go/no-go request; no release advance until resolved |
