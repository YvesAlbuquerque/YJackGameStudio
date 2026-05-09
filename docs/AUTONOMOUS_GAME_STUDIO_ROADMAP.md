# Autonomous Game Studio Roadmap

**Last Updated:** 2026-05-04

---

## 🎯 Vision

This roadmap moves Claude Code Game Studios from a **collaborative assistant framework** toward an **owner-directed autonomous studio operating system**.

Under this model:

- The **owner** sets intent and approval boundaries.
- **Agents** decompose, execute, validate, and report in parallel through issue-backed contracts.
- Work is driven by structured GitHub issues with defined schemas, dependencies, and ownership.
- Validation gates are autonomous and auditable, not just advisory.

This is not a shift toward fully unconstrained AI autonomy. The owner remains the director. What changes is the _surface area of delegation_: agents handle decomposition, scheduling, execution, and status reporting without requiring step-by-step instruction for every action.

---

## 🗂 Table of Contents

1. [Operating Model Shift](#1-operating-model-shift)
2. [Execution Order](#2-execution-order)
3. [Work Items](#3-work-items)
   - [AUTO-001: Owner-Directed Autonomy Modes and Approval Boundaries](#auto-001-owner-directed-autonomy-modes-and-approval-boundaries)
   - [AUTO-002: YJackCore Consumer Authority and Workspace Routing](#auto-002-yjackcore-consumer-authority-and-workspace-routing)
   - [AUTO-003: Game Studio Roadmap OS](#auto-003-game-studio-roadmap-os)
   - [AUTO-004: GitHub Issue Templates and Label Taxonomy](#auto-004-github-issue-templates-and-label-taxonomy)
   - [AUTO-005: Agent Work Contract Schema](#auto-005-agent-work-contract-schema)
   - [AUTO-006: Dependency Graph and File Ownership Protocol](#auto-006-dependency-graph-and-file-ownership-protocol)
   - [AUTO-007: Autonomous Sprint Planner and Issue Scheduler](#auto-007-autonomous-sprint-planner-and-issue-scheduler)
   - [AUTO-008: Team Skills as Issue-Driven Execution Planners](#auto-008-team-skills-as-issue-driven-execution-planners)
   - [AUTO-009: YJackCore-Backed Unity Project Bootstrap Templates](#auto-009-yjackcore-backed-unity-project-bootstrap-templates)
   - [AUTO-010: Autonomous Validation Gates](#auto-010-autonomous-validation-gates)
   - [AUTO-011: Skill-Test Executable CI](#auto-011-skill-test-executable-ci)
   - [AUTO-012: Autonomous Run Memory and Handoff Model](#auto-012-autonomous-run-memory-and-handoff-model)
   - [AUTO-013: Owner Dashboard and Autonomous Status Report](#auto-013-owner-dashboard-and-autonomous-status-report)
   - [AUTO-014: Risk Register and Escalation Policy](#auto-014-risk-register-and-escalation-policy)
   - [AUTO-015: Autonomous Brownfield Adoption for YJackCore-Backed Unity Projects](#auto-015-autonomous-brownfield-adoption-for-yjackcore-backed-unity-projects)
   - [AUTO-016: Documentation and Product-Positioning Drift](#auto-016-documentation-and-product-positioning-drift)
   - [AUTO-017: Autonomous Asset Pipeline Issue Generation](#auto-017-autonomous-asset-pipeline-issue-generation)
   - [AUTO-018: Multi-Agent QA and Playtest Evidence Workflow](#auto-018-multi-agent-qa-and-playtest-evidence-workflow)
4. [Architecture Impact](#4-architecture-impact)
5. [YJackCore Alignment](#5-yjackcore-alignment)
6. [Constraints and Non-Goals](#6-constraints-and-non-goals)

---

## 1. Operating Model Shift

### Current Model (Collaborative Assistant)

```
Owner: "Design a crafting system."
Agent: Asks questions → presents options → drafts → awaits approval → writes file.
```

Every step requires active owner participation. The agent is a consultant that waits for direction at each decision point.

### Target Model (Owner-Directed Autonomous Studio OS)

```
Owner: "Ship the crafting system MVP by sprint end. Auto-approve LOW risk decisions."
Agent: Reads intent → decomposes into issues → assigns to specialist agents →
       executes → validates → escalates MEDIUM/HIGH risk decisions → reports status.
```

The owner sets the approval boundary once. Agents handle the full decomposition-to-validation loop within that boundary. Only items outside the boundary surface for owner review.

### What Stays the Same

- The owner is always the creative director and final arbiter.
- All work is tracked in auditable GitHub issues with structured schemas.
- YJackCore package boundaries, low-code authoring model, and Unity manual validation requirements are preserved.
- Agents never bypass the owner on risk-classified decisions.

---

## 2. Execution Order

Work items must be implemented in the order below. Later items depend on contracts, schemas, and authority models established by earlier ones.

```
AUTO-001  Owner-directed autonomy modes and approval boundaries          [FOUNDATION]
AUTO-002  YJackCore consumer authority and workspace routing             [FOUNDATION]
AUTO-016  Documentation and product-positioning drift                    [FOUNDATION]
AUTO-003  Game Studio Roadmap OS                                         [INFRASTRUCTURE]
AUTO-004  GitHub Issue templates and label taxonomy                      [INFRASTRUCTURE]
AUTO-005  Agent work contract schema                                     [INFRASTRUCTURE]
AUTO-006  Dependency graph and file ownership protocol                   [INFRASTRUCTURE]
AUTO-007  Autonomous sprint planner and issue scheduler                  [EXECUTION]
AUTO-009  YJackCore-backed Unity project bootstrap templates             [EXECUTION]
AUTO-015  Autonomous brownfield adoption for YJackCore-backed Unity      [EXECUTION]
AUTO-008  Team skills as issue-driven execution planners                 [EXECUTION]
AUTO-010  Autonomous validation gates                                    [VALIDATION]
AUTO-011  Skill-test executable CI                                       [VALIDATION]
AUTO-012  Autonomous run memory and handoff model                        [VALIDATION]
AUTO-014  Risk register and escalation policy                            [GOVERNANCE]
AUTO-018  Multi-agent QA and playtest evidence workflow                  [QUALITY]
AUTO-013  Owner dashboard and autonomous status report                   [REPORTING]
AUTO-017  Autonomous asset pipeline issue generation                     [REPORTING]
```

---

## 3. Work Items

### AUTO-001: Owner-Directed Autonomy Modes and Approval Boundaries

**Goal:** Define the owner-facing control model that governs all autonomous agent behavior in the studio.

**Scope:**
- Define autonomy modes (e.g., `GUIDED`, `SUPERVISED`, `AUTONOMOUS`) that the owner selects per session or per project.
- Define approval boundary tiers (LOW / MEDIUM / HIGH risk) and what categories of decision fall into each.
- Document the escalation trigger: any action classified above the current autonomy mode boundary must pause and surface to the owner before proceeding.
- Establish where these settings are stored (likely `.agents/docs/technical-preferences.md` or a dedicated `production/autonomy-config.md`).

**Constraints:**
- Must not remove the owner from any HIGH risk decision regardless of mode.
- Modes must be reversible at any time without breaking in-flight work.

**Artifacts:** Autonomy mode specification in `.agents/docs/` and updated `AGENTS.md` collaboration protocol section.

---

### AUTO-002: YJackCore Consumer Authority and Workspace Routing

**Goal:** Clarify which authority governs YJackCore decisions and how agents route YJackCore-related work to the correct specialist.

**Scope:**
- Document the authority hierarchy: YJackCore's own `AGENTS.md` and `.agents/skills/` take precedence over the Game Studio generic Unity specialist.
- Define workspace routing rules: when a task touches `Packages/YJackCore/**` or `Packages/com.ygamedev.yjack/**`, it routes to the YJackCore-aware agent path.
- Update `.agents/rules/yjackcore-unity.md` if routing rules require clarification.
- Ensure the generic Unity fallback is used only when YJackCore-specific assets are absent.

**Constraints:**
- YJackCore package boundaries must remain intact; agents must not modify `Packages/YJackCore/**` without explicit owner authorization.
- Low-code authoring model must be preserved in all routing decisions.

**Artifacts:** Updated routing rules and authority documentation.

---

### AUTO-003: Game Studio Roadmap OS

**Goal:** Implement the operating-system layer that maintains the roadmap as a live, machine-readable artifact that agents can query and update.

**Scope:**
- Define how this roadmap document is kept in sync with GitHub issue state.
- Establish a schema or convention for roadmap entries that agents can parse.
- Define how new AUTO work items are registered and how completed items are marked.
- Provide a mechanism for agents to propose new roadmap items for owner review.

**Constraints:**
- The roadmap must remain readable by humans as a primary concern.
- Machine-readable sections must not degrade the human-readable experience.

**Artifacts:** Roadmap schema convention, update protocol documentation.

---

### AUTO-004: GitHub Issue Templates and Label Taxonomy

**Goal:** Standardize GitHub issue templates and labels to support structured autonomous work contracts.

**Scope:**
- Design issue templates for: agent work contracts, bug reports (autonomous), validation reports, escalation requests, and owner decisions.
- Define the label taxonomy: autonomy tier labels (`auto:low`, `auto:medium`, `auto:high`), domain labels (design, architecture, implementation, QA), and status labels.
- Templates must include all fields required by the agent work contract schema (AUTO-005).
- Update `.github/ISSUE_TEMPLATE/` with new templates.

**Constraints:**
- Existing `bug_report.md` and `feature_request.md` templates must remain functional.
- Labels must be consistent with the approval boundary model from AUTO-001.

**Artifacts:** New issue templates in `.github/ISSUE_TEMPLATE/`, label taxonomy document.

---

### AUTO-005: Agent Work Contract Schema

**Goal:** Define the structured schema that governs every autonomous agent work unit.

**Scope:**
- A work contract is the unit of autonomous delegation. Define its required fields: `contract_id`, `owner`, `specialist_agent`, `scope`, `inputs`, `outputs`, `risk_tier`, `approval_boundary`, `validation_criteria`, `escalation_conditions`.
- Define the contract lifecycle: `PROPOSED` → `APPROVED` → `IN_PROGRESS` → `BLOCKED` → `VALIDATED` → `CLOSED`.
- Document how contracts are stored (GitHub issues with structured front-matter, or YAML files in `production/`).
- Define how contracts reference each other for dependency tracking.

**Constraints:**
- Schema must be forward-compatible with AUTO-006 (dependency graph) and AUTO-007 (scheduler).
- Must not require custom tooling beyond standard Markdown and YAML.

**Artifacts:** Work contract schema specification in `.agents/docs/`, contract template.

---

### AUTO-006: Dependency Graph and File Ownership Protocol

**Goal:** Establish a machine-readable dependency graph for agent work contracts and a file ownership protocol to prevent conflicts.

**Scope:**
- Define how contracts declare file ownership (which files a contract reads, which it writes).
- Define conflict detection: two contracts with overlapping write scope cannot execute in parallel without explicit resolution.
- Establish the dependency graph format (e.g., YAML adjacency list in `production/`) and how agents read it before scheduling work.
- Define ownership transfer protocol: when a contract closes, how ownership is released or transferred.

**Constraints:**
- The graph must be human-readable and auditable.
- Conflict resolution must always escalate to the owner; agents cannot unilaterally resolve ownership conflicts.

**Artifacts:** Dependency graph schema, file ownership protocol documentation.

---

### AUTO-007: Autonomous Sprint Planner and Issue Scheduler

**Goal:** Upgrade the `/sprint-plan` skill to operate autonomously within owner-set constraints.

**Scope:**
- Given a set of approved work contracts, the sprint planner selects, sequences, and assigns contracts to specialist agents.
- Respects the dependency graph (AUTO-006) and approval boundary model (AUTO-001).
- Produces a machine-readable sprint schedule that agents can consume.
- Surfaces any unresolvable conflicts or boundary violations to the owner before execution begins.
- Integrates with the existing `production/sprints/` artifact format.

**Constraints:**
- The planner must not move `MEDIUM` or `HIGH` risk contracts to `IN_PROGRESS` without explicit owner approval.
- Sprint scope must remain bounded by the owner's stated sprint goal.

**Artifacts:** Updated `/sprint-plan` skill, sprint schedule schema.

---

### AUTO-008: Team Skills as Issue-Driven Execution Planners

**Goal:** Upgrade team coordination skills (`/team-combat`, `/team-narrative`, `/team-ui`, etc.) to generate and track GitHub issues as their execution plan.

**Scope:**
- Each team skill currently produces a coordination plan in Markdown. Extend this to also produce a set of agent work contracts (AUTO-005) as GitHub issues.
- Define how team skills decompose a feature into individual contracts and assign them to specialist agents.
- Ensure each contract has a `validation_criteria` that the team skill checks on completion.
- Provide a rollup report that the team skill posts back to the parent issue.

**Constraints:**
- Team skills must still produce human-readable coordination plans as a primary output.
- Issue generation must be idempotent: running a team skill twice on the same feature must not create duplicate contracts.

**Artifacts:** Updated team skill specifications, issue generation protocol.

---

### AUTO-009: YJackCore-Backed Unity Project Bootstrap Templates

**Goal:** Provide ready-to-use bootstrap templates for Unity projects that use YJackCore as their framework package.

**Scope:**
- Template project structure with correct `Packages/YJackCore/` layout and assembly definitions.
- Pre-wired `.agents/docs/technical-preferences.md` for Unity + YJackCore.
- Bootstrap script or instructions that initialize the project directory, configure the engine reference, and set up the workspace routing rules from AUTO-002.
- Integration with `/setup-engine` skill so that selecting Unity + YJackCore automatically applies the bootstrap template.

**Constraints:**
- Templates must respect YJackCore package boundaries.
- Must not embed proprietary YJackCore source; templates reference the package by path or registry entry only.

**Artifacts:** Bootstrap template files, `/setup-engine` skill update.

---

### AUTO-010: Autonomous Validation Gates

**Goal:** Make validation gates (`/gate-check`) executable autonomously rather than advisory-only.

**Scope:**
- Define machine-readable pass/fail criteria for each gate in `.agents/docs/workflow-catalog.yaml`.
- Implement an autonomous gate runner that evaluates criteria, produces a structured verdict, and either advances the phase or escalates to the owner.
- Gates that cannot be evaluated without human judgment must escalate with a clear description of what the owner needs to decide.
- Integrate gate results into work contract lifecycle (AUTO-005): a contract cannot close until its gate passes.

**Constraints:**
- Gate verdicts must always be auditable; the evidence for each pass/fail must be recorded.
- The owner can always override a gate verdict with an explicit decision record.

**Artifacts:** Updated `.agents/docs/workflow-catalog.yaml` with machine-readable criteria, gate runner specification.

---

### AUTO-011: Skill-Test Executable CI

**Goal:** Make `/skill-test` executable as a CI job so that skill changes are validated automatically on every PR.

**Scope:**
- Define a CI workflow (`.github/workflows/`) that runs the `/skill-test` suite against changed skills.
- `/skill-test` must produce a machine-readable report that CI can parse for pass/fail.
- Define the minimum test coverage required for a skill to be considered CI-ready.
- Integrate with the PR workflow: skill changes that do not pass `/skill-test` CI must not be merged without owner override.

**Constraints:**
- CI must not require any proprietary or paid services beyond what GitHub Actions provides.
- Existing skills must continue to work even before they have CI coverage.

**Artifacts:** CI workflow file, `/skill-test` report schema update.

---

### AUTO-012: Autonomous Run Memory and Handoff Model

**Goal:** Define how agents persist memory across sessions and hand off state to the next agent or session.

**Scope:**
- Extend the `production/session-state/` model to support structured handoff records.
- A handoff record captures: active contracts, pending decisions, last validated state, next scheduled action, and risk items requiring owner attention.
- Define when a handoff record is written (end of session, before escalation, after sprint completion).
- Agents starting a new session must read the handoff record and resume from the last validated state.

**Constraints:**
- Handoff records must not contain secrets or credentials.
- `production/session-state/` is a **tracked** directory (it holds a `.gitkeep`); working files written during a session (e.g., `active.md`) are not gitignored by default. `production/session-logs/` is gitignored. The implementation of this item must decide and document which path owns persistent handoff records and whether `production/session-state/active.md` should be gitignored, so that all agents and tooling handle ephemeral vs. persistent state consistently.

**Artifacts:** Handoff record schema, session-state lifecycle documentation update.

---

### AUTO-013: Owner Dashboard and Autonomous Status Report

**Goal:** Provide the owner with a concise, always-current view of autonomous studio activity.

**Scope:**
- Define a dashboard artifact (`production/dashboard.md` or equivalent) that summarizes: active contracts, pending owner decisions, completed work since last review, next scheduled actions, and open risk items.
- The dashboard is regenerated by agents after each significant state change.
- Provide a `/studio-status` skill (or extend `/sprint-status`) that produces the dashboard on demand.
- Define what "significant state change" means in terms of the contract lifecycle (AUTO-005).

**Constraints:**
- The dashboard must be readable at a glance; no scrolling required for the summary section.
- Owner decisions must be clearly distinguished from agent status items.

**Artifacts:** Dashboard schema, `/studio-status` skill (or `/sprint-status` extension).

---

### AUTO-014: Risk Register and Escalation Policy

**Goal:** Define how risks are identified, classified, tracked, and escalated throughout the autonomous studio workflow.

**Scope:**
- Define a risk register schema: `risk_id`, `description`, `likelihood`, `impact`, `risk_tier`, `owner`, `mitigation`, `status`.
- Define the escalation policy: which risk tiers trigger automatic escalation, what information is included in an escalation request, and what constitutes a valid owner response.
- Integrate the risk register with the work contract lifecycle (AUTO-005): contracts with unresolved HIGH risks cannot advance to `IN_PROGRESS`.
- Provide a `/risk-register` command or extend `/gate-check` to surface open risks at phase transitions.

**Constraints:**
- Risk classification must be deterministic for common scenarios; agents should not re-classify known risk patterns differently across sessions.
- The risk register must be auditable over the full project lifetime.

**Artifacts:** Risk register schema, escalation policy documentation, risk register template.

---

### AUTO-015: Autonomous Brownfield Adoption for YJackCore-Backed Unity Projects

**Goal:** Extend the `/adopt` skill to handle brownfield Unity projects that already use YJackCore.

**Scope:**
- Detect YJackCore package presence and version during the `/adopt` audit.
- Apply YJackCore-specific compliance checks: package boundary integrity, assembly definition structure, low-code authoring conventions.
- Produce a migration plan that respects YJackCore package authority (AUTO-002).
- Integrate with the bootstrap templates from AUTO-009 to provide a clear upgrade path.

**Constraints:**
- The `/adopt` skill must not modify files inside `Packages/YJackCore/**` without explicit owner authorization.
- The migration plan must be phased; agents cannot perform a big-bang migration autonomously.

**Artifacts:** Updated `/adopt` skill, YJackCore compliance check specification.

---

### AUTO-016: Documentation and Product-Positioning Drift

**Goal:** Correct positioning drift in existing documentation so that it accurately reflects the autonomous studio model rather than the collaborative assistant model.

**Scope:**
- Audit `docs/COLLABORATIVE-DESIGN-PRINCIPLE.md`, `docs/WORKFLOW-GUIDE.md`, `AGENTS.md`, and the README for language that positions the studio as purely assistant-driven.
- Update documentation to reflect the owner-directed autonomous model while preserving the owner-as-director principle.
- Ensure the updated docs clearly communicate what changes under the autonomous model and what stays the same.
- Update `README.md` product description to reflect the new positioning.

**Constraints:**
- Documentation updates must not contradict the collaborative design principles that still apply (owner is always the creative director).
- Changes must be reviewed by the owner before merge.

**Artifacts:** Updated `docs/COLLABORATIVE-DESIGN-PRINCIPLE.md`, `docs/WORKFLOW-GUIDE.md`, `AGENTS.md`, and `README.md`.

---

### AUTO-017: Autonomous Asset Pipeline Issue Generation

**Goal:** Upgrade `/asset-spec` to generate structured GitHub issues for each required asset, enabling autonomous tracking and delegation.

**Scope:**
- Extend `/asset-spec` output to produce agent work contracts (AUTO-005) as GitHub issues for each asset specification.
- Each asset issue captures: asset ID, spec reference, assignee agent, format requirements, size budget, and validation criteria.
- Define how asset issues link to the sprint plan and dependency graph (AUTO-006).
- Provide a rollup view of asset pipeline status that the owner can review at a glance.

**Constraints:**
- Issue generation must remain idempotent.
- Asset issues must reference the approved asset specification; they must not duplicate spec content.

**Artifacts:** Updated `/asset-spec` skill, asset issue template.

---

### AUTO-018: Multi-Agent QA and Playtest Evidence Workflow

**Goal:** Define how multiple agents coordinate to execute a QA plan and collect playtest evidence autonomously.

**Scope:**
- Extend `/qa-plan` to produce a set of agent work contracts (AUTO-005) that can be distributed across specialist QA agents.
- Define how QA agents collect, record, and validate test evidence against the acceptance criteria.
- Integrate with the `/playtest-report` skill to produce structured evidence that gates phase advancement (AUTO-010).
- Define how conflicting QA findings are escalated to the owner.

**Constraints:**
- QA evidence must be traceable to the GDD requirements they validate.
- No QA gate may be marked passed without evidence that satisfies the defined criteria.

**Artifacts:** Updated `/qa-plan` skill, QA evidence schema, `/playtest-report` integration specification.

---

## 4. Architecture Impact

This roadmap affects only the **AI operating model and repository workflow layer**. No game runtime code, engine bindings, or gameplay systems are modified by this roadmap.

Specifically:

| Layer | Impact |
|-------|--------|
| `.agents/` skills and docs | Updated and extended |
| `.github/` issue templates and workflows | New templates and CI workflow added |
| `docs/` workflow and design docs | Repositioning updates |
| `production/` schemas | New contract, dashboard, and risk register schemas |
| `src/` game source code | **No changes** |
| `design/` GDDs | **No changes** |
| Engine bindings | **No changes** |
| YJackCore package internals | **No changes** |

---

## 5. YJackCore Alignment

YJackCore-backed Unity projects are first-class targets of this roadmap. All work items must preserve the following YJackCore constraints:

1. **Package boundary integrity** — Agents must never modify files inside `Packages/YJackCore/**` or `Packages/com.ygamedev.yjack/**` without explicit owner authorization.

2. **Low-code authoring model** — Workflow and skill changes must not require YJackCore consumers to write engine-level C# code where the low-code path suffices.

3. **Unity manual validation requirements** — Gates that require Unity Editor validation (domain reload, Play Mode tests, build) must escalate to the owner. These cannot be autonomously confirmed.

4. **Framework-vs-product authority** — YJackCore's own `AGENTS.md` and `.agents/skills/` take precedence over the Game Studio generic Unity specialist for all YJackCore-specific decisions.

5. **Routing correctness** — Work touching YJackCore paths must route to the YJackCore-aware agent path as defined in AUTO-002, not the generic Unity fallback.

---

## 6. Constraints and Non-Goals

### Constraints

- The owner is always the creative director and final decision maker.
- No autonomous action may be taken above the owner's declared approval boundary for the session.
- All autonomous decisions must be auditable via GitHub issue history or session logs.
- The roadmap does not assume any specific game concept, genre, or engine beyond what is configured in `.agents/docs/technical-preferences.md`.

### Non-Goals

- This roadmap does not make agents fully autonomous without owner oversight.
- This roadmap does not modify any shipped game runtime code.
- This roadmap does not change the fundamental skill-based workflow — it extends it.
- This roadmap does not require agents to operate without a GitHub-backed issue contract.
- Removing the collaborative design principle for human-creative work (GDDs, art direction, narrative) is explicitly out of scope.
