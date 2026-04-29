# Source Directory Instructions

When writing or editing game code in this directory, follow these standards.

## Engine Version Warning

Always check `docs/engine-reference/` before using engine APIs. Do not guess at
post-cutoff API signatures.

## Coding Standards

- Public APIs require doc comments.
- Gameplay values must be data-driven through external config, not hardcoded.
- Prefer dependency injection over singletons for testability.
- Every new durable system needs a corresponding ADR in `docs/architecture/`.
- Commits, if requested, should reference the relevant story ID or design document.

## File Routing

Match the engine-specialist role to the file type being written. Read the
`Engine Specialists` section in `.agents/docs/technical-preferences.md`.
When in doubt, use the primary configured engine specialist.

## Tests

Tests live in `tests/`, not `src/`. Run or follow `/test-setup` if the test
framework does not exist yet. Gameplay systems should have tests covering formulas
and edge cases.

## Verification-Driven Development

Write tests first when adding gameplay systems. For UI changes, verify with
screenshots where the selected tool supports it. Compare expected output to actual
output before marking work complete.
