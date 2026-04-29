<p align="center">
  <h1 align="center">Agentic Game Studios</h1>
  <p align="center">
    A portable game-development studio architecture for Codex, GitHub Copilot, Gemini, Google Antigravity, and Claude Code.
    <br />
    49 agents. 72 skills. One coordinated AI team.
  </p>
</p>

<p align="center">
  <a href="LICENSE"><img src="https://img.shields.io/badge/license-MIT-blue.svg" alt="MIT License"></a>
  <a href=".agents/agents"><img src="https://img.shields.io/badge/agents-49-blueviolet" alt="49 Agents"></a>
  <a href=".agents/skills"><img src="https://img.shields.io/badge/skills-72-green" alt="72 Skills"></a>
  <a href=".agents/rules"><img src="https://img.shields.io/badge/rules-11-red" alt="11 Rules"></a>
  <a href=".agents/hooks"><img src="https://img.shields.io/badge/hooks-12-orange" alt="12 Hooks"></a>
  <a href="AGENTS.md"><img src="https://img.shields.io/badge/AI%20entrypoint-AGENTS.md-black" alt="AGENTS.md"></a>
</p>

---

## Why This Exists

A single AI coding chat is useful, but game development needs structure: design
ownership, architecture decisions, content validation, QA, sprint planning, and
release discipline. This repository packages those responsibilities as a studio
model that agentic tools can follow.

The original project was Claude Code-centric. It now has a provider-neutral
shared layer under `.agents/` plus native adapters for the major agentic coding
systems.

## Supported Agent Systems

| System | Entrypoint | Notes |
|--------|------------|-------|
| Codex | `AGENTS.md` | Uses the cross-agent instructions and can load `.agents/skills/` as project skills. |
| GitHub Copilot | `.github/copilot-instructions.md` | Also includes path-specific instructions under `.github/instructions/`. |
| Gemini CLI | `GEMINI.md` and `.gemini/settings.json` | Configured to load both `AGENTS.md` and `GEMINI.md`. |
| Google Antigravity | `AGENTS.md`, `GEMINI.md`, `.agents/rules/` | Uses the shared rules/docs layout; `.agent/rules/game-studio.md` is a compatibility pointer. |
| Claude Code | `CLAUDE.md` and `.claude/` | Preserved as a compatibility layer. |

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
