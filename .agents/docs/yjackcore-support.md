# YJackCore Support

Use this document only when a Unity project consumes the YJackCore package or
when the user asks this template to adapt to YJackCore rules.

YJackCore is optional. Generic Unity guidance remains valid when YJackCore is
absent, and Godot and Unreal projects should ignore this document.

For authority hierarchy, workspace routing, and manual validation expectations,
read `.agents/docs/yjackcore-authority.md` first.

## Detection

Treat a project as YJackCore-backed for optional routing if any of these are
true:

- `.yjack-workspace.json` is present at the project root
- `Packages/manifest.json` contains `com.ygamedev.yjack` or `YJackCore`
- a local package exists at `Packages/YJackCore/package.json`
- a git submodule path points to `YJackCore`
- `.agents/docs/technical-preferences.md` contains `- **Framework**: YJackCore`
- technical preferences name a YJackCore package source, local path, or submodule
- the user explicitly says the game uses YJackCore

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

Do not use this document to make YJackCore the default future of
YJackGameStudio. It is an optional Unity integration path.

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

- Prefer YJackCore prefabs, ScriptableObjects, UnityEvents, and existing manager
  entry points over custom bootstrap code.
- Map work to the closest YJackCore layer before inventing a host-game system.
- Do not modify YJackCore package files from a host-game task unless the user is
  intentionally changing the framework package.
- If framework changes are required, switch context to the YJackCore repository
  or package path and follow its instructions, package boundaries, asmdefs, and
  validation rules.
- Keep host-game glue small and explicit. If glue grows into reusable framework
  behavior, propose a separate YJackCore change rather than burying it in the game.
- Preserve Unity `.meta` files and package/submodule integrity.
- Treat Unity-module-backed paths as primary when YJackCore uses compile symbols;
  bare fallback paths exist for hosts without that module.

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

## Workspace Manifest

For workspace path resolution, create a `.yjack-workspace.json` file at the
project root. Agents read this file first to determine the YJackCore layout
(UPM, sibling checkout, submodule, vendor, or inline) before falling back to
`Packages/manifest.json`.

Copy the relevant layout example from
`.agents/docs/templates/yjack-workspace.json` and remove the `_comment`,
`_layouts`, and `_CHOOSE_ONE_LAYOUT_BELOW_AND_DELETE_THE_REST` keys, plus any
unused layout blocks, before committing.

## Setup Checklist

When configuring a Unity project that chooses YJackCore:

- Set engine to Unity and language to C#
- Start from `.agents/docs/templates/yjackcore-unity-bootstrap.md` for AGENTS, ARCHITECTURE, technical preferences, and framework notes templates
- Record YJackCore in `.agents/docs/technical-preferences.md` only when the project actually uses it
- Record the package source: UPM git URL, local path, or submodule path
- Record the package path (or explicit `N/A` for pure UPM) and selected layer routing notes
- Create `.yjack-workspace.json` at the project root when path resolution is needed for a local, sibling, submodule, vendor, or inline package layout
- Add YJackCore and Odin Inspector to allowed libraries only when actually used
- Route framework architecture questions through YJackCore guidance plus the
  Unity specialist, in that order
- Keep host-game repo changes separate from YJackCore package changes unless framework edits are explicitly authorized
- Keep engine reference docs pinned to the Unity version used by the host project
