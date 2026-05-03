---
paths:
  - "src/**"
  - "Packages/YJackCore/**"
  - "Packages/com.ygamedev.yjack/**"
---

# YJackCore Unity Rules

Apply these rules only when the project uses YJackCore or the edited path is a
YJackCore package path.

- Read `.claude/docs/yjackcore-support.md` before designing or reviewing Unity
  architecture for a YJackCore-backed project.
- Prefer existing YJackCore layer surfaces before new host-game abstractions:
  GameLayer for global services, LevelLayer/SceneLayer for scene flow,
  PlayerLayer/CoreLayer for input/camera/player behavior, ViewLayer for
  presentation, Shared for reusable ScriptableObject/event/utility patterns.
- Keep host-game glue small. If behavior belongs in the framework, propose a
  separate YJackCore package change instead of hiding it in `src/`.
- Prefer inspector-first authoring: serialized fields, UnityEvents,
  ScriptableObject assets, prefabs, and Visual Scripting-friendly entry points.
- Do not edit YJackCore package files casually. Preserve package boundaries,
  `.asmdef` dependencies, Unity asset `.meta` files, and submodule/package
  integrity.
- If editing package code is explicitly requested, inspect the package's local
  `AGENTS.md`, `package.json`, `ARCHITECTURE.md`, nearest docs, and relevant
  `.asmdef` files before changing code.
- Report architecture-sensitive work with Architecture impact, Doc impact, and
  Manual validation still required.
