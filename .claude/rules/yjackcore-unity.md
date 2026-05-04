---
paths:
  - "src/**"
  - "Packages/YJackCore/**"
  - "Packages/com.ygamedev.yjack/**"
---

# YJackCore Unity Rules

Apply these rules when the project uses YJackCore and the edited path is a
YJackCore package path or host-game source code in `src/`.

## Task Routing

Before acting on any YJackCore-related task, load guidance in this order:

1. **YJackCore's own repository guidance** (highest authority): If a local
   YJackCore package or checkout is available, read its `AGENTS.md`,
   `.ai/AI_ARCHITECTURE.md`, `package.json`, `ARCHITECTURE.md`, nearest layer
   docs, and closest `.agents/skills/*/SKILL.md` before proposing any
   framework architecture or package changes.
2. **Game Studio YJackCore guidance** (consumer fallback): Read
   `.claude/docs/yjackcore-authority.md` and `.claude/docs/yjackcore-support.md`
   when YJackCore-specific assets are absent or the task is host-game work.
3. **Generic Unity specialist** (engine fallback): Use the Game-Studio
   `unity-specialist` for generic Unity engine/API behavior, subsystem choices,
   profiling, rendering, input, UI, and Addressables.

If a `.yjack-workspace.json` is present at the project root, read it first to
resolve paths and layout before reading `Packages/manifest.json`.

## Authoring and Boundary Rules

- Prefer existing YJackCore layer surfaces before new host-game abstractions:
  GameLayer for global services, LevelLayer/SceneLayer for scene flow,
  PlayerLayer/CoreLayer for input/camera/player behavior, ViewLayer for
  presentation, Shared for reusable ScriptableObject/event/utility patterns.
- Keep host-game glue small. If behavior belongs in the framework, propose a
  separate YJackCore package change instead of hiding it in `src/`.
- Prefer inspector-first authoring: serialized fields, UnityEvents,
  ScriptableObject assets, prefabs, Odin-driven inspector ergonomics, and Visual
  Scripting-friendly entry points.
- Do not edit YJackCore package files casually. Preserve package boundaries,
  `.asmdef` dependencies, Unity asset `.meta` files, and submodule/package
  integrity.
- If editing package code is explicitly requested, inspect the package's local
  `AGENTS.md`, `package.json`, `ARCHITECTURE.md`, nearest docs, nearest subtree
  `AGENTS.md`, and relevant `.asmdef` files before changing code.
- Treat Unity-module-backed compile-symbol paths as the primary path when the
  module is installed; bare paths are compatibility fallbacks.
- Report architecture-sensitive work with Architecture impact, Doc impact, and
  Manual validation still required.

## Manual Validation

Agents cannot run the Unity Editor. Always flag the following as requiring
manual owner confirmation: domain reload, Play Mode behavior, Package Manager
resolution, compile symbol branches, Odin Inspector rendering, `.meta` file
integrity, asset database refresh, and build (Development or Release). See
`.claude/docs/yjackcore-authority.md` for the full validation table.
