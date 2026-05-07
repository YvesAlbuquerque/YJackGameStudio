# YJackCore Unity Consumer Bootstrap Templates

Use this template set when bootstrapping a **Unity + YJackCore** game repository.
Copy only the sections you need into the target project.

## 1) `CLAUDE.md` — Technology Stack block

```markdown
- **Engine**: Unity [version]
- **Language**: C#
- **Framework**: YJackCore (`com.ygamedev.yjack`)
- **Build System**: Unity Build Pipeline
- **Asset Pipeline**: Unity Asset Import Pipeline + Addressables
```

## 2) `ARCHITECTURE.md` — YJackCore boundary and routing block

```markdown
## YJackCore Consumer Boundary

- Host game code lives in `src/`, `Assets/`, and game-owned docs.
- Framework package code lives in `Packages/YJackCore/**` or `Packages/com.ygamedev.yjack/**`.
- Do not mix ownership boundaries. Host-game stories must not modify framework package code unless explicitly authorized.

## YJackCore Layer Routing

- **GameLayer**: global startup, save/load, scene transitions, platform services
- **LevelLayer / SceneLayer**: level flow, win/loss, quests, inventory, scene-owned systems
- **PlayerLayer / CoreLayer**: input, controller activation, camera, player-facing runtime behavior
- **ViewLayer**: HUD, menus, popups, loading screens, presentation
- **Shared**: reusable ScriptableObject state/events, utility assets, cross-layer helpers
```

## 3) `.claude/docs/technical-preferences.md` — Framework Integration defaults

```markdown
## Framework Integration
- **Framework**: YJackCore
- **Framework Source**: [UPM URL | sibling path | submodule path | vendor path | inline path]
- **Framework Version**: [e.g., 1.6.0]
- **Framework Docs**: .claude/docs/yjackcore-support.md
- **Framework Rules**: .claude/rules/yjackcore-unity.md
- **Framework Routing Notes**: Read `.claude/docs/yjackcore-authority.md` first, then `.claude/docs/yjackcore-support.md`, then `unity-specialist` for generic Unity API behavior.
- **Workspace Manifest**: .yjack-workspace.json
```

Low-code authoring defaults to preserve:

```markdown
- Prefer ScriptableObject assets for reusable state/events over hardcoded singleton state.
- Prefer serialized UnityEvents and inspector wiring before custom bootstrap manager code.
- Prefer Unity Visual Scripting-friendly entry points for designer-owned flow.
- Keep setup inspector-first: prefabs + serialized references + scene composition before framework rewrites.
```

## 4) `docs/framework/yjackcore-integration.md` — framework notes template

```markdown
# YJackCore Integration Notes

## Workspace
- **Layout**: [upm|sibling|submodule|vendor|inline]
- **Source**: [URL or path]
- **Version**: [e.g., 1.6.0]
- **Package Path**: [path to package root or N/A for pure UPM]
- **Agents Path**: [path to framework .agents if present, otherwise N/A]

## Layer Ownership
- Feature routing follows: GameLayer, LevelLayer/SceneLayer, PlayerLayer/CoreLayer, ViewLayer, Shared.
- Each game feature should declare its owning layer before implementation.

## Ownership Boundary
- **Game repo changes**: scenes, prefabs, gameplay glue, game docs.
- **YJackCore package changes**: framework APIs, package architecture, asmdefs, package metadata.
- Package changes require explicit owner approval and should be tracked separately from host-game tasks.

## Low-Code Defaults
- Prefer ScriptableObjects, UnityEvents, and inspector composition.
- Prefer Visual Scripting-compatible surfaces when exposing gameplay hooks.
- Add custom code only when the low-code path cannot satisfy the requirement.
```

## 5) `.yjack-workspace.json` layout mapping

Use `.claude/docs/templates/yjack-workspace.json` and choose one layout:

| Layout | `Framework Source` example | `Package Path` |
| ------ | -------------------------- | -------------- |
| `upm` | `https://github.com/ygamedev/yjackcore.git#1.6.0` | `N/A (resolved by UPM)` |
| `sibling` | `../YJackCore` | `../YJackCore` |
| `submodule` | `Packages/com.ygamedev.yjack` | `Packages/com.ygamedev.yjack` |
| `vendor` | `Packages/YJackCore` | `Packages/YJackCore` |
| `inline` | `Assets/YJackCore` | `Assets/YJackCore` |

Always record:
- framework version
- framework source
- package path (or explicit `N/A` for pure UPM)
- selected layer routing notes
