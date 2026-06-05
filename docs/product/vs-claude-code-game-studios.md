# YJackGameStudio vs. Claude Code Game Studios

## Purpose

This page helps readers decide whether YJackGameStudio is the right fit when
they are comparing it with Claude Code Game Studios style workflows.

This is not a hostile comparison page, a market ranking, or a claim that one
approach is objectively best. It is a fit guide based on the scope and
positioning of this repository.

## Shared Ground

Both approaches are aimed at AI-assisted game development workflows rather than
general-purpose software automation. Both can help structure work beyond a
single prompt and both can be useful for developers who want more than ad hoc
chat sessions.

YJackGameStudio is explicitly based on the earlier Claude Code Game Studios
lineage, but it has been extended into a provider-neutral public reference
architecture.

## Use YJackGameStudio When...

- You want a provider-neutral workflow that remains usable across Codex,
  GitHub Copilot, Gemini, Google Antigravity, Claude Code, and future tools.
- You want the repo to act as a reusable reference architecture rather than a
  tool-specific starter kit.
- You want explicit owner approval gates for source code, pull requests,
  releases, and phase transitions.
- You want engine-neutral guidance that stays useful across Godot, Unity, and
  Unreal rather than centering one editor or provider workflow.
- You want optional YJackCore-aware Unity routing without making YJackCore a
  required dependency.
- You want inspectable docs, skills, rules, templates, and validation language
  that can be audited or adapted by another team.

## Use Another Tool When...

- You specifically want a Claude Code-centered workflow and do not need
  provider-neutral portability.
- You want the lightest possible starting point and prefer a narrower scope
  over a broader public reference layer.
- You do not need cross-provider compatibility guidance, shared authority docs,
  or multi-entrypoint maintenance across several AI coding systems.
- You are optimizing for a Claude-native workflow first and would treat other
  tool ecosystems as out of scope.

## Key Difference in Positioning

YJackGameStudio is positioned as an open-source reference architecture for
AI-native game studios. It owns the reusable public layer: roles, workflows,
contracts, validation expectations, compatibility guidance, and optional engine
or framework adapters.

It is not a hosted product, not Loomlight Studio, not a prompt-to-game system,
and not a Unity AI integration. It also does not require YJackCore.

## What This Comparison Does Not Claim

- It does not claim feature parity with every Claude-specific workflow.
- It does not claim YJackGameStudio is more mature, more productive, or more
  widely adopted.
- It does not claim one repository should replace the other for every team.
- It does not claim provider-neutrality is always the right tradeoff.

## Related Docs

- [`README.md`](../../README.md)
- [`docs/product/public-messaging.md`](public-messaging.md)
- [`docs/product/ecosystem-map.md`](ecosystem-map.md)
- [`docs/product/repo-positioning.md`](repo-positioning.md)
- [`docs/product/maintenance-and-scope.md`](maintenance-and-scope.md)
