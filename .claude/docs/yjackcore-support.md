# YJackCore Support

Use this document when a Unity project consumes the YJackCore package or when
the user asks this template to adapt to YJackCore rules.

> **Provider-neutral version**: `.agents/docs/yjackcore-support.md`
> **Authority rules**: `.agents/docs/yjackcore-authority.md`
> **Workspace manifest**: `.agents/docs/yjack-workspace-manifest.md`
>
> When there is a conflict between this file and `.agents/docs/yjackcore-authority.md`,
> the `.agents/` doc takes precedence for policy and authority rules.

## Detection

Treat a project as YJackCore-backed if any of these are true:

- `.yjack-workspace.json` exists in the repo root **(read this first)**
- `Packages/manifest.json` contains `com.ygamedev.yjack` or `YJackCore`
- a local package exists at `Packages/YJackCore/package.json`
- a git submodule path points to `YJackCore`
- `.claude/docs/technical-preferences.md` contains `- **Framework**: YJackCore` in the Framework Integration section
- technical preferences name a YJackCore package source, local path, or submodule
- the user explicitly says the game uses YJackCore

**If `.yjack-workspace.json` exists, read it before `Packages/manifest.json`.**

A sibling checkout such as `../YJackCore` may be used as reference material only
after confirming it is the intended framework source or the closest available
local YJackCore repo.

## Specialist Precedence

The YJackCore repo's own guidance is expected to be more specific than this
Game-Studio Unity specialist. Prefer it whenever YJackCore is available.

Use this order:

1. Confirm YJackCore is active from package metadata, technical preferences, or
   the user's statement.
2. If a local YJackCore package or checkout is available, read its repository
   guidance before proposing framework architecture.
3. Use YJackCore-specific skills, agents, and commands for framework ownership,
   layer boundaries, package edits, compile symbols, ScriptableObject/event
   patterns, editor tooling, testing, and doc impact.
4. Use the Game-Studio `unity-specialist` for generic Unity engine/API behavior,
   Unity package/module choices, profiling, rendering, input, UI, Addressables,
   and host-project integration.
5. If YJackCore-specific assets are unavailable, use this file plus the generic
   Unity specialist as a safe fallback.
6. If the project is not YJackCore-backed, ignore this file and use normal Unity
   guidance.

Do not copy YJackCore implementation details blindly. Local package metadata,
nearest docs, asmdefs, and subtree instructions win over this summary.

## Preferred YJackCore Reading Order

When a local YJackCore package or checkout is available, start with:

1. `AGENTS.md`
2. `.ai/AI_ARCHITECTURE.md`, when AI workflow or specialist routing matters
3. `package.json`
4. `ARCHITECTURE.md`
5. `Docs/Workflow/framework-vision.md`
6. `Docs/index.md`
7. nearest layer doc for the task
8. nearest subtree `AGENTS.md`
9. closest `.agents/skills/*/SKILL.md`
10. relevant `.ai/contexts/*` or `.ai/commands/*` workflow, for reviews or audits

Useful YJackCore skill families include:

- `unity-package-maintainer`: package structure, asmdefs, `.meta` integrity
- `yjack-layer-boundary`: GameLayer, LevelLayer, PlayerLayer/CoreLayer, ViewLayer, Shared ownership
- `yjack-runtime-architecture`: runtime orchestration and manager lifecycle
- `yjack-editor-tooling`: editor-only assembly and inspector tooling
- `yjack-compile-symbols`: optional Unity module and platform branches
- `yjack-scriptableobject-patterns`: status assets, events, reset semantics
- `yjack-testing-and-validation`: honest automated/manual Unity validation split
- `yjack-doc-impact`: selective doc-review and update decisions

## Package Assumptions

YJackCore is a Unity package, not a complete Unity project. Host projects should
consume it through Unity Package Manager or as a git submodule/package under
`Packages/`.

Known baseline assumptions from YJackCore:

- Unity package name: `com.ygamedev.yjack`
- Primary language: C#
- Authoring model: low-code, inspector-first setup
- Preferred surfaces: serialized `UnityEvent`, Unity Visual Scripting,
  ScriptableObject state/events, prefabs, and scene-level composition
- Odin Inspector is a baseline authoring dependency
- Unity package dependencies may include TextMeshPro, Cinemachine, Visual
  Scripting, Mathematics, and Input System

If the installed package version differs from these notes, the local package
metadata wins.

## Agent Rules

When YJackCore is active:

- **YJackCore repo docs and AGENTS.md override generic Game Studio Unity guidance.**
  Read them in this order: `AGENTS.md` → `package.json` → `ARCHITECTURE.md` →
  `Docs/Workflow/framework-vision.md` → nearest layer doc for the task.
- **YJackCore package files are read-only by default.** Do not modify
  `Packages/com.ygamedev.yjack/**` or `Packages/YJackCore/**` unless the owner
  explicitly authorizes a framework change.
- **Classify work before starting.** Every work contract must declare whether
  work is `game-repo-work`, `framework-work`, or `both`. Do not mix the two
  without separate owner authorization for the framework portion.
- **Low-code authoring paths are preferred before custom code.** Check YJackCore
  prefabs, ScriptableObjects, UnityEvents, and Visual Scripting surfaces before
  inventing new host-game abstractions.
- Use Unity specialists for engine behavior, but apply YJackCore layer boundaries
  before inventing new architecture.
- Keep host-game glue small and explicit. If glue grows into reusable framework
  behavior, propose a separate YJackCore change rather than burying it in the game.
- Preserve Unity `.meta` files and package/submodule integrity.
- Treat Unity-module-backed paths as primary when YJackCore uses compile symbols;
  bare fallback paths exist for hosts without that module.
- **Report Unity manual validation debt honestly.** Do not claim Unity Editor,
  domain reload, Play Mode, or build validation unless actually run. List all
  outstanding manual validation in the work contract and evidence packet.
  See `.agents/docs/validation-evidence.md`.

## YJackCore Layer Map

Map game work to the closest YJackCore layer:

| Need | Prefer |
| ---- | ---- |
| global startup, save/load, scene transitions, settings, platform services | GameLayer |
| level flow, win/loss, quests, inventory, scene-owned systems | LevelLayer / SceneLayer |
| input, controller activation, camera, player-facing runtime behavior | PlayerLayer / CoreLayer |
| HUD, popups, menus, loading screens, minimap, presentation | ViewLayer |
| reusable state, event, pools, utilities, command/behavior-tree primitives | Shared |

## Design Guidance

GDDs and stories for YJackCore-backed projects should call out:

- which YJackCore layer owns the feature
- which existing prefab, manager, ScriptableObject, event asset, or UnityEvent
  surface should be reused
- what host-game glue is allowed
- what would require a framework change
- what must be manually validated in Unity Play Mode

For small samples, prioritize a complete visible loop over broad framework
coverage. A tiny game should demonstrate a few YJackCore surfaces clearly rather
than touching every subsystem superficially.

## Architecture Impact Reporting

For architecture-sensitive YJackCore work, include:

- **Architecture impact**: host-only wiring, YJackCore package change, or both
- **Doc impact**: game docs only, YJackCore docs, or none
- **Manual validation still required**: Unity scene/prefab wiring, Play Mode
  behavior, package resolution, compile symbols, and any package manager steps

## Setup Checklist

When configuring a project for YJackCore:

- Set engine to Unity and language to C#
- Record YJackCore in `.claude/docs/technical-preferences.md`
- Record the package source: UPM git URL, local path, or submodule path
- Create or update `.yjack-workspace.json` in the repo root
- Add YJackCore and Odin Inspector to allowed libraries only when actually used
- Route framework architecture questions through YJackCore guidance plus the
  Unity specialist, in that order
- Keep engine reference docs pinned to the Unity version used by the host project
- Record outstanding manual Unity validation in every work contract and evidence packet
