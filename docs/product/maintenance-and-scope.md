# Maintenance and Scope

## Purpose

This document defines what belongs in YJackGameStudio, what belongs in
Loomlight Studio, what belongs in YJackCore, and how contributions should be
evaluated.

YJackGameStudio is the open-source reference architecture and public ecosystem
layer. Its scope is reusable standards, workflows, adapters, templates, and
examples for AI-native game production.

## What belongs here

Features belong in YJackGameStudio when they improve the reusable operating
model without requiring a specific commercial product, provider, engine, or
framework.

Good fit:

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
- Optional framework-routing guidance.
- Compatibility notes for AI coding tools.

## What belongs in Loomlight Studio instead

Features belong in Loomlight Studio when they are productized, hosted,
commercial, account-based, proprietary, or specific to the commercial platform
experience.

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

## What belongs in YJackCore instead

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

YJackGameStudio may document how to consume YJackCore, but it should not modify
YJackCore package files as incidental template work.

## How to evaluate contributions

Evaluate each contribution against these questions:

1. Does it improve the public operating model?
2. Does it remain useful without Loomlight Studio?
3. Does it remain useful without YJackCore?
4. If it is engine-specific, is it scoped as an optional adapter, specialist,
   reference pipeline, or example rather than a repo-wide default?
5. Does it avoid dependency on a specific AI provider?
6. Are engine, provider, and framework assumptions stated clearly?
7. Does it preserve owner-directed autonomy and hard approval gates?
8. Does it improve validation honesty rather than imply unverified runtime
   coverage?
9. Is the change documented enough for other tools and contributors to adopt?
10. Is the change small enough to review without hiding scope or coupling?

If the answer to any of questions 2 through 5 is "no", the contribution should
either be moved to a better repo, redesigned as an optional adapter, or clearly
scoped as a non-default example. Engine-specific contributions are welcome when
they improve a Godot, Unity, Unreal, or custom-engine path without making that
engine mandatory for the whole repository.

## Scope boundary examples

Good fit:

- A new schema for portable agent work contracts.
- A provider adapter guide for a new AI coding tool.
- A validation evidence template that works across engines.
- A Godot, Unity, or Unreal reference pipeline that keeps engine assumptions
  explicit.
- A YJackCore routing guide that treats YJackCore as optional.
- A workflow standard for sprint planning, QA evidence, or release gates.

Not a good fit:

- A hosted dashboard that requires Loomlight accounts.
- A proprietary scheduler or orchestration service.
- A billing workflow.
- A Unity-only default that makes Godot or Unreal second-class.
- A YJackCore package runtime change.
- A workflow that claims external AI model behavior as guaranteed.
- A Loomlight-specific internal production process that does not generalize.

## Maintenance expectations

Maintainers should prioritize:

- Coherent `.agents/` source-of-truth assets.
- Accurate README and product docs.
- Link and terminology consistency.
- Compatibility with multiple AI tools.
- Clear engine-reference boundaries.
- Validation scripts and schemas that remain easy for agents to parse.
- Honest status reporting for anything not actually run or integrated.

Maintainers should reject or redirect changes that turn this repo into a closed
commercial product surface, a YJackCore dependency layer, a Unity-only template,
or a claim about integrations that do not exist.
