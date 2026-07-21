# YJackGameStudio

**Open-source, provider-neutral and engine-neutral reference architecture for AI-native game studios.**

YJackGameStudio provides reusable game-development roles, procedural skills, templates, rules, validation guidance, and adapters for Codex, GitHub Copilot, Gemini CLI, Google Antigravity, Claude Code, and future tools.

It is intended to be forked and configured for Godot, Unity, or Unreal game projects.

## Public product boundary

YJackGameStudio is the public reference/template. It is not the commercial **Loomlight Game Studio** product and does not implement that product's private command-center application, hosted services, commercial workflow, or roadmap.

Public users do not need access to private Loomlight or YFramework repositories to understand or use this template.

## Framework neutrality

A Unity project may optionally use **Loomlight Flux, formerly YJackCore**, or another gameplay framework.

- Loomlight Flux is optional.
- Generic Unity workflows remain first-class.
- Godot and Unreal workflows do not depend on Flux.
- `YJackCore` is a legacy alias retained only for package detection, historical paths, compatibility, and migration.
- New canonical documentation should use Loomlight Flux terminology.

When a project uses an external framework, prefer that framework's installed package/repository guidance and the game project's own configuration over this template's generic assumptions.

## What is included

- 50 specialized game-development responsibility definitions.
- 77 procedural workflows.
- Provider-neutral shared guidance under `.agents/`.
- Tool adapters for Codex, Copilot, Gemini, Antigravity, and Claude Code.
- Engine-aware reference material for Godot, Unity, and Unreal.
- Owner-directed autonomy modes and production phase gates.
- Structured QA evidence assignment, review, aggregation, and sign-off.
- Templates for design, architecture, production, testing, and release work.

Counts describe repository inventory, not proof of autonomous capability or production quality.

## What this is not

- Not a prompt-to-game product.
- Not a one-prompt autonomous game creator.
- Not a hosted commercial platform.
- Not dependent on Loomlight Game Studio, Loomlight Nexus, Loomlight Flux, or private YFramework sources.
- Not tied to one engine, AI provider, coding assistant, or gameplay framework.
- Not an art or audio asset generator.

## Start here

1. Read [AGENTS.md](AGENTS.md).
2. Confirm the chosen AI tool loaded its adapter.
3. Follow `.agents/skills/start/SKILL.md` or `/start`.
4. Configure the game engine through `.agents/skills/setup-engine/SKILL.md` or `/setup-engine`.
5. Read `.agents/docs/technical-preferences.md` and the selected engine version reference.
6. Use the task-relevant skill, rule, template, and nearest directory-level `AGENTS.md`.
7. Run the configured game-project validation before claiming completion.

There is no universal build or test command before engine setup.

## Tool entrypoints

| Tool | Entrypoint |
|---|---|
| Codex | `AGENTS.md` |
| GitHub Copilot | `.github/copilot-instructions.md` |
| Gemini CLI | `GEMINI.md` and `.gemini/settings.json` |
| Google Antigravity | `AGENTS.md`, `GEMINI.md`, and `.agents/rules/` |
| Claude Code | `CLAUDE.md` and `.claude/` |

Shared behavior belongs in `.agents/`. Tool-specific adapters may explain loading behavior but must not redefine repository scope or approval policy.

## Typical project structure

```text
AGENTS.md                         Canonical cross-agent instructions
.agents/                          Shared roles, skills, rules, docs, hooks, and schemas
.claude/                          Claude Code compatibility layer
.agent/                           Compatibility pointers
design/                           Game design artifacts
docs/                             Architecture, ADRs, references, and product docs
src/                              Game source after configuration
production/                       Milestones, gates, QA, and release tracking
tests/                            Configured game-project tests
prototypes/                       Isolated proof work
```

## Common workflows

- `/start`
- `/brainstorm`
- `/setup-engine`
- `/map-systems`
- `/design-system`
- `/review-all-gdds`
- `/create-architecture`
- `/architecture-decision`
- `/create-epics`
- `/create-stories`
- `/dev-story`
- `/story-done`
- `/qa-evidence-assign`
- `/test-evidence-review`
- `/qa-evidence-aggregate`
- `/gate-check`
- `/release-checklist`

When slash commands are unavailable, read `.agents/skills/<skill-name>/SKILL.md` directly.

## Owner-directed autonomy

Projects may configure `GUIDED`, `SUPERVISED`, or `AUTONOMOUS` delegation modes through `production/autonomy-config.md`.

Autonomy controls which scoped production decisions may proceed without pausing. It does not grant unrestricted release, destructive, legal, financial, privacy, security, or public-claim authority.

The owner retains authority over starting a game programme, major phase gates, releases, public claims, irreversible work, and other high-impact decisions.

## Validation

- Skill changes: use the skill validation workflow.
- Design: use design review workflows.
- Architecture: use architecture review workflows.
- Game code: run configured engine and project checks.
- QA: use evidence assignment, review, aggregation, and gate workflows.
- Framework-specific changes: use the framework's own validation and report manual engine validation still required.

Do not claim a runtime, build, test, hook, integration, or release check ran unless it actually ran.

## Documentation

- [Repository Positioning](docs/product/repo-positioning.md)
- [Provider Compatibility Matrix](docs/product/provider-compatibility-matrix.md)
- [Public Messaging](docs/product/public-messaging.md)
- [Reference Roadmap](docs/product/roadmap.md)
- [Public Loomlight Boundary Note](docs/product/loomlight-boundary-note.md)

## License

MIT License. See [LICENSE](LICENSE).
