# Agentic Game Studios - Agent Instructions

This is the cross-agent source of truth for this repository. It is written for
Codex, GitHub Copilot, Gemini, Google Antigravity, Claude Code, and other
agentic coding systems.

## Role

Treat this repository as a game-development studio template, not a game runtime.
It provides agent roles, procedural skills, workflow docs, templates, rules, and
engine-reference scaffolding for Godot, Unity, and Unreal projects.

## Technology Stack

- **Engine**: [CHOOSE: Godot 4 / Unity / Unreal Engine 5]
- **Language**: [CHOOSE: GDScript / C# / C++ / Blueprint]
- **Version Control**: Git with trunk-based development
- **Build System**: [SPECIFY after choosing engine]
- **Asset Pipeline**: [SPECIFY after choosing engine]

Engine-specialist agents exist for Godot, Unity, and Unreal. Use the set matching
the configured engine.

## Engine Version Reference

@docs/engine-reference/godot/VERSION.md

If the active tool does not support `@` imports, treat the line above as a file
path that must be read manually when engine-version context is needed.

## Tool Entry Points

- Codex: read this `AGENTS.md` first. Local skills live in `.agents/skills/`.
- GitHub Copilot: read `.github/copilot-instructions.md` plus this file.
- Gemini CLI: read `GEMINI.md`; `.gemini/settings.json` configures both `AGENTS.md` and `GEMINI.md` as context files.
- Google Antigravity: read `AGENTS.md`, `GEMINI.md`, and workspace rules in `.agents/rules/`. `.agent/rules/game-studio.md` exists only as a compatibility pointer for clients that still inspect `.agent/rules/`.
- Claude Code: read `CLAUDE.md`; Claude-native compatibility assets remain in `.claude/`.

## Shared Source Of Truth

Prefer the provider-neutral layer unless a tool-specific adapter says otherwise:

- `.agents/agents/` - studio role definitions
- `.agents/skills/` - procedural skills and slash-command equivalents
- `.agents/rules/` - path/domain rules
- `.agents/docs/` - shared docs, templates, workflow catalog, technical preferences
- `.agents/hooks/` - portable hook scripts; automatic wiring is tool-specific

The `.claude/` directory is retained for Claude Code compatibility. Do not make
new shared workflow changes only in `.claude/`; mirror or author them in `.agents/`.

## Framework Integration

Optional framework/package integrations are recorded in
`.agents/docs/technical-preferences.md`. When a Unity project uses YJackCore,
read `.agents/docs/yjackcore-authority.md`, `.agents/docs/yjackcore-support.md`,
and `.agents/rules/yjackcore-unity.md` before proposing architecture or
implementation.

If a local YJackCore package or checkout is available, prefer its own
`AGENTS.md`, `.agents/skills/*`, `.ai/commands/*`, docs, package metadata,
asmdefs, and subtree instructions over this repo's generic Unity specialist.
Use the Game-Studio Unity specialist as the fallback for generic Unity
engine/API behavior or when YJackCore-specific assets are unavailable.

If a `.yjack-workspace.json` is present at the project root, read it to resolve
the YJackCore installation layout and path before reading `Packages/manifest.json`.

## Tool Capability Translation

Some shared skills still use Claude-origin capability names such as `Read`,
`Glob`, `Grep`, `Write`, `Edit`, `Bash`, `Task`, `AskUserQuestion`, and
`WebSearch`. Treat these as capability labels. Map them to the active tool's
equivalent behavior using `.agents/docs/tool-compatibility.md`.

## Working Rules

- Inspect the repo before asserting structure, behavior, or intent.
- Separate facts, inferences, and open questions.
- Prefer existing repo patterns over new abstractions.
- Preserve existing style unless there is a concrete reason to change it.
- Do not imply build, runtime, hook, or test validation happened unless it did.
- Keep changes low-risk and phased; do not broad-rewrite unless asked.
- Surface hidden coupling, lifecycle risks, performance costs, allocation risks, weak validation, and testability issues.
- Never commit, push, or publish unless explicitly asked.
- Do not read or expose secrets. `.env`, credentials, keys, and local-only files are off limits unless the user explicitly authorizes a specific safe action.

## Collaboration Protocol

This repository is user-driven, not autonomous. For design and architecture work,
follow: Question -> Options -> Decision -> Draft -> Approval.

For direct implementation requests, make the requested changes, but keep scope
small and report validation honestly.

### Autonomy Modes

The owner may set an autonomy mode that controls the delegation surface — the
set of decisions agents may execute without pausing for owner review. The active
mode is stored in `production/autonomy-config.md`.

| Mode | Tag | Behavior |
|------|-----|----------|
| Guided | `GUIDED` | Default. Every decision surfaced. Classic collaborative loop. |
| Supervised | `SUPERVISED` | LOW-risk actions execute autonomously. MEDIUM and HIGH require owner approval. |
| Autonomous | `AUTONOMOUS` | LOW and MEDIUM actions execute autonomously. HIGH always requires owner approval. |

If `production/autonomy-config.md` is absent, default to `GUIDED`.

**Hard gates — never bypassed by any mode:**
- A new game may not start or be set up without the owner explicitly initiating it.
- A project may not advance through any phase gate without explicit owner approval.
- Game source files (`src/`), PRs, releases, and YJackCore package files always require owner approval.

Full specification: `.agents/docs/autonomy-modes.md`

## Project Structure

See `.agents/docs/directory-structure.md` and `.agents/docs/quick-start.md`.
High-level paths:

- `src/` - game source code
- `design/` - GDDs, narrative docs, UX docs, level designs
- `docs/` - architecture, ADRs, engine references, technical docs
- `production/` - sprints, milestones, release tracking, session state
- `tests/` - test suites once the selected engine is configured
- `prototypes/` - throwaway prototypes isolated from production source

## Engine And Validation

- Engine is not assumed until `.agents/docs/technical-preferences.md` is configured.
- Before using engine APIs, inspect `docs/engine-reference/<engine>/VERSION.md` and relevant module notes.
- This template has no universal build/test command before engine setup.
- For skill changes, run or follow `/skill-test` where available.
- For design docs, run or follow `/design-review` or `/review-all-gdds` as relevant.
- For architecture docs, run or follow `/architecture-review`.
- For game code, run the configured engine-specific build/test command after setup.

## AI-Friendly Structured APIs

Selected validation scripts support `--format=json` for machine-parseable output conforming to
`.agents/schemas/validation-output.schema.json` (currently: `validate-skill-static.sh` and
`check-write-sets.sh`). This enables autonomous agents to:

- Parse validation results without regex text parsing
- Understand error contracts and remediation paths programmatically
- Chain validations and auto-correct from documented errors
- Validate artifacts against schemas before committing

**Example:**
```bash
# Human-readable output (default)
.agents/scripts/validate-skill-static.sh brainstorm

# Machine-parseable JSON
.agents/scripts/validate-skill-static.sh brainstorm --format=json
```

See `.agents/docs/ai-friendly-apis.md` for complete agent integration guide, error codes,
schemas, and remediation patterns.

## Skill Use

If the tool supports project skills or slash commands, use the relevant skill
normally. If not, read the skill file directly and follow its phases:

`.agents/skills/<skill-name>/SKILL.md`

Common entry points:

- `/start` - first-time onboarding
- `/setup-engine` - configure engine and technical preferences
- `/project-stage-detect` - detect current project stage
- `/adopt` - audit existing project artifacts
- `/design-system` - author a GDD
- `/create-architecture` - create master architecture
- `/dev-story` - implement a prepared story
- `/story-done` - validate completion against acceptance criteria

## Directory Instructions

Additional scoped instructions exist in:

- `design/AGENTS.md`
- `docs/AGENTS.md`
- `src/AGENTS.md`
- `CCGS Skill Testing Framework/AGENTS.md`

Use the nearest applicable file when working inside those directories.
