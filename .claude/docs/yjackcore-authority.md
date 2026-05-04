# YJackCore Consumer Authority and Workspace Routing

This document defines the authority hierarchy, task routing rules, workspace
manifest contract, and manual validation expectations for Unity projects that
consume YJackCore (`com.ygamedev.yjack`, version 1.6.0, Unity 6000.0).

Read this document alongside `.claude/docs/yjackcore-support.md` and
`.claude/rules/yjackcore-unity.md` for the full YJackCore guidance set.

---

## Authority Hierarchy

When a task touches a YJackCore-backed project, agents must apply guidance in
this order. A higher-authority source overrides a lower one on any point that
conflicts.

1. **YJackCore's own repository guidance** (highest authority)
   - YJackCore `AGENTS.md`
   - `.ai/AI_ARCHITECTURE.md`
   - `package.json`, `ARCHITECTURE.md`
   - `Docs/Workflow/framework-vision.md`, `Docs/index.md`
   - Nearest subtree `AGENTS.md` and closest `.agents/skills/*/SKILL.md`
   - Relevant `.ai/contexts/*` or `.ai/commands/*` workflows

2. **Game Studio YJackCore guidance** (framework-consumer fallback)
   - `.claude/docs/yjackcore-authority.md` ← this file
   - `.claude/docs/yjackcore-support.md`
   - `.claude/rules/yjackcore-unity.md`

3. **Game Studio generic Unity specialist** (engine fallback)
   - `.claude/agents/unity-specialist.md`
   - Generic Unity engine/API behavior, subsystem choices, profiling,
     rendering, input, UI, Addressables, and host-project integration

**Rule:** The YJackCore repository knows more about its own framework than this
Game Studio template. When its docs and these docs conflict, its docs win.
Use the Game Studio layer only when YJackCore-specific assets are absent.

---

## Framework-vs-Product Boundary

| Concern | Owner |
| ------- | ----- |
| Framework layer design (GameLayer, LevelLayer, PlayerLayer, ViewLayer, Shared) | YJackCore |
| Package structure, `.asmdef` wiring, compile symbols | YJackCore |
| Inspector-first authoring model, Odin ergonomics, ScriptableObject patterns | YJackCore |
| Editor tooling, package manager integration | YJackCore |
| Host-game scene composition using YJackCore surfaces | Game (host) |
| Host-game gameplay logic that calls YJackCore entry points | Game (host) |
| Game-specific GDDs, systems, balance, narrative | Game (host) |
| Generic Unity engine API, rendering, input, physics, Addressables | Unity specialist |

Agents must not blur these boundaries. A host-game story should use YJackCore
surfaces; it must not rewrite or bypass them. If a needed YJackCore surface
does not exist, propose a framework change rather than duplicating framework
behavior in `src/`.

---

## Workspace Routing

### Path-Based Routing

When an agent task touches a file in any of the paths below, it must load
YJackCore guidance before acting:

| Path Pattern | Routing |
| ------------ | ------- |
| `Packages/YJackCore/**` | Read YJackCore repo guidance first; this file as fallback |
| `Packages/com.ygamedev.yjack/**` | Same as above |
| `src/**` (YJackCore project) | Read YJackCore layer map; use unity-specialist for engine API |
| `design/**` (YJackCore project) | Call out owning YJackCore layer in every GDD |

A project is considered YJackCore-backed when any of these are true:
- `Packages/manifest.json` contains `com.ygamedev.yjack` or `YJackCore`
- A local package exists at `Packages/YJackCore/package.json`
- A git submodule path points to `YJackCore`
- `.claude/docs/technical-preferences.md` contains `- **Framework**: YJackCore`
- `.yjack-workspace.json` is present at the project root

### Task Routing Decision Tree

```
Is the task YJackCore-related?
├── No  → Use the standard Game Studio Unity specialist path
└── Yes → Is there a local YJackCore package or checkout?
          ├── Yes → Read YJackCore repo guidance first (authority level 1)
          │         Fall back to this file only for gaps
          └── No  → Use this file + yjackcore-support.md (authority level 2)
                    Fall back to the generic Unity specialist for engine API
```

### Workspace Manifest

A `.yjack-workspace.json` file at the project root tells agents where YJackCore
lives in this workspace, how it was installed, and what version is in use. This
removes guesswork about package layout.

See `.claude/docs/templates/yjack-workspace.json` for annotated layout examples
covering UPM, sibling checkout, submodule, vendor, and inline layouts.

**Manifest fields:**

| Field | Required | Description |
| ----- | -------- | ----------- |
| `layout` | Yes | Installation layout: `upm`, `sibling`, `submodule`, `vendor`, `inline` |
| `packageName` | Yes | UPM package name: `com.ygamedev.yjack` |
| `version` | Yes | Installed version, e.g. `1.6.0` |
| `unityVersion` | Yes | Host project Unity version, e.g. `6000.0` |
| `packagePath` | No | Relative path to the `package.json` root (omit for pure UPM) |
| `sourcePath` | No | Relative path to source root when doing a sibling/submodule checkout |
| `upmUrl` | No | UPM git URL when `layout` is `upm` |
| `agentsPath` | No | Relative path to YJackCore `.agents/` when available locally |
| `modules` | No | Array of active compile-symbol modules, e.g. `["GameLayer", "ViewLayer"]` |
| `notes` | No | Free-text notes for human readers |

Agents must read `.yjack-workspace.json` before reading `Packages/manifest.json`
when both are available. The manifest always wins on layout and path resolution.

---

## Manual Unity Validation Expectations

Agents cannot run the Unity Editor. The following validations always require
manual owner confirmation before a story can be marked Done:

| Validation Type | Why Autonomous Confirmation Is Impossible |
| --------------- | ----------------------------------------- |
| Domain reload (script compilation) | Requires Unity Editor with project loaded |
| Play Mode behavior and scene wiring | Requires Unity Play Mode execution |
| Package Manager resolution | Requires UPM resolver inside the Editor |
| Compile symbol branches | Requires Editor build with module flags |
| Odin Inspector rendering | Requires Editor with Odin installed |
| `.meta` file integrity | Risk of Unity re-importing and breaking references |
| Asset database refresh | Requires Editor asset import pipeline |
| Build (Development / Release) | Requires Unity Cloud Build or local Editor build |

When reporting on architecture-sensitive YJackCore work, always include:

- **Architecture impact**: host-only wiring, YJackCore package change, or both
- **Doc impact**: game docs only, YJackCore docs, or none
- **Manual validation still required**: list the specific validations from the
  table above that apply to this change

Agents must never claim Unity-side validation has passed unless the owner has
confirmed it explicitly.

---

## Package Boundary Integrity

YJackCore package files (`Packages/YJackCore/**` and
`Packages/com.ygamedev.yjack/**`) are framework-owner territory. Agents:

- **Must not** edit package files from a host-game task without explicit owner
  authorization.
- **Must not** add, remove, or modify `.asmdef`, `.meta`, or `package.json`
  files without reading the package's own `AGENTS.md` first.
- **Must not** bypass package boundaries by copying framework code into `src/`.
- **Should** propose YJackCore package changes as separate work items with their
  own owner approval gate.

---

## Low-Code Authoring Model Preservation

Every routing decision must preserve YJackCore's inspector-first authoring model:

- Prefer serialized `UnityEvent`, `ScriptableObject` assets, prefabs, and
  Visual Scripting-friendly call-throughs over new C# bootstrap code.
- If a feature can be composed in the Inspector using existing YJackCore
  surfaces, do not write code.
- When writing host-game glue code, keep it minimal and explicitly separate
  from framework code.
- Any routing decision that forces consumers to write engine-level C# where
  the low-code path suffices is wrong.
