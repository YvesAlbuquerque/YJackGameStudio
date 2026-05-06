# YJackCore Authority

This document defines which repository owns what when both YJackGameStudio and
YJackCore are active. All agents must read this before designing, reviewing, or
implementing Unity + YJackCore work.

## The Authority Split

| Question | Authority |
|---------|-----------|
| Unity runtime behavior, layer architecture, package API | **YJackCore repo** |
| Game-specific prefabs, scenes, scripts, assets | **Game repo** |
| Studio orchestration, planning, issue contracts, validation | **YJackGameStudio** |

## Override Priority

When YJackCore repo docs exist locally, they override generic Game Studio Unity
guidance in this order:

1. YJackCore `AGENTS.md` — package-level agent rules
2. YJackCore `package.json` — version and dependency truth
3. YJackCore `ARCHITECTURE.md` — layer architecture authority
4. YJackCore `Docs/Workflow/framework-vision.md` — design intent
5. YJackCore `Docs/index.md` — entry point to all other docs
6. The nearest YJackCore layer doc for the specific task

**These override** `.claude/docs/yjackcore-support.md` and generic Unity guidance
whenever they conflict.

## Package File Authority

YJackCore package files are **read-only by default** for game-repo agents.

| Path Pattern | Default Permission | Override Required |
|-------------|-------------------|------------------|
| `Packages/com.ygamedev.yjack/**` | Read-only | Owner explicit authorization |
| `Packages/YJackCore/**` | Read-only | Owner explicit authorization |
| `src/**` | Read/write | Within domain delegation |
| `Assets/**` (game assets) | Read/write | Within domain delegation |
| `Packages/manifest.json` | Read (detect); write only for package version bumps | Owner approval |

## Work Classification (Required)

Every work contract must classify its work:

- `game-repo-work` — changes only in the host game repository
- `framework-work` — changes in the YJackCore package (requires framework authorization)
- `both` — hybrid; the framework portion requires its own separate authorization

Do not mix game-repo work and framework-work in the same work contract unless
the owner has explicitly pre-approved the framework portion.

## Framework vs. Game Change Decision

Ask these questions before writing any code:

1. Does this behavior belong to every game built on YJackCore, or only this game?
   → If every game: it belongs in YJackCore. Propose a framework change.
2. Would this glue grow into reusable framework behavior?
   → If yes: propose a separate YJackCore change rather than burying it in `src/`.
3. Is this a new host-game entry point that calls existing YJackCore APIs?
   → If yes: it belongs in the game repo. Keep glue small and explicit.

## Manual Unity Validation Debt

YJackCore work **always** accumulates Unity manual validation debt. Agents must
report this honestly. Do not claim the following are done unless actually run:

- Unity Editor import (package resolution, `.meta` regeneration)
- Domain reload (no compile errors)
- Play Mode (runtime behavior)
- Scene/prefab wiring (component references valid)
- Build verification

Report all outstanding manual validation in the work contract's
`manual_validation_still_required` field and the validation evidence packet.

## Low-Code Preference

Before writing custom C# code for a YJackCore-backed feature:

1. Check if a YJackCore prefab, ScriptableObject, or UnityEvent surface covers it.
2. Check if Visual Scripting can wire it without custom code.
3. Check if inspector-first setup (serialized fields, Odin Inspector) is sufficient.

Custom code is appropriate only when the low-code path is insufficient or
the team has explicitly decided to extend with code.

## YJackCore Layer Map

| Need | Prefer |
|------|--------|
| Global startup, save/load, scene transitions, settings, platform services | GameLayer |
| Level flow, win/loss, quests, inventory, scene-owned systems | LevelLayer / SceneLayer |
| Input, controller activation, camera, player-facing runtime behavior | PlayerLayer / CoreLayer |
| HUD, popups, menus, loading screens, minimap, presentation | ViewLayer |
| Reusable state, events, pools, utilities, command/behavior-tree primitives | Shared |

## YJackCore Repo Reading Order (When Available Locally)

```
YJackCore/AGENTS.md
YJackCore/package.json
YJackCore/ARCHITECTURE.md
YJackCore/Docs/Workflow/framework-vision.md
YJackCore/Docs/index.md
YJackCore/Runtime/<Layer>/  (nearest layer for the task)
```
