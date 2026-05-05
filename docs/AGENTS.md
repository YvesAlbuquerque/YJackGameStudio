# Docs Directory Instructions

When authoring or editing files in this directory, follow these standards.

## Architecture Decision Records (`docs/architecture/`)

Use the ADR template: `.agents/docs/templates/architecture-decision-record.md`.

Required sections: Title, Status, Context, Decision, Consequences,
ADR Dependencies, Engine Compatibility, GDD Requirements Addressed.

Status lifecycle: `Proposed` -> `Accepted` -> `Superseded`.
Never skip `Accepted`; stories referencing a `Proposed` ADR are blocked.

TR registry: `docs/architecture/tr-registry.yaml`.
Stable requirement IDs such as `TR-MOV-001` link GDD requirements to stories.
Never renumber existing IDs; only append new ones.

Control manifest: `docs/architecture/control-manifest.md`.
It is a flat programmer rules sheet with Required, Forbidden, and Guardrails per layer.
Stories embed its version; `/story-done` checks for staleness.

Validation: run or follow `/architecture-review` after completing a related set of ADRs.

## Engine Reference (`docs/engine-reference/`)

Version-pinned engine API snapshots live here. Always check this directory before
using engine APIs. The model's training data may predate the pinned engine version.
