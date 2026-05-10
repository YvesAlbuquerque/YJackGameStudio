# Public Messaging for YJackGameStudio

## Core Positioning

**YJackGameStudio** is the open-source reference architecture for AI-native game
studio workflows. It packages 49 specialized agents, 76 procedural skills,
owner-directed autonomy, work contracts, validation evidence, and professional
game-production templates into a provider-neutral operating model for Godot,
Unity, Unreal, and adaptable custom-engine projects.

This repo is the public ecosystem layer. It is not Loomlight Studio, not a
closed product surface, not a YJackCore dependency, and not tied to any specific
AI provider.

## What This Is

YJackGameStudio is a portable game-development studio architecture that works
across major AI coding systems: Codex, GitHub Copilot, Gemini, Google
Antigravity, and Claude Code. It provides reusable roles and workflows for
planning, design, architecture, implementation, QA evidence, release gates, and
studio operations.

### Key Capabilities

1. **Open operating model**: Public, inspectable, MIT-licensed standards for
   AI-native game production.
2. **Structured development**: Design ownership, architecture decisions, content
   validation, QA, sprint planning, and release discipline.
3. **Multi-agent coordination**: Specialized roles that collaborate like a
   studio team.
4. **Professional workflows**: From `/brainstorm` through `/design-system`,
   `/create-architecture`, `/dev-story`, and `/release-checklist`.
5. **Engine-aware**: Specialist guidance for Godot, Unity, and Unreal.
6. **Framework-aware when useful**: Optional YJackCore routing for Unity
   projects using the inspector-first framework.
7. **Owner control**: Three autonomy modes with hard gates on source code, PRs,
   releases, YJackCore package edits, and production phase transitions.

## What This Is Not

### Not Loomlight Studio

YJackGameStudio is not the commercial/productized autonomous game studio
platform. Loomlight Studio may build on ideas from this repo, but hosted
services, commercial dashboard UX, proprietary orchestration, billing, and
Loomlight-specific workflows belong outside the open-source reference layer.

### Not a Prompt-to-Game Toy

YJackGameStudio requires owner direction at major gates. You do not type one
sentence and receive a finished game. Instead, you:

- Guide the brainstorm and approve the concept.
- Review and approve GDD sections.
- Make architecture decisions through ADRs.
- Approve epics and stories before implementation.
- Review code changes and validation evidence.
- Control phase transitions, PRs, and releases.

The studio assists your game-development process; it does not replace your
creative direction or decision-making.

### Not Black-Box Autonomous Development

The studio supports autonomous task execution in bounded modes, but all work is:

- **Owner-initiated**: You choose what to build and when.
- **Bounded by work contracts**: Agents declare scope, write sets, validation,
  and escalation conditions upfront.
- **Gated at critical points**: Source code changes, PRs, releases, framework
  package changes, and phase transitions always require owner approval.
- **Transparent**: Decisions, file changes, and validation results are visible
  and auditable.

### Not a Unity AI Integration

YJackGameStudio is not integrated with Unity AI. It:

- Does not claim Unity AI support.
- Does not depend on Unity AI APIs or services.
- Does not require Unity AI subscriptions or accounts.
- Remains engine-neutral and AI-tool-neutral.

Unity AI may become an interesting external execution layer in the future, but
only if owner gates, work contracts, and validation evidence remain intact.

### Not an Asset Generator

YJackGameStudio orchestrates code, design documents, workflow structure, and
validation planning. It does not create final art, audio, animation, models, or
commercial asset libraries. It can help specify asset needs, but asset
generation remains outside the core value proposition.

## Ecosystem Relationships

### Loomlight Studio

Loomlight Studio is the commercial/productized evolution. Treat it as separate
from this repo. YJackGameStudio remains product-neutral and open-source.

### YJackCore

YJackCore is an optional but recommended Unity acceleration path: a low-code,
inspector-first framework for gameplay systems. YJackGameStudio supports
YJackCore-aware routing when YJackCore is present, but generic Unity, Godot, and
Unreal workflows remain first-class.

### Unity AI

Unity AI is an external Unity-owned AI surface. No integration exists or is
claimed in this repo. Future compatibility must be explicit, validated, and
optional.

### External AI Tools

YJackGameStudio works across AI coding tools by keeping the shared source of
truth in `.agents/` and exposing adapters through `AGENTS.md`,
`.github/copilot-instructions.md`, `GEMINI.md`, `CLAUDE.md`, and compatibility
rules. The repo should stay useful as tools change.

## Positioning vs. Alternatives

### vs. Raw AI Coding Tools

Using one AI coding assistant alone gives you ad-hoc help. YJackGameStudio adds
the studio operating model: roles, workflows, contracts, validation evidence,
handoffs, and approval gates.

### vs. Prompt-to-Game Tools

Prompt-to-game tools optimize for speed and immediacy. YJackGameStudio optimizes
for maintainable production: transparent decisions, scoped work, validation
evidence, and owner control.

### vs. Unity AI

Unity AI is Unity's engine-native assistant surface. YJackGameStudio is an
engine-neutral workflow architecture across the full development lifecycle.
Different scope, no integration claim.

### vs. Loomlight Studio

Loomlight Studio is where productized commercial orchestration may live.
YJackGameStudio is where reusable public standards, docs, workflows, examples,
and provider-neutral templates live.

## Target Audience

### Primary

1. Solo developers and small studios using AI-assisted workflows.
2. Technical game designers who want structured production without giving up
   authoring control.
3. Game-development educators teaching systematic workflows.
4. AI researchers and tool builders studying multi-agent software workflows.

### Secondary

1. Existing YJackCore users who want optional Unity framework-aware routing.
2. Game engine teams exploring AI-native workflows.
3. Larger teams adapting the open operating model internally.

### Non-Target

- Players.
- Users looking for a no-code game vending machine.
- Teams that need a hosted commercial platform; that belongs to Loomlight
  Studio or another product surface.
- Users expecting this repo to own AI generation models or provider terms.

## Key Messages

### 1-Sentence Description

**YJackGameStudio is the open-source operating model for AI-native game studios:
49 agents, 76 workflows, owner-directed autonomy, and provider-neutral
production standards.**

### 1-Paragraph Description

YJackGameStudio is a portable game-development studio architecture that works
across Codex, GitHub Copilot, Gemini, Google Antigravity, and Claude Code. It
provides 49 specialized agents, 76 procedural skills, work contracts,
evidence-based QA, and professional workflows for Godot, Unity, and Unreal
projects. It is not Loomlight Studio, not tied to YJackCore, and not a
one-prompt game generator. It is the open ecosystem layer teams can fork,
extend, study, and adapt.

## Use Cases

### Solo Indie Developer

Use YJackGameStudio to turn vague intent into scoped design docs, architecture,
stories, validation plans, and evidence packets while keeping ownership of
creative and release decisions.

### Small Studio

Use YJackGameStudio to coordinate parallel AI-assisted work streams with
declared write sets, dependencies, approval boundaries, and handoff records.

### Educator

Use YJackGameStudio as a visible model for production discipline: GDDs, ADRs,
QA evidence, sprint planning, release gates, and transparent AI collaboration.

### Tool Builder or Researcher

Use YJackGameStudio as an open test bed for multi-agent workflow standards,
provider portability, work contracts, and validation evidence.

### Unity + YJackCore Project

Use optional YJackCore routing to map systems to framework layers, preserve
low-code authoring surfaces, and separate game-repo work from framework changes.

## Proof Points

- **49 agents** across design, programming, art, audio, narrative, QA, and
  production.
- **76 procedural skills** covering the development lifecycle.
- **11 workspace rules** for domain-specific constraints.
- **12 portable hooks** with tool-specific wiring where available.
- **38 templates** for GDDs, ADRs, sprint plans, test plans, release docs, and
  more.
- **Multi-engine support**: Godot, Unity, Unreal with version-pinned references.
- **Multi-tool support**: Codex, Copilot, Gemini, Antigravity, Claude Code.
- **Evidence-based QA**: Structured validation packets and aggregated sign-off.
- **Work contract system**: Scope, write sets, dependency handling, validation,
  and escalation.
- **MIT license**: Forkable, inspectable, and adaptable.

## Common Misconceptions

### "It's just prompts"

No. The repo defines roles, procedures, work contracts, validation standards,
handoffs, and approval gates. Prompts are only one small part of the operating
model.

### "It's Unity-only"

No. Godot, Unity, and Unreal are first-class. YJackCore is one optional Unity
path.

### "It replaces game developers"

No. Humans set intent, approve high-risk decisions, validate subjective or
engine/editor-specific results, and control releases.

### "It integrates with Unity AI"

No. Unity AI is separate. This repo does not claim that integration.

### "It is the commercial product"

No. This repo is the open ecosystem layer. Productized commercial platform work
belongs to Loomlight Studio.

## Next Steps for Users

1. Install an AI coding tool.
2. Clone YJackGameStudio.
3. Read `AGENTS.md`.
4. Run `/start`, or read `.agents/skills/start/SKILL.md` manually.
5. Configure your engine with `/setup-engine`.
6. Use the relevant workflow for design, architecture, implementation, QA, or
   release.

## License & Legal

- **License**: MIT.
- **No warranties**: Provided as-is.
- **AI IP disclaimer**: AI-generated code IP status varies by tool and
  jurisdiction. Users are responsible for their own legal review.
- **No Unity AI affiliation**: Not affiliated with, endorsed by, or integrated
  with Unity Technologies or Unity AI.

## Support & Community

- **GitHub Issues**: Bug reports and feature requests.
- **Discussions**: Q&A, examples, and customization.
- **Contributions**: PRs welcome for agents, skills, rules, templates, docs, and
  portable examples.
- **Forks**: Encouraged for studio-specific adaptation.

---

**Last Updated**: 2026-05-10
**Version**: Public operating model positioning
