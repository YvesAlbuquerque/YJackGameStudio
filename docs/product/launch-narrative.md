# Launch Narrative for YJackGameStudio

## Pre-Launch Story (Context Setting)

### The Problem We Saw

Game development has always been a team sport. AAA studios have hundreds of specialists — designers, programmers, artists, animators, sound designers, QA testers, producers. Each role requires deep expertise and years of experience.

But most games aren't made by AAA studios. They're made by solo developers, two-person teams, small indies working nights and weekends. These developers wear every hat: designer, programmer, artist, QA, producer. Context-switching kills productivity. Documentation falls behind. Quality suffers. Burnout is the norm, not the exception.

### The AI Wave

AI coding tools promised to help. ChatGPT, Claude, Copilot — they're amazing at single tasks. "Write a function to calculate projectile arc." "Debug this shader." "Suggest a better data structure."

But game development isn't a collection of isolated tasks. It's a **coordinated system**: design feeds into architecture, architecture shapes implementation, implementation requires QA, QA informs iteration. One AI assistant helping with one file at a time doesn't capture that system-level coordination.

We saw developers using AI tools in ad-hoc ways:
- One Claude session for design doc brainstorming
- A separate Copilot autocomplete flow for coding
- Manual QA with no structured validation
- No connection between design decisions and implementation choices

**There was power in the tools, but no structure to harness it.**

### The Insight

What if we could package game development **roles** and **workflows** in a way that AI tools could execute — while the developer maintained creative control?

Not "AI generates a game for you" (that's a toy, not a tool).

Instead: "AI agents take on specialist roles (designer, programmer, QA lead), follow professional workflows (GDD authoring, architecture decisions, evidence-based validation), and coordinate like a real studio — with the developer as creative director."

That became YJackGameStudio: the open-source reference architecture and public
operating model for AI-native game studios.

---

## What We Built

### A Portable Studio Architecture

YJackGameStudio is a **game development studio as code**:

- **49 specialized agents** with role definitions, expertise areas, and delegation hierarchies
- **76 procedural workflows** covering concept → design → architecture → implementation → QA → release
- **11 workspace rules** for domain-specific constraints (gameplay, engine, UI, networking, tests)
- **Dozens of templates** for professional artifacts (GDDs, ADRs, sprint plans, test plans, UX specs)

It's not a plugin, not a service, and not a SaaS product. It's the **open
ecosystem layer**: a collection of instructions, workflows, standards, and
patterns that AI coding tools can follow. Loomlight Studio is the separate
commercial/productized platform; YJackGameStudio remains product-neutral and
forkable.

### Multi-Tool, Multi-Engine

We designed for **portability**:

- Works with **Codex, GitHub Copilot, Gemini, Google Antigravity, and Claude Code**
- Supports **Godot, Unity, and Unreal Engine** with version-pinned references
- Each engine has specialist agents who know the APIs, conventions, and best practices

You pick your AI tool. You pick your engine. YJackGameStudio adapts.

### Owner-Directed, Not Autonomous

We learned early that **"AI makes a game for you" is the wrong promise**. Creative direction, design taste, and quality judgment are human skills. AI is fast at execution, documentation, and validation — but terrible at knowing **what** to build.

So we built three autonomy modes:

1. **GUIDED** (default): Approve every decision. Classic AI chat collaboration.
2. **SUPERVISED**: LOW-risk tasks (reading, analysis, planning) execute autonomously. MEDIUM and HIGH require approval.
3. **AUTONOMOUS**: LOW and MEDIUM tasks execute autonomously. HIGH always requires approval.

But **regardless of mode**, certain gates are always manual:
- Approving a game concept
- Writing game source files
- Opening or merging a pull request
- Creating a release
- Advancing through production phase gates

The developer is the **creative director**. Agents are the **execution team**.

### Evidence-Based QA

We rejected "trust me, I tested it" development. Every story in YJackGameStudio has a **test evidence requirement**:

| Story Type | Evidence Required | Gate Level |
|------------|-------------------|------------|
| Logic (formulas, state machines) | Unit test | BLOCKING |
| Integration (multi-system) | Integration test or playtest doc | BLOCKING |
| Visual/Feel (animation, VFX) | Screenshot + lead sign-off | ADVISORY |
| UI (menus, HUD) | Walkthrough doc or interaction test | ADVISORY |
| Config/Data (balance tuning) | Smoke check pass | ADVISORY |

QA agents produce **structured evidence packets**. `/qa-evidence-aggregate` collects them and produces a PASS/FAIL verdict with receipts.

No hand-waving. No "looks good to me." Just verifiable evidence.

### YJackCore Framework Support (Optional)

For Unity developers using [YJackCore](https://github.com/YvesAlbuquerque/YJackCore) — a low-code, inspector-first gameplay framework — we added framework-aware agents.

These agents:
- Enforce YJackCore layer boundaries (GameLayer, LevelLayer, PlayerLayer, ViewLayer, Shared)
- Preserve low-code authoring patterns (ScriptableObjects, UnityEvents, Inspector-first composition)
- Validate package integrity and assembly definitions
- Prevent cross-layer violations automatically

**YJackCore is entirely optional.** The generic Unity specialist path works for all Unity projects. Framework awareness is an enhancement for teams already using YJackCore.

---

## Launch Messaging Arc

### Week 1: Awareness ("The Problem")

**Hook**: "You're designer, programmer, artist, QA, and producer all at once. No wonder you're burning out."

**Content**:
- Blog post: "Why Solo Game Dev Feels Like Drowning (And What We Built to Help)"
- Twitter/X thread: "10 things every solo indie does that kills productivity"
- Reddit post (r/gamedev): "I built a multi-agent AI studio because one AI assistant wasn't enough"

**Goal**: Establish the pain point. Get developers nodding along.

### Week 2: Introduction ("What We Built")

**Hook**: "What if you had 49 specialists working on your game — for free?"

**Content**:
- Launch post: "Introducing YJackGameStudio: Turn AI Tools Into a Game Dev Team"
- Demo video: Brainstorming a roguelike concept → GDD authoring → architecture → first story implementation (15 min walkthrough)
- GitHub Discussion: "How YJackGameStudio Works (AMA)"

**Goal**: Show the solution. Make it tangible.

### Week 3: Differentiation ("What It's NOT")

**Hook**: "We're not selling 'prompt-to-game' magic. Here's why."

**Content**:
- Blog post: "Why YJackGameStudio Requires Your Direction (And Why That's Good)"
- Comparison post: "YJackGameStudio vs. SEELE vs. Unity AI vs. Raw ChatGPT"
- FAQ page on GitHub

**Goal**: Set honest expectations. Attract the right audience (developers who want assistance, not automation).

### Week 4: Proof ("It Works")

**Hook**: "We shipped a vertical slice in 2 weeks with YJackGameStudio. Here's the breakdown."

**Content**:
- Case study: Shipping a small game with evidence (GDD screenshots, architecture doc, test evidence, playable build)
- GitHub repo tour: "Every artifact YJackGameStudio created for this project"
- Community showcase: "Share your YJackGameStudio projects" (Twitter hashtag, GitHub Discussions thread)

**Goal**: Provide social proof. Show it's not vaporware.

---

## Target Channels

### Primary
- **GitHub**: Repository, Discussions, Issues (where developers already are)
- **Reddit**: r/gamedev, r/IndieDev, r/godot, r/Unity3D, r/unrealengine
- **Twitter/X**: Game dev community, AI dev community

### Secondary
- **YouTube**: Demo walkthroughs, tutorial series, case studies
- **Dev.to / Hashnode**: Technical deep-dives (multi-agent coordination, work contracts, evidence-based QA)
- **Discord**: Game dev servers (participation, not promotion)

### Tertiary
- **Hacker News**: "Show HN" post (but only once, with a solid demo)
- **LinkedIn**: For enterprise/education angle (less urgent for v1)

---

## Key Messages (Repeated Across All Content)

### Always Say
1. **Owner-directed, not autonomous**: You control all major decisions.
2. **Multi-agent coordination**: 49 specialists, not one assistant.
3. **Evidence-based QA**: Structured validation, not hand-waving.
4. **Portable**: Works with your AI tool, your engine.
5. **Customizable**: Fork it, modify it, make it yours.

### Never Say
1. "AI will build your game for you"
2. "One prompt creates a complete production-ready game"
3. "Integrated with Unity AI" (no such integration exists)
4. "Replace game developers"
5. "One prompt, done"

### Address Directly
- **"Will this replace me?"** → No. It assists you. You direct, agents execute.
- **"Is my job safe?"** → Yes. Creative direction and design taste are human skills. This makes you **more** productive, not obsolete.
- **"Can I trust AI code?"** → Only with validation. That's why we built evidence-based QA.

---

## Community Strategy

### Open-Source First
- **MIT License**: Permissive, forkable, transparent
- **Public Development**: All issues, discussions, roadmap on GitHub
- **Contributions Welcome**: PRs for new agents, skills, templates

### No Gatekeeping
- No signup required
- No waiting list
- No "request access"
- Clone the repo, run `/start`, go

### Documentation-Driven
- Every agent has a role definition
- Every skill has a workflow file
- Every template is ready to use
- Everything is readable `.md` files

### Show, Don't Tell
- Publish real GDDs created with YJackGameStudio
- Share architecture docs, sprint plans, QA evidence packets
- GitHub repos of small games built with the studio
- Encourage users to do the same

---

## Launch Day Checklist

### Pre-Launch (1 Week Before)
- [ ] Finalize all public messaging docs
- [ ] Update README with hero copy and links
- [ ] Record 15-minute demo video (brainstorm → GDD → architecture → story)
- [ ] Prepare "Show HN" post
- [ ] Draft launch post for GitHub Discussions
- [ ] Draft Twitter/X thread (10-tweet launch narrative)
- [ ] Queue Reddit posts (r/gamedev, r/IndieDev)
- [ ] Set up GitHub Discussions categories (Q&A, Show & Tell, Feature Requests)

### Launch Day
- [ ] Publish launch post on GitHub Discussions
- [ ] Post demo video on YouTube
- [ ] Tweet launch thread
- [ ] Post to Reddit (r/gamedev first, others 2-3 hours apart)
- [ ] "Show HN" on Hacker News (if demo is strong)
- [ ] Monitor GitHub Issues, Discussions, Reddit comments, Twitter replies

### Post-Launch (First Week)
- [ ] Respond to every GitHub Discussion question within 24 hours
- [ ] Address bugs and feedback in real-time
- [ ] Publish "Week 1 Learnings" post (what worked, what didn't, what's next)
- [ ] Start tutorial series (YouTube + blog posts)
- [ ] Feature early adopters (Twitter shoutouts, GitHub pinned discussions)

---

## Success Metrics

### Week 1
- **GitHub Stars**: 100+ (awareness)
- **Discussions Posts**: 20+ (engagement)
- **Issues Opened**: 10+ (usage)
- **Demo Video Views**: 500+ (reach)

### Month 1
- **GitHub Stars**: 500+ (growing awareness)
- **Forks**: 50+ (customization/adoption)
- **Community Showcases**: 5+ (real usage)
- **Tutorial Series**: 5 videos published

### Month 3
- **GitHub Stars**: 1,000+ (established project)
- **Contributors**: 10+ (community ownership)
- **Shipped Games**: 3+ showcased (proof of production use)
- **Case Studies**: 2+ published (validation)

---

## Messaging Evolution

### Version 1 (Now): "Open AI-Native Studio Architecture"
Positioning: Owner-directed, multi-agent, evidence-based, portable,
customizable, and open-source.

Target: Developers, educators, and tool builders who want structure without
losing control.

### Version 2 (6 Months): "Reusable Production Workflow Standards"
Positioning: Stronger reference pipelines, validation schemas, compatibility
guides, and optional framework adapters.

Target: Small studios, educators, researchers, and contributors adapting the
model to real projects.

### Version 3 (12 Months): "Public Ecosystem Layer"
Positioning: Community-maintained standards for agentic game production across
engines, tools, and studio workflows.

Target: Broader open-source contributors, engine communities, AI-tool vendors,
and teams adopting provider-neutral operating models.

**But for now**: Focus on the public operating model. Keep Loomlight Studio,
commercial platform UX, and hosted orchestration out of this repo.

---

## Launch Narrative (TL;DR)

**Setup**: Solo game dev is hard. AI tools help, but lack structure.

**Conflict**: One AI assistant isn't enough. Game dev needs coordination, workflows, validation.

**Solution**: YJackGameStudio packages 49 specialized agents, 76 workflows, and professional practices into a portable studio architecture.

**Differentiation**: Not prompt-to-game magic. Owner-directed, evidence-based, customizable.

**Proof**: Open-source, MIT-licensed, works with your tools and engine. Try it now.

**Call to Action**: Clone the repo. Run `/start`. Build your game with a virtual studio team.

---

**Last Updated**: 2026-05-10
**Version**: Public operating model positioning
