# YJackGameStudio Roadmap

## Current Status: Public Operating Model Phase

**YJackGameStudio** is maintained as the open-source reference architecture for
AI-native game production workflows. The roadmap is no longer to build the
commercial product inside this repo. The roadmap is to maintain and evolve the
public operating model: reusable agents, workflows, contracts, validation
standards, examples, and provider-neutral compatibility guidance.

Loomlight Studio is the separate commercial/productized platform. YJackCore is
an optional but recommended Unity acceleration path. YJackGameStudio remains
useful without either one.

---

## Roadmap Principles

- Keep `.agents/` as the provider-neutral source of truth.
- Preserve Godot, Unity, and Unreal support.
- Preserve owner-directed autonomy and hard approval gates.
- Treat YJackCore as optional, never mandatory.
- Treat Unity AI and other external AI systems as separate tools unless real
  integration exists and is validated.
- Prefer reusable standards, examples, and compatibility layers over
  proprietary product features.
- Do not claim runtime, build, editor, provider, or AI-service validation unless
  it actually happened.

---

## Ecosystem Maintenance

Goal: Keep the open repository coherent, active, and easy to extend.

Planned work:

- Maintain README, product docs, and repository positioning.
- Keep `AGENTS.md`, tool adapters, and `.agents/docs/tool-compatibility.md`
  aligned.
- Review terminology for engine/provider neutrality.
- Keep counts, entrypoints, and directory maps accurate as agents, skills,
  rules, hooks, and templates change.
- Preserve compatibility with Claude Code legacy assets while authoring shared
  workflow changes in `.agents/` first.

Validation:

- Link checks for public docs.
- Search checks for deprecated or misleading positioning.
- Static validation for skill and schema changes where scripts exist.

## Compatibility Roadmap

Goal: Make YJackGameStudio portable across AI tools, engines, and project
layouts.

Planned work:

- Maintain adapters for Codex, GitHub Copilot, Gemini CLI, Google Antigravity,
  and Claude Code.
- Add compatibility notes for emerging AI coding tools when they can consume the
  repo's provider-neutral instructions.
- Keep engine setup guidance explicit: no engine is assumed until configured.
- Improve brownfield adoption guidance for existing Godot, Unity, Unreal, and
  custom-engine projects.
- Keep optional YJackCore routing isolated from generic Unity routing.

Out of scope here:

- Provider-owned SDK implementation code.
- Hosted account, billing, or enterprise setup.
- Loomlight-specific orchestration.

## Agent/Provider Portability

Goal: Make agent workflows executable by different AI systems without rewriting
the studio model.

Planned work:

- Document capability translation for tools with different names for read,
  search, edit, shell, delegation, and web access.
- Keep role definitions and skills readable as plain Markdown.
- Add provider-neutral examples for task delegation, work contracts, and
  validation evidence.
- Avoid relying on hidden model behavior or provider-specific memory.
- Capture provider assumptions explicitly in adapter docs.

Validation:

- Run skill static checks when workflow files change.
- Verify examples do not require unavailable provider features unless marked as
  adapter-specific.

## Workflow Standards

Goal: Evolve common production workflows into reusable standards.

Planned work:

- Improve start, adoption, design, architecture, story, QA, release, and
  retrospective workflows.
- Keep workflow phases explicit: inputs, decisions, outputs, validation, and
  escalation conditions.
- Preserve the Question -> Options -> Decision -> Draft -> Approval loop for
  design and architecture work.
- Add more examples that demonstrate owner-directed autonomy without hiding
  decisions.

Reference areas:

- `.agents/skills/`
- `.agents/docs/workflow-catalog.md`
- `.agents/docs/templates/`

## Validation Standards

Goal: Make trust depend on evidence, not agent confidence.

Planned work:

- Improve validation-output schemas and machine-readable reports.
- Expand examples for automated checks, agent review, owner review, and manual
  validation debt.
- Keep BLOCKING vs ADVISORY evidence distinctions clear.
- Document engine/editor validations that remain manual.
- Preserve the rule that no Unity Editor, Play Mode, build, or Unity AI result
  is claimed unless actually run and confirmed.

Reference areas:

- `.agents/schemas/validation-output.schema.json`
- `.agents/docs/qa-evidence-task-schema.md`
- `.agents/docs/autonomy-modes.md`
- `.agents/docs/work-contract-schema.md`

## Reference Implementations

Goal: Provide small, inspectable examples that prove the operating model without
turning the repo into a product runtime.

Planned work:

- Add engine-neutral sample work contracts.
- Add Godot, Unity, and Unreal planning examples with clear assumptions.
- Add optional Unity/YJackCore examples that demonstrate framework-aware routing
  without making YJackCore mandatory.
- Add example QA evidence packets and owner dashboard outputs.
- Keep examples small enough to audit.

Non-goals:

- Shipping a proprietary Loomlight demo here.
- Adding commercial dashboard UI.
- Adding hosted orchestration code.
- Claiming game generation or editor validation that has not been performed.

## Example Pipelines

Goal: Show how teams can adapt the reference architecture to real workflows.

Planned pipelines:

- Idea -> scoped production plan.
- Brownfield project adoption -> gap report.
- GDD set -> architecture and ADRs.
- Approved story -> implementation contract -> validation evidence.
- Sprint plan -> QA evidence aggregation -> gate-check report.
- Optional Unity/YJackCore plan -> layer map -> manual validation checklist.

Each pipeline should include:

- Inputs.
- Expected outputs.
- Approval gates.
- Validation expectations.
- Known manual checks.
- Engine/provider assumptions.

## Documentation Quality

Goal: Keep the public docs accurate enough for contributors and agents to use.

Planned work:

- Maintain product positioning, ecosystem map, and scope docs.
- Keep README links current.
- Add decision records when the public operating model changes materially.
- Remove or mark historical productization notes that no longer describe this
  repo's role.
- Keep public messaging aligned with the repo being active, open-source,
  provider-neutral, and engine-neutral.

Validation:

- `git diff --check`.
- Link checks for internal Markdown links.
- Search checks for misleading claims.

## Extensibility

Goal: Make the repo easy to adapt without fragmenting the shared standards.

Planned work:

- Document how to add agents, skills, rules, templates, and provider adapters.
- Add contribution evaluation guidance in
  `docs/product/maintenance-and-scope.md`.
- Keep optional framework integrations modular.
- Support project-local customization without forcing upstream adoption.
- Preserve clear boundaries between shared `.agents/` assets and compatibility
  layers such as `.claude/`, `.github/`, `.gemini/`, and `.agent/`.

---

## De-Emphasized in This Repo

The following may matter for Loomlight Studio or separate products, but they are
not the roadmap center for YJackGameStudio:

- Product UX.
- Proprietary orchestration.
- Commercial dashboard surfaces.
- Hosted services.
- Billing, accounts, and monetization.
- Loomlight-specific workflows.
- Engine-specific hard coupling.
- Provider-specific AI model features.

---

## Current Priorities

1. Stabilize public positioning and ecosystem boundaries.
2. Improve compatibility docs for multiple AI tools.
3. Strengthen work-contract and validation standards.
4. Add small reference pipelines that work without YJackCore or Loomlight Studio.
5. Add optional YJackCore-aware examples that remain clearly scoped to Unity.
6. Improve documentation quality and internal link consistency.

---

## Maintenance Notes

- Autonomy remains owner-directed. Hard gates in
  `.agents/docs/autonomy-modes.md` remain authoritative.
- Work contracts remain the core unit for safe delegation.
- Validation evidence remains the trust boundary.
- YJackCore remains optional.
- Unity AI remains external; no integration is claimed.
- Loomlight Studio remains separate from this open-source repo.

---

**Last Updated**: 2026-05-10
**Current Phase**: Public Operating Model
**Next Milestone**: Compatibility and reference-pipeline hardening
