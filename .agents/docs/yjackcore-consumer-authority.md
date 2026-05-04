# YJackCore Consumer Authority and Workspace Routing

This document defines:

- the authority hierarchy for Game Studio projects that consume YJackCore
- how agents route Unity + YJackCore tasks to the correct guidance layer
- the `.yjack-workspace.json` manifest contract for path resolution
- manual Unity validation expectations that agents must never claim to satisfy

Aligned with: `com.ygamedev.yjack` version 1.6.0, Unity 6000.0,
inspector-first authoring model.

---

## 1. Framework-vs-Product Authority

Three distinct authority layers apply to a YJackCore-backed Game Studio project.
Each task must be mapped to the correct layer before proposing changes.

### 1a. Framework Authority — YJackCore

**Scope**: Anything inside the YJackCore package itself.

**Paths governed**: `Packages/com.ygamedev.yjack/**`, `Packages/YJackCore/**`

**Primary sources** (read in this order when available locally):
1. `AGENTS.md` at the YJackCore package root
2. `.ai/AI_ARCHITECTURE.md` (AI workflow and specialist routing)
3. `package.json` (version, dependencies, module flags)
4. `ARCHITECTURE.md`
5. `Docs/Workflow/framework-vision.md`
6. `Docs/index.md`
7. Nearest layer doc for the task
8. Nearest subtree `AGENTS.md`
9. Closest `.agents/skills/*/SKILL.md`

**Rule**: YJackCore's own guidance beats this Game Studio file for all
framework-layer decisions. If a local YJackCore checkout or package is
available, read its docs before proposing architecture.

**Hard constraint**: Agents must never modify YJackCore package files during
a host-game task unless the user explicitly asks to change the framework.
When editing package code is requested, follow the package's own instructions
for boundary compliance, asmdef rules, and `.meta` integrity.

### 1b. Product Authority — Game Studio host game

**Scope**: Everything outside the YJackCore package — the game itself.

**Paths governed**: `src/**`, `Assets/**` (non-package), `design/**`,
`docs/**`, `production/**`

**Primary sources**: This Game Studio template — docs, skills, rules, and
`technical-preferences.md`.

**YJackCore constraint**: When host-game code integrates with YJackCore,
read `.agents/docs/yjackcore-support.md` before proposing managers, wrappers,
or bootstrap systems. Map all host features to the closest YJackCore layer
rather than inventing parallel abstractions.

### 1c. Engine Authority — Unity

**Scope**: Generic Unity engine/API questions not specific to YJackCore.

**Examples**: rendering pipeline, Addressables, Input System, UGUI vs UI
Toolkit, DOTS/ECS, platform builds, package manager (non-YJackCore).

**Primary source**: `unity-specialist` agent.

**Fallback rule**: Use the `unity-specialist` only after YJackCore guidance
has been consulted for any feature that touches the framework layer.

---

## 2. Workspace Routing Rules

### 2a. Task classification

Before acting on a Unity + YJackCore task, classify it:

| Task touches… | Route to… |
|---|---|
| `Packages/com.ygamedev.yjack/**` or `Packages/YJackCore/**` | YJackCore framework authority (§1a) |
| `src/**` or `Assets/**` and YJackCore is active | `.agents/docs/yjackcore-support.md` rules + unity-specialist fallback (§1b) |
| Design docs, GDDs, stories | Game Studio design system + YJackCore layer map |
| Generic Unity API with no YJackCore surface | unity-specialist (§1c) |

### 2b. Detection order

Treat a project as YJackCore-backed if any of the following are true (checked
in this order):

1. `.yjack-workspace.json` is present at the project root — read it first
   to discover layout and local paths (see §3)
2. `Packages/manifest.json` contains `com.ygamedev.yjack` or `YJackCore`
3. A local package exists at `Packages/YJackCore/package.json`
4. A local package exists at `Packages/com.ygamedev.yjack/package.json`
5. A git submodule path points to `YJackCore`
6. `.agents/docs/technical-preferences.md` lists `Framework: YJackCore`
7. The user explicitly states the project uses YJackCore

A sibling checkout at `../YJackCore` is reference material only; confirm it
is the intended source before treating it as authoritative.

### 2c. YJackCore specialist precedence chain

When a task is classified as YJackCore-relevant, agents must follow this chain:

```
1. Local YJackCore package/checkout AGENTS.md and docs   ← highest priority
2. .agents/docs/yjackcore-support.md (this repo's support doc)
3. .agents/rules/yjackcore-unity.md (path-scope rules)
4. unity-specialist (generic Unity engine fallback)        ← lowest priority
```

Never skip directly to `unity-specialist` for decisions about layer ownership,
prefab wiring, ScriptableObject patterns, or compile symbols.

---

## 3. Workspace Manifest — `.yjack-workspace.json`

The optional `.yjack-workspace.json` file, placed at the project root, tells
agents precisely where YJackCore lives. It is the single source of truth for
path resolution when the layout is non-trivial (not a plain UPM entry in
`Packages/manifest.json`).

### 3a. Schema

```jsonc
{
  // One of: "upm" | "sibling" | "submodule" | "vendor" | "inline"
  "layout": "submodule",

  // Official UPM package name — must match package.json "name"
  "packageName": "com.ygamedev.yjack",

  // Installed version — match against package.json "version"
  "version": "1.6.0",

  // Unity editor version used by the host project
  "unityVersion": "6000.0",

  // Path to the package root, relative to the project root.
  // Omit for "upm" layout (package is immutable; no local edit path).
  "packagePath": "Packages/com.ygamedev.yjack",

  // Path to YJackCore's AGENTS.md, relative to project root.
  // Agents read this before proposing framework changes.
  // Omit for "upm" layout.
  "agentsPath": "Packages/com.ygamedev.yjack/AGENTS.md",

  // UPM git URL or registry entry. Required for "upm" layout only.
  "upmSource": "",

  // Sibling directory path, relative to project root.
  // Required for "sibling" layout only.
  "siblingPath": "",

  // Additional notes visible to agents — layout quirks, known constraints.
  "notes": ""
}
```

### 3b. Layout examples

#### UPM (Unity Package Manager git URL)

The package is fetched by Unity and lives in the package cache. It is
read-only from the agent's perspective. Agents must not propose edits to
package internals.

```json
{
  "layout": "upm",
  "packageName": "com.ygamedev.yjack",
  "version": "1.6.0",
  "unityVersion": "6000.0",
  "upmSource": "https://github.com/YvesAlbuquerque/YJackCore.git#v1.6.0",
  "notes": "Package is managed by UPM. Do not edit package internals."
}
```

#### Sibling checkout

YJackCore is checked out alongside the project (e.g., in a workspace with
both repos side by side). It is reference material; path resolution uses the
relative path.

```json
{
  "layout": "sibling",
  "packageName": "com.ygamedev.yjack",
  "version": "1.6.0",
  "unityVersion": "6000.0",
  "siblingPath": "../YJackCore",
  "agentsPath": "../YJackCore/AGENTS.md",
  "notes": "Sibling checkout used as reference. Confirm with owner before treating as editable."
}
```

#### Git submodule

YJackCore is a git submodule pinned under `Packages/`. The package is locally
editable only with explicit owner authorization.

```json
{
  "layout": "submodule",
  "packageName": "com.ygamedev.yjack",
  "version": "1.6.0",
  "unityVersion": "6000.0",
  "packagePath": "Packages/com.ygamedev.yjack",
  "agentsPath": "Packages/com.ygamedev.yjack/AGENTS.md",
  "notes": "Git submodule. Do not modify without owner authorization."
}
```

#### Vendor (local copy)

A specific YJackCore version has been copied or extracted into `Packages/`.
The vendored copy does not receive automatic updates.

```json
{
  "layout": "vendor",
  "packageName": "com.ygamedev.yjack",
  "version": "1.6.0",
  "unityVersion": "6000.0",
  "packagePath": "Packages/com.ygamedev.yjack",
  "agentsPath": "Packages/com.ygamedev.yjack/AGENTS.md",
  "notes": "Vendored copy. Check version before proposing framework changes."
}
```

#### Inline (monorepo)

YJackCore source lives inside the same repository (e.g., a monorepo or a
game that ships the framework as part of its own tree).

```json
{
  "layout": "inline",
  "packageName": "com.ygamedev.yjack",
  "version": "1.6.0",
  "unityVersion": "6000.0",
  "packagePath": "Packages/com.ygamedev.yjack",
  "agentsPath": "Packages/com.ygamedev.yjack/AGENTS.md",
  "notes": "Inline monorepo layout. Framework and product share the same git root."
}
```

### 3c. Agent behavior when manifest is present

1. Read `.yjack-workspace.json` before any other YJackCore detection step.
2. Use `packagePath` to locate the package root. If `agentsPath` is present,
   read that file before proposing framework changes.
3. For `upm` layout: treat the package as immutable. Propose changes as
   "framework change needed" and surface them to the owner rather than
   attempting to edit package files.
4. For `sibling` layout: read for reference only unless the owner explicitly
   authorizes edits to the sibling repo.
5. If the manifest is absent, fall back to the detection order in §2b.

---

## 4. Manual Unity Validation Expectations

The following tasks require manual Unity Editor intervention. Agents must
never claim to have validated these items. Always surface them to the owner.

### Always manual

| Task | Reason |
|---|---|
| Domain reload and compilation | Must occur in the Unity Editor |
| Play Mode behavior tests | Require running the game in the Editor |
| Scene and prefab wiring | Inspector-driven setup cannot be confirmed from code alone |
| Package Manager resolution | UPM or submodule steps run inside Unity |
| Compile symbol verification | Requires Editor compilation with the correct module flags |
| Odin Inspector rendering | Inspector output is only visible in the Editor |
| Unity Visual Scripting graphs | Graph execution requires Editor Play Mode |
| Console errors / warnings | Only visible in the Unity Console at runtime |
| Build verification | Requires an actual platform build |
| Asset import results | Import pipeline runs inside the Editor |

### Propose but do not verify

For the following, agents may propose or draft solutions, but must mark them
as **"Manual validation still required"**:

- New asmdef dependencies (require Editor compilation to confirm)
- ScriptableObject default values (must be verified in the Inspector)
- Prefab override propagation (must be checked in the Prefab Editor)
- New compile symbol paths (require a Unity module install to confirm)
- Package version bumps (require UPM refresh inside Unity)

### Reporting format

For architecture-sensitive YJackCore work, always include:

- **Architecture impact**: host-only wiring | YJackCore package change | both
- **Doc impact**: game docs only | YJackCore docs | none
- **Manual validation still required**: list the specific items above that apply

---

## 5. Invariants

These constraints hold in all autonomy modes and cannot be overridden by agent
decisions:

1. Agents must never modify `Packages/com.ygamedev.yjack/**` or
   `Packages/YJackCore/**` without explicit owner authorization.
2. Agents must never auto-generate Unity inspector-driven data
   (ScriptableObjects, prefabs, scene state) in place of the owner doing it.
3. Agents must never claim Play Mode, build, or import validation has
   succeeded — these require the Unity Editor.
4. Agents must never skip reading YJackCore's own `AGENTS.md` before
   proposing framework-layer changes when a local copy is available.
5. Host-game glue must stay small. If glue grows into reusable framework
   behavior, propose a separate YJackCore change rather than embedding it
   in `src/`.
