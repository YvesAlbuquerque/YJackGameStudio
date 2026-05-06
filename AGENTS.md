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

## Tool Entry Points

This repo is the cross-agent source of truth. Each provider has a dedicated
entry point:

| System | Entrypoint | Notes |
|--------|------------|-------|
| Codex | `AGENTS.md` | Uses cross-agent instructions and can load `.agents/skills/` as project skills. |
| GitHub Copilot | `.github/copilot-instructions.md` | Also includes path-specific instructions under `.github/instructions/`. |
| Gemini CLI | `GEMINI.md` and `.gemini/settings.json` | Configured to load both `AGENTS.md` and `GEMINI.md`. |
| Google Antigravity | `AGENTS.md`, `GEMINI.md`, `.agents/rules/` | Uses the shared rules/docs layout. `.agent/rules/game-studio.md` is a compatibility pointer. |
| Claude Code | `CLAUDE.md` and `.claude/` | Preserved as a compatibility layer. |

## Shared Source Of Truth

Prefer the provider-neutral layer unless a tool-specific adapter says otherwise:

- `.agents/agents/` — studio role definitions
- `.agents/skills/` — procedural skills and slash-command equivalents
- `.agents/rules/` — path/domain rules
- `.agents/docs/` — shared docs, templates, workflow catalog, technical preferences
- `.agents/hooks/` — portable hook scripts; automatic wiring is tool-specific

The `.claude/` directory is retained for Claude Code compatibility. Do not make
new shared workflow changes only in `.claude/`; mirror or author them in `.agents/`.

## Working Rules

- Inspect the repo before asserting structure, behavior, or intent.
- Separate facts, inferences, and open questions.
- Prefer existing repo patterns over new abstractions.
- Preserve existing style unless there is a concrete reason to change it.
- Do not imply build, runtime, hook, or test validation happened unless it did.
- Keep changes low-risk and phased; do not broad-rewrite unless asked.
- Never commit, push, or publish unless explicitly asked.
- Do not read or expose secrets.

## Collaboration Protocol

For design and architecture work, follow: Question → Options → Decision → Draft → Approval.
For direct implementation requests, make the requested changes, keep scope small,
and report validation honestly.

## Project Structure

High-level paths:

- `src/` — game source code
- `design/` — GDDs, narrative docs, UX docs, level designs
- `docs/` — architecture, ADRs, engine references, technical docs
- `production/` — sprints, milestones, release tracking, session state
- `tests/` — test suites once the selected engine is configured
- `prototypes/` — throwaway prototypes isolated from production source

See `.agents/docs/directory-structure.md` and `.agents/docs/quick-start.md` for
full path listings. Scoped instructions also exist in `design/AGENTS.md`,
`docs/AGENTS.md`, `src/AGENTS.md`, and `CCGS Skill Testing Framework/AGENTS.md`.

## Skill Use

If the tool supports project skills or slash commands, use the relevant skill
normally. If not, read the skill file and follow its phases:
`.agents/skills/<skill-name>/SKILL.md`

Common entry points: `/start`, `/setup-engine`, `/project-stage-detect`, `/adopt`,
`/design-system`, `/create-architecture`, `/dev-story`, `/story-done`.
