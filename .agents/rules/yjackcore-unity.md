---
paths:
  - "src/**"
  - "Packages/YJackCore/**"
  - "Packages/com.ygamedev.yjack/**"
---

# YJackCore Unity Rules

Apply these rules when the project uses YJackCore (including when editing YJackCore
package paths).

- Before any YJackCore task, check for `.yjack-workspace.json` at the project
  root. If present, read it to resolve the package layout and local authority
  paths before proceeding.
- Read `.agents/docs/yjackcore-consumer-authority.md` to understand the
  framework-vs-product authority hierarchy, workspace routing, and manual
  Unity validation expectations.
- Read `.agents/docs/yjackcore-support.md` before designing or reviewing Unity
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
