# Website Copy for YJackGameStudio

## Hero Section

### Headline
**Turn AI Coding Tools Into a Game Development Studio**

### Subheadline
49 specialized agents. 76 procedural workflows. Owner-directed autonomy for Godot, Unity, and Unreal.

### Hero CTA
- **Primary**: "Get Started" → Links to README quick start
- **Secondary**: "View on GitHub" → Links to repository

### Hero Description
YJackGameStudio is the open-source reference architecture that transforms Codex,
Claude Code, Copilot, Gemini, and other AI coding tools into coordinated game
development teams. Designers, programmers, QA leads, and producers work in
parallel on your project while you maintain full creative control.

---

## Problem Statement Section

### Headline
**Solo and Small-Team Game Development Is Hard**

### Pain Points

#### Wearing Too Many Hats
You're designer, programmer, artist, QA, and producer all at once. Context-switching kills productivity. Documentation falls behind. Quality suffers.

#### Lack of Structure
One-off prompts to AI tools help with immediate tasks, but game development needs systematic workflows: design ownership, architecture decisions, QA discipline, release planning.

#### No AI Coordination
AI coding assistants work great for single files, but game dev spans dozens of systems. How do you coordinate design reviews, parallel implementation, and evidence-based validation across multiple AI sessions?

---

## Solution Section

### Headline
**A Studio Architecture for AI-Assisted Game Development**

YJackGameStudio is the public ecosystem layer: forkable agents, workflows,
rules, templates, and validation standards for AI-native game production. It is
not Loomlight Studio, not a hosted service, and not tied to one AI provider.

### Solution Points

#### 49 Specialized Agents
Not one AI assistant doing everything — a **coordinated team** of specialists:
- **Design**: game-designer, systems-designer, level-designer, narrative-director
- **Programming**: gameplay-programmer, engine-programmer, ai-programmer, network-programmer
- **QA**: qa-lead, qa-tester, performance-analyst
- **Production**: producer, release-manager, devops-engineer

Each agent has domain expertise and delegates work appropriately.

#### 76 Procedural Workflows
Structured skills covering the full development lifecycle:
- **Concept**: `/brainstorm` → `/map-systems`
- **Design**: `/design-system` → `/review-all-gdds`
- **Architecture**: `/create-architecture` → `/architecture-decision`
- **Implementation**: `/create-epics` → `/dev-story` → `/story-done`
- **QA**: `/qa-plan` → `/smoke-check` → `/qa-evidence-aggregate`
- **Release**: `/release-checklist` → `/launch-checklist`

No more inventing workflows every sprint — follow proven studio practices.

#### Owner-Directed Autonomy
You control how much autonomy to grant:
- **GUIDED**: Approve every decision (classic AI chat)
- **SUPERVISED**: LOW-risk tasks execute autonomously; MEDIUM+ need approval
- **AUTONOMOUS**: LOW and MEDIUM tasks execute autonomously; HIGH always requires approval

But **source code, PRs, and releases always require owner approval** — regardless of mode.

#### Multi-Engine Support
Native specialist sets for:
- **Godot 4** (GDScript, C#, GDExtension)
- **Unity 6** (C#, DOTS, UI Toolkit, Addressables)
- **Unreal Engine 5** (C++, Blueprints, GAS, Niagara)

Version-pinned engine references keep agents accurate even for new releases.

---

## How It Works Section

### Headline
**From Concept to Release — Guided Every Step**

### Workflow Steps

#### 1. Install an AI Coding Tool
YJackGameStudio works with:
- Codex
- GitHub Copilot
- Gemini CLI
- Google Antigravity
- Claude Code

Pick your tool, clone the repo, and you're ready.

#### 2. Run `/start`
The onboarding skill detects your project stage (empty repo, prototype, in-progress, or production) and guides you to the right next step.

#### 3. Brainstorm Your Game
`/brainstorm` uses professional ideation techniques (player psychology, MDA framework, pillar definition) to shape a solid concept. You approve or reject ideas; the agent executes.

#### 4. Design Your Systems
`/design-system` writes GDDs section-by-section:
- Overview, Player Fantasy, Detailed Rules, Formulas, Edge Cases, Dependencies, Tuning Knobs, Acceptance Criteria

Each section is drafted, reviewed, and approved before moving on.

#### 5. Create Architecture
`/create-architecture` reads all your GDDs and builds a technical blueprint. Engine-aware agents ensure Godot/Unity/Unreal best practices.

#### 6. Break Into Stories
`/create-epics` and `/create-stories` translate design + architecture into implementable work items with acceptance criteria and test evidence requirements.

#### 7. Implement & Validate
`/dev-story` implements a story, writes tests, and produces evidence. `/story-done` validates against acceptance criteria before marking complete.

#### 8. QA Sign-Off
`/qa-evidence-aggregate` collects all test evidence, produces a PASS/FAIL verdict with BLOCKING/ADVISORY distinctions, and generates a sign-off report.

#### 9. Ship
`/release-checklist` ensures builds, store metadata, certification requirements, and launch readiness are all green before release.

---

## Features Section

### Headline
**Professional Game Development, Systematized**

### Feature Grid

#### Evidence-Based QA
No more "I tested it, trust me." QA agents produce structured evidence:
- Unit tests for logic stories (BLOCKING)
- Integration tests for multi-system work (BLOCKING)
- Visual evidence for feel/polish (ADVISORY)
- Playtest docs for UX validation (ADVISORY)

`/qa-evidence-aggregate` gives you a verdict with receipts.

#### Work Contract System
Every autonomous task declares:
- **Scope**: What will be changed
- **Write Set**: Which files will be modified
- **Validation Plan**: How success is proven
- **Escalation Conditions**: When to stop and ask the owner

Collision detection prevents parallel agents from editing the same file.

#### YJackCore Framework Support
For Unity projects using [YJackCore](https://github.com/YvesAlbuquerque/YJackCore), agents:
- Enforce framework layer boundaries (GameLayer, LevelLayer, PlayerLayer, ViewLayer, Shared)
- Preserve low-code authoring patterns (ScriptableObjects, UnityEvents, Inspector-first)
- Validate package integrity and assembly definitions

Generic Unity path works for all Unity projects; YJackCore awareness is an enhancement.

#### Handoff Records & Session Recovery
Agents write handoff records when switching tasks or ending sessions. When work resumes:
- Read handoff file to understand last validated state
- No need to replay full chat history
- Stateless agent resumption

Session crashes don't lose progress — handoff files persist in Git.

#### Customizable & Forkable
Don't like our game-designer agent? Rewrite it. Want a skill for your studio's workflow? Add it.

Everything lives in `.agents/`:
- `.agents/agents/` — role definitions (Markdown)
- `.agents/skills/` — procedural workflows (Markdown)
- `.agents/rules/` — domain constraints (Markdown)
- `.agents/docs/templates/` — GDD, ADR, sprint plan templates (Markdown, YAML, JSON)

Fork it, customize it, make it yours. MIT license.

#### Portable Across AI Tools
The same studio architecture works with:
- **Codex** (reads `AGENTS.md` + `.agents/skills/`)
- **GitHub Copilot** (`.github/copilot-instructions.md` + path rules)
- **Gemini CLI** (`GEMINI.md` + `.gemini/settings.json`)
- **Google Antigravity** (`AGENTS.md` + `.agents/rules/`)
- **Claude Code** (`CLAUDE.md` + `.claude/` compatibility layer)

Switch tools without rewriting your studio.

---

## What This Is NOT Section

### Headline
**Honest Positioning — What We Don't Claim**

### NOT Loomlight Studio
YJackGameStudio is the open-source reference architecture. Loomlight Studio is
the separate commercial/productized platform. Hosted services, commercial
dashboard UX, billing, and proprietary orchestration belong outside this repo.

### NOT Prompt-to-Game
You don't type "make me a platformer" and get a finished game. YJackGameStudio requires:
- Owner approval at every major gate (concept, GDDs, architecture, stories, PRs, releases)
- Iterative review (design docs written section-by-section, reviewed as you go)
- Active direction (you choose what to build, when to ship, what quality bar to hit)

The studio **assists** your development process; it doesn't replace your creative direction.

### NOT Full Autonomous Generation
While agents can execute tasks autonomously (in SUPERVISED or AUTONOMOUS modes):
- **You initiate** all work (agents don't start on their own)
- **Work contracts** declare scope upfront (no silent scope creep)
- **Hard gates** always require approval (source code, PRs, releases, phase transitions)
- **Transparency** is mandatory (all decisions, file changes, validation results are visible)

Autonomy means **less interruption**, not **no control**.

### NOT Unity AI Integration
YJackGameStudio is **not integrated with Unity AI** (formerly Unity Muse):
- No Unity AI APIs used
- No Unity AI subscriptions required
- No claims of Unity AI partnership or endorsement

Unity AI is a separate tool. They may complement each other in the future (e.g., Unity AI for in-Editor validation, YJackGameStudio for multi-agent coordination), but today they're independent.

### NOT an Asset Generator
YJackGameStudio generates **code and design docs**, not art assets:
- **Does generate**: C#/GDScript/C++ code, GDDs, architecture docs, test plans
- **Does not generate**: 3D models, textures, animations, audio, shaders

For assets, use traditional tools (Blender, Photoshop) or AI asset generators (DALL-E, Stable Diffusion) separately. The studio helps **specify** what assets are needed but doesn't create them.

---

## Comparison Section

### Headline
**How YJackGameStudio Compares**

### Comparison Table

| Feature | YJackGameStudio | Raw AI Tools | SEELE-like Tools | Unity AI |
|---------|-----------------|--------------|------------------|----------|
| **Multi-Agent** | 49 specialized agents | 1 assistant | 1 autonomous system | 1 assistant |
| **Control** | Owner-directed | Full manual control | Black-box autonomous | Unity-assisted |
| **Scope** | Full lifecycle (design → release) | Task-by-task | Full game generation | In-Editor tasks |
| **Engine Support** | Godot, Unity, Unreal | Any | Varies | Unity only |
| **Customizable** | Fork & modify agents/skills | Prompts only | Limited | Unity-native |
| **Evidence-Based QA** | Structured packets + aggregation | Manual | None (autonomous) | Unity Play Mode |
| **Transparency** | Full (all decisions visible) | Full | Opaque | Partial |
| **Production Use** | Designed for it | Possible but ad-hoc | Prototyping focus | Designed for it |

---

## Use Cases Section

### Headline
**Who Uses YJackGameStudio?**

### Use Case Cards

#### Solo Indie Developers
**Challenge**: Wearing all hats (design, code, art, QA, production) leads to burnout and quality issues.

**Solution**: YJackGameStudio provides a virtual studio team. Agents handle execution and documentation; you focus on creative decisions.

**Result**: Ship faster, maintain quality, avoid burnout.

#### Small Studios (2-5 People)
**Challenge**: Team is stretched thin. Can't afford specialists.

**Solution**: Agents act as force multipliers — handle parallel work streams, systematic QA, and documentation while your humans focus on high-value decisions.

**Result**: Scale output without scaling headcount.

#### Technical Designers
**Challenge**: Prototyping is fast, but prototypes are messy and don't ship.

**Solution**: `/prototype` for speed + `/balance-check` for validation + `/reverse-document` to turn good prototypes into production GDDs.

**Result**: Iterate fast, ship clean.

#### Game Development Educators
**Challenge**: Teaching discipline (design docs, architecture, QA) is hard when students want to jump straight to code.

**Solution**: YJackGameStudio gives students a working studio model to learn from. They see agents doing design reviews, writing ADRs, running evidence-based QA.

**Result**: Students learn professional practices through observation and use.

---

## Proof Points Section

### Headline
**By the Numbers**

- **49 Agents**: Designers, programmers, artists, QA, producers
- **76 Skills**: Full lifecycle workflows from brainstorming to release
- **11 Workspace Rules**: Domain-specific constraints (gameplay, engine, UI, AI, networking, tests, docs)
- **Dozens of Templates**: GDDs, ADRs, sprint plans, test plans, UX specs, release docs
- **3 Engines**: Godot, Unity, Unreal with version-pinned references
- **5 AI Tools**: Codex, Copilot, Gemini, Antigravity, Claude Code
- **MIT License**: Open-source, permissive, forkable

---

## Getting Started Section

### Headline
**Get Started in Under 30 Minutes**

### Quick Start Steps

1. **Install an AI coding tool** (Codex, Copilot, Gemini, Antigravity, or Claude Code)
2. **Clone the repository**: `git clone https://github.com/YvesAlbuquerque/YJackGameStudio.git`
3. **Read AGENTS.md** to understand the studio model
4. **Run `/start`** (or read `.agents/skills/start/SKILL.md` manually if your tool doesn't support skills)
5. **Configure your engine** with `/setup-engine`
6. **Brainstorm a concept** with `/brainstorm`
7. **Design your first system** with `/design-system`

### CTA Buttons
- **Primary**: "Get Started" → README quick start
- **Secondary**: "Read the Docs" → `AGENTS.md` and `.agents/docs/`
- **Tertiary**: "View on GitHub" → Repository

---

## FAQ Section

### Headline
**Frequently Asked Questions**

#### Q: Does this replace game developers?
**A:** No. YJackGameStudio **assists** developers by handling execution, documentation, and validation while you maintain creative control. You approve concepts, review GDDs, make architecture decisions, and control releases. Agents execute; you direct.

#### Q: Is this Unity-only?
**A:** No. YJackGameStudio supports **Godot, Unity, and Unreal** equally. Unity + YJackCore is one optional path; generic Unity and Godot/Unreal paths are fully supported.

#### Q: Does it integrate with Unity AI?
**A:** No. Unity AI (formerly Unity Muse) is a separate tool. No integration exists or is claimed. YJackGameStudio works with any AI coding tool and any engine independently.

#### Q: Is this Loomlight Studio?
**A:** No. YJackGameStudio is the open-source ecosystem layer. Loomlight Studio
is the separate commercial/productized platform.

#### Q: Is it safe to use AI-generated code in my game?
**A:** IP status of AI-generated code varies by tool and jurisdiction. YJackGameStudio doesn't change those terms — check with your AI tool vendor. We recommend reviewing all generated code and treating it like code from a junior dev who needs supervision.

#### Q: Can I customize the agents and workflows?
**A:** Absolutely. Everything is `.md` files. Fork the repo, modify agents in `.agents/agents/`, add skills in `.agents/skills/`, tweak rules in `.agents/rules/`. MIT license — it's yours.

#### Q: How much does it cost?
**A:** YJackGameStudio is **free and open-source** (MIT license). You'll need an AI coding tool (Codex, Copilot, Gemini, Claude Code), which may have its own pricing. Check with your tool vendor.

#### Q: Will it write my whole game for me?
**A:** No. It will guide you through structured workflows, execute implementation tasks, produce documentation, and validate quality — but you choose what to build, approve every major decision, and control when to ship. It's a **team**, not a vending machine.

#### Q: What if my AI tool doesn't support skills or slash commands?
**A:** Skills are just `.md` files in `.agents/skills/`. If your tool doesn't expose them as commands, read the file directly and ask the AI to follow it. Example: "Read `.agents/skills/design-system/SKILL.md` and apply it to create a GDD for movement."

---

## Footer Section

### Links
- **GitHub Repository**: [YvesAlbuquerque/YJackGameStudio](https://github.com/YvesAlbuquerque/YJackGameStudio)
- **Documentation**: `AGENTS.md`, `.agents/docs/`
- **Issues**: GitHub Issues for bug reports and feature requests
- **Discussions**: GitHub Discussions for Q&A and community
- **License**: MIT (see `LICENSE` file)

### Legal
- No warranties — provided as-is
- Not affiliated with Unity Technologies, Unity AI, or any game engine vendor
- AI-generated code IP status varies by tool — users responsible for their own legal review

### Attribution
Based on [Donchitos/Claude-Code-Game-Studios](https://github.com/Donchitos/Claude-Code-Game-Studios). Extended to support multiple AI tools and engines.

---

**Last Updated**: 2026-05-10
**Version**: Public operating model positioning
