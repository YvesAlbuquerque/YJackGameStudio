# YJackCore Support

Use this document when a Unity project consumes the YJackCore package or when
the user asks this template to adapt to YJackCore rules.

## Detection

Treat a project as YJackCore-backed if any of these are true:

- `.yjack-workspace.json` exists in the Unity project root
- `Packages/manifest.json` contains `com.ygamedev.yjack` or `YJackCore`
- a local package exists at `Packages/YJackCore/package.json`
- a git submodule path points to `YJackCore`
- `.agents/docs/technical-preferences.md` lists `Framework: YJackCore`
- technical preferences name a YJackCore package source, local path, or submodule
- the user explicitly says the game uses YJackCore

Check for `.yjack-workspace.json` first; it is the most reliable and explicit
signal. A sibling checkout such as `../YJackCore` may be used as reference
material only after confirming it is the intended framework source or the
closest available local YJackCore repo.

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

## Framework vs Product Authority

YJackCore is a reusable framework package. The game built on top of it is the
product. These are separate ownership boundaries with different governing
authorities.

**Framework authority (YJackCore):**
- YJackCore's own `AGENTS.md` and `.agents/skills/` take precedence over the
  Game Studio generic Unity specialist for all YJackCore-specific decisions.
- Package internals (`Packages/YJackCore/**`, `Packages/com.ygamedev.yjack/**`)
  are governed by YJackCore's own guidance, not the host game's rules.
- Framework architecture, layer ownership, compile symbols, asmdef boundaries,
  and ScriptableObject/event patterns are YJackCore authority.

**Product authority (host game):**
- Host-game code in `src/` is the product. The Game Studio's own rules and the
  unity-specialist agent govern host-game decisions.
- The product may wire to YJackCore layers but must not alter framework internals
  except through an explicit framework-change workflow.
- GDDs, stories, and architecture decisions for the product are owned by the
  game studio, not by the YJackCore package maintainer.

**Decision routing:**
1. Task about framework internals? → YJackCore authority. Read its `AGENTS.md`
   and `.agents/skills/` first.
2. Task about host-game code integrating YJackCore? → Product authority, but
   read this file first to select the correct YJackCore layer.
3. Task about generic Unity APIs unrelated to YJackCore layers? → Use the Game
   Studio unity-specialist directly.

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

## Workspace Manifest

A `.yjack-workspace.json` file in the Unity project root tells agents which
YJackCore layout is in use and where to find YJackCore's own guidance assets.
Check for this file before checking `Packages/manifest.json` or scanning for
`package.json` files; when it exists, it is the authoritative source for layout
and path resolution.

A template is available at `.agents/docs/templates/yjack-workspace.json`.
Copy it to your Unity project root and configure the fields for your layout.

### Manifest Fields

| Field | Purpose |
| ----- | ------- |
| `packageId` | Unity package name; must be `com.ygamedev.yjack` |
| `version` | Installed package version |
| `unity` | Unity version the project targets (e.g., `6000.0`) |
| `layout` | Layout type: `upm`, `sibling`, `submodule`, `vendor`, or `inline` |
| `packagePath` | Path where Unity resolves the package, relative to project root |
| `sourcePath` | Path to YJackCore source where `AGENTS.md` lives; `null` if not locally available |
| `upmSource` | UPM git URL or file reference; used with `upm` and `sibling` layouts |
| `agentEntryPoint` | Override path to `AGENTS.md`; defaults to `<sourcePath>/AGENTS.md` |
| `agentSkillsPath` | Override path to `.agents/skills/`; defaults to `<sourcePath>/.agents/skills` |

### Layout Examples

**UPM** — Package resolved by Unity Package Manager from a git URL. No local
source available for agent guidance; fall back to this file.

```json
{
  "yjack": {
    "packageId": "com.ygamedev.yjack",
    "version": "1.6.0",
    "unity": "6000.0",
    "layout": "upm",
    "packagePath": "Packages/com.ygamedev.yjack",
    "sourcePath": null,
    "upmSource": "https://github.com/YGameDev/YJackCore.git#v1.6.0",
    "agentEntryPoint": null,
    "agentSkillsPath": null
  }
}
```

**Sibling checkout** — YJackCore checked out as a sibling directory alongside
the Unity project. Useful during active framework development.

```json
{
  "yjack": {
    "packageId": "com.ygamedev.yjack",
    "version": "1.6.0",
    "unity": "6000.0",
    "layout": "sibling",
    "packagePath": "Packages/com.ygamedev.yjack",
    "sourcePath": "../YJackCore",
    "upmSource": "file:../YJackCore",
    "agentEntryPoint": "../YJackCore/AGENTS.md",
    "agentSkillsPath": "../YJackCore/.agents/skills"
  }
}
```

**Submodule** — YJackCore added as a git submodule under `Packages/`.

```json
{
  "yjack": {
    "packageId": "com.ygamedev.yjack",
    "version": "1.6.0",
    "unity": "6000.0",
    "layout": "submodule",
    "packagePath": "Packages/YJackCore",
    "sourcePath": "Packages/YJackCore",
    "upmSource": null,
    "agentEntryPoint": "Packages/YJackCore/AGENTS.md",
    "agentSkillsPath": "Packages/YJackCore/.agents/skills"
  }
}
```

**Vendor** — YJackCore source copied directly into `Packages/com.ygamedev.yjack/`.

```json
{
  "yjack": {
    "packageId": "com.ygamedev.yjack",
    "version": "1.6.0",
    "unity": "6000.0",
    "layout": "vendor",
    "packagePath": "Packages/com.ygamedev.yjack",
    "sourcePath": "Packages/com.ygamedev.yjack",
    "upmSource": null,
    "agentEntryPoint": "Packages/com.ygamedev.yjack/AGENTS.md",
    "agentSkillsPath": "Packages/com.ygamedev.yjack/.agents/skills"
  }
}
```

**Inline** — YJackCore embedded directly inside the `Assets/` folder, outside
the normal `Packages/` tree. Use sparingly; prefer `Packages/` layouts.

```json
{
  "yjack": {
    "packageId": "com.ygamedev.yjack",
    "version": "1.6.0",
    "unity": "6000.0",
    "layout": "inline",
    "packagePath": "Assets/YJackCore",
    "sourcePath": "Assets/YJackCore",
    "upmSource": null,
    "agentEntryPoint": "Assets/YJackCore/AGENTS.md",
    "agentSkillsPath": "Assets/YJackCore/.agents/skills"
  }
}
```

### Path Resolution Order

When resolving where to find YJackCore guidance assets:

1. Read `.yjack-workspace.json` if present in the project root.
2. Use `agentEntryPoint` if non-null; otherwise `<sourcePath>/AGENTS.md`.
3. Use `agentSkillsPath` if non-null; otherwise `<sourcePath>/.agents/skills`.
4. If `sourcePath` is `null` (UPM layout or manifest absent), fall back to this
   document and the Game Studio unity-specialist.

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

The Unity Editor must be used directly for many YJackCore-related validations.
The steps below cannot be autonomously confirmed and must be escalated to the
owner when they are required by a task.

### Always Requires Manual Validation

- **Domain reload** — assembly compilation errors after changing asmdefs, compile
  symbols, or package references
- **Prefab wiring** — serialized field linkage, nested-prefab overrides, and
  prefab variants
- **Scene composition** — layer manager references, UnityEvent wiring between
  GameObjects, and scene-level ScriptableObject assignments
- **Play Mode behavior** — runtime initialization order, event flow, and
  YJackCore manager lifecycle
- **Package Manager steps** — installing, updating, or removing the YJackCore
  package via the Unity Package Manager window
- **Inspector-driven setup** — any authoring step that requires clicking in the
  Unity Inspector (Odin Inspector groups, buttons, custom drawers)
- **Addressable labels and asset groups** — if the project uses Addressables
- **Build verification** — final IL2CPP or Mono build with all modules included

### Automation Boundary

Automated tests (Unity Test Runner, NUnit) can validate:

- Pure C# logic that does not require a scene or domain reload
- ScriptableObject asset state in Edit Mode tests
- Layer-boundary contracts that can be tested without runtime manager startup

Report the automation/manual boundary explicitly in every task that touches
YJackCore runtime wiring.

## Setup Checklist

When configuring a project for YJackCore:

- Set engine to Unity and language to C#
- Record YJackCore in `.agents/docs/technical-preferences.md` (Framework section)
- Record the package source: UPM git URL, local path, or submodule path
- Copy `.agents/docs/templates/yjack-workspace.json` to the Unity project root
  and set `layout`, `packagePath`, `sourcePath`, and related fields
- Add YJackCore and Odin Inspector to allowed libraries only when actually used
- Route framework architecture questions through YJackCore guidance plus the
  Unity specialist, in that order
- Keep engine reference docs pinned to the Unity version used by the host project
