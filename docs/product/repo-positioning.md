# Repo Positioning

## Product Thesis

YJackGameStudio is the open-source reference architecture and reusable template
for AI-native game studios. It defines provider-neutral roles, workflows,
contracts, validation expectations, and engine-aware guidance that teams can
adapt without depending on a commercial platform, a specific engine, a specific
AI provider, or YJackCore.

## Why This Repo Exists

This repo exists to make agentic game production inspectable, reusable, and
adaptable. It gives developers, educators, researchers, and tool builders a
public foundation for coordinated AI-assisted game production.

The repo should remain useful for:

- Solo developers and small studios using AI coding tools.
- Educators teaching production discipline and AI collaboration.
- Researchers studying multi-agent software workflows.
- Contributors extending provider, engine, workflow, and validation patterns.
- Game teams on Godot, Unity, Unreal, or custom engines.

## What YJackGameStudio Is

YJackGameStudio is:

- A public open-source reference architecture.
- A reusable template for AI-native game studio workflows.
- A provider-neutral operating model for agents, skills, rules, templates, and
  validation evidence.
- An engine-neutral workflow standard with optional engine-specific adapters.
- A public ecosystem and experimentation layer for agentic game production.
- A project that should remain actively useful without Loomlight Studio,
  YJackCore, Unity, or any specific AI provider.

## What YJackGameStudio Is Not

YJackGameStudio is not:

- Loomlight Studio.
- The commercial/productized platform.
- A closed ecosystem.
- A hosted orchestration backend.
- A commercial dashboard UI.
- A game engine or runtime.
- A replacement for Unity, Unreal, Godot, or custom engines.
- A wrapper around one AI provider.
- An owner of AI generation models.
- A one-prompt game creator.
- A YJackCore dependency layer.

## Relationship to Loomlight Studio

Loomlight Studio is the separate commercial/productized autonomous AI game
studio platform. It may productize concepts proven in YJackGameStudio, but it
owns a different surface: visual product UX, hosted orchestration, accounts,
commercial support workflows, platform operations, and proprietary
implementation.

YJackGameStudio owns the public reference layer: open workflows, contributor
standards, reusable contracts, validation patterns, examples, and tool/engine
compatibility guidance.

## Relationship to YJackCore

YJackCore is an optional Unity gameplay framework and low-code authoring
substrate. YJackGameStudio supports YJackCore-aware routing for Unity projects
that choose that path, but YJackGameStudio must remain useful without YJackCore.

The boundary is:

- YJackGameStudio owns studio workflow, delegation, contracts, validation
  expectations, and owner gates.
- YJackCore owns Unity framework runtime behavior, package APIs, low-code
  authoring surfaces, layer architecture, and framework documentation.
- YJackCore package changes are framework changes and require explicit owner
  approval.
- Generic Unity, Godot, and Unreal workflows remain first-class.

## Relationship to Unity AI and External AI Tools

Unity AI is an external Unity-owned AI surface. YJackGameStudio does not claim
Unity AI support. Future compatibility should be optional and should preserve
owner approval gates, work contracts, and validation evidence.

External AI tools include coding agents, review agents, documentation agents,
asset/content generation tools, and future provider stacks. YJackGameStudio
defines the reference workflow around them; it does not own their model
behavior, service terms, pricing, subscriptions, or generated content policies.

## Open-Source Role

YJackGameStudio should serve as the public ecosystem and standards layer for
AI-native game production. The repo should prioritize:

- Inspectable Markdown/YAML/JSON artifacts.
- Clear source-of-truth docs under `.agents/`.
- Tool compatibility without provider lock-in.
- Engine adapters without engine lock-in.
- Honest validation language.
- Contribution paths that improve reusable standards.

## Contribution Philosophy

Contributions should improve the public operating model rather than narrow the
repo around one commercial product, one framework, one engine, or one AI
provider.

Good contributions are:

- Reusable across multiple projects.
- Explicit about assumptions.
- Compatible with owner-directed autonomy.
- Easy to audit and adapt.
- Backed by documentation, examples, schemas, or validation checks.
- Scoped so they do not silently change Loomlight Studio, YJackCore, downstream
  games, or provider behavior.

## Maintenance Policy

This repo should be maintained as an active reference architecture. Maintenance
focuses on:

- Keeping public docs accurate.
- Preserving provider-neutral `.agents/` assets.
- Updating compatibility guidance as AI tools change.
- Keeping engine references and optional engine adapters clear.
- Improving work-contract and validation standards.
- Avoiding runtime, build, editor, provider, or integration claims that have not
  been validated.

Maintenance does not imply hosted support, commercial service guarantees, or
feature parity with Loomlight Studio.

## Strategic Non-Goals

Current non-goals:

- Building Loomlight Studio inside this repo.
- Adding commercial dashboard UI.
- Adding hosted services, billing, accounts, or private analytics.
- Adding proprietary orchestration backend code.
- Making YJackCore mandatory.
- Making Unity the default future of the repo.
- Replacing Unity, Unreal, Godot, or custom engines.
- Owning or shipping AI generation models.
- Claiming Unity AI support.
- Hiding owner decisions behind black-box automation.

## Future Direction

YJackGameStudio should evolve as the public reference layer:

- Stronger workflow schemas and examples.
- Better provider/tool portability.
- More explicit validation evidence standards.
- Engine-neutral reference pipelines.
- Optional adapters for engines, frameworks, and tools.
- Clearer contribution review rules.
- Documentation that helps users adapt the architecture without confusing it
  with Loomlight Studio or YJackCore.
