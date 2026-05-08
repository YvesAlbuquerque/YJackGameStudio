# First Wedge

## Conclusion

The first product wedge is:

"Idea -> production-ready YJackCore-aware vertical-slice plan."

This is the right wedge because it uses the completed autonomy foundation without
claiming full autonomous game generation or Unity Editor execution.

## Input example

Owner input:

```text
I want a cozy tactical gardening roguelite in Unity. The player grows plants
that become squad units, explores small grid-based biomes, and chooses between
short runs with permanent garden upgrades. I want this built with YJackCore if
it fits, and I care more about maintainable systems than a flashy demo.
```

## Output artifacts

The wedge should produce:

- Product brief: target fantasy, player promise, constraints, and non-goals.
- Target user and platform assumptions.
- Core loop and vertical-slice definition.
- Systems map: gameplay, UI, progression, content, input, save/load, QA.
- YJackCore fit assessment.
- YJackCore layer map: GameLayer, LevelLayer, PlayerLayer, ViewLayer, Shared, or
  n/a for each system.
- Game-repo vs framework-work classification.
- Work contract set with owner goal, success criteria, non-goals, dependencies,
  read set, write set, risk tier, and validation plan.
- Production roadmap for the slice.
- Validation evidence plan, including manual Unity validation still required.
- Owner decision log and high-risk approval gates.
- Demo script for showing the plan.

## Why this wedge is credible

The repo already has the foundation needed for this wedge:

- Autonomy modes.
- Work contract schema.
- Dependency and file ownership expectations.
- Validation evidence rules.
- Owner dashboard direction.
- Risk gates.
- YJackCore authority and workspace routing.
- Brownfield adoption direction.
- QA evidence expectations.

This wedge is planning-heavy, so it can be validated through docs review,
contract completeness, link checks, and consistency with existing authority
rules. It does not require claiming Unity Editor, Play Mode, or build validation.

## Why not one-prompt full game yet

One-prompt full-game generation is the wrong first wedge because:

- It pushes the product toward prompt-to-game positioning.
- It hides architecture, validation, ownership, and scope decisions.
- It risks creating unmaintainable Unity projects.
- It would require strong Unity Editor and asset validation that the current
  product does not yet prove.
- It competes directly with tools optimized for spectacle instead of production
  reliability.
- It weakens the owner-directed autonomy model by implying the owner can skip
  high-risk decisions.

## Next wedge

The next wedge should be:

"Plan -> first playable Unity/YJackCore prototype."

That wedge should only begin after the planning demo proves that the generated
contracts, system map, validation plan, and owner decision points are useful.

Expected next outputs:

- Unity/YJackCore project setup plan.
- First playable implementation contracts.
- Scene/prefab/manual validation checklist.
- QA evidence packet template.
- Owner dashboard report for prototype progress.

## Success criteria

This wedge succeeds when a solo Unity developer or technical designer can read
the generated plan and say:

- The game is scoped enough to start.
- The YJackCore fit is clear.
- The risky decisions are visible.
- The work can be split safely.
- The validation debt is honest.
- The next implementation step is obvious.
