# Market Positioning

## Conclusion

YJackGameStudio should be positioned as an owner-directed autonomous game studio OS
for maintainable, AI-native game development. It should own production strategy,
planning, agent orchestration, issue contracts, validation evidence, and owner
approval gates. It should not compete as a prompt-to-game toy, asset generator,
UGC platform, or Unity AI clone.

## Product thesis

AI can make game development faster, but only if the work stays structured,
reviewable, maintainable, and aligned with the owner's intent. YJackGameStudio is
the studio operating layer that turns creative goals into scoped work contracts,
routes work to specialist agents, tracks ownership and dependencies, requires
validation evidence, and keeps high-risk decisions owner-gated.

## Category

Primary category: AI-native game production operating system.

Adjacent categories:

- Multi-agent game studio scaffold.
- Autonomous production planning layer.
- Issue-native game development workflow.
- Unity/YJackCore-aware planning and validation layer.

Not the category:

- Prompt-to-game generator.
- Game runtime or engine.
- UGC publishing platform.
- Asset-generation suite.

## Target users

Initial target:

- Solo Unity developers using AI-assisted workflows.
- Technical designers who can reason about systems, authoring UX, and validation.
- Small indie teams that need structure without hiring a full production staff.
- Existing YJackCore users who want planning and production orchestration around
  a low-code Unity authoring substrate.

Later target:

- AI-native prototypers.
- Non-technical dream-game creators, after the planning-to-prototype path is
  proven and safer authoring surfaces exist.

## What YJackGameStudio is

YJackGameStudio is:

- An owner-directed autonomous game studio OS.
- A production and orchestration layer for AI-assisted game development.
- A contract system for decomposing goals into scoped, dependency-aware work.
- A validation-evidence system that records what was actually checked.
- A routing system for specialist agents, engine guidance, and YJackCore
  authority boundaries.
- A way to preserve owner control while allowing supervised or trusted autonomy.

## What YJackGameStudio is not

YJackGameStudio is not:

- A one-prompt full-game generator.
- A generic vibe-coding wrapper.
- A Unity AI clone.
- A replacement for Unity, Unreal, Godot, Roblox Studio, or UEFN.
- A marketplace, UGC platform, or player-facing distribution network.
- A standalone asset generator.
- A promise that agents can safely modify scenes, prefabs, builds, or framework
  package files without owner approval and manual validation.

## Relationship to YJackCore

YJackCore is the preferred Unity gameplay framework and low-code authoring
substrate for the YJack ecosystem. YJackGameStudio should treat YJackCore as an
optional but first-class Unity path.

When YJackCore is present:

- YJackCore owns Unity runtime behavior, package APIs, layer architecture, and
  framework docs.
- YJackGameStudio owns studio orchestration, issue contracts, validation
  evidence, production routing, and owner decisions.
- YJackGameStudio may consume YJackCore guidance and route work to YJackCore
  layers.
- YJackGameStudio must not modify YJackCore package files unless the owner
  explicitly authorizes a framework change.

## Relationship to Unity AI

Unity AI should be treated as a future engine-native execution layer and platform
threat. YJackGameStudio should orchestrate above it, not replicate it.

Unity-owned surface:

- Editor-integrated assistance.
- Scene, asset, and package operations.
- AI asset generation.
- Unity MCP and AI Gateway access.
- Runtime ML through Sentis.
- Unity Cloud, pricing, permissions, and generated-asset metadata.

YJackGameStudio-owned surface:

- Product intent.
- Work contracts.
- Owner approval boundaries.
- Agent assignment and dependency planning.
- YJackCore-aware routing.
- Validation evidence and manual Unity validation debt.

No Unity AI integration is claimed in this repo today.

## Relationship to prompt-to-game tools

Prompt-to-game tools optimize for immediacy: describe a game, get a prototype,
scene, asset set, or playable result quickly. That is useful for ideation, but it
is not enough for maintainable production.

YJackGameStudio should learn from their speed and low-friction onboarding, but
avoid their weakest promise: hiding design, architecture, validation, ownership,
and maintainability behind a single prompt.

## Differentiation

YJackGameStudio differentiates through:

- Owner-directed autonomy instead of unchecked generation.
- Work contracts instead of chat-history intent.
- Validation evidence instead of vague completion summaries.
- Explicit risk gates for architecture, data loss, framework changes, Unity
  scene/prefab wiring, releases, monetization, legal, and player safety.
- YJackCore-aware Unity routing without making YJackCore mandatory.
- Provider-neutral orchestration that can route work to Claude, Codex, Copilot,
  Gemini, Cursor, Windsurf, or future agents.
- Maintainability as a product feature, not an afterthought.

## Strategic non-goals

Current non-goals:

- Full autonomous game generation from one prompt.
- Replacing Unity Editor workflows.
- Building an asset-generation marketplace.
- Becoming a UGC publishing platform.
- Treating YJackCore as mandatory outside the YJack/Unity path.
- Bypassing owner approval for high-risk actions.
- Claiming Unity Editor, Play Mode, build, or Unity AI validation unless actually
  run.

## Current wedge

The first wedge is:

"Idea -> production-ready YJackCore-aware vertical-slice plan."

This wedge is credible because it uses the completed autonomy foundation:
autonomy modes, work contracts, ownership, validation evidence, scheduler, QA
evidence, owner dashboard, risk model, YJackCore routing, and brownfield adoption.

The next wedge is:

"Production-ready plan -> first playable Unity/YJackCore prototype."
