# Maintenance and Scope

## Purpose

This document defines what belongs in YJackGameStudio, what belongs in
Loomlight Studio, what belongs in YJackCore, what belongs in downstream games,
and how contributions should be evaluated.

YJackGameStudio is the open-source reference architecture and public ecosystem
layer for AI-native game studio workflows.

## What Belongs in YJackGameStudio

Features belong here when they improve the reusable operating model without
requiring a specific commercial product, provider, engine, or framework.

Good fit examples:

- Provider adapters.
- Workflow schemas.
- Validation standards.
- Agent contracts.
- Work contract examples.
- Orchestration patterns.
- Owner-gate and autonomy rules.
- Documentation.
- Examples.
- Reference pipelines.
- Engine-neutral templates.
- Optional engine or framework adapters.
- Compatibility notes for AI coding tools.

## What Belongs in Loomlight Studio

Features belong in Loomlight Studio when they are productized, hosted,
commercial, account-based, proprietary, or specific to the visual autonomous AI
game studio platform.

Not a good fit for this repo:

- Commercial dashboard UI.
- Proprietary orchestration backend.
- Hosted services.
- Billing, subscriptions, account management, or monetization features.
- Loomlight-specific workflows.
- Private product analytics.
- Enterprise tenant management.
- Platform-specific deployment code.
- Commercial support workflows that do not generalize to the open template.

## What Belongs in YJackCore

Features belong in YJackCore when they change the Unity gameplay framework, its
runtime APIs, package layout, low-code authoring model, editor tooling, or
framework documentation.

YJackCore-owned work includes:

- Unity package runtime behavior.
- Framework layer architecture.
- ScriptableObject and UnityEvent surfaces.
- Inspector-first authoring components.
- Package `.asmdef`, `.meta`, and dependency structure.
- Editor tooling inside the package.
- Framework-specific tests and validation.
- YJackCore package documentation.

YJackGameStudio may document how to consume YJackCore, but it should not carry
YJackCore runtime features or package implementation.

## What Belongs in Downstream Games

Downstream game repositories own project-specific game content and
implementation.

Downstream-owned work includes:

- Game source files.
- Scenes, maps, prefabs, and assets.
- Project-specific GDDs, ADRs, stories, and sprint plans.
- Engine project settings.
- Build pipelines for a particular game.
- Game-specific automation, telemetry, and release configuration.

YJackGameStudio may provide templates and examples for these artifacts, but the
actual project content belongs in the game repo.

## Feature Acceptance Criteria

A contribution is a good fit when it:

- Improves the public operating model.
- Remains useful without Loomlight Studio.
- Remains useful without YJackCore.
- Avoids dependency on a specific AI provider.
- States engine, provider, and framework assumptions clearly.
- Preserves owner-directed autonomy and hard approval gates.
- Improves validation honesty.
- Is documented enough for other contributors to adopt.
- Keeps scope small enough to review.

Engine-specific contributions are acceptable when they are scoped as optional
adapters, specialists, reference pipelines, or examples rather than repo-wide
defaults.

## Contribution Review Checklist

Reviewers should ask:

1. Does this improve the shared reference layer?
2. Does it introduce commercial/product coupling?
3. Does it make YJackCore mandatory?
4. Does it make Unity, Unreal, Godot, or any custom engine mandatory?
5. Does it depend on one AI provider's private behavior?
6. Does it preserve `.agents/` as the provider-neutral source of truth?
7. Does it state what validation did and did not happen?
8. Does it introduce hidden lifecycle, package, or approval risks?
9. Does it belong more naturally in Loomlight Studio, YJackCore, or a downstream
   game repo?
10. Is the contribution small enough to review independently?

## Examples

Good fit:

- A new schema for portable work contracts.
- A provider adapter guide for a new AI coding tool.
- A validation evidence template that works across engines.
- A Godot, Unity, or Unreal reference pipeline with explicit assumptions.
- A YJackCore routing guide that treats YJackCore as optional.
- A workflow standard for sprint planning, QA evidence, or release gates.

Not a good fit:

- Commercial dashboard UI.
- Proprietary orchestration backend.
- Hosted services.
- Monetization features.
- Engine-specific hard coupling.
- Loomlight-specific workflows.
- YJackCore runtime features.
- A workflow that claims external AI model behavior as guaranteed.
- A game-specific system implementation that belongs in a downstream game repo.
