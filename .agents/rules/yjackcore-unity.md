---
paths:
  - "src/**"
  - "Packages/YJackCore/**"
  - "Packages/com.ygamedev.yjack/**"
  - "Assets/**"
---

# YJackCore Unity Rules (Provider-Neutral)

Apply these rules when the project uses YJackCore or the edited path is a
YJackCore package path. All agents (Claude, Codex, Gemini, Copilot, others)
must follow these rules. Claude Code agents also apply `.claude/rules/yjackcore-unity.md`.

## Authority Override

YJackCore repo docs override generic Game Studio Unity guidance. Read in order:
1. YJackCore `AGENTS.md`
2. YJackCore `package.json`
3. YJackCore `ARCHITECTURE.md`
4. YJackCore `Docs/Workflow/framework-vision.md`
5. Nearest YJackCore layer doc for the task

If a local YJackCore package or checkout is available, prefer its own
`AGENTS.md`, `.agents/skills/*`, `.ai/commands/*`, docs, package metadata,
asmdefs, and subtree instructions over this generic Game-Studio fallback.

## Package File Permission

- YJackCore package files are **read-only by default** for all agents.
- Do not edit `Packages/com.ygamedev.yjack/**` or `Packages/YJackCore/**`
  without explicit owner authorization.
- If editing package code is requested, read the package's `AGENTS.md`,
  `package.json`, `ARCHITECTURE.md`, and relevant `.asmdef` files first.
- Framework changes and game-repo changes must be classified separately in the
  work contract.

## Work Classification (Required)

Before writing any code, classify the work:
- `game-repo-work` — changes only in the host game
- `framework-work` — changes in the YJackCore package (owner must authorize)
- `both` — requires separate authorization for the framework portion

## Low-Code Preference

Before writing custom C# code:
1. Check if a YJackCore prefab, ScriptableObject, or UnityEvent surface covers it.
2. Check if Visual Scripting can wire it without custom code.
3. Check if inspector-first setup (serialized fields, Odin Inspector) is sufficient.

Custom code is appropriate only when the low-code path is insufficient.

## Layer Routing

Prefer YJackCore layer surfaces before inventing new architecture:
- `GameLayer` — global startup, save/load, scene transitions, settings
- `LevelLayer` / `SceneLayer` — level flow, win/loss, quests, inventory
- `PlayerLayer` / `CoreLayer` — input, camera, player-facing runtime
- `ViewLayer` — HUD, popups, menus, loading screens, presentation
- `Shared` — reusable ScriptableObject, events, utilities, primitives

Keep host-game glue small. If glue grows into reusable framework behavior,
propose a YJackCore change rather than burying it in `src/`.

- Prefer inspector-first authoring: serialized fields, UnityEvents,
  ScriptableObject assets, prefabs, Odin-driven inspector ergonomics, and Visual
  Scripting-friendly entry points.
- Treat Unity-module-backed compile-symbol paths as the primary path when the
  module is installed; bare paths are compatibility fallbacks.
- Do not edit YJackCore package files casually. Preserve package boundaries,
  `.asmdef` dependencies, Unity asset `.meta` files, and submodule/package
  integrity.

## Manual Validation Debt

Unity manual validation is always required and cannot be done autonomously.
Report honestly in every work contract and validation evidence packet:
- Unity import (package resolution, `.meta` regeneration)
- Domain reload (no compile errors)
- Play Mode (runtime behavior)
- Scene/prefab wiring (component references valid)

Do not claim any of the above are done unless actually run.

## Reporting

For architecture-sensitive YJackCore work, always include:
- **Architecture impact**: host-only wiring, YJackCore package change, or both
- **Doc impact**: game docs only, YJackCore docs, or none
- **Manual validation still required**: list all outstanding Unity checks
