# Repo Positioning

## Product thesis

YJackGameStudio is the open-source reference architecture for AI-native game
production workflows. It defines a portable operating model for coordinating
human owners, specialist agents, work contracts, validation evidence, and
engine-aware guidance without depending on a specific engine, AI provider, or
commercial platform.

## Why this repo exists

This repo exists to make agentic game production inspectable, reusable, and
adaptable. It gives teams a public foundation they can fork, study, extend, and
use as a standards layer for their own AI-assisted game-development workflow.

The repo should stay useful for:

- Solo developers and small studios adopting AI-assisted workflows.
- Educators teaching production discipline and AI-native collaboration.
- Researchers testing multi-agent software-development patterns.
- Tool builders designing interoperable agent, validation, and workflow
  contracts.
- Engine users on Godot, Unity, Unreal, or custom engines.

## What YJackGameStudio is

YJackGameStudio is:

- An open-source operating model for AI-native game studios.
- A reusable template and ecosystem layer for agentic production workflows.
- A provider-neutral set of agents, skills, rules, templates, and validation
  expectations.
- A standards and experimentation layer for work contracts, owner gates,
  delegation boundaries, evidence packets, and production handoffs.
- A multi-engine reference that supports Godot, Unity, and Unreal without making
  any one engine mandatory.
- An actively maintained public project, not an abandoned precursor.

## What YJackGameStudio is not

YJackGameStudio is not:

- The proprietary product.
- Loomlight Studio.
- A closed ecosystem.
- A hosted orchestration backend.
- A commercial dashboard UI.
- A game engine or runtime.
- A replacement for Unity, Unreal, Godot, Roblox Studio, UEFN, or custom
  engines.
- A wrapper around one AI provider.
- An owner of AI generation models.
- A one-prompt complete game creator.
- A claim of Unity AI support.
- A requirement to use YJackCore.

## Relationship to Loomlight Studio

Loomlight Studio is the separate commercial/productized autonomous game studio
platform. It may build on ideas proven in YJackGameStudio, but it is not the same
repo and should not be treated as the same product surface.

YJackGameStudio owns the public ecosystem layer: reference workflows,
interoperable contracts, provider-neutral documentation, examples, and standards.

Loomlight Studio owns any productized commercial layer: hosted services,
proprietary orchestration, commercial dashboard UX, billing, enterprise account
management, and platform-specific implementation code.

## Relationship to YJackCore

YJackCore is an optional but recommended Unity acceleration path for teams that
want a low-code, inspector-first gameplay framework. YJackGameStudio supports
YJackCore-aware routing because it is valuable for Unity projects in the YJack
ecosystem, but YJackGameStudio must remain useful without YJackCore.

The boundary is:

- YJackGameStudio owns studio workflows, contracts, validation expectations,
  owner gates, and provider-neutral routing.
- YJackCore owns Unity framework runtime behavior, package APIs, layer
  architecture, low-code authoring surfaces, and framework documentation.
- Generic Unity, Godot, and Unreal paths remain first-class.
- YJackCore package edits always require explicit owner approval and should be
  handled as framework work, not incidental template work.

## Relationship to Unity AI and AI providers

Unity AI is an external engine-native AI surface. This repo has no Unity AI
integration and claims none. Future compatibility may be explored only if it
preserves owner approval gates, work contracts, provider neutrality, and
validation evidence.

AI providers and coding tools are external execution surfaces. YJackGameStudio
supports portable workflow adapters for tools such as Codex, GitHub Copilot,
Gemini, Google Antigravity, and Claude Code. It must not depend on any specific
provider, model, subscription, API, or proprietary model behavior.

## Open-source role

YJackGameStudio should act like the public standards and experimentation layer
for agentic game production: comparable in role to an open framework that others
can extend, adapt, and learn from.

The open-source repo should prioritize:

- Readable source-of-truth documentation.
- Portable `.agents/` workflows.
- Clear adapter boundaries for specific tools.
- Engine-neutral and provider-neutral examples.
- Honest validation rules.
- Contribution paths that improve shared standards.

## Contribution philosophy

Contributions should improve the public operating model rather than narrow the
repo around one commercial product, one engine, one framework, or one provider.

Good contributions are:

- Reusable across multiple projects.
- Explicit about engine/provider assumptions.
- Compatible with owner-directed autonomy.
- Easy to audit and adapt.
- Backed by docs, examples, validation rules, or tests where appropriate.
- Scoped so they do not silently change YJackCore, Loomlight, or engine-specific
  behavior.

## Maintenance policy

This repo remains actively maintained as an open-source reference architecture.
Maintenance focuses on:

- Keeping provider-neutral `.agents/` assets coherent.
- Updating compatibility guidance as AI tooling changes.
- Preserving engine-neutral workflows and version-reference expectations.
- Improving validation schemas and evidence standards.
- Reviewing contributions for scope, portability, and documentation quality.
- Avoiding claims about integrations or runtime validation that have not been
  implemented and verified.

Maintenance does not imply hosted support, commercial service guarantees, or
feature parity with Loomlight Studio.

## Strategic non-goals

Current non-goals:

- Building Loomlight Studio inside this repo.
- Adding proprietary orchestration code.
- Adding hosted services, billing, accounts, or commercial dashboard UX.
- Tightly coupling the template to YJackCore.
- Making Unity the default assumption for all projects.
- Replacing Unity, Unreal, Godot, or other engines.
- Owning or shipping AI generation models.
- Claiming Unity AI integration before real integration exists and is validated.
- Hiding owner decisions behind black-box automation.
- Optimizing for spectacle over maintainable production workflows.

## Future direction

The future direction is to evolve YJackGameStudio as the public operating model:

- Stronger workflow schemas and work-contract examples.
- Better provider and agent-tool portability.
- More engine-neutral reference pipelines.
- Optional framework adapters, including YJackCore-aware Unity routing.
- Validation standards that separate automated checks, agent review, and manual
  owner confirmation.
- Documentation that helps users adapt the architecture without confusing it
  with Loomlight Studio or YJackCore.
