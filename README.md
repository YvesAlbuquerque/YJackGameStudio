<p align="center">
  <h1 align="center">YJackGameStudio</h1>
  <p align="center">
    <strong>Open-source reference architecture for AI-native game studios.</strong>
    <br />
    49 specialized agents. 76 procedural workflows. Owner-directed autonomy.
    <br />
    <em>Provider-neutral template for Godot, Unity, and Unreal projects.</em>
  </p>
</p>

<p align="center">
  <a href="LICENSE"><img src="https://img.shields.io/badge/license-MIT-blue.svg" alt="MIT License"></a>
  <a href=".agents/agents"><img src="https://img.shields.io/badge/agents-49-blueviolet" alt="49 Agents"></a>
  <a href=".agents/skills"><img src="https://img.shields.io/badge/skills-76-green" alt="76 Skills"></a>
  <a href=".agents/rules"><img src="https://img.shields.io/badge/rules-11-red" alt="11 Rules"></a>
  <a href=".agents/hooks"><img src="https://img.shields.io/badge/hooks-12-orange" alt="12 Hooks"></a>
  <a href="AGENTS.md"><img src="https://img.shields.io/badge/AI%20entrypoint-AGENTS.md-black" alt="AGENTS.md"></a>
</p>

---

## What Is This?

**YJackGameStudio** is a public, open-source, provider-neutral reference
architecture and template for AI-native game studios. It turns AI coding tools
into coordinated game development teams through 49 specialized agents
(designers, programmers, QA, producers), 76 procedural skills (from
brainstorming to release), and professional workflows for Godot, Unity, and
Unreal projects.

This repository is the reusable ecosystem layer: roles, workflows, rules,
templates, validation expectations, and tool adapters that teams can fork,
study, extend, and adapt. It is not the commercial product and it is not a
closed platform. **Loomlight Studio** is the separate commercial/productized
autonomous AI game studio platform that may build on these concepts.

Unlike prompt-to-game toys, YJackGameStudio requires your direction at every stage. You approve concepts, review design docs, make architecture decisions, and control releases. The agents handle execution, documentation, and validation — but you remain the creative director.

**Key Features:**
- **Open Reference Architecture**: MIT-licensed studio template for AI-native game production
- **Multi-Agent Coordination**: 49 specialists working in parallel, not one assistant
- **Engine-Aware**: Native support for Godot, Unity, Unreal with version-pinned references
- **Evidence-Based QA**: Structured validation with BLOCKING/ADVISORY verdicts
- **Owner Control**: Three autonomy modes with hard gates on source code and releases
- **Portable**: Works across Codex, Copilot, Gemini, Antigravity, Claude Code
- **Customizable**: Fork and modify agents, skills, rules, and templates

**What This Is NOT:**
- ❌ Not a prompt-to-game toy (requires owner direction at every major gate)
- ❌ Not a one-prompt autonomous game creator (you control all major decisions)
- ❌ Not Loomlight Studio or the commercial productized platform
- ❌ Not tied to YJackCore; YJackCore is optional
- ❌ Not tied to one engine, AI provider, or coding assistant
- ❌ Not connected to Unity AI (separate tool, no support is claimed)
- ❌ Not an asset generator (generates code and docs, not art/audio)

**Learn More:**
- 📖 [Public Messaging](docs/product/public-messaging.md) — Complete positioning and differentiation
- 🎯 [Elevator Pitches](docs/product/elevator-pitches.md) — 10-second to 1-minute explanations
- 🌐 [Website Copy](docs/product/website-copy.md) — Hero sections, comparisons, FAQ
- 🚀 [Launch Narrative](docs/product/launch-narrative.md) — Story, strategy, community plan
- 🗺️ [Product Roadmap](docs/product/roadmap.md) — Current status and upcoming milestones

Based on [Donchitos/Claude-Code-Game-Studios](https://github.com/Donchitos/Claude-Code-Game-Studios) with provider-neutral extensions.

## Ecosystem Positioning

**YJackGameStudio** is the open-source reference architecture and reusable
template for AI-native game studios. It owns the public ecosystem layer:
provider-neutral agent roles, procedural workflows, rules, templates, validation
expectations, and compatibility guidance.

**Loomlight Studio** is the commercial/productized visual autonomous AI game
studio platform. Loomlight-specific product UI, hosted orchestration,
commercial workflows, and implementation code belong outside this repository.

**YJackCore** is an optional Unity gameplay framework and low-code authoring
substrate. YJackGameStudio supports YJackCore-aware routing for Unity projects
that choose it, but generic Unity, Godot, and Unreal workflows remain
first-class.

**Unity AI and external AI tools** are possible external execution or content
tools. No Unity AI support is claimed here. YJackGameStudio stays useful across
Codex, GitHub Copilot, Gemini CLI, Google Antigravity, Claude Code, and future
AI tooling stacks.

## Supported Agent Systems

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
| Skills | 76 | `.agents/skills/` | Procedural workflows such as `/start`, `/design-system`, `/dev-story`, and `/story-done` |
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

### Optional YJackCore Framework

For Unity projects, an optional framework-aware agent path exists for
[YJackCore](https://github.com/YvesAlbuquerque/YJackCore), a low-code,
inspector-first Unity package for gameplay systems.

**YJackCore is entirely optional.** The generic Unity specialist path works for
all Unity projects, and Godot and Unreal workflows do not depend on YJackCore.
When YJackCore is detected (via `Packages/manifest.json`, `.yjack-workspace.json`,
or technical preferences), agents route through YJackCore-specific guidance for:

- Framework layer boundaries (GameLayer, LevelLayer, PlayerLayer/CoreLayer, ViewLayer, Shared)
- Package integrity and assembly definition structure
- Low-code authoring model preservation
- ScriptableObject patterns and UnityEvent surfaces

See `.agents/docs/yjackcore-support.md` and
`.agents/docs/yjackcore-authority.md` for the full framework-aware routing model.

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
- `/qa-evidence-assign`, `/qa-evidence-aggregate` - multi-agent QA evidence workflow
- `/test-evidence-review` - QA evidence quality review

When a tool does not expose slash commands, treat `/skill-name` as shorthand for
reading `.agents/skills/skill-name/SKILL.md`.

---

## Multi-Agent QA Evidence Workflow

The studio supports parallel QA execution through evidence tasks. This workflow enables
qa-tester agents to execute test verification independently and aggregate results into
sprint or milestone sign-off reports.

### How It Works

1. **After Implementation**: Stories are implemented and unit/integration tests are written
2. **Evidence Assignment**: `/qa-evidence-assign sprint` generates QA evidence tasks for each story
3. **Parallel Execution**: qa-tester agents execute evidence tasks independently (or use `/team-qa`)
4. **Evidence Review**: `/test-evidence-review sprint` validates evidence quality before aggregation
5. **Aggregation**: `/qa-evidence-aggregate sprint-03` (or omit the argument to choose scope interactively) produces a sign-off report with BLOCKING/ADVISORY verdicts
6. **Gate Advancement**: `/gate-check` consumes aggregated evidence to approve phase transitions

### Evidence Task Types

| Story Type | Evidence Task | Artifact Location | Gate Level |
|---|---|---|---|
| Logic | `unit-test` | `tests/unit/[system]/` | BLOCKING |
| Integration | `integration-test` | `tests/integration/[system]/` or playtest doc | BLOCKING |
| Visual/Feel | `visual-evidence` | `production/qa/evidence/` | ADVISORY |
| UI | `ui-evidence` | `production/qa/evidence/` | ADVISORY |
| Config/Data | `smoke-check` | `production/qa/smoke-*.md` | ADVISORY |
| Playtest | `playtest-session` | `production/qa/playtests/` | ADVISORY |
| Release | `release-check` | `production/releases/` | BLOCKING |

### Quick Start

```bash
# After sprint implementation is complete:
/qa-evidence-assign sprint         # Generate evidence tasks for all stories
/test-evidence-review sprint        # Review evidence quality (before aggregation)
/qa-evidence-aggregate sprint-03    # Produce QA sign-off report (or omit argument to choose scope interactively)

# Check sign-off verdict in production/qa/qa-signoff-[sprint]-[date].md
# Verdict: APPROVED / APPROVED WITH CONDITIONS / NOT APPROVED
```

### Key Files

- **Schema**: `.agents/docs/qa-evidence-task-schema.md`
- **Templates**: `.agents/docs/templates/qa-evidence-task.{yml,md}`
- **Skills**: `.agents/skills/qa-evidence-assign/`, `.agents/skills/qa-evidence-aggregate/`, `.agents/skills/test-evidence-review/`

### Unverifiable Criteria

When acceptance criteria cannot be verified autonomously (subjective qualities, Unity Play
Mode requirements, platform-specific behavior), they are flagged as "unverifiable" and
surfaced to the owner dashboard. BLOCKING unverifiable criteria require explicit owner
confirmation before story completion.

For Unity + YJackCore projects, manual validation requirements are documented in
`.agents/docs/templates/yjackcore-unity-manual-validation.md` and included in evidence packets.

---

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

## Owner-Directed Autonomy

The owner sets the level of agent autonomy in `production/autonomy-config.md`.
Under all modes, the owner remains the creative director and final arbiter.

The studio operates in one of three modes:

| Mode | Agent autonomy |
|------|---------------|
| `GUIDED` (default) | Every decision surfaced to the owner. Classic collaborative loop. |
| `SUPERVISED` | LOW-risk actions (analysis, planning, status) execute automatically. MEDIUM and HIGH require owner approval. |
| `AUTONOMOUS` | LOW and MEDIUM actions execute automatically. HIGH always requires owner approval. |

**Regardless of mode**, the following always require explicit owner approval:

- Starting a new game or brainstorm session
- Advancing through any production phase gate
- Writing game source files (`src/`)
- Opening or merging a pull request
- Creating a release
- Modifying YJackCore package files

Full specification: `.agents/docs/autonomy-modes.md`

For the roadmap toward increased autonomous capabilities while maintaining
owner direction and control, see: `docs/AUTONOMOUS_GAME_STUDIO_ROADMAP.md`

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
