<p align="center">
  <h1 align="center">Agentic Game Studios</h1>
  <p align="center">
    A portable game-development studio architecture for Codex, GitHub Copilot, Gemini, Google Antigravity, and Claude Code.
    <br />
    49 agents. 72 skills. One coordinated AI team.
  </p>
</p>

> **YJackGameStudio** — When used as the owner-directed studio OS for YJack + YJackCore
> projects, this template becomes an autonomous AI production layer that orchestrates
> planning, issue contracts, ownership, validation evidence, and YJackCore routing.
> See [AGENTS.md](AGENTS.md) for the product thesis and authority boundaries.
> See [Product Positioning](docs/market/positioning.md) and the
> [Product Roadmap](docs/product/roadmap.md) for the current wedge.

<p align="center">
  <a href="LICENSE"><img src="https://img.shields.io/badge/license-MIT-blue.svg" alt="MIT License"></a>
  <a href=".agents/agents"><img src="https://img.shields.io/badge/agents-49-blueviolet" alt="49 Agents"></a>
  <a href=".agents/skills"><img src="https://img.shields.io/badge/skills-72-green" alt="72 Skills"></a>
  <a href=".agents/rules"><img src="https://img.shields.io/badge/rules-11-red" alt="11 Rules"></a>
  <a href=".agents/hooks"><img src="https://img.shields.io/badge/hooks-12-orange" alt="12 Hooks"></a>
  <a href="AGENTS.md"><img src="https://img.shields.io/badge/AI%20entrypoint-AGENTS.md-black" alt="AGENTS.md"></a>
</p>

---

## Product Positioning

**YJackGameStudio is an owner-directed autonomous game studio OS for
maintainable, AI-native game development.**

Its first product wedge is:

> Idea -> production-ready YJackCore-aware vertical-slice plan.

YJackGameStudio is the production/studio layer: it turns owner intent into
structured plans, work contracts, dependency ownership, validation evidence, QA
expectations, and owner decisions. It is not a prompt-to-game toy, Unity AI
clone, UGC platform, asset generator, or claim of full autonomous game
generation.

| Name | Meaning |
|------|---------|
| **Claude Code Game Studios** | The original Claude Code template distribution: 49 agents, 72 skills, hooks, rules, and workflow docs. |
| **Agentic Game Studios** | The broader product category/pattern: AI-assisted studio teams that plan, implement, review, and validate game work. |
| **YJackGameStudio** | The owner-directed studio OS profile for maintainable AI-native game development, with provider-neutral contracts and first-class YJackCore routing. |
| **YJackCore** | The optional but preferred Unity gameplay framework / low-code authoring substrate for YJack ecosystem projects. |

When integrated with Unity, YJackGameStudio orchestrates production, planning,
agents, issue contracts, validation, and owner decisions. YJackCore remains the
Unity runtime/editor framework authority. Unity AI is tracked as a future
engine-native execution layer and platform factor; this repo does not claim Unity
AI integration today.

Current product docs:

- [Market positioning](docs/market/positioning.md)
- [Competitive landscape](docs/market/competitive-landscape.md)
- [Unity AI watch](docs/market/unity-ai-watch.md)
- [Tracking watchlist](docs/market/tracking-watchlist.md)
- [Target users](docs/product/target-users.md)
- [First wedge](docs/product/first-wedge.md)
- [Demo strategy](docs/product/demo-strategy.md)
- [Packaging](docs/product/packaging.md)
- [Monetization](docs/product/monetization.md)
- [Product roadmap](docs/product/roadmap.md)

---

## Why This Exists

A single AI coding chat is useful, but game development needs structure: design
ownership, architecture decisions, content validation, QA, sprint planning, and
release discipline. This repository packages those responsibilities as a studio
model that agentic tools can follow.

This fork is based on
[Donchitos/Claude-Code-Game-Studios](https://github.com/Donchitos/Claude-Code-Game-Studios).
The original project was Claude Code-centric; this fork adds a provider-neutral
shared layer under `.agents/` plus native adapters for the major agentic coding
systems.

## Supported Agent Systems

### YJackGameStudio: Owner-Directed Autonomous Studio OS

> **YJackGameStudio is an owner-directed autonomous game studio OS for agentic game development.**

When used as YJackGameStudio, this system goes beyond a collaborative assistant template:

- The owner states a game goal, selects an autonomy mode, and the studio creates
  structured, dependency-aware, validation-aware issues with routing to the right
  specialist agents.
- Work is tracked as explicit **work contracts** — not chat history.
- Agents operate within owner-set boundaries: they do not claim unlimited autonomy.
  HIGH-risk decisions always require owner approval.

YJackGameStudio can operate in two configurations:

| Configuration | Description |
|--------------|-------------|
| **Standalone** | Generic multi-agent game studio for any engine |
| **Integrated with YJackCore** | Full studio OS for games built on the YJackCore Unity framework |

**The split when integrated:**

| Layer | Role |
|-------|------|
| **YJackCore** | Unity runtime/editor authoring framework (`com.ygamedev.yjack`) |
| **YJackGameStudio** | Autonomous AI production/studio layer — planning, contracts, ownership, validation, routing |

YJackCore is the authority for Unity package files, layer architecture, and the low-code authoring substrate. YJackGameStudio consumes YJackCore guidance. It does not modify YJackCore package files unless the owner explicitly authorizes a framework change.

Unity AI is a separate engine-native AI surface. YJackGameStudio should monitor
it as both a future execution layer and a platform threat, while continuing to
own higher-level planning, contracts, validation evidence, and owner gates. No
Unity AI integration is claimed here.

---

| System | Entrypoint | Notes |
|--------|------------|-------|
| Codex | `AGENTS.md` | Uses the cross-agent instructions and can load `.agents/skills/` as project skills. |
| GitHub Copilot | `.github/copilot-instructions.md` | Also includes path-specific instructions under `.github/instructions/`. |
| Gemini CLI | `GEMINI.md` and `.gemini/settings.json` | Configured to load both `AGENTS.md` and `GEMINI.md`. |
| Google Antigravity | `AGENTS.md`, `GEMINI.md`, `.agents/rules/` | Uses the shared rules/docs layout; `.agent/rules/game-studio.md` is a compatibility pointer. |
| Claude Code | `CLAUDE.md` and `.claude/` | Preserved as a compatibility layer. |

## How To Use It With Each Agent System

The shared workflow is the same for every tool:

1. Make sure the tool has loaded the correct instruction entrypoint.
2. Start with `/start` if the tool supports slash commands or project skills.
3. If it does not, ask the tool to read `.agents/skills/start/SKILL.md` and follow it.
4. For any later workflow, treat `/skill-name` as shorthand for reading `.agents/skills/skill-name/SKILL.md`.
5. Use `.agents/docs/tool-compatibility.md` to translate capability names such as `Task`, `AskUserQuestion`, `WebSearch`, `Read`, `Glob`, and `Bash`.

### Codex

Codex should read `AGENTS.md` automatically in this repository.

Use it like this:

1. Open the repository in Codex.
2. Confirm Codex has read `AGENTS.md`.
3. Ask: `Run /start for this project` or `Follow .agents/skills/start/SKILL.md`.
4. For implementation work, ask Codex to use the relevant skill, for example:
   `Follow .agents/skills/dev-story/SKILL.md for production/stories/<story>.md`.
5. When Codex delegates work, keep delegation scoped to independent tasks and disjoint file sets.

Codex-specific source of truth:

- `AGENTS.md`
- `.agents/skills/`
- `.agents/docs/tool-compatibility.md`

### GitHub Copilot

Copilot uses repository instructions and optional path-specific instructions.

Use it like this:

1. Open the repository in VS Code or GitHub with Copilot enabled.
2. Copilot should load `.github/copilot-instructions.md`.
3. When editing `design/`, `docs/`, `src/`, or agent config files, Copilot also has matching `.github/instructions/*.instructions.md` files.
4. Ask Copilot to follow the specific workflow file, for example:
   `Use .agents/skills/design-system/SKILL.md to draft a GDD for movement`.
5. If Copilot cannot execute a slash command, keep the skill file open or referenced in the prompt.

Copilot-specific source of truth:

- `.github/copilot-instructions.md`
- `.github/instructions/*.instructions.md`
- `AGENTS.md`

### Gemini CLI

Gemini CLI is configured through `.gemini/settings.json` to load both `AGENTS.md`
and `GEMINI.md`.

Use it like this:

1. Open Gemini CLI from the repository root.
2. Run `/memory show` to confirm `AGENTS.md` and `GEMINI.md` are loaded.
3. If you edit instructions, run `/memory refresh`.
4. Ask Gemini to follow a skill file directly, for example:
   `Read .agents/skills/project-stage-detect/SKILL.md and apply it to this repo`.
5. For subagent/team instructions, either perform the role locally or split the work into separate approved sessions.

Gemini-specific source of truth:

- `GEMINI.md`
- `.gemini/settings.json`
- `AGENTS.md`

### Google Antigravity

Antigravity should use the shared `AGENTS.md` / `GEMINI.md` instructions and the
workspace rule files.

Use it like this:

1. Open the repository in Antigravity.
2. Confirm the workspace instructions include `AGENTS.md` and `GEMINI.md`.
3. Confirm rules are visible from `.agents/rules/`; `.agent/rules/game-studio.md` points back to the canonical shared rules for clients that inspect the older singular path.
4. Use Agent Manager or the equivalent task workflow for skills that request `Task` or subagent delegation.
5. If delegation is not available, read the referenced role file in `.agents/agents/<role>.md` and perform that role in the current thread.

Antigravity-specific source of truth:

- `AGENTS.md`
- `GEMINI.md`
- `.agents/rules/`
- `.agent/rules/game-studio.md`

### Claude Code

Claude Code remains supported through the legacy-native compatibility layer.

Use it like this:

1. Open Claude Code from the repository root.
2. Claude Code reads `CLAUDE.md`, which points back to `AGENTS.md`.
3. Native Claude slash commands and hooks continue to use `.claude/skills/` and `.claude/hooks/`.
4. For shared workflow changes, update `.agents/` first, then mirror to `.claude/` only when Claude compatibility requires it.

Claude-specific source of truth:

- `CLAUDE.md`
- `.claude/`
- `AGENTS.md`

## What's Included

| Category | Count | Shared Location | Purpose |
|----------|-------|-----------------|---------|
| Agents | 49 | `.agents/agents/` | Studio roles across design, programming, art, audio, narrative, QA, and production |
| Skills | 72 | `.agents/skills/` | Procedural workflows such as `/start`, `/design-system`, `/dev-story`, and `/story-done` |
| Rules | 11 | `.agents/rules/` | Path/domain constraints for gameplay, engine, UI, AI, networking, tests, and docs |
| Hooks | 12 | `.agents/hooks/` | Portable validation scripts; automatic wiring depends on the tool |
| Templates | 38 | `.agents/docs/templates/` | GDDs, ADRs, sprint plans, UX specs, test plans, release docs, and more |

Claude Code-native copies remain in `.claude/` so existing Claude workflows keep
working while new shared changes can be made in `.agents/` first.

See `.agents/docs/tool-compatibility.md` for how shared skill capability names
map onto Codex, Copilot, Gemini, Antigravity, and Claude Code.

## Studio Hierarchy

Agents are organized like a real studio:

```text
Tier 1 - Directors
  creative-director    technical-director    producer

Tier 2 - Department Leads
  game-designer        lead-programmer       art-director
  audio-director       narrative-director    qa-lead
  release-manager      localization-lead

Tier 3 - Specialists
  gameplay-programmer  engine-programmer     ai-programmer
  network-programmer   tools-programmer      ui-programmer
  systems-designer     level-designer        economy-designer
  technical-artist     sound-designer        writer
  world-builder        ux-designer           prototyper
  performance-analyst  devops-engineer       analytics-engineer
  security-engineer    qa-tester             accessibility-specialist
  live-ops-designer    community-manager
```

Engine specialist sets are included for Godot, Unity, and Unreal.

## Getting Started

1. Install the AI coding tool you want to use.
2. Open the repository in that tool.
3. Confirm it has loaded the correct entrypoint from the table above.
4. Read `AGENTS.md` first if the tool does not load it automatically.
5. Start with `/start` if the tool supports skills or slash commands.
6. If it does not, read `.agents/skills/start/SKILL.md` and follow the phases manually.

This template has no universal build or test command until a game engine is
configured with `/setup-engine`.

## Core Workflow

Common commands or procedural skill files:

- `/start` - first-time onboarding
- `/brainstorm` - game concept ideation
- `/setup-engine` - engine/version configuration
- `/map-systems` - system decomposition
- `/design-system` - GDD authoring
- `/review-all-gdds` - cross-GDD review
- `/create-architecture` - master architecture document
- `/architecture-decision` - ADR creation
- `/create-epics` and `/create-stories` - production breakdown
- `/dev-story` - story implementation
- `/story-done` - acceptance review
- `/qa-plan`, `/smoke-check`, `/release-checklist` - QA and release gates

When a tool does not expose slash commands, treat `/skill-name` as shorthand for
reading `.agents/skills/skill-name/SKILL.md`.

## Project Structure

```text
AGENTS.md                         # Cross-agent source of truth
GEMINI.md                         # Gemini/Antigravity adapter
CLAUDE.md                         # Claude Code adapter
.github/copilot-instructions.md   # GitHub Copilot adapter
.gemini/settings.json             # Gemini CLI context-file config
.agents/                          # Provider-neutral shared layer
  agents/                         # Studio role definitions
  skills/                         # Procedural skills
  rules/                          # Workspace/domain rules
  docs/                           # Templates, workflow catalog, references
  hooks/                          # Portable hook scripts
.claude/                          # Claude Code compatibility layer
.agent/rules/                     # Antigravity compatibility pointer
design/                           # GDDs, UX, narrative, level design
docs/                             # Architecture, ADRs, engine references
src/                              # Game source code once configured
production/                       # Sprints, milestones, release tracking
```

Scoped instructions also exist in `design/AGENTS.md`, `docs/AGENTS.md`,
`src/AGENTS.md`, and `CCGS Skill Testing Framework/AGENTS.md`.

## Validation

Validation is workflow-specific:

- Skill changes: run or follow `/skill-test`.
- Design docs: run or follow `/design-review` and `/review-all-gdds`.
- Architecture docs: run or follow `/architecture-review`.
- Game code: inspect `.agents/docs/technical-preferences.md`, check `docs/engine-reference/`, then run the configured engine-specific checks.
- Hooks: Claude Code wires `.claude/hooks/`; other tools can run equivalent scripts from `.agents/hooks/` manually.

Do not claim runtime, build, hook, or test validation unless it actually happened.

### Autonomy Modes

The system supports three modes. The default is **collaborative**.

| Mode | Owner Touchpoints | When to Use |
|------|-------------------|-------------|
| **Collaborative** (default) | Every step — Ask → Options → Decide → Draft → Approve | All new projects; any time you want full visibility |
| **Supervised Autonomous** | Sprint start, sprint end, HIGH-risk gates | When you've pre-approved a sprint scope and trust the agents to execute |
| **Trusted Autonomous** | HIGH-risk gates + async status reports | Standing mandate; owner reviews milestones and escalations only |

**HIGH-risk actions are owner-gated in every mode.** This includes architecture changes, framework package edits, scope expansion, and release actions.

Set the mode in your work contract (`autonomy_mode` field). When in doubt, default to collaborative.

See [`.agents/docs/autonomy-modes.md`](.agents/docs/autonomy-modes.md) for full definitions.

You stay in control. Agents provide structure, decompose work, and surface options — they do not operate without boundaries.

### Automated Safety

**Hooks** run automatically on every session:

| Hook | Trigger | What It Does |
|------|---------|--------------|
| `validate-commit.sh` | PreToolUse (Bash) | Checks for hardcoded values, TODO format, JSON validity, design doc sections — exits early if the command is not `git commit` |
| `validate-push.sh` | PreToolUse (Bash) | Warns on pushes to protected branches — exits early if the command is not `git push` |
| `validate-assets.sh` | PostToolUse (Write/Edit) | Validates naming conventions and JSON structure — exits early if the file is not in `assets/` |
| `session-start.sh` | Session open | Shows current branch and recent commits for orientation |
| `detect-gaps.sh` | Session open | Detects fresh projects (suggests `/start`) and missing design docs when code or prototypes exist |
| `pre-compact.sh` | Before compaction | Preserves session progress notes |
| `post-compact.sh` | After compaction | Reminds Claude to restore session state from `active.md` |
| `notify.sh` | Notification event | Shows Windows toast notification via PowerShell |
| `session-stop.sh` | Session close | Archives `active.md` to session log and records git activity |
| `log-agent.sh` | Agent spawned | Audit trail start — logs subagent invocation |
| `log-agent-stop.sh` | Agent stops | Audit trail stop — completes subagent record |
| `validate-skill-change.sh` | PostToolUse (Write/Edit) | Advises running `/skill-test` after any `.claude/skills/` change |

> **Note**: `validate-commit.sh`, `validate-assets.sh`, and `validate-skill-change.sh` fire on every Bash/Write tool call and exit immediately (exit 0) when the command or file path is not relevant. This is normal hook behavior — not a performance concern.

**Permission rules** in `settings.json` auto-allow safe operations (git status, test runs) and block dangerous ones (force push, `rm -rf`, reading `.env` files).

### Path-Scoped Rules

Coding standards are automatically enforced based on file location:

| Path | Enforces |
|------|----------|
| `src/gameplay/**` | Data-driven values, delta time usage, no UI references |
| `src/core/**` | Zero allocations in hot paths, thread safety, API stability |
| `src/ai/**` | Performance budgets, debuggability, data-driven parameters |
| `src/networking/**` | Server-authoritative, versioned messages, security |
| `src/ui/**` | No game state ownership, localization-ready, accessibility |
| `design/gdd/**` | Required 8 sections, formula format, edge cases |
| `tests/**` | Test naming, coverage requirements, fixture patterns |
| `prototypes/**` | Relaxed standards, README required, hypothesis documented |

## Design Philosophy

The template is grounded in professional game-development practices:

- MDA Framework for mechanics/dynamics/aesthetics analysis
- Self-Determination Theory for player motivation
- Flow-state design for challenge/skill balance
- Bartle player types for audience framing
- Verification-driven development for implementation quality

## Customization

Everything is intended to be customized:

- Add or remove agents in `.agents/agents/`
- Tune workflows in `.agents/skills/`
- Add path/domain rules in `.agents/rules/`
- Add project-specific templates in `.agents/docs/templates/`
- Mirror changes into `.claude/` only when Claude Code compatibility needs it

## Upgrading

Historical upgrade notes are in `UPGRADING.md`. Some entries still refer to the
original Claude Code layout because they document earlier releases.

## License

MIT License. See `LICENSE` for details.
