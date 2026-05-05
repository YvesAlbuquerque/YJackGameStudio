# Design Directory Instructions

When authoring or editing files in this directory, follow these standards.

## GDD Files (`design/gdd/`)

Every GDD must include all 8 required sections in this order:

1. Overview - one-paragraph summary
2. Player Fantasy - intended feeling and experience
3. Detailed Rules - unambiguous mechanics
4. Formulas - all math defined with variables
5. Edge Cases - unusual situations handled
6. Dependencies - other systems listed
7. Tuning Knobs - configurable values identified
8. Acceptance Criteria - testable success conditions

File naming: `[system-slug].md` such as `movement-system.md`.

Update `design/gdd/systems-index.md` when adding a new GDD.

Design order: Foundation -> Core -> Feature -> Presentation -> Polish.

Validation: run or follow `/design-review [path]` after authoring any GDD, and
`/review-all-gdds` after completing a related set.

## Quick Specs (`design/quick-specs/`)

Use `/quick-design` for tuning changes, minor mechanics, and balance adjustments.

## UX Specs (`design/ux/`)

- Per-screen specs: `design/ux/[screen-name].md`
- HUD design: `design/ux/hud.md`
- Interaction pattern library: `design/ux/interaction-patterns.md`
- Accessibility requirements: `design/ux/accessibility-requirements.md`

Use `/ux-design` to author. Validate with `/ux-review` before passing to UI implementation.
