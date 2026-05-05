# YJackCore Support

Use this document when a project consumes the YJackCore Unity package or when
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
- `.claude/docs/technical-preferences.md` lists `Framework: YJackCore`
- the user explicitly says the game uses YJackCore

**If `.yjack-workspace.json` exists, read it before `Packages/manifest.json`.**

When a local YJackCore checkout is available, prefer its repository docs over
generic Unity advice. Start with:

1. `AGENTS.md`
2. `package.json`
3. `ARCHITECTURE.md`
4. `Docs/Workflow/framework-vision.md`
5. `Docs/index.md`
6. the nearest layer doc for the task

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
- Unity package dependencies include TextMeshPro, Cinemachine, Visual Scripting,
  Mathematics, and Input System

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
- Route framework architecture questions through Unity specialist plus this doc
- Keep engine reference docs pinned to the Unity version used by the host project
- Record outstanding manual Unity validation in every work contract and evidence packet
