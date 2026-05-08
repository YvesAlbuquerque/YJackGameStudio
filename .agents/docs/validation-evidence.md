# Validation Evidence

This document defines what honest validation looks like in YJackGameStudio.
All agents must follow this guidance when closing a work contract or a GitHub Issue.

## The Core Rule

**Do not claim a validation check was run unless it was actually run.**

This applies to every check type, especially:

- Unity Editor import
- Domain reload (compile check)
- Play Mode (runtime behavior)
- Build verification
- Hook execution
- CI pipeline results

Overclaiming validation is a honesty violation. It misleads the owner into
thinking work is safer or more complete than it is. Under-claiming (listing debt
honestly) is always the correct choice.

## Validation Evidence Packet

Every completed work contract must include a validation evidence packet. It may
appear in the issue comment, the work contract `handoff_notes`, or a dedicated
`validation-report.md` file for larger work.

### Packet Fields

| Field | Type | Description |
|-------|------|-------------|
| `checks_run` | list | Validation steps that were actually executed during this work. |
| `checks_unavailable` | list | Validation steps that apply but could not be run (with reason). |
| `static_inspection` | string | Result of reading the code/docs and reasoning about correctness. |
| `docs_review` | string | Result of reviewing documentation for accuracy and consistency. |
| `script_validation` | string | Result of running any local scripts (linters, validators, test scripts). |
| `engine_validation` | string | Result of Unity Editor checks IF actually run. Omit or mark `not-run` if not run. |
| `unity_editor_validation` | string | Specific Editor result (import, compile, domain reload). Omit or mark `not-run` if not run. |
| `manual_validation_still_required` | list | Checks that must be done by the owner or a human with Unity open. |
| `known_risks` | list | Identified risks not fully resolved by this work. |
| `confidence` | enum | `HIGH` \| `MEDIUM` \| `LOW` — agent's honest confidence in the work's completeness. |

### Confidence Levels

| Level | Meaning |
|-------|---------|
| `HIGH` | Static inspection strong, docs consistent, scripts pass, risks understood. |
| `MEDIUM` | Static inspection reasonable but Unity checks outstanding, or some risks unresolved. |
| `LOW` | Significant uncertainty remains — manual validation strongly recommended before merging. |

## What Each Check Means

### `checks_run` Examples

- `"git diff --check"` — whitespace/syntax check run via git.
- `"static doc review"` — docs read and cross-checked for contradictions.
- `"markdown link inspection"` — internal links checked manually or via script.
- `"JSON schema validation"` — JSON file validated against a schema or with `jq`.
- `"skill-test script"` — `.claude/skills/*/skill.yaml` validated by a local script.

### `checks_unavailable` Examples

- `"Unity Editor import — agent cannot open Unity Editor autonomously"`
- `"Play Mode test — requires Unity Editor and running scene"`
- `"CI pipeline — no CI configured for this repo yet"`
- `"Build verification — requires Unity license and build environment"`

### `manual_validation_still_required` Examples

These must always be listed honestly for Unity/YJackCore work:

- Unity import (package resolution, `.meta` regeneration)
- Domain reload (no compile errors)
- Play Mode (runtime behavior matches intent)
- Scene/prefab wiring (component references valid)
- YJackCore layer routing (correct layer surfaces used, confirmed in Editor)
- Odin Inspector serialization (inspector UI appears as expected)
- Package manager resolution (UPM or local package resolves without errors)

## Minimal Evidence Packet (Markdown Format)

```markdown
## Validation Evidence

- **checks_run**: git diff --check, static doc review, markdown link inspection
- **checks_unavailable**: Unity Editor import (agent cannot open Editor), Play Mode (requires Editor)
- **static_inspection**: PASS — code reads correctly, layer routing matches yjackcore-authority.md
- **docs_review**: PASS — docs consistent with work contract success criteria
- **script_validation**: PASS — git diff --check returned exit 0
- **engine_validation**: not-run
- **unity_editor_validation**: not-run
- **manual_validation_still_required**:
  - Unity domain reload (confirm no compile errors)
  - Play Mode (confirm runtime behavior)
  - Scene/prefab wiring (confirm component references)
- **known_risks**: None identified beyond normal Unity manual validation debt.
- **confidence**: MEDIUM
```

## Docs-Only Work

For documentation-only changes (no code, no Unity assets), the expected packet is:

- `checks_run`: `["git diff --check", "static doc review", "markdown link inspection"]`
- `checks_unavailable`: none (docs do not require Unity)
- `engine_validation`: `n/a`
- `unity_editor_validation`: `n/a`
- `manual_validation_still_required`: none (unless doc changes affect Unity workflows)
- `confidence`: `HIGH` if doc review passes cleanly.

## How This Integrates With Work Contracts

The `validation_plan` field in a work contract lists the checks the agent
*intends* to run. The validation evidence packet records what was *actually*
run and what remains.

If `manual_validation_required` in the work contract lists items the agent
cannot satisfy, those must appear verbatim in `manual_validation_still_required`
in the evidence packet. They do not get removed simply because the work is done.

## Escalation for Validation Gaps

If the agent reaches the validation stage and realizes a check that was listed in
`validation_plan` cannot actually be run (e.g., a required script is missing or a
required tool is unavailable), the agent must:

1. Add the check to `checks_unavailable` with the reason.
2. Add it to `manual_validation_still_required`.
3. Lower `confidence` appropriately.
4. Do **not** mark the contract `VALIDATED` with HIGH confidence when significant
   checks are outstanding.
