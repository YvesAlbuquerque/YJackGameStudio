# Game Studio Agent Architecture - Quick Start

## What This Is

This repository contains a portable game-development agent architecture for AI
coding systems. The shared layer lives in `.agents/` and is intended to be read
by Codex, GitHub Copilot, Gemini, Antigravity, Claude Code, and other tools that
can consume Markdown project instructions.

The architecture provides:

- 49 studio roles in `.agents/agents/`
- 72 procedural skills in `.agents/skills/`
- 11 path/domain rules in `.agents/rules/`
- Shared templates and workflow docs in `.agents/docs/`
- Claude-specific compatibility assets in `.claude/`

See `.agents/docs/tool-compatibility.md` for capability-name mapping across
Codex, Copilot, Gemini, Antigravity, and Claude Code.

## Entry Points By Tool

| Tool | Primary file |
|------|--------------|
| Codex | `AGENTS.md` |
| GitHub Copilot | `.github/copilot-instructions.md` and `AGENTS.md` |
| Gemini CLI | `GEMINI.md`, `.gemini/settings.json`, and `AGENTS.md` |
| Google Antigravity | `AGENTS.md`, `GEMINI.md`, `.agents/rules/`; `.agent/rules/game-studio.md` is a compatibility pointer |
| Claude Code | `CLAUDE.md` and `.claude/` |

## How To Start

1. Read `AGENTS.md` first.
2. Check `.agents/docs/technical-preferences.md` to see whether the engine is configured.
3. If no game concept or engine is configured, run or follow the `/start` skill.
4. If adopting an existing project, run or follow `/project-stage-detect`, then `/adopt`.
5. Before editing engine APIs, inspect `docs/engine-reference/` for the pinned engine version.

## Skill Usage

Tools differ in how they expose reusable procedures:

- Codex desktop can load `.agents/skills/*/SKILL.md` as local skills.
- Claude Code uses `.claude/skills/*/SKILL.md` as slash-command skills.
- Copilot, Gemini, and Antigravity can still read the skill files as procedural instructions even if they do not expose them as native slash commands.

When a tool does not support slash commands, treat `/skill-name` as shorthand for:

1. Read `.agents/skills/skill-name/SKILL.md`.
2. Follow the phases exactly.
3. Produce the same artifacts and validation output the skill requires.

## Core Workflow

1. Concept: `/start`, `/brainstorm`, `/setup-engine`, `/art-bible`
2. Design: `/map-systems`, `/design-system`, `/review-all-gdds`, `/gate-check`
3. Architecture: `/create-architecture`, `/architecture-decision`, `/create-control-manifest`, `/architecture-review`
4. Pre-production: `/ux-design`, `/prototype`, `/playtest-report`, `/create-epics`, `/create-stories`
5. Production: `/sprint-plan`, `/dev-story`, `/story-done`, `/sprint-status`
6. QA/release: `/qa-plan`, `/smoke-check`, `/regression-suite`, `/release-checklist`, `/launch-checklist`

## Project Layout

```text
AGENTS.md                         # Cross-agent source of truth
GEMINI.md                         # Gemini/Antigravity adapter
CLAUDE.md                         # Claude Code adapter
.github/copilot-instructions.md   # GitHub Copilot adapter
.gemini/settings.json             # Gemini CLI context-file config
.agents/                          # Shared portable agent assets
  agents/                         # Studio role definitions
  skills/                         # Procedural skills
  rules/                          # Path/domain rules
  docs/                           # Shared docs, templates, workflow catalog
  hooks/                          # Portable hook scripts; tool wiring varies
.claude/                          # Claude Code-native compatibility layer
.agent/rules/                     # Antigravity compatibility pointer
src/                              # Game source code
design/                           # GDDs, narrative docs, UX docs, level design
docs/                             # Architecture, ADRs, engine references
production/                       # Sprint, milestone, release, and session state
```

## Validation Expectations

This template repository has no universal build or test command yet. Validation is
artifact-specific:

- Skill edits: run or follow `/skill-test` against the changed skill.
- Design docs: run or follow `/design-review` and `/review-all-gdds` as relevant.
- Architecture docs: run or follow `/architecture-review`.
- Game code: run the engine-specific build/test command after the engine is configured.
- Hooks: Claude Code wires `.claude/hooks/`; other tools should run equivalent scripts manually if needed.

Do not claim validation happened unless the command or review workflow was actually run.
