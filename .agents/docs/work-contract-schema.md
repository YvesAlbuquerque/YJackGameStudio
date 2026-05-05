# Work Contract Schema

Every autonomous work unit in YJackGameStudio must have a work contract before
execution begins. This document defines the required fields, optional fields, and
lifecycle states.

A work contract may be expressed as a GitHub Issue (using the agent-work template),
a YAML/JSON file, or a structured markdown block inside a planning doc. The fields
are the same regardless of format.

## Required Fields

### Intent and Scope

| Field | Type | Description |
|-------|------|-------------|
| `owner_goal` | string | One-sentence statement of what the owner wants to achieve. |
| `success_criteria` | list | Measurable conditions that define completion. |
| `non_goals` | list | What this contract explicitly does NOT cover. |

### Assignment

| Field | Type | Description |
|-------|------|-------------|
| `specialist_agent` | string | Primary agent role responsible (e.g., `engine-programmer`, `qa-tester`). |
| `autonomy_mode` | enum | `collaborative` \| `supervised` \| `trusted`. Defaults to `collaborative`. |
| `risk_tier` | enum | `LOW` \| `MEDIUM` \| `HIGH`. HIGH always requires owner approval gate. |
| `approval_boundary` | string | Describes what the agent may do without asking vs. what requires owner sign-off. |

### YJackCore Classification (Required When YJackCore Is Active)

| Field | Type | Description |
|-------|------|-------------|
| `yjackcore_relevance` | enum | `none` \| `consumer` \| `framework-change`. |
| `yjackcore_layer` | string | Which YJackCore layer this touches (GameLayer, LevelLayer, PlayerLayer, ViewLayer, Shared, or `n/a`). |
| `framework_change_vs_game_change` | enum | `game-repo-work` \| `framework-work` \| `both`. |

### File Ownership

| Field | Type | Description |
|-------|------|-------------|
| `dependencies` | list | Issue IDs or contract IDs that must be VALIDATED before this work starts. |
| `read_set` | list | Files/directories this agent will read (for context). |
| `write_set` | list | Files/directories this agent has exclusive write permission for. |

> **Rule**: Two concurrent contracts must not share any path in their `write_set`.
> Overlap → escalate to owner before starting.

### Outputs and Validation

| Field | Type | Description |
|-------|------|-------------|
| `expected_outputs` | list | Concrete artifacts this contract produces (files, issue updates, reports). |
| `validation_plan` | list | Checks the agent will run to verify work (static, script, doc, CI). |
| `manual_validation_required` | list | Unity Editor, Play Mode, build, or other checks the agent cannot run autonomously. |
| `escalation_conditions` | list | Conditions under which the agent must stop and notify the owner. |

### Handoff

| Field | Type | Description |
|-------|------|-------------|
| `handoff_notes` | string | What the next agent or owner needs to know to continue from this contract's end state. |

## Lifecycle States

```
PROPOSED → APPROVED → IN_PROGRESS → BLOCKED → VALIDATED → CLOSED
```

| State | Meaning |
|-------|---------|
| `PROPOSED` | Contract drafted; awaiting owner review and approval. |
| `APPROVED` | Owner has approved scope, autonomy mode, and risk tier. Work may begin. |
| `IN_PROGRESS` | Agent is actively executing within the approved boundary. |
| `BLOCKED` | Agent has hit an escalation condition. Owner action required. |
| `VALIDATED` | All validation_plan items complete; manual_validation_required items documented. |
| `CLOSED` | Owner has accepted the validated output. Issue closed. |

Contracts must not skip `APPROVED`. An agent that begins work without an approved
contract is operating outside bounds.

## Minimal Markdown Example

```markdown
## Work Contract

- **owner_goal**: Add a persistent settings system using YJackCore GameLayer.
- **success_criteria**:
  - Settings save/load works via GameLayer ScriptableObject.
  - Settings are accessible from ViewLayer HUD without direct reference to GameLayer internals.
- **non_goals**: Custom settings UI design (separate UX contract). Cloud sync.
- **specialist_agent**: engine-programmer
- **autonomy_mode**: supervised
- **risk_tier**: MEDIUM
- **approval_boundary**: May write src/ and docs/. Must not modify Packages/com.ygamedev.yjack.
- **yjackcore_relevance**: consumer
- **yjackcore_layer**: GameLayer
- **framework_change_vs_game_change**: game-repo-work
- **dependencies**: [] (none)
- **read_set**: [.agents/docs/yjackcore-authority.md, Packages/com.ygamedev.yjack/Runtime/GameLayer/]
- **write_set**: [src/Settings/, docs/architecture/settings-adr.md]
- **expected_outputs**: [SettingsManager.cs, SettingsData.asset, settings-adr.md]
- **validation_plan**: [static C# inspection, doc review]
- **manual_validation_required**: [Unity domain reload, Play Mode save/load, scene wiring check]
- **escalation_conditions**: [Any required change to YJackCore package files]
- **handoff_notes**: Settings asset path is Assets/Data/Settings/SettingsData.asset.
```

## YAML Representation (Optional)

```yaml
owner_goal: "Add a persistent settings system using YJackCore GameLayer."
success_criteria:
  - "Settings save/load works via GameLayer ScriptableObject."
  - "Settings accessible from ViewLayer without GameLayer internal references."
non_goals:
  - "Custom settings UI design."
  - "Cloud sync."
specialist_agent: engine-programmer
autonomy_mode: supervised
risk_tier: MEDIUM
approval_boundary: "May write src/ and docs/. No framework package edits."
yjackcore_relevance: consumer
yjackcore_layer: GameLayer
framework_change_vs_game_change: game-repo-work
dependencies: []
read_set:
  - .agents/docs/yjackcore-authority.md
  - Packages/com.ygamedev.yjack/Runtime/GameLayer/
write_set:
  - src/Settings/
  - docs/architecture/settings-adr.md
expected_outputs:
  - SettingsManager.cs
  - SettingsData.asset
  - settings-adr.md
validation_plan:
  - static C# inspection
  - doc review
manual_validation_required:
  - Unity domain reload
  - Play Mode save/load
  - scene wiring check
escalation_conditions:
  - Any required change to YJackCore package files
handoff_notes: "Settings asset path is Assets/Data/Settings/SettingsData.asset."
```

## Parallel Execution Rules

When multiple contracts run simultaneously:

1. No two active contracts may share a path in their `write_set`.
2. `read_set` overlap is allowed — reading is not exclusive.
3. A contract whose `dependencies` include another contract in `IN_PROGRESS`
   must wait in `PROPOSED` or `APPROVED` state until dependencies reach `VALIDATED`.
4. Agents must produce partial reports if some dependencies complete and others block.
