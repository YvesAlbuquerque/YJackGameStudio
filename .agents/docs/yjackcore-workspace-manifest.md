# YJackCore Workspace Manifest

The `.yjack-workspace.json` file is an optional manifest placed at the **Unity
project root**. It tells agents and tools exactly where the YJackCore package
lives, which authority rules apply, and what must be manually validated.

## When to Use

Place this file if:

- The project uses YJackCore and agents need to resolve the package path
  automatically (sibling checkout, submodule, or vendor layouts especially).
- You want to lock in the authority routing so no agent has to infer it from
  `Packages/manifest.json` or file-system heuristics.
- You want to pin the YJackCore version and Unity version for this project.

UPM-managed packages resolve through Unity's normal `Packages/` resolution;
the manifest is still useful for documenting authority intent and manual
validation requirements.

## Schema

| Field | Type | Required | Description |
|-------|------|----------|-------------|
| `packageId` | string | yes | Always `"com.ygamedev.yjack"` |
| `version` | string | yes | Semver of the YJackCore release in use |
| `unityVersion` | string | yes | Unity Editor version (e.g. `"6000.0"`) |
| `layout` | string | yes | One of: `upm`, `sibling`, `submodule`, `vendor`, `inline` |
| `packageRoot` | string\|null | conditional | Relative path from project root to the YJackCore package folder. Required for `sibling`, `submodule`, `vendor`, and `inline` layouts. `null` for `upm`. |
| `agentReadOrder` | string[] | no | Ordered list of files inside `packageRoot` that agents should read before proposing framework architecture. Defaults to standard reading order if omitted. |
| `authorityNotes` | string | no | Free-text reminder of which authority governs YJackCore decisions. |
| `manualValidationRequired` | string[] | no | Steps that cannot be autonomously confirmed and must be escalated to the owner. |

## Layout Values

### `upm`

YJackCore is installed via Unity Package Manager from a git URL or registry.
The package is resolved into the project-local `Library/PackageCache/` folder.
Agents should not attempt to read or modify files inside `Library/`.

```json
{
  "packageId": "com.ygamedev.yjack",
  "version": "1.6.0",
  "unityVersion": "6000.0",
  "layout": "upm",
  "packageRoot": null
}
```

Detection heuristic: `Packages/manifest.json` contains `com.ygamedev.yjack`
with a git URL or registry reference, and no local `Packages/YJackCore/` or
`Packages/com.ygamedev.yjack/` folder is present.

For `upm` layouts, omit `agentReadOrder` — package source files are resolved
into `Library/PackageCache/` which agents must not read. If you also have a
sibling checkout of the YJackCore source for reference, add a `sibling` entry
instead.

### `sibling`

YJackCore is checked out as a sibling directory alongside the Unity project root.
The `packageRoot` is expressed relative to the project root using `..`.

```json
{
  "packageId": "com.ygamedev.yjack",
  "version": "1.6.0",
  "unityVersion": "6000.0",
  "layout": "sibling",
  "packageRoot": "../YJackCore"
}
```

Detection heuristic: a directory at `../YJackCore` contains `package.json` with
name `com.ygamedev.yjack`, and `Packages/manifest.json` references it as a local
path (`"file:../YJackCore"` or similar).

### `submodule`

YJackCore is embedded as a git submodule. The submodule is typically registered
under `Packages/` so Unity treats it as a local package.

```json
{
  "packageId": "com.ygamedev.yjack",
  "version": "1.6.0",
  "unityVersion": "6000.0",
  "layout": "submodule",
  "packageRoot": "Packages/com.ygamedev.yjack"
}
```

Detection heuristic: `.gitmodules` contains a path matching
`Packages/YJackCore` or `Packages/com.ygamedev.yjack`, and a `package.json`
exists there.

### `vendor`

YJackCore source is copied directly into a `vendor/` or similar directory and
referenced as a local UPM path. The package is not a live git submodule.

```json
{
  "packageId": "com.ygamedev.yjack",
  "version": "1.6.0",
  "unityVersion": "6000.0",
  "layout": "vendor",
  "packageRoot": "vendor/YJackCore"
}
```

Detection heuristic: `vendor/YJackCore/package.json` exists with name
`com.ygamedev.yjack`, and there is no `.gitmodules` entry for that path.

### `inline`

YJackCore source lives inside the main `Assets/` tree (legacy placement, not
recommended for new projects).

```json
{
  "packageId": "com.ygamedev.yjack",
  "version": "1.6.0",
  "unityVersion": "6000.0",
  "layout": "inline",
  "packageRoot": "Assets/YJackCore"
}
```

Detection heuristic: `Assets/YJackCore/` contains a `package.json` with name
`com.ygamedev.yjack` and there is no `Packages/` entry for it.

## Authority Hierarchy

When `.yjack-workspace.json` is present:

1. Read `packageRoot/<agentReadOrder>` files (if `packageRoot` is non-null)
   before proposing any framework architecture.
2. YJackCore's own `AGENTS.md`, `.agents/skills/`, `.ai/commands/`, and nearest
   subtree `AGENTS.md` files take precedence over Game Studio generic rules for
   all YJackCore-specific decisions.
3. Game Studio `.agents/docs/yjackcore-support.md` applies as a fallback when
   the above are absent.
4. Game Studio generic Unity specialist handles engine/API behavior, rendering,
   input, UI, Addressables, and host-game integration outside the framework.
5. Do not modify files inside `packageRoot` from a host-game task without
   explicit owner authorization.

## Manual Validation Expectations

The following steps **cannot** be autonomously confirmed and must be escalated
to the owner:

- Unity Editor domain reload after any package or assembly change
- Play Mode smoke test for scene and prefab wiring
- Package Manager resolution and lock-file consistency check
- Compile-symbol verification (`#if YJACK_*` branches)
- Odin Inspector serialization visible in the Unity Inspector window
- Asset `.meta` file consistency after layout changes

Add project-specific steps to the `manualValidationRequired` array in the
manifest.

## Agent Behavior

Agents that detect or read this manifest must:

1. Resolve `packageRoot` relative to the Unity project root (not the repo root
   if they differ).
2. For `upm` layout, treat `Packages/manifest.json` and the UPM lock file as
   the source of truth for the installed version; do not assume source is
   locally accessible.
3. Before proposing changes to framework code, confirm the task scope is
   host-game only. If framework changes are needed, switch context to the
   YJackCore repository/package path and follow its own instructions.
4. Surface all items in `manualValidationRequired` in the response before
   closing a task that touches package paths or compile symbols.
