# Unity AI Watch

## Conclusion

Unity AI should be treated as a future engine-native execution layer and
platform threat. YJackGameStudio should orchestrate above it, not replicate it.

YJackGameStudio does not currently integrate with Unity AI.

Last checked: 2026-05-08.

## Why Unity AI matters

Unity owns the most important execution surface for Unity games: the Editor,
scene graph, assets, packages, runtime integration, and project metadata. If
Unity AI becomes reliable, it can execute tasks that external agents can only
describe or approximate.

That makes Unity AI both:

- A platform threat, because Unity can absorb editor-native planning, generation,
  and validation workflows.
- A future execution layer, because YJackGameStudio can route approved work
  contracts into Unity-native tooling once integration is stable and safe.

## Unity-owned surface

Unity owns:

- Unity Editor and scene/prefab operations.
- Package Manager installation and package APIs.
- Project context, GameObjects, components, assets, import settings, and logs.
- Unity AI Assistant.
- Unity AI Generators for sprites, textures, sounds, materials, animations, and
  terrain layers.
- Sentis runtime ML execution.
- Unity AI Gateway for third-party model/tool connection.
- Unity MCP Server for IDE or external-agent access to the Editor.
- Unity Cloud project linkage, usage monitoring, pricing, permissions, and data
  settings.
- Generated-asset metadata and Unity's app-store declaration guidance.

## YJackGameStudio-owned surface

YJackGameStudio should own:

- Product thesis and owner intent.
- Target users, open-source roadmap, and demo strategy.
- Autonomy mode selection.
- Work contracts and issue lifecycle.
- Dependency graph and file ownership.
- Agent assignment and provider-neutral orchestration.
- Optional YJackCore routing and framework authority boundaries.
- Risk gates and owner approvals.
- Validation evidence, including manual Unity validation debt.
- Owner dashboard and status reporting.

## MCP / AI Gateway implications

Unity MCP and AI Gateway are strategically important because they may let
external agents operate through Unity-owned context instead of brittle external
automation.

Implications for YJackGameStudio:

- Treat MCP/Gateway as execution connectors, not the product strategy layer.
- Preserve work contracts as the source of truth before any Unity AI action.
- Require explicit approval for high-risk scene, prefab, package, or framework
  work.
- Capture Unity AI actions as validation evidence or execution logs when support
  exists.
- Keep fallback paths for projects that cannot use Unity AI because of version,
  subscription, policy, or platform constraints.

## Capabilities to monitor

Monitor:

- Assistant quality on real Unity projects.
- Whether Assistant can inspect scenes, GameObjects, components, logs, and
  package state accurately.
- MCP Server stability, permissions, subscription requirements, and API coverage.
- AI Gateway support for third-party agents and model routing.
- Whether Unity AI can execute reversible scene/prefab changes with usable diffs.
- Generated-asset metadata, provenance, and app-store declaration workflows.
- Sentis workflow maturity for runtime ML use cases.
- Pricing, credits, subscription bundling, and team/seat limits.
- Unity version requirements and backward compatibility.

## Limitations to monitor

Monitor for:

- Hallucinated Unity API usage.
- Weak awareness of project-specific architecture.
- Unsafe scene/prefab edits.
- Poor diffs for binary or serialized assets.
- Asset provenance and licensing gaps.
- Generated assets that are technically invalid or unoptimized.
- Subscription or Unity Cloud requirements that block teams.
- MCP permissions that are too broad for autonomous use.
- Lack of repeatable validation evidence.

## Integration opportunities

Possible future integrations:

- Work contract -> Unity AI task handoff.
- YJackCore layer map -> Unity AI project context.
- Owner approval gate -> Unity AI permission grant.
- Unity MCP execution logs -> validation evidence packet.
- Generated asset metadata -> asset issue evidence.
- Unity Editor diagnostics -> owner dashboard validation debt.
- Sentis model usage -> runtime ML planning contract.

## Threats

Unity AI threats:

- Unity can make generic Unity-agent routing less valuable by owning the editor
  execution layer.
- Unity can bundle AI assistance into paid plans and lock key workflows behind
  Unity Cloud.
- Unity can control MCP/API surface area, permissions, and pricing.
- Unity-native generated assets may become the default expectation for Unity
  creators.
- If Unity AI adds robust planning and validation, it can compete directly with
  part of YJackGameStudio's workflow surface.

## Strategic response

YJackGameStudio should:

- Stay above engine-native execution.
- Own planning, contracts, validation evidence, owner gates, and optional
  framework routing.
- Treat Unity AI as an optional execution backend when available.
- Avoid cloning Unity's editor-native assistant, generators, MCP server, or AI
  Gateway.
- Keep YJackCore optional but recommended for Unity/YJack ecosystem use.
- Preserve provider-neutral orchestration so work can route to Codex, Claude,
  Copilot, Gemini, Cursor, Windsurf, or Unity AI depending on the task.

## Open questions

- Which Unity AI features are stable enough for production workflows?
- Which Unity AI actions can produce reviewable diffs and evidence?
- How restrictive are MCP and AI Gateway subscription requirements?
- Can Unity AI safely operate inside YJackCore-backed projects without violating
  framework authority boundaries?
- What Unity versions should the YJack ecosystem support before relying on Unity
  AI?
- How should generated-asset provenance and app-store declaration evidence be
  recorded in work contracts?
