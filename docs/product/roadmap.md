# YJackGameStudio Reference Roadmap

## Current Role

YJackGameStudio is the public open-source reference architecture and reusable
template for AI-native game studios. It defines a provider-neutral agentic game
studio template, an engine-neutral workflow standard, and a set of maintainable
production practices that can be adapted across tools and engines.

This repo remains useful without Loomlight Studio, without YJackCore, without
Unity, and without any specific AI provider.

Loomlight Studio is the separate commercial/productized autonomous AI game
studio platform. YJackCore is an optional Unity gameplay framework and low-code
authoring substrate. YJackGameStudio may document optional compatibility paths
for both, but this roadmap is for the public reference layer.

---

## Maintenance Priorities

The roadmap prioritizes maintenance and reference quality over commercial
product launch work.

- **Compatibility with AI tools**: Keep Codex, GitHub Copilot, Gemini CLI,
  Google Antigravity, Claude Code, and future tool adapters aligned with the
  provider-neutral `.agents/` source of truth.
- **Workflow reliability**: Keep skills, role boundaries, handoffs, and
  approval gates coherent and repeatable.
- **Documentation quality**: Keep README, reference docs, engine references, and
  contributor-facing docs accurate and internally consistent.
- **Schemas and contracts**: Harden work contracts, dependency expectations,
  write-set rules, and validation schemas.
- **Validation evidence**: Improve standards for automated checks, agent review,
  owner review, and manual validation debt.
- **Portability**: Preserve usefulness across Godot, Unity, Unreal, custom
  engines, and multiple AI tooling stacks.
- **Examples**: Provide small reference examples that demonstrate workflows
  without turning this repo into a game project.
- **Engine adapters**: Maintain optional engine-specific guidance without making
  any engine the default reference direction.

---

## Roadmap Themes

### REF-001 Repo Positioning and Ecosystem Split

Clarify that YJackGameStudio is the public open-source reference architecture,
Loomlight Studio is the productized platform, and YJackCore is an optional Unity
framework path.

Expected outputs:

- README positioning update.
- Reference positioning doc.
- Ecosystem map.
- Consistent language across public messaging.

### REF-002 Maintenance and Scope Policy

Define what belongs in this repository and what belongs elsewhere.

Expected outputs:

- Scope policy for YJackGameStudio.
- Boundary guidance for Loomlight Studio, YJackCore, downstream games, and
  provider adapters.
- Contribution acceptance checklist.

### REF-003 Provider/Tool Compatibility Upkeep

Keep tool-specific entrypoints aligned with the provider-neutral workflow layer.

Expected outputs:

- Updated compatibility notes for supported AI tools.
- Adapter guidance for new tools.
- Clear rules for when provider-specific files may diverge from `.agents/`.

### REF-004 Workflow/Schema Hardening

Improve the reliability of agent workflows and machine-readable contracts.

Expected outputs:

- Stronger work-contract examples.
- Clearer dependency and write-set rules.
- Better workflow phase definitions.
- More explicit escalation conditions.

### REF-005 Validation Evidence Standards

Make validation evidence harder to overstate and easier to audit.

Expected outputs:

- Improved evidence templates.
- Clear distinction between automated checks, agent review, owner review, and
  manual engine/editor checks.
- Validation output examples that tools can parse.

### REF-006 Engine-Neutral Example Pipelines

Add small examples that show how the reference architecture can be adapted
without creating a demo game inside this repo.

Expected outputs:

- Idea -> scoped production plan example.
- Brownfield adoption -> gap report example.
- GDD -> architecture -> work contract example.
- QA evidence aggregation example.
- Engine assumptions stated explicitly.

### REF-007 Optional YJackCore Integration Maintenance

Maintain YJackCore-aware routing as an optional Unity acceleration path.

Expected outputs:

- Clear detection and routing docs.
- Manual Unity validation expectations.
- Package-boundary protection rules.
- Generic Unity fallback guidance when YJackCore is absent.

### REF-008 Community Contribution Guidelines

Make contribution boundaries clear enough for outside maintainers.

Expected outputs:

- Good-fit and not-good-fit examples.
- Contributor checklist.
- Guidance for optional engine/provider/framework adapters.
- Documentation review expectations.

### REF-009 Reference Release/Versioning Policy

Define how this public reference layer communicates changes over time.

Expected outputs:

- Versioning guidance for templates, skills, and compatibility docs.
- Changelog expectations.
- Migration notes for breaking workflow changes.

### REF-010 Template Quality Audit

Audit templates, rules, skills, and docs for consistency with the open reference
architecture role.

Expected outputs:

- Stale wording report.
- Broken-link fixes.
- Template consistency pass.
- Validation command inventory.

---

## What Belongs Elsewhere

- Loomlight-specific visual UI belongs in Loomlight Studio.
- Hosted orchestration belongs in Loomlight Studio.
- Billing, accounts, private analytics, and commercial product workflows belong
  in Loomlight Studio.
- Unity gameplay framework features belong in YJackCore.
- YJackCore demos belong in Loomlight Studio or YJackCore demo repositories, not
  this roadmap.
- Downstream game content, scenes, builds, and project-specific implementation
  belong in downstream game repositories.

---

## Non-Goals

- No commercial dashboard in this repository.
- No hosted services in this repository.
- No mandatory YJackCore dependency.
- No Unity AI support claims.
- No prompt-to-game promises.
- No Loomlight-specific implementation.
- No Unity project setup or game demo milestone in this roadmap.
- No runtime, build, editor, or provider validation claims unless those checks
  actually ran and produced evidence.

---

## Contributor Direction

Useful next contributions are those that improve the public reference layer:

- Better docs.
- More precise schemas.
- More robust validation standards.
- Clearer work-contract examples.
- Optional provider/tool adapters.
- Optional engine-specific adapters that do not make an engine mandatory.
- Small reference pipelines that explain inputs, outputs, gates, and validation.

Contributors should keep changes small, explicit about assumptions, and honest
about what was not validated.

---

**Last Updated**: 2026-05-10
**Current Phase**: Public Reference Architecture Maintenance
**Next Milestone**: Repo positioning and template quality hardening
