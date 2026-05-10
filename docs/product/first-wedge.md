# First Wedge

## Conclusion

The first public wedge is:

"Open operating model -> adaptable project workflow."

This is the right wedge because YJackGameStudio is the open-source reference
architecture, not the commercial product and not a Unity/YJackCore-only
offering. The wedge should prove that the repo can turn owner intent into
structured, provider-neutral production artifacts without claiming automated
game delivery or engine/editor execution.

## Input example

Owner input:

```text
I want to explore a cozy tactical gardening roguelite. I have not chosen an
engine yet. I want a maintainable plan, clear risks, and a workflow I can run
with my AI coding tool. If I choose Unity later, I may evaluate YJackCore, but I
do not want the plan to depend on it.
```

## Output artifacts

The wedge should produce:

- Product brief: target fantasy, player promise, constraints, and non-goals.
- Target user and platform assumptions.
- Engine selection assumptions and open questions.
- Core loop and vertical-slice definition.
- Systems map: gameplay, UI, progression, content, input, save/load, QA.
- Work contract set with owner goal, success criteria, non-goals, dependencies,
  read set, write set, risk tier, and validation plan.
- Provider/tool assumptions and adapter notes.
- Production roadmap for the slice.
- Validation evidence plan, including manual engine validation still required.
- Owner decision log and high-risk approval gates.
- Optional framework fit notes, including YJackCore only when Unity is selected
  or explicitly being evaluated.

## Why this wedge is credible

The repo already has the foundation needed for this wedge:

- Autonomy modes.
- Work contract schema.
- Dependency and file ownership expectations.
- Validation evidence rules.
- Owner dashboard direction.
- Risk gates.
- Optional YJackCore authority and workspace routing.
- Brownfield adoption direction.
- QA evidence expectations.
- Provider-neutral `.agents/` source of truth.

This wedge is planning-heavy, so it can be validated through docs review,
contract completeness, link checks, and consistency with existing authority
rules. It does not require claiming Unity Editor, Play Mode, build, or Unity AI
validation.

## Why not one-prompt game creation

One-prompt game creation is the wrong first wedge because:

- It pushes the repo toward prompt-to-game positioning.
- It hides architecture, validation, ownership, and scope decisions.
- It risks creating unmaintainable game projects.
- It would require strong editor, asset, and build validation that this repo does
  not claim.
- It competes on spectacle instead of production reliability.
- It weakens the owner-directed autonomy model by implying the owner can skip
  high-risk decisions.

## Next wedge

The next wedge should be:

"Reference workflow -> engine-specific example pipeline."

That wedge should only begin after the open operating model is clear and stable.

Expected next outputs:

- Godot, Unity, or Unreal project setup plan.
- First playable implementation contracts.
- Engine-specific manual validation checklist.
- QA evidence packet template.
- Owner dashboard report for prototype progress.
- Optional Unity/YJackCore layer map when YJackCore is deliberately in scope.

## Success criteria

This wedge succeeds when a solo developer, small studio, educator, or tool
builder can read the generated plan and say:

- The game is scoped enough to start.
- Engine and provider assumptions are clear.
- YJackCore is optional, not mandatory.
- Risky decisions are visible.
- Work can be split safely.
- Validation debt is honest.
- The next implementation step is obvious.
