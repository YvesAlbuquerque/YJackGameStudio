# YJackGameStudio AI Delivery Pipeline

Use this pipeline after root `AGENTS.md`. YJackGameStudio is a public provider-neutral, engine-neutral studio template; its AI workflow must remain useful without private Polite Goblin repositories or one vendor's runtime.

## Default flow

```text
public project evidence
  -> detect/configure engine + stage + optional framework
  -> select provider-neutral skill/rule
  -> select compatible engine-specific helper when useful
  -> define acceptance + engine-specific validation
  -> smallest project/template slice
  -> configured engine validation
  -> provider-adapter neutrality review
  -> PR / docs / evidence reconciliation
```

## 1. Start from the configured project

Before game implementation identify:

- engine and version;
- language/authoring choices;
- project stage;
- technical preferences;
- optional framework/package usage;
- current source/tests/build evidence.

Do not assume Unity, Flux, Godot, Unreal, Codex, Claude or any other provider merely because the template supports them.

## 2. Shared behavior stays provider-neutral

Reusable roles, skills, rules, docs, hooks and schemas belong under `.agents/`. Vendor-specific surfaces are adapters and must not define shared behavior that another supported provider cannot discover or reproduce.

A shared skill may describe capability requirements, evidence and safe workflow; it should not require a private Loomlight repository or hidden product contract.

Provider-native skill surfaces are not interchangeable. A Unity Assistant project/package skill, a Claude/Codex skill adapter and the provider-neutral `.agents` workflow may describe the same bounded workflow for different consumers, but the adapter must remain subordinate to project configuration and shared rules.

## 3. Choose the smallest workflow

Use existing skills before adding new ones. Route game implementation to the configured engine/project evidence and use engine-specific validation only after setup proves the engine.

Framework integrations remain optional. Loomlight Flux is one possible Unity framework, not a requirement for generic Unity projects.

### Unity-configured projects

When the configured project is Unity, prefer compatible official `Unity-Technologies/skills` for generic engine mechanics rather than copying those workflows into this public template. Useful upstream routes currently include:

- `unity-cli` for Editor/project/build/test operations and connected Pipeline workflows;
- `unity-package-management` for UPM-aware package changes;
- `ui` and its UI Toolkit/uGUI/IMGUI routes;
- `optimize-web` when a real Unity Web target exists;
- `validate-urp-render-graph-renderer-feature` for compatible Unity 6+ URP Renderer Feature work.

Before using an upstream skill, compare its declared Editor/package assumptions with the actual configured project. The project repository and installed versions remain authoritative.

Do not install multiplayer, ads, IAP, UGS or another optional Unity subsystem merely because an upstream skill exists. Capability must follow a real project requirement.

Community Unity automation projects can inform risk classification, dry-run/planning, rollback, audit, batch consistency and domain-reload recovery. Do not make a second REST/MCP/Editor-control runtime a template dependency when the project's existing Unity tooling is sufficient.

## 4. Mutate Unity through the safest available surface

For Unity scene/prefab/asset/settings work, prefer the actual Editor and project-owned deterministic tools over hand-editing serialized YAML when that is safer.

For non-trivial mutations:

1. inspect current state;
2. discover the exact available command/tool surface rather than guessing names;
3. classify mutation and authority risk;
4. establish rollback or a reversible checkpoint;
5. use a dry-run/plan equivalent where the tool supports it;
6. execute the smallest coherent mutation;
7. reconnect after expected compile/domain reload windows;
8. let Unity import/save and preserve `.meta`/GUID integrity;
9. inspect Console/compile state and changed files;
10. run focused tests, Play Mode, build or target-platform checks required by the claim.

A command returning success is not equivalent to correct game behavior.

## 5. Define validation from configuration

There is no universal build command. Select tests/build/import/Play Mode/editor/runtime checks from the configured project. If the required environment is unavailable, state manual validation debt rather than claiming success.

For Unity, distinguish at least:

- skill discovery/activation;
- Editor command success;
- import/compile success;
- Edit/Play Mode tests;
- runtime behavior;
- build success;
- target-platform performance/visual evidence.

Public documentation and examples must use anonymously accessible references.

## 6. Evaluate project-local Unity skills before promoting them

Project/package-local Unity Assistant skills can be useful when they encode a repeated project-specific workflow rather than generic Unity knowledge already owned upstream.

Before retaining one:

- use a fixed representative project state and request;
- compare repeated runs without and with the candidate skill;
- include a negative/adversarial case where the skill should stop or defer;
- measure correctness, consistency, unnecessary edits, validation behavior and human correction cost;
- keep the local skill only when the improvement is material.

Static `SKILL.md` presence does not prove Unity Assistant discovery, enablement or behavioral value.

## 7. Preserve authority boundaries

Autonomy/delegation mode does not grant release, destructive, legal, financial, privacy, security or public-claim authority. Major phase gates remain explicit owner decisions.

Do not import private commercial Loomlight Game Studio commitments into this public repository.

## 8. Close the loop

After shared skill changes check provider adapters for drift and run the repository's skill validation workflow. Improve an existing shared skill before adding a near-duplicate.

For Unity-configured consumers, capture the Editor/package versions and the upstream skill/ref used when version-sensitive guidance materially affects the work.
