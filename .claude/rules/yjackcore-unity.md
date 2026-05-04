---
paths:
  - "Packages/YJackCore/**"
  - "Packages/com.ygamedev.yjack/**"
---

# YJackCore Unity Rules

Apply these rules only when the project uses YJackCore and the edited path is a
YJackCore package path. For host-game code in `src/` that integrates with
YJackCore, the unity-specialist agent will read `.claude/docs/yjackcore-support.md`
when technical preferences or a `.yjack-workspace.json` manifest indicate YJackCore
is active.

## Workspace Manifest

If `.yjack-workspace.json` exists at the Unity project root, read it first to
resolve the package root path, version, layout, and authority notes. See
`.agents/docs/yjackcore-workspace-manifest.md` for the manifest schema and
examples for UPM, sibling, submodule, vendor, and inline layouts.

## Authority Routing

Route tasks according to the following hierarchy. Do not skip levels.

1. **YJackCore authority** — for framework layer boundaries, package structure,
   asmdefs, compile symbols, ScriptableObject/event patterns, editor tooling,
   testing, and documentation impact, always prefer YJackCore's own `AGENTS.md`,
   `.agents/skills/*`, `.ai/commands/*`, docs, package metadata, and subtree
   instructions over anything in this Game Studio fallback.
2. **Game Studio yjackcore-support** — when YJackCore-specific assets are absent,
   use `.claude/docs/yjackcore-support.md` as the next best authority.
3. **Game Studio unity-specialist** — for generic Unity engine/API behavior,
   profiling, rendering, input, UI, Addressables, and host-project integration.

When a task touches `Packages/YJackCore/**` or `Packages/com.ygamedev.yjack/**`:

- Read the package's local `AGENTS.md`, `package.json`, `ARCHITECTURE.md`,
  nearest subtree `AGENTS.md`, and relevant `.asmdef` files before changing code.
- Do not modify package files from a host-game task without explicit owner
  authorization.
- If the change is host-game only, use YJackCore layer surfaces and wiring
  points rather than modifying the package.

## Authoring and Integration Rules

- Read `.claude/docs/yjackcore-support.md` before designing or reviewing Unity
  architecture for a YJackCore-backed project.
- If a local YJackCore package or checkout is available, prefer its own
  `AGENTS.md`, `.agents/skills/*`, `.ai/commands/*`, docs, package metadata,
  asmdefs, and subtree instructions over this generic Game-Studio fallback.
- Use the Game-Studio Unity specialist for generic Unity engine/API behavior;
  use YJackCore-specific guidance for framework layer ownership, package
  boundaries, compile symbols, ScriptableObject/event patterns, editor tooling,
  testing, and doc impact.
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

Always surface the following items before closing any task that touches
`Packages/**`, `.asmdef` files, or compile symbols:

- Unity domain reload required after package/assembly changes
- Play Mode smoke test for scene and prefab wiring
- Package Manager resolution and lock-file check
- Compile-symbol branch verification
- Odin Inspector serialization check in the Unity Inspector window
- Asset `.meta` file integrity after layout changes
