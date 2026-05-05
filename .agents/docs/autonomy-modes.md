# Autonomy Modes

This document defines the three autonomy modes available in YJackGameStudio.
All agents (Claude, Codex, Gemini, Copilot, or others) must respect the active
mode. The mode is set by the owner per session or per work contract.

## Mode Definitions

### Collaborative (default)

Every step requires owner input before proceeding.

Protocol: **Question → Options → Decision → Draft → Approval**

- Agents ask before proposing solutions.
- Agents present 2–4 options with pros/cons.
- Owner makes the call.
- Agents show a draft or summary before writing.
- Nothing is written without explicit owner approval.
- No commits without owner instruction.

Owner touchpoints: every step.

### Supervised Autonomous (`supervised`)

Agents may plan and execute within a pre-approved sprint contract. Owner reviews
at sprint boundaries and at every HIGH-risk gate.

- Owner approves the sprint plan and work contract before execution begins.
- Agents may implement, validate, document, and commit within the approved scope.
- Agents surface BLOCKED states immediately — no silent skipping.
- Agents produce a status report at sprint boundary for owner sign-off.
- HIGH-risk actions always require owner approval (see risk gates below).
- Scope changes require a new owner approval cycle.

Owner touchpoints: sprint start, sprint end, HIGH-risk gates, any scope change.

### Trusted Autonomous (`trusted`)

Agents operate within a standing owner mandate. Owner reviews async status
reports. HIGH-risk gates still require explicit approval.

- Owner provides a standing goal, risk tolerance, and budget.
- Agents plan, decompose, execute, validate, and report without per-task approval.
- Agents send async status reports at milestones or when blocked.
- HIGH-risk gates are synchronous — agents stop and wait.
- All work is traceable through issue contracts and validation evidence.

Owner touchpoints: mandate setup, HIGH-risk gates, milestone reports, escalations.

## Risk Gates (Apply in All Modes)

These actions **always require owner approval**, regardless of mode:

| Risk Category | Examples |
|--------------|---------|
| Architecture change | New subsystem, removing a layer, changing public API |
| Data loss risk | Deleting or irreversibly overwriting assets or data |
| YJackCore package boundary | Editing framework package files |
| Unity scene/prefab wiring | Structural scene changes, prefab restructure |
| Scope expansion | Adding features not in the approved work contract |
| Release / publish | Version bumps, store submissions, live-ops changes |
| Monetization / legal | Pricing, licensing, player data |
| Security / player safety | Auth, data exposure, anti-cheat |

## Mode Declaration

The active mode should be declared in one of:

- The current work contract (`autonomy_mode` field in `.agents/docs/work-contract-schema.md`)
- Explicit owner instruction at session start for a session-level override

If no mode is declared, default to **collaborative**.

## Escalation

Agents must escalate (stop and notify the owner) when:

- The work contract scope is insufficient to proceed.
- A HIGH-risk action is required that is not pre-approved.
- A conflict exists between two agents' write sets.
- Validation cannot be completed without Unity Editor or Play Mode (which the
  agent cannot run autonomously).
- A required doc or dependency is missing or contradictory.

Escalation is not a failure. It is the correct autonomous behavior.
