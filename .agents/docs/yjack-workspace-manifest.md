# YJack Workspace Manifest Specification

This document specifies `.yjack-workspace.json` — the bridge between a game
repository, YJackGameStudio, and YJackCore.

## Purpose

When a game repo contains `.yjack-workspace.json`, agents know:

- Which YJackCore package source is authoritative.
- Which zones (game repo vs. framework package) each agent may write to.
- What manual Unity validation is required before any work is considered complete.

**If `.yjack-workspace.json` exists in the repo root, agents MUST read it before
reading `Packages/manifest.json` or `Packages/com.ygamedev.yjack/package.json`.**

## File Location

```
<game-repo-root>/.yjack-workspace.json
```

## Full Schema

```json
{
  "framework": "YJackCore",
  "frameworkPackage": "com.ygamedev.yjack",
  "source": "upm",
  "packagePath": "Packages/com.ygamedev.yjack",
  "unityVersion": "6000.0",
  "authoringMode": "low-code",
  "allowedAgentActions": {
    "gameRepo": ["docs", "prefabs", "scenes", "scripts", "assets"],
    "frameworkPackage": ["read-only-by-default"]
  },
  "manualValidation": [
    "Unity import",
    "domain reload",
    "Play Mode",
    "scene/prefab wiring"
  ]
}
```

## Field Definitions

### `framework`

The framework name. Currently only `"YJackCore"` is defined. Set to `null` or
omit if the project does not use a framework.

### `frameworkPackage`

The Unity Package Manager package name. For YJackCore: `"com.ygamedev.yjack"`.

### `source`

How the framework package is included in this project.

| Value | Meaning |
|-------|---------|
| `upm` | Installed via UPM git URL in `Packages/manifest.json` |
| `sibling` | Local package in a sibling directory (outside this repo) |
| `submodule` | Git submodule inside this repo |
| `vendor` | Vendored copy inside `Packages/` |
| `inline` | Inlined directly (not a separate package; unusual) |

### `packagePath`

The path to the framework package root, relative to the game repo root.
Used for:

- Detecting which files are framework files (and therefore read-only by default).
- Routing architecture questions to the correct source of truth.

Examples:
- `"Packages/com.ygamedev.yjack"` (UPM or vendor)
- `"../YJackCore"` (sibling checkout)
- `"Packages/YJackCore"` (submodule)

### `unityVersion`

The Unity Editor version string this project targets. Agents use this to scope
engine reference docs. Example: `"6000.0"`.

### `authoringMode`

Preferred authoring style for game-repo work.

| Value | Meaning |
|-------|---------|
| `low-code` | Prefer ScriptableObjects, UnityEvents, prefabs, Visual Scripting. Custom code only where needed. |
| `code-first` | Custom C# is the primary authoring surface. YJackCore surfaces used as APIs. |

Default when absent: `"low-code"`.

### `allowedAgentActions`

Declares what agents may do per zone without additional owner authorization.

```json
"allowedAgentActions": {
  "gameRepo": ["docs", "prefabs", "scenes", "scripts", "assets"],
  "frameworkPackage": ["read-only-by-default"]
}
```

- `"gameRepo"` — the host game's files (outside `packagePath`).
- `"frameworkPackage"` — the YJackCore package files at `packagePath`.

Valid action values for `gameRepo`:

| Value | What It Permits |
|-------|----------------|
| `docs` | Write to `docs/`, `design/`, markdown files |
| `prefabs` | Write to prefab files in `Assets/` |
| `scenes` | Write to scene files (use with care; scene wiring is manual-validation debt) |
| `scripts` | Write to `src/`, `Assets/Scripts/` |
| `assets` | Write to art, audio, data assets |

Valid action values for `frameworkPackage`:

| Value | What It Permits |
|-------|----------------|
| `read-only-by-default` | Agents may read; writes require explicit owner approval |
| `framework-author` | Owner has authorized framework changes (set only when intentionally extending YJackCore) |

### `manualValidation`

A list of manual validation steps that apply to all work on this project. These
are in addition to any validation listed in individual work contracts.

Common values:

| Value | Meaning |
|-------|---------|
| `"Unity import"` | Package must be re-imported cleanly in Unity |
| `"domain reload"` | No compile errors after domain reload |
| `"Play Mode"` | Runtime behavior verified in Play Mode |
| `"scene/prefab wiring"` | Component references and prefab connections verified by hand |
| `"build"` | Clean build for target platform |

## Minimal Example (UPM Package)

```json
{
  "framework": "YJackCore",
  "frameworkPackage": "com.ygamedev.yjack",
  "source": "upm",
  "packagePath": "Packages/com.ygamedev.yjack",
  "unityVersion": "6000.0",
  "authoringMode": "low-code",
  "allowedAgentActions": {
    "gameRepo": ["docs", "prefabs", "scenes", "scripts", "assets"],
    "frameworkPackage": ["read-only-by-default"]
  },
  "manualValidation": [
    "Unity import",
    "domain reload",
    "Play Mode",
    "scene/prefab wiring"
  ]
}
```

## Sibling Checkout Example

```json
{
  "framework": "YJackCore",
  "frameworkPackage": "com.ygamedev.yjack",
  "source": "sibling",
  "packagePath": "../YJackCore",
  "unityVersion": "6000.0",
  "authoringMode": "low-code",
  "allowedAgentActions": {
    "gameRepo": ["docs", "scripts", "assets"],
    "frameworkPackage": ["read-only-by-default"]
  },
  "manualValidation": [
    "Unity import",
    "domain reload",
    "Play Mode",
    "scene/prefab wiring"
  ]
}
```

## Agent Reading Rules

1. If `.yjack-workspace.json` exists, read it **first** before `Packages/manifest.json`.
2. Use `packagePath` to determine the boundary between game-repo files and
   framework files.
3. Apply `allowedAgentActions.frameworkPackage` as the default permission for
   all paths under `packagePath`.
4. Add all `manualValidation` entries to the work contract's
   `manual_validation_required` field.
5. If `source` is `sibling`, the framework package is outside this repo — do not
   commit framework changes from this repo's git history.

## When This File Is Absent

If `.yjack-workspace.json` does not exist:

- The project is either not using YJackCore, or YJackCore detection is via
  `Packages/manifest.json` or `technical-preferences.md`.
- Apply YJackCore rules if detected by any other signal (see
  `.agents/docs/yjackcore-authority.md`).
- Default `authoringMode` is `low-code`.
- Default `frameworkPackage` permission is `read-only-by-default`.
