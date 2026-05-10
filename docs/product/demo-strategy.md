# Demo Strategy

## Conclusion

The demo sequence should prove that YJackGameStudio is a reusable, open-source
operating model for AI-native game production. Do not demo it as Loomlight
Studio, as a Unity-only tool, as a YJackCore requirement, or as one-prompt game
creation.

## Demo 1: idea to portable production plan

Goal:

- Show the core wedge: owner intent -> scoped, provider-neutral production plan.

Input:

- One game idea from the owner.
- Engine undecided, or engine selected explicitly.
- AI tool selected by the user.
- Autonomy mode: collaborative or supervised.

Expected output:

- Product brief.
- Vertical-slice definition.
- Work contracts.
- Dependencies and write ownership.
- Risk gates.
- Validation plan.
- Engine/provider assumptions.

What this proves:

- YJackGameStudio can turn vague intent into production structure without
  pretending a game already exists or forcing one engine/framework path.

## Demo 2: compatibility and adapter routing

Goal:

- Show that the shared `.agents/` layer can be consumed through multiple AI
  tools and engine paths.

Expected output:

- Tool entrypoint map for Codex, Copilot, Gemini, Antigravity, and Claude Code.
- Capability translation notes.
- Engine setup assumptions.
- Adapter-specific limits.

What this proves:

- YJackGameStudio is a provider-neutral reference architecture, not a prompt
  pack for one assistant.

## Demo 3: optional Unity/YJackCore routing

Goal:

- Show that YJackCore is an optional Unity acceleration path, not a dependency.

Expected output:

- System-to-layer map for GameLayer, LevelLayer, PlayerLayer, ViewLayer, Shared,
  or n/a.
- Game-repo vs framework-work classification.
- Low-code authoring opportunities.
- Manual Unity validation debt.
- Generic Unity fallback path when YJackCore is absent.

What this proves:

- YJackGameStudio can support the YJack ecosystem while preserving engine and
  framework neutrality.

## Demo 4: QA/validation evidence and owner dashboard

Goal:

- Show that autonomy closes with evidence, not vague summaries.

Expected output:

- Validation evidence packet.
- Checks run.
- Checks unavailable.
- Known risks.
- Manual validation still required.
- Owner decisions needed.
- Blocked/unblocked issue view.

What this proves:

- YJackGameStudio preserves trust by separating facts, inferences, and remaining
  validation debt.

## Later demo: engine-specific reference pipeline

Goal:

- Show plan -> first playable prototype after the operating-model demos are
  stable.

Expected output:

- Godot, Unity, or Unreal host project changes.
- Implementation contracts.
- Engine-specific validation checklist.
- Playable vertical-slice scene.
- Editor, Play Mode, build, or runtime evidence only if actually run.

What this proves:

- YJackGameStudio can move from planning to implementation without losing owner
  gates, architecture boundaries, or validation honesty.

## Demo non-goals

Do not demo:

- One-prompt complete game creation.
- Loomlight Studio features inside this repo.
- Unity AI support unless a real integration exists and is validated.
- YJackCore package edits without explicit owner authorization.
- Asset generation as the core value proposition.
- UGC publishing or creator marketplace features.

## Demo order

Recommended order:

1. Idea to portable production plan.
2. Compatibility and adapter routing.
3. Optional Unity/YJackCore routing.
4. QA/validation evidence and owner dashboard.
5. Engine-specific reference pipeline.

The first four demos can be docs-first. The fifth requires engine-specific
validation.
