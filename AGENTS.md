# YJackGameStudio — Agent Instructions

This is the canonical cross-agent guidance for the public YJackGameStudio reference architecture and template. Tool-specific adapters may explain loading behavior but must not override this file.

## Repository role

YJackGameStudio is a public, open-source, provider-neutral and engine-neutral reference/template for AI-native game studios.

It provides reusable:

- game-development responsibility definitions;
- procedural skills;
- workflow and validation guidance;
- game-project templates;
- engine-reference scaffolding for Godot, Unity, and Unreal;
- provider adapters for Codex, Copilot, Gemini, Antigravity, Claude Code, and future tools.

It is not:

- the commercial Loomlight Game Studio product;
- Loomlight Nexus;
- Loomlight Flux;
- YFramework;
- a prompt-to-game product;
- a hosted orchestration platform;
- dependent on private Loomlight repositories.

Public users must be able to understand and use this repository without access to private Loomlight strategy or doctrine.

## Game-project context

Unlike the commercial Game Studio product repository, this public template is intended to be configured for a game project.

Before game implementation:

- select or detect the game engine;
- configure technical preferences;
- identify the project stage;
- preserve game-specific source, design, production, tests, builds, and evidence in the project workspace.

## Technology configuration

The template supports:

- Godot 4 with GDScript or configured alternatives;
- Unity with C#;
- Unreal Engine 5 with C++, Blueprint, or configured combinations.

Do not assume an engine until project configuration proves it. Read the corresponding version reference before using engine APIs.

## Optional framework integration

Framework support is optional and replaceable.

**Loomlight Flux, formerly YJackCore**, is one possible Unity framework integration. Generic Unity workflows remain first-class, and Godot or Unreal workflows do not depend on Flux.

Use `YJackCore` only for:

- legacy package detection;
- historical filenames or paths;
- compatibility and migration;
- workspaces that still expose old identifiers.

Do not require `.yjack-workspace.json` or YJackCore-specific files for normal Unity use. When a project actually uses Flux, prefer the installed package/repository instructions and project configuration over this template’s generic Unity guidance.

## Read order

1. `AGENTS.md`
2. `README.md`
3. `.agents/docs/quick-start.md`
4. `.agents/docs/technical-preferences.md`
5. The selected engine version reference
6. The nearest applicable skill, rule, template, and directory-level `AGENTS.md`
7. The game project’s own design, architecture, production status, source, and tests

## Shared source of truth

Provider-neutral shared behavior belongs in:

- `.agents/agents/`
- `.agents/skills/`
- `.agents/rules/`
- `.agents/docs/`
- `.agents/hooks/`
- `.agents/schemas/` where present

Tool-specific files are adapters:

- `CLAUDE.md` and `.claude/`
- `GEMINI.md` and `.gemini/`
- `.github/copilot-instructions.md`
- `.agent/` compatibility pointers

Shared workflow changes should not live only in one vendor adapter.

## Public Loomlight terminology

- Use **Loomlight Game Studio** for the separate commercial product.
- Use **Loomlight Flux** for the current framework product name.
- Use **YJackCore** only as a legacy alias.
- Do not require private YFramework documents, internal issues, or private product roadmaps for public operation.
- Do not claim private commercial features are implemented here.

## Working rules

- Inspect the repository and project before asserting structure, behavior, status, or intent.
- Separate facts, assumptions, hypotheses, unknowns, risks, recommendation, and validation when useful.
- Prefer existing roles, skills, rules, templates, and schemas over parallel abstractions.
- Preserve provider and engine neutrality.
- Keep changes scoped and reviewable.
- Do not claim runtime, build, test, hook, integration, or release validation unless it actually ran.
- Never read, expose, or commit secrets without explicit safe authorization.
- Public documentation must use links available to anonymous users.

## Collaboration and autonomy

The repository supports `GUIDED`, `SUPERVISED`, and `AUTONOMOUS` delegation modes for project work. Autonomy controls which production decisions may execute without pausing; it does not grant unrestricted GitHub, release, destructive, financial, legal, privacy, or public-claim authority.

If `production/autonomy-config.md` is absent, default to `GUIDED`.

Always require explicit owner approval for:

- initiating a new game programme;
- advancing major production phase gates;
- releases and public claims;
- destructive or irreversible operations;
- high-impact legal, financial, privacy, security, or architecture decisions.

For direct scoped implementation explicitly requested by the owner, make the requested change and report validation honestly. Do not add redundant approval loops for ordinary file edits.

## Project structure

Typical configured game workspace paths include:

- `design/` — GDDs, narrative, UX, and level design;
- `docs/` — architecture, ADRs, engine references, and technical documentation;
- `src/` — game source after engine setup;
- `production/` — milestones, sprints, releases, autonomy mode, and QA evidence;
- `tests/` — configured engine/project test suites;
- `prototypes/` — isolated throwaway proof work.

Use the nearest directory-level `AGENTS.md` where present.

## Validation

There is no universal build/test command before engine setup.

- Skill changes: use the skill validation workflow.
- Design documents: use design review workflows.
- Architecture documents: use architecture review workflows.
- Game code: use the configured engine-specific build/test commands.
- QA evidence: use the repository evidence assignment, review, aggregation, and gate workflows.
- Framework-specific work: use the installed framework’s own validation and report any manual engine validation still required.

Selected validation scripts may support `--format=json` through the repository validation schema. Report exact commands and outcomes.

## Primary goal

Provide a portable, public, evidence-oriented studio template that helps owners coordinate AI-assisted game development without vendor lock-in, engine lock-in, private-repository dependency, or black-box autonomy.
