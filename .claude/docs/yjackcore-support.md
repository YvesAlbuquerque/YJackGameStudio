# YJackCore Support

Use this document when a Unity project consumes the YJackCore package or when
the user asks this template to adapt to YJackCore rules.

## Detection

Treat a project as YJackCore-backed if any of these are true:

- `.yjack-workspace.json` exists at the Unity project root (highest confidence)
- `Packages/manifest.json` contains `com.ygamedev.yjack` or `YJackCore`
- a local package exists at `Packages/YJackCore/package.json`
- a git submodule path points to `YJackCore`
- `.claude/docs/technical-preferences.md` contains `- **Framework**: YJackCore` in the Framework Integration section
- technical preferences name a YJackCore package source, local path, or submodule
- the user explicitly says the game uses YJackCore

When `.yjack-workspace.json` is present, read it first to resolve the package
root path and authority notes. See `.agents/docs/yjackcore-workspace-manifest.md`
for the manifest schema and layout examples.

A sibling checkout such as `../YJackCore` may be used as reference material only
after confirming it is the intended framework source or the closest available
local YJackCore repo.

## Framework-vs-Product Authority

YJackCore is a separately maintained framework package. Its own repository is
the authoritative source for all framework-specific decisions. The Game Studio
template is the authoritative source for host-game workflow, skills, and studio
process only.

| Decision type | Authoritative source |
|--------------|----------------------|
| Layer boundaries, package structure, asmdefs | YJackCore `AGENTS.md` and architecture docs |
| Compile symbols, optional modules | YJackCore `AGENTS.md` and nearest subtree docs |
| ScriptableObject/event patterns | YJackCore skill families |
| Editor tooling, Odin Inspector usage | YJackCore editor docs |
| Host-game scene/prefab wiring | Game Studio + YJackCore layer guidance |
| Generic Unity engine/API | Game Studio `unity-specialist` |
| Studio workflow, sprints, GDDs | Game Studio skills and templates |

When a decision spans both authorities (e.g. a host-game feature that needs a
new framework entry point), follow the collaboration protocol:
1. Confirm whether the change is host-only or requires a framework change.
2. If host-only, use YJackCore layer surfaces and the Game Studio workflow.
3. If a framework change is required, context-switch to the YJackCore package
   path, follow its own instructions, and propose the change separately.

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

## Manual Unity Validation Expectations

The following steps **cannot** be autonomously confirmed by any agent and must
be escalated to the owner for manual execution:

- **Domain reload** — required after any assembly definition (`.asmdef`) or
  package change; Unity must complete the domain reload before subsequent
  compile-symbol branches are reliable.
- **Play Mode smoke test** — verify scene and prefab wiring in Play Mode after
  any structural change to a prefab, scene, or bootstrap manager.
- **Package Manager resolution** — confirm `Packages/packages-lock.json` is
  consistent and the installed package version matches the intended version.
- **Compile-symbol verification** — check that `#if YJACK_*` branches compile
  correctly with and without the optional module installed.
- **Inspector serialization** — visually confirm Odin-serialized fields appear
  correctly in the Unity Inspector window after a domain reload.
- **Asset `.meta` integrity** — ensure `.meta` files are present and consistent
  after any package layout change (submodule update, path change, etc.).

Always surface the relevant items from this list before closing a task that
touches `Packages/**`, `.asmdef` files, or compile symbols.

## Setup Checklist

When configuring a project for YJackCore:

- Set engine to Unity and language to C#
- Record YJackCore in `.claude/docs/technical-preferences.md`
- Record the package source: UPM git URL, local path, or submodule path
- Place `.yjack-workspace.json` at the Unity project root (copy from
  `.agents/docs/templates/yjack-workspace.json` and fill in `layout`,
  `version`, `unityVersion`, and `packageRoot`)
- Add YJackCore and Odin Inspector to allowed libraries only when actually used
- Route framework architecture questions through YJackCore guidance plus the
  Unity specialist, in that order
- Keep engine reference docs pinned to the Unity version used by the host project
