# Idea To Sprint Reference Pipeline

This example shows how an owner and the YJackGameStudio workflow can turn a rough idea into a scoped sprint packet.

It is a reference pipeline only:
- It does not include engine runtime files.
- It does not include game source under `src/`.
- It does not claim runtime/build/test validation.

## Scope

- Input: one rough game idea prompt.
- Output: concept summary, GDD excerpt, architecture/ADR excerpt, epic/story slice, QA evidence plan, owner decision log.
- Out of scope: implementation code, scenes/prefabs, assets, CI execution.

## Pipeline Steps

1. Input prompt captured: [01-input-prompt.md](./01-input-prompt.md)
2. Concept framing drafted: [02-concept-summary.md](./02-concept-summary.md)
3. GDD excerpt drafted: [03-gdd-excerpt.md](./03-gdd-excerpt.md)
4. Architecture decision recorded: [04-architecture-adr-excerpt.md](./04-architecture-adr-excerpt.md)
5. Epic/story breakdown scoped: [05-epic-story-breakdown.md](./05-epic-story-breakdown.md)
6. QA evidence expectations defined: [06-qa-evidence-plan.md](./06-qa-evidence-plan.md)
7. Owner gates and assumptions tracked: [07-owner-decisions-and-assumptions.md](./07-owner-decisions-and-assumptions.md)
8. Not-automated boundaries stated: [08-not-automated.md](./08-not-automated.md)

## Owner Approval Gates

- Gate A: approve concept direction before detailed GDD work.
- Gate B: approve architecture approach before story decomposition.
- Gate C: approve sprint scope before implementation starts.

## Validation Expectations For This Example

- Markdown renders cleanly in GitHub.
- Relative links in this folder resolve.
- `git diff --check` passes.

## Related Skills

- [/start](../../../.agents/skills/start/SKILL.md)
- [/design-system](../../../.agents/skills/design-system/SKILL.md)
- [/create-architecture](../../../.agents/skills/create-architecture/SKILL.md)
- [/create-epics](../../../.agents/skills/create-epics/SKILL.md)
- [/create-stories](../../../.agents/skills/create-stories/SKILL.md)
- [/qa-plan](../../../.agents/skills/qa-plan/SKILL.md)
- [/qa-evidence-assign](../../../.agents/skills/qa-evidence-assign/SKILL.md)

## Important Note

This pipeline is intentionally engine-neutral. If a team selects Godot, Unity, or Unreal later, they must run engine setup and engine-specific validation before any runtime claims.
