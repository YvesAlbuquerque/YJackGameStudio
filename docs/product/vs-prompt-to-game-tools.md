# YJackGameStudio vs. Prompt-to-Game Tools

## Purpose

This page helps readers decide whether they want an owner-directed reference
architecture for AI-assisted game production or a prompt-to-game tool focused
on generating a playable result quickly.

This is not a dismissal of rapid-generation tools. It is a statement that they
solve a different problem.

## Use YJackGameStudio When...

- You want to guide design, architecture, implementation, QA, and release work
  step by step instead of asking for a full game from one prompt.
- You want explicit owner control over approvals, hard gates, scope, and
  validation evidence.
- You want a workflow that stays useful even when the output is documentation,
  architecture, or planning rather than immediately playable content.
- You want a public reference architecture that can be inspected, forked, and
  adapted by teams using different engines and AI tools.
- You want clear separation between YJackGameStudio, Loomlight Studio, engine
  runtimes, and optional frameworks such as YJackCore.
- You need a system that stays honest about what was and was not validated.

## Use Another Tool When...

- You want to generate a prototype or toy result quickly with minimal process.
- You are comfortable trading away some transparency, approval structure, or
  workflow explicitness for speed of generation.
- You do not need reusable production docs, review gates, or evidence-driven QA
  as part of the tool itself.
- You are exploring ideas casually and do not need a long-lived studio
  operating model.

## Key Difference in Positioning

Prompt-to-game tools center on generation speed and output immediacy.
YJackGameStudio centers on production structure, inspectable artifacts, owner
approval, and reusable workflows.

YJackGameStudio is not a one-prompt game creator. It does not claim hosted
orchestration, game-runtime generation, or asset-generation capability in this
repository.

## What This Comparison Does Not Claim

- It does not claim prompt-to-game tools have no value.
- It does not claim YJackGameStudio is the fastest path to a playable
  prototype.
- It does not claim this repository can generate a finished game without owner
  direction.
- It does not claim commercial Loomlight Studio behavior exists here.

## Related Docs

- [`README.md`](../../README.md)
- [`docs/product/public-messaging.md`](public-messaging.md)
- [`docs/product/ecosystem-map.md`](ecosystem-map.md)
- [`docs/product/repo-positioning.md`](repo-positioning.md)
- [`docs/product/maintenance-and-scope.md`](maintenance-and-scope.md)
