# YJackGameStudio AI Delivery Pipeline

Use this pipeline after root `AGENTS.md`. YJackGameStudio is a public provider-neutral, engine-neutral studio template; its AI workflow must remain useful without private Polite Goblin repositories or one vendor's runtime.

## Default flow

```text
public project evidence
  -> detect/configure engine + stage + optional framework
  -> select provider-neutral skill/rule
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

## 3. Choose the smallest workflow

Use existing skills before adding new ones. Route game implementation to the configured engine/project evidence and use engine-specific validation only after setup proves the engine.

Framework integrations remain optional. Loomlight Flux is one possible Unity framework, not a requirement for generic Unity projects.

## 4. Define validation from configuration

There is no universal build command. Select tests/build/import/Play Mode/editor/runtime checks from the configured project. If the required environment is unavailable, state manual validation debt rather than claiming success.

Public documentation and examples must use anonymously accessible references.

## 5. Preserve authority boundaries

Autonomy/delegation mode does not grant release, destructive, legal, financial, privacy, security or public-claim authority. Major phase gates remain explicit owner decisions.

Do not import private commercial Game Studio commitments into this public repository.

## 6. Close the loop

After shared skill changes check provider adapters for drift and run the repository's skill validation workflow. Improve an existing shared skill before adding a near-duplicate.

## Skills added by this pass

- `project-bootstrap-route` — determine engine/stage/framework/skill/validation routing for a configured or new game workspace.
- `provider-neutrality-audit` — ensure shared AI assets remain provider-neutral and public, with vendor logic confined to adapters.
