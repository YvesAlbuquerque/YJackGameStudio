# Public Messaging for YJackGameStudio

## Core Positioning

**YJackGameStudio** is an owner-directed autonomous game studio OS that transforms AI coding tools into coordinated game development teams. It provides the structure, roles, and workflows needed for maintainable, AI-native game development — not just one-off prompts, but a complete studio architecture.

## What This Is

YJackGameStudio is a **portable game-development studio architecture** that works across major AI coding systems (Codex, GitHub Copilot, Gemini, Google Antigravity, and Claude Code). It packages 49 specialized agents, 76 procedural skills, and studio-grade workflows into a coordinated system that follows professional game development practices.

### Key Capabilities

1. **Structured Development**: Design ownership, architecture decisions, content validation, QA, sprint planning, and release discipline
2. **Multi-Agent Coordination**: Specialized roles (designers, programmers, artists, QA, producers) that delegate and collaborate like a real studio
3. **Professional Workflows**: From `/brainstorm` through `/design-system`, `/create-architecture`, `/dev-story`, to `/release-checklist`
4. **Engine-Aware**: Native specialist sets for Godot, Unity, and Unreal Engine
5. **Framework Integration**: Optional YJackCore-aware routing for Unity projects using the inspector-first framework
6. **Owner Control**: Three autonomy modes (GUIDED, SUPERVISED, AUTONOMOUS) with hard gates on source code, PRs, and releases

## What This Is NOT

### Not a Prompt-to-Game Toy

YJackGameStudio requires **owner direction** at every stage. You don't type "make me a platformer" and get a finished game. Instead, you:

- Guide the brainstorm and approve the concept
- Review and approve every GDD section
- Make architecture decisions through ADRs
- Approve epics and stories before implementation
- Review code changes and validation evidence
- Control when to advance through phase gates

The studio **assists** your game development process; it doesn't replace your creative direction or decision-making.

### Not Full Autonomous Game Generation

While the studio supports autonomous task execution (in SUPERVISED or AUTONOMOUS modes), all work is:

- **Owner-initiated**: You choose what to build and when
- **Bounded by work contracts**: Agents declare their scope, write sets, and escalation conditions upfront
- **Gated at critical points**: Source code changes, PRs, releases, and phase transitions always require owner approval
- **Transparent**: All decisions, file changes, and validation results are visible and auditable

The system enables **faster iteration** and **parallel work** through agent coordination, not black-box autonomous development.

### Not a Unity AI Integration

YJackGameStudio is **not integrated with Unity AI** (formerly Unity Muse). While we watch Unity AI's development as a potential future execution layer or platform factor, we:

- Do not claim any integration with Unity AI
- Do not depend on Unity AI APIs or services
- Do not require Unity AI subscriptions or accounts
- Remain engine-agnostic (Godot, Unity, Unreal)

Unity AI may become an interesting complement in the future (e.g., using Unity AI's AI-native runtime alongside YJackGameStudio's agent coordination), but today they are separate tools.

### Not an Asset Generator

YJackGameStudio orchestrates **code and design document creation**, not asset generation. The studio:

- **Does generate**: C#/GDScript/C++ code, GDDs, architecture docs, test plans, sprint plans
- **Does not generate**: 3D models, textures, animations, audio files, shaders

For asset creation, you'll use traditional tools (Blender, Photoshop, Audacity) or AI asset generators (DALL-E, Stable Diffusion, etc.) separately. The studio helps **specify** what assets are needed (through design docs and asset manifests) but doesn't create the assets themselves.

### Not a UGC Platform

This is a **developer tool**, not a player-facing platform. Players don't use YJackGameStudio. Game developers use it to build games faster and more systematically.

## Relationship to YJackCore

**YJackCore** is an optional Unity package — a low-code, inspector-first framework for gameplay systems. YJackGameStudio **supports** YJackCore but doesn't require it.

When YJackCore is detected in a Unity project (via `Packages/manifest.json` or `.yjack-workspace.json`), agents route through YJackCore-specific guidance for:

- Framework layer boundaries (GameLayer, LevelLayer, PlayerLayer, ViewLayer, Shared)
- Package integrity and assembly definitions
- Low-code authoring model preservation
- ScriptableObject patterns and UnityEvent surfaces

The **generic Unity specialist path** works for all Unity projects. YJackCore awareness is an **enhancement**, not a requirement.

## Relationship to Unity AI

**Unity AI** (formerly Unity Muse) is Unity's official AI-powered development assistant. As of this writing:

- **No integration exists** between YJackGameStudio and Unity AI
- **No integration is claimed** or planned in the current roadmap
- YJackGameStudio remains **engine-agnostic** and **AI-tool-agnostic**

### Future Potential (Speculative)

Unity AI may evolve into an interesting **execution layer** or **platform factor**:

- Unity AI could handle in-Editor validation, Play Mode testing, or asset pipeline automation
- YJackGameStudio could orchestrate agent workflows while Unity AI executes Unity-specific runtime validation
- They could complement each other: YJackGameStudio for multi-agent coordination, Unity AI for Unity-native execution

But this is **speculative**. Today, YJackGameStudio works with any AI coding tool (Codex, Copilot, Gemini, Antigravity, Claude Code) and any engine (Godot, Unity, Unreal) independently.

## Positioning vs. Alternatives

### vs. SEELE-like Tools

Tools like SEELE focus on **autonomous prompt-to-game generation** with minimal owner intervention. YJackGameStudio takes the opposite approach:

| Aspect | SEELE-like Tools | YJackGameStudio |
|--------|------------------|-----------------|
| **Control** | Black-box autonomous | Owner-directed, transparent |
| **Scope** | Full game from one prompt | Iterative, approval-gated workflow |
| **Output** | Complete game assets | Code + design docs + validation |
| **Customization** | Limited (prompt engineering) | Full (modify agents, skills, rules) |
| **Professional Use** | Prototyping, jams | Production, maintainable codebases |

YJackGameStudio is for developers who want **AI assistance** with full **creative control** and **production discipline**.

### vs. Unity AI

| Aspect | Unity AI | YJackGameStudio |
|--------|----------|-----------------|
| **Scope** | Unity Editor assistant | Multi-engine studio OS |
| **Integration** | Unity-native | AI-tool-agnostic |
| **Workflows** | In-Editor suggestions | Full studio lifecycle |
| **Multi-Agent** | Single assistant | 49-agent coordination |
| **Validation** | Unity-native (Editor/Play Mode) | Manual validation + test evidence |

YJackGameStudio orchestrates **agent teams** across the entire development lifecycle. Unity AI focuses on **in-Editor assistance**.

### vs. Raw AI Coding Tools

Using Claude Code, Copilot, or Gemini alone gives you:

- One AI assistant
- No role specialization
- No workflow structure
- No multi-agent coordination
- Ad-hoc validation

YJackGameStudio adds:

- **49 specialized agents** with domain expertise
- **76 procedural skills** for common workflows
- **Studio hierarchy** (directors, leads, specialists)
- **Parallel task execution** through agent teams
- **Work contracts** with declared scope and validation
- **Evidence-based QA** with aggregated sign-off reports

It's the difference between **one helpful assistant** and **a coordinated studio team**.

## Target Audience

### Primary

1. **Solo indie developers** who want structured, disciplined development without hiring a team
2. **Small indie studios** (2-5 people) who need AI assistance with professional workflows
3. **Technical game designers** who prototype frequently and need fast iteration
4. **Game development educators** teaching systematic game development practices

### Secondary

1. **AI researchers** exploring multi-agent systems and autonomous software development
2. **Game engine teams** (Godot, Unity, Unreal) considering AI-native workflows
3. **Enterprise game teams** experimenting with AI-assisted development

### Non-Target

- **Players** (this is a developer tool, not a game)
- **Non-technical creators** looking for no-code game builders
- **Teams requiring legally auditable AI usage** (current AI coding tools have unclear IP status)

## Key Messages

### 1-Sentence Description

**YJackGameStudio turns AI coding tools into coordinated game development teams with 49 specialized agents, 76 workflows, and owner-directed autonomy.**

### 1-Paragraph Description

YJackGameStudio is a portable game-development studio architecture that works across Codex, GitHub Copilot, Gemini, Google Antigravity, and Claude Code. It provides 49 specialized agents (designers, programmers, artists, QA, producers), 76 procedural skills (from brainstorming to release), and professional workflows for Godot, Unity, and Unreal projects. Unlike prompt-to-game toys, YJackGameStudio requires owner direction at every stage — you approve concepts, review GDDs, make architecture decisions, and control phase transitions. The system enables faster iteration and parallel work through multi-agent coordination while maintaining full transparency and creative control.

### 1-Page Description

See **"What This Is"** and **"What This Is NOT"** sections above.

## Use Cases

### Use Case 1: Solo Indie Dev Building a Roguelike

**Before YJackGameStudio:**
- Switches between design docs, code, and validation manually
- Loses context between sessions
- No systematic QA or release discipline
- Everything bottlenecks on one person

**With YJackGameStudio:**
- `/brainstorm` guides concept development
- `/design-system` creates GDDs section-by-section
- `/create-architecture` builds technical blueprint
- `/dev-story` implements features systematically
- `/qa-evidence-aggregate` produces sign-off reports
- Owner approves at key gates but AI handles execution

**Result:** Faster iteration, better documentation, systematic quality gates — still solo, but with a coordinated AI team.

### Use Case 2: Small Studio Prototyping New Mechanics

**Before YJackGameStudio:**
- Prototypes are throwaway code with no documentation
- Hard to evaluate which mechanics to keep
- No systematic validation or balance checking

**With YJackGameStudio:**
- `/prototype` skill with relaxed standards for speed
- `/balance-check` analyzes progression and economy
- `/design-review` validates mechanics against pillars
- `/reverse-document` creates GDDs from working prototypes

**Result:** Faster prototyping with built-in validation and documentation. Easy to promote good prototypes to production.

### Use Case 3: YJackCore Unity Project

**Before YJackGameStudio:**
- Manually ensure layer boundaries are respected
- No automated package integrity checks
- Hard to onboard new devs to framework patterns

**With YJackGameStudio:**
- Agents route through YJackCore-specific guidance
- Work contracts prevent cross-layer violations
- `/adopt` audits existing code for framework compliance
- Low-code authoring model is preserved automatically

**Result:** Framework patterns are enforced by agents, not just documentation.

## Differentiators

1. **Owner-Directed**: Not a black box. You approve every major decision.
2. **Multi-Agent Coordination**: 49 specialists working in parallel, not one assistant doing everything.
3. **Engine-Aware**: Native support for Godot, Unity, Unreal with version-pinned references.
4. **Framework-Aware**: Optional YJackCore routing for Unity projects.
5. **Evidence-Based QA**: Structured validation with BLOCKING/ADVISORY verdicts.
6. **Portable**: Works across Codex, Copilot, Gemini, Antigravity, Claude Code.
7. **Customizable**: Modify agents, skills, rules, and templates for your workflow.
8. **Professional**: Based on real studio practices (MDA, SDT, Flow, Bartle, ADRs).

## Common Misconceptions

### "It's just ChatGPT with game dev prompts"

**Reality:** YJackGameStudio is a **multi-agent coordination system** with role specialization, delegation hierarchies, work contracts, and structured validation. It's not about better prompts — it's about better architecture.

### "It replaces game developers"

**Reality:** It **assists** game developers by handling execution, documentation, and validation while the developer maintains creative control and makes all key decisions.

### "It generates full games autonomously"

**Reality:** It requires owner approval at every major gate (concept, GDD, architecture, stories, PRs, releases). Autonomy modes (SUPERVISED, AUTONOMOUS) only affect **how much** the owner is interrupted for minor decisions, not **whether** they control the project.

### "It's Unity-only"

**Reality:** It supports **Godot, Unity, and Unreal** equally. Unity + YJackCore is one **optional** path; generic Unity and Godot/Unreal paths are fully supported.

### "It integrates with Unity AI"

**Reality:** No integration exists or is claimed. Unity AI is a separate tool. They may complement each other in the future, but today YJackGameStudio works with any AI coding tool and any engine independently.

## Proof Points

- **49 agents** across design, programming, art, audio, narrative, QA, production
- **76 procedural skills** covering full development lifecycle
- **11 workspace rules** for domain-specific constraints
- **38 templates** for GDDs, ADRs, sprint plans, test plans, release docs
- **Multi-engine support**: Godot, Unity, Unreal with version-pinned engine references
- **Evidence-based QA**: Structured validation packets with aggregated sign-off reports
- **Work contract system**: Declared scope, write sets, collision detection
- **Autonomous memory model**: Session state, handoff records, durable lessons
- **Professional design frameworks**: MDA, SDT, Flow, Bartle, verification-driven development

## Next Steps for Users

1. **Install an AI coding tool** (Codex, Copilot, Gemini, Antigravity, or Claude Code)
2. **Clone YJackGameStudio** from GitHub
3. **Read AGENTS.md** to understand the studio model
4. **Run `/start`** (or read `.agents/skills/start/SKILL.md` manually)
5. **Configure your engine** with `/setup-engine`
6. **Brainstorm a game** with `/brainstorm`
7. **Design your first system** with `/design-system`
8. **Create architecture** with `/create-architecture`
9. **Implement stories** with `/dev-story`
10. **Validate and release** with `/qa-evidence-aggregate` and `/release-checklist`

## License & Legal

- **License**: MIT (permissive, open-source)
- **No warranties**: Provided as-is
- **AI IP disclaimer**: AI-generated code IP status varies by tool and jurisdiction. Users are responsible for their own legal review.
- **No Unity AI affiliation**: Not affiliated with, endorsed by, or integrated with Unity Technologies or Unity AI

## Support & Community

- **GitHub Issues**: Bug reports, feature requests
- **Discussions**: Q&A, examples, customization
- **Contributions**: PRs welcome for agents, skills, rules, templates
- **Forks**: Encouraged! Customize for your studio or framework

---

**Last Updated**: 2026-05-08
**Version**: PRODUCT-009 (initial public messaging)
