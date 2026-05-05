# YJackGameStudio — Agent Entry Point

Repository: current checkout/fork
Studio OS: YJackGameStudio
Last updated: 2026-05-05

## What This Repo Is

YJackGameStudio is an **owner-directed autonomous game studio OS** for agentic game
development. It is not a game runtime. It is the production/studio layer that
orchestrates planning, issue contracts, ownership, validation evidence, owner
approvals, YJackCore routing, and autonomous production workflows.

It can operate:

- **Standalone** — as a generic multi-agent game studio scaffold for any engine.
- **Integrated with YJackCore** — as the studio OS for games built on the
  YJackCore Unity framework (`com.ygamedev.yjack`).

## The Split

| Layer | Repo | Role |
|-------|------|------|
| **YJackGameStudio** | this repo | Autonomous AI production/studio OS |
| **YJackCore** | `YvesAlbuquerque/YJackCore` | Unity runtime/editor authoring framework |

YJackCore is the authority for Unity package files, assembly definitions, layer
architecture, and the low-code authoring substrate. YJackGameStudio consumes
YJackCore guidance. It does not modify YJackCore package files unless the owner
explicitly authorizes a framework change.

## Key Docs — Read In This Order

All agents (Claude, Codex, Gemini, Copilot, or others) must read these before
acting:

1. **This file** — product identity and authority boundaries.
2. `.agents/docs/autonomy-modes.md` — what agents may do autonomously vs what
   requires owner approval.
3. `.agents/docs/work-contract-schema.md` — required contract before starting any
   autonomous work unit.
4. `.agents/docs/yjackcore-authority.md` — YJackCore vs game-repo authority rules.
5. `.agents/docs/yjack-workspace-manifest.md` — how to detect YJackCore layout
   and route work correctly.
6. `.agents/docs/validation-evidence.md` — what honest validation looks like.
7. `.agents/docs/tool-compatibility.md` — which tools apply per provider.

Claude Code agents also read `.claude/` for Claude-specific configuration:

- `.claude/docs/yjackcore-support.md`
- `.claude/docs/technical-preferences.md`
- `.claude/docs/coordination-rules.md`
- `.claude/docs/director-gates.md`

## Autonomy Modes

Three modes are defined. The current default is **collaborative**.

| Mode | Short Name | Owner Touchpoints |
|------|-----------|-------------------|
| Collaborative | `collaborative` | Every step — Question→Options→Decision→Draft→Approve |
| Supervised Autonomous | `supervised` | Sprint boundary + HIGH-risk gates |
| Trusted Autonomous | `trusted` | HIGH-risk gates only + async status reports |

See `.agents/docs/autonomy-modes.md` for full definitions.

**HIGH-risk actions are always owner-gated in every mode.**

## Owner-as-Creative-Director

The owner sets intent, scope, risk tolerance, and approval boundaries. Agents
decompose, plan, implement, validate, and report inside those boundaries. The
owner is never removed from the loop for creative or high-risk decisions.

## YJackCore Routing (When Applicable)

If `.yjack-workspace.json` exists in the game repo root, agents MUST read it
before `Packages/manifest.json`. It defines:

- Framework source and package path
- Allowed agent actions per zone (game repo vs framework package)
- Manual Unity validation requirements

See `.agents/docs/yjack-workspace-manifest.md`.

## Validation Honesty

Agents must not claim Unity Editor, Play Mode, build, hook, or CI validation
unless those checks were actually run. See `.agents/docs/validation-evidence.md`.

## File Ownership

- Game repo files: agents may read/write within their delegated domain.
- YJackCore package files (`Packages/com.ygamedev.yjack/**`,
  `Packages/YJackCore/**`): **read-only by default** unless the owner
  explicitly authorizes framework modification.
- Classification required: every work contract must declare whether work is
  *game-repo work*, *framework-package work*, or *both*.
