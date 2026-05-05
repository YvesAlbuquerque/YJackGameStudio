---
paths:
  - "src/**"
  - "Packages/YJackCore/**"
  - "Packages/com.ygamedev.yjack/**"
---

# YJackCore Unity Rules

Apply these rules only when the project uses YJackCore or the edited path is a
YJackCore package path.

> **Provider-neutral version**: `.agents/rules/yjackcore-unity.md`
> **Authority rules**: `.agents/docs/yjackcore-authority.md`

## Authority Override

- YJackCore repo docs and its `AGENTS.md` override generic Game Studio Unity guidance.
  When a local YJackCore checkout is available, read: `AGENTS.md` → `package.json`
  → `ARCHITECTURE.md` → `Docs/Workflow/framework-vision.md` → nearest layer doc.
- These override `.claude/docs/yjackcore-support.md` whenever they conflict.

## Package File Permission

- **YJackCore package files are read-only by default** for all game-repo work.
  Do not edit `Packages/com.ygamedev.yjack/**` or `Packages/YJackCore/**`
  without explicit owner authorization.
- If editing package code is explicitly requested, read the package's local
  `AGENTS.md`, `package.json`, `ARCHITECTURE.md`, nearest docs, and relevant
  `.asmdef` files before changing code.

## Work Classification (Required)

- Before writing code, declare in the work contract whether work is:
  `game-repo-work` | `framework-work` | `both`
- Do not mix the two without separate owner authorization for the framework portion.

## Layer Routing

- Read `.claude/docs/yjackcore-support.md` before designing or reviewing Unity
  architecture for a YJackCore-backed project.
- Prefer existing YJackCore layer surfaces before new host-game abstractions:
  GameLayer for global services, LevelLayer for scene flow, PlayerLayer for
  input/camera/player behavior, ViewLayer for presentation, Shared for reusable
  ScriptableObject/event/utility patterns.

## Low-Code Preference

- **Low-code authoring paths are preferred before custom code.** Check YJackCore
  prefabs, ScriptableObjects, UnityEvents, and Visual Scripting before writing C#.
- Prefer inspector-first authoring: serialized fields, UnityEvents,
  ScriptableObject assets, prefabs, and Visual Scripting-friendly entry points.
- Keep host-game glue small. If behavior belongs in the framework, propose a
  separate YJackCore package change instead of hiding it in `src/`.

## Validation Honesty

- **Do not claim Unity Editor, Play Mode, build, or CI validation unless actually run.**
- Report architecture-sensitive work with:
  - **Architecture impact**: host-only wiring, YJackCore package change, or both
  - **Doc impact**: game docs only, YJackCore docs, or none
  - **Manual validation still required**: domain reload, Play Mode, scene/prefab
    wiring, package resolution — list all items honestly in the work contract.
  - See `.agents/docs/validation-evidence.md` for the full evidence packet format.
