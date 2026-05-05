# GitHub Copilot Instructions

This repository is a game-development agent/studio template. It is not yet a
configured game runtime. The shared agent source of truth is `AGENTS.md`; read it
before making changes.

## Repository Layout

- `.agents/` contains provider-neutral agents, skills, rules, docs, templates, and hook scripts.
- `.claude/` is the Claude Code compatibility layer. Do not make new shared behavior only in `.claude/`.
- `design/` contains GDDs, UX docs, narrative docs, level design, and registries.
- `docs/` contains architecture docs, ADRs, engine-reference snapshots, and workflow docs.
- `src/` is empty scaffolding until a game engine is configured.
- `production/` contains sprint, milestone, release, and session-state artifacts.

## Working Rules

- Inspect existing files before asserting structure or intent.
- Prefer the smallest low-risk change that satisfies the request.
- Preserve existing style and template conventions.
- Do not invent a build/test command. This template has no universal build before `/setup-engine`.
- Do not claim validation unless you actually ran the command or completed the named review workflow.
- Do not read or expose secrets from `.env`, credentials, keys, or local-only files.
- Do not commit, push, open PRs, or publish unless explicitly asked.

## Validation

Use the relevant workflow rather than generic checks:

- Skill changes: follow `.agents/skills/skill-test/SKILL.md`.
- GDD/design changes: follow `.agents/skills/design-review/SKILL.md` or `.agents/skills/review-all-gdds/SKILL.md`.
- Architecture changes: follow `.agents/skills/architecture-review/SKILL.md`.
- Game code changes: first inspect `.agents/docs/technical-preferences.md` and `docs/engine-reference/`; run engine-specific checks only after the engine is configured.

## Scoped Instructions

Also read the nearest applicable `AGENTS.md` under `design/`, `docs/`, `src/`, or
`CCGS Skill Testing Framework/` when editing those paths.
