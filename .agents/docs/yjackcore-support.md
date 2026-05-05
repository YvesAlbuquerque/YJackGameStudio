# YJackCore Support (Provider-Neutral)

This is the provider-neutral reference for YJackCore support.
Claude Code agents: also read `.claude/docs/yjackcore-support.md` for
Claude-specific configuration details.

For full authority rules, read `.agents/docs/yjackcore-authority.md`.
For workspace detection, read `.agents/docs/yjack-workspace-manifest.md`.

## Detection

Treat a project as YJackCore-backed if any of these are true:

- `.yjack-workspace.json` exists in the repo root *(highest confidence — read this first)*
- `Packages/manifest.json` contains `com.ygamedev.yjack` or `YJackCore`
- A local package exists at `Packages/YJackCore/package.json`
- A git submodule path points to `YJackCore`
- `technical-preferences.md` lists `Framework: YJackCore`
- The owner explicitly states the game uses YJackCore

**When `.yjack-workspace.json` exists, read it before `Packages/manifest.json`.**

## Override Priority

YJackCore repo docs override generic Game Studio Unity guidance. See
`.agents/docs/yjackcore-authority.md` for the full override priority list.

## Package Assumptions

- Package name: `com.ygamedev.yjack`
- Primary language: C#
- Authoring model: low-code, inspector-first
- Preferred surfaces: serialized `UnityEvent`, Visual Scripting,
  ScriptableObject state/events, prefabs, scene-level composition
- Odin Inspector is a baseline authoring dependency
- Dependencies include TextMeshPro, Cinemachine, Visual Scripting,
  Mathematics, and Input System

## Package File Permission

YJackCore package files are **read-only by default** for all agents, regardless
of provider. Framework changes require explicit owner authorization. See
`.agents/docs/yjackcore-authority.md`.

## YJackCore Layer Map

| Need | Prefer |
|------|--------|
| Global startup, save/load, scene transitions, settings, platform | GameLayer |
| Level flow, win/loss, quests, inventory, scene-owned systems | LevelLayer / SceneLayer |
| Input, camera, player-facing runtime | PlayerLayer / CoreLayer |
| HUD, popups, menus, loading screens, presentation | ViewLayer |
| Reusable state, events, pools, utilities, primitives | Shared |

## Manual Validation Debt

All YJackCore work carries Unity manual validation debt. Always list outstanding
manual validation in the work contract and validation evidence packet. See
`.agents/docs/validation-evidence.md`.
