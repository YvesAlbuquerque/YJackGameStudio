# Market Positioning

## Conclusion

YJackGameStudio should be positioned as the open-source reference architecture
for AI-native game studio workflows: the public operating model, standards
layer, and reusable template ecosystem. It should not be positioned as
Loomlight Studio, as a YJackCore dependency layer, as a Unity-only product, as a
Unity AI clone, or as a prompt-to-game generator.

## Product thesis

AI can make game development faster only when the work remains structured,
reviewable, maintainable, and aligned with the owner's intent. YJackGameStudio
defines the portable operating layer for that work: specialist roles, scoped
work contracts, owner approval boundaries, validation evidence, handoff records,
and engine/provider-neutral workflows.

## Category

Primary category: open-source AI-native game production operating model.

Adjacent categories:

- Multi-agent game studio scaffold.
- Agentic workflow standards for game production.
- Issue-native game-development workflow.
- Provider-neutral AI studio template.
- Engine-aware planning and validation layer.

Not the category:

- Commercial autonomous studio platform.
- Prompt-to-game generator.
- Game runtime or engine.
- UGC publishing platform.
- Asset-generation suite.
- Unity AI integration.

## Target users

Initial target:

- Solo developers and small studios using AI-assisted workflows.
- Technical designers who can reason about systems, authoring UX, and
  validation.
- Educators teaching systematic game-development production.
- Researchers and tool builders exploring multi-agent software workflows.
- Existing YJackCore users who want an optional Unity acceleration path.

Later target:

- Larger teams that want to adapt the open operating model into internal
  workflows.
- Custom-engine teams that need provider-neutral agent standards.
- Non-technical creators, only after safer templates and stronger constrained
  authoring paths exist.

## What YJackGameStudio is

YJackGameStudio is:

- An open-source reference architecture for AI-native game production.
- A public ecosystem and standards layer.
- A reusable template for agents, skills, rules, contracts, validation, and
  documentation.
- A provider-neutral routing model for AI coding tools.
- A multi-engine workflow layer for Godot, Unity, Unreal, and adaptable custom
  engine projects.
- A way to preserve owner control while allowing supervised or trusted
  delegation.

## What YJackGameStudio is not

YJackGameStudio is not:

- Loomlight Studio.
- A proprietary product.
- A closed ecosystem.
- A Unity-only template.
- A YJackCore requirement.
- A Unity AI clone.
- A replacement for Unity, Unreal, Godot, Roblox Studio, UEFN, or custom
  engines.
- A marketplace, UGC platform, or player-facing distribution network.
- A standalone asset generator.
- A promise that agents can safely modify scenes, prefabs, builds, framework
  package files, or releases without owner approval and manual validation.

## Relationship to Loomlight Studio

Loomlight Studio is the separate commercial/productized autonomous game studio
platform. It may build on patterns and standards proven in YJackGameStudio, but
YJackGameStudio remains the public, product-neutral reference layer.

Commercial dashboard UX, hosted orchestration, billing, account management,
private platform analytics, and Loomlight-specific workflows belong outside this
repo.

## Relationship to YJackCore

YJackCore is an optional but recommended Unity acceleration path for projects
that want a low-code, inspector-first gameplay framework. YJackGameStudio should
support YJackCore-aware routing without depending on it.

When YJackCore is present:

- YJackCore owns Unity runtime behavior, package APIs, layer architecture, and
  framework docs.
- YJackGameStudio owns studio orchestration, issue contracts, validation
  evidence, production routing, and owner decisions.
- YJackGameStudio may consume YJackCore guidance and route work to YJackCore
  layers.
- YJackGameStudio must not modify YJackCore package files unless the owner
  explicitly authorizes a framework change.

When YJackCore is absent, generic Unity, Godot, and Unreal workflows still work.

## Relationship to Unity AI

Unity AI should be treated as a separate engine-native AI surface and potential
future execution layer. YJackGameStudio should orchestrate above any engine AI
tool rather than replicate or depend on it.

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
- Optional framework routing, including YJackCore when present.
- Validation evidence and manual engine-validation debt.

No Unity AI integration is claimed in this repo today.

## Relationship to prompt-to-game tools

Prompt-to-game tools optimize for immediacy: describe a game and get a prototype,
scene, asset set, or playable result quickly. That can be useful for ideation,
but it is not enough for maintainable production.

YJackGameStudio should learn from their speed and low-friction onboarding while
avoiding their weakest promise: hiding design, architecture, validation,
ownership, and maintainability behind a single prompt.

## Differentiation

YJackGameStudio differentiates through:

- Open-source standards instead of a closed product surface.
- Owner-directed autonomy instead of unchecked generation.
- Work contracts instead of chat-history intent.
- Validation evidence instead of vague completion summaries.
- Explicit risk gates for architecture, data loss, framework changes, engine
  scene/prefab wiring, releases, monetization, legal, and player safety.
- Optional YJackCore-aware Unity routing without making YJackCore mandatory.
- Provider-neutral orchestration that can route work to Codex, Copilot, Gemini,
  Antigravity, Claude Code, Cursor, Windsurf, or future agents.
- Maintainability as a core value, not an afterthought.

## Strategic non-goals

Current non-goals:

- Building Loomlight Studio inside this repo.
- Building a commercial hosted platform here.
- Replacing Unity Editor workflows or any game engine.
- Building an asset-generation marketplace.
- Becoming a UGC publishing platform.
- Treating YJackCore as mandatory.
- Bypassing owner approval for high-risk actions.
- Claiming Unity Editor, Play Mode, build, or Unity AI validation unless
  actually run.

## Current wedge

The current public wedge is:

"Open operating model -> adaptable project workflow."

This wedge is credible because it uses the completed autonomy foundation:
autonomy modes, work contracts, ownership, validation evidence, scheduling
rules, QA evidence, owner dashboards, risk models, optional YJackCore routing,
and brownfield adoption.

The next wedge is:

"Reference workflow -> engine-specific example pipeline."
