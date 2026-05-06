# Autonomous Game Studio Roadmap

Date: 2026-05-04
Repo: current repository (see `README.md` for canonical links)
Target state: owner-directed autonomous game studio, aligned with YJackCore.

## Conclusion

The project is a strong collaborative game-studio scaffold, not yet an autonomous studio operating system.

The core shift needed is from:

`user approves every workflow step`

to:

`owner sets strategy, budgets, risk tolerance, and approval boundaries; agents decompose, schedule, execute, validate, and report in parallel within those boundaries`.

YJackCore alignment should be explicit, not incidental. The Game Studio framework should treat YJackCore-backed Unity projects as a first-class product path with framework-aware routing, package boundaries, low-code authoring expectations, and manual Unity validation gates.

## Evidence From Repo Dive

Facts:

- The repo contains 49 agents, 72 skills, 12 hooks, 11 rules, and 39 docs templates.
- `README.md` positions the system as "collaborative, not autonomous."
- `docs/COLLABORATIVE-DESIGN-PRINCIPLE.md` requires Question -> Options -> Decision -> Draft -> Approval before writes.
- `.claude/docs/coordination-rules.md` documents subagent parallelism and experimental agent teams, but says agent teams are "not yet used in this project."
- `.claude/docs/workflow-catalog.yaml` defines a mature 7-phase game production pipeline.
- `.claude/skills/dev-story`, `story-readiness`, `story-done`, `create-epics`, and `create-stories` create a traceable story lifecycle, but remain conversation-first and approval-heavy.
- `CCGS Skill Testing Framework` exists and tracks 72 skill specs plus 49 agent specs, but recorded test result fields are empty.
- GitHub Issues were disabled on this repo at audit time and had to be enabled before creating this backlog.
- `.claude/docs/technical-preferences.md` has a Framework Integration section for YJackCore, but it is still unconfigured.
- `.claude/docs/yjackcore-support.md` correctly describes YJackCore detection and layer mapping.
- An audit-time local YJackCore checkout used for comparison showed package name `com.ygamedev.yjack`, version `1.6.0`, Unity `6000.0`, and dependencies on TextMeshPro, Cinemachine, Visual Scripting, Mathematics, and Input System; treat these as an external snapshot, not a repo-verifiable fact.
- External YJackCore documentation describes a low-code, inspector-first, ScriptableObject, UnityEvent, and Visual Scripting-friendly framework direction.
- External YJackCore materials reviewed during the audit indicate a Roadmap OS with structured tasks, priority, effort, generated roadmaps, GitHub Issues integration, L/XL decomposition rules, and planning-routing rules.

Inferences:

- The fastest path to "state of the art" is not more agents. It is an issue-native operating model that lets existing agents work from structured contracts.
- YJackCore's Roadmap OS is the strongest local pattern to reuse for autonomous backlog, decomposition, labels, and issue lifecycle.
- The biggest architecture risk is letting "autonomy" bypass the design, ADR, manifest, and validation contracts that already make this repo useful.
- The biggest product risk is keeping the system file-approval-bound while calling it autonomous. That will not scale to parallel execution.

Open questions:

- Whether autonomous runs should be supported inside Claude Code only, across Codex/GitHub/Copilot/etc., or through a vendor-neutral file contract first.
- Whether issue creation should remain manual/CLI-driven in this repo or be automated like YJackCore's Roadmap OS.
- Whether the current "collaborative protocol" remains the default mode, with "autonomous mode" opt-in, or whether the product positioning changes globally.

## Product Principles

1. Owner owns intent, risk, scope, budget, and final creative/product tradeoffs.
2. Agents own decomposition, execution planning, implementation, validation, and reporting inside explicit boundaries.
3. Issues become the work contract, not chat history.
4. Parallel work requires file ownership, dependency order, validation evidence, and handoff notes.
5. YJackCore-backed Unity projects must default to framework-aware routing before custom architecture.
6. Autonomy must be bounded by proof: tests, static checks, review gates, playtest evidence, or manual Unity validation notes.
7. Large work is decomposed before implementation. `L` and `XL` issues are parent coordination surfaces.

## MVP 1: Owner-Directed Issue-Backed Planning

The first milestone is intentionally narrow. It does not require autonomous execution.
It requires the infrastructure that makes autonomous execution safe.

**Goal**: An owner can state a game goal, select an autonomy mode, and YJackGameStudio
can create structured, dependency-aware, validation-aware issues with YJackCore-aware routing.

**MVP 1 is complete when all of the following are true:**

| Criterion | Artefact |
|-----------|----------|
| Autonomy mode is explicit | `.agents/docs/autonomy-modes.md` exists and is referenced from `AGENTS.md` |
| YJackCore routing is explicit | `.agents/docs/yjackcore-authority.md` and `.agents/docs/yjack-workspace-manifest.md` exist |
| Work contract schema exists | `.agents/docs/work-contract-schema.md` defines all required fields and lifecycle states |
| Issue templates can represent agent work | `.github/ISSUE_TEMPLATE/agent_work.md` captures owner intent, scope, non-goals, dependencies, write set, risk tier, validation evidence, and YJackCore fields |
| File ownership and dependency rules exist | Work contract schema defines write-set exclusivity and dependency ordering |
| Validation evidence is defined before scheduling | `.agents/docs/validation-evidence.md` defines the evidence packet and honesty rules |

MVP 1 does **not** require:
- Autonomous sprint scheduling (AUTO-007)
- Parallel agent execution (AUTO-006)
- Executable CI (AUTO-011)
- Owner dashboard (AUTO-013)

Those belong to MVP 2 and beyond.

---

## Roadmap

### Phase 0: Product Alignment and Authority

Goal: define what autonomous means without breaking the current safety model.

Deliverables:

- Owner-directed autonomy model.
- Approval boundary matrix.
- YJackCore framework-vs-product authority model.
- Documentation cleanup where the repo says conflicting counts or outdated claims.

Exit criteria:

- A user can choose collaborative, supervised autonomous, or trusted autonomous mode.
- A YJackCore-backed Unity project has an explicit routing path and framework authority boundary.

### Phase 1: Issue-Native Studio OS

Goal: make GitHub Issues and roadmap files the canonical work queue.

Deliverables:

- Labels, priority, effort, phase, domain, and YJackCore tags.
- Roadmap OS adapted from YJackCore.
- Issue templates for epics, stories, bugs, agent work shards, validation tasks, and planning tasks.
- Dependency and ownership fields.

Exit criteria:

- Agents can pick independent issues and understand scope, dependencies, write ownership, validation, and handoff expectations without re-reading the whole project.

### Phase 2: Parallel Agent Execution

Goal: let agents safely work in parallel.

Deliverables:

- Agent work contract schema.
- File ownership and lock protocol.
- Parallel shard planning skill.
- Team skill refactor from conversation-first orchestration to issue-driven execution plans.
- YJackCore-specific Unity templates and technical preferences.

Exit criteria:

- A feature can be split into independent implementation, docs, tests, UX, art, and QA shards with clear non-overlapping write scopes.

### Phase 3: Autonomous Validation and Evidence

Goal: agents prove completion without relying on vague summaries.

Deliverables:

- Executable skill-test CI.
- Autonomous validation gates.
- QA evidence workflow.
- Manual Unity validation templates for YJackCore.
- Owner dashboard/reporting surface.

Exit criteria:

- Every autonomous run closes with evidence: checks run, files changed, acceptance criteria mapped, unresolved risk, and manual validation still required.

### Phase 4: Studio Operations

Goal: support full production flow beyond code.

Deliverables:

- Asset pipeline issue generation.
- Release/live-ops issue workflows.
- Memory and handoff model compatible with YJackCore Sleep/Note.
- Metrics for cycle time, blocked issues, validation debt, and agent throughput.

Exit criteria:

- The owner can operate the studio from the issue board and periodic status reports rather than from a single chat session.

## Issue Backlog

### AUTO-001: Define owner-directed autonomy modes and approval boundaries

Labels: `roadmap`, `type: epic`, `priority: p0`, `effort: l`, `domain: owner-experience`, `phase: 0-product-alignment`, `autonomy`

Create the product contract for collaborative, supervised autonomous, and trusted autonomous operation.

Acceptance criteria:

- Defines what agents may do without asking in each mode.
- Defines what always requires owner approval.
- Explains how file writes, GitHub issues, branches, commits, PRs, and releases are gated per mode.
- Updates README and collaborative docs without losing the existing safety model.
- Includes rollback/escalation language for autonomous mistakes.

### AUTO-002: Add YJackCore consumer authority and workspace routing

Labels: `roadmap`, `type: feature`, `priority: p0`, `effort: m`, `domain: yjackcore`, `phase: 0-product-alignment`, `yjackcore`

Make YJackCore-backed Unity projects first-class in Game Studio.

Acceptance criteria:

- Documents framework-vs-product authority for YJackCore consumers.
- Adds or adapts a `.yjack-workspace.json` style manifest for path resolution.
- Updates `.claude/docs/technical-preferences.md` setup guidance for YJackCore.
- Routes Unity + YJackCore tasks to YJackCore layer rules before generic Unity advice.
- Includes manual Unity validation expectations.

### AUTO-003: Build a Game Studio Roadmap OS modeled on YJackCore

Labels: `roadmap`, `type: epic`, `priority: p0`, `effort: l`, `domain: production`, `phase: 1-issue-os`, `automation`

Adapt the YJackCore Roadmap OS pattern to this repo.

Acceptance criteria:

- Adds structured task files for bugs, improvements, features, and autonomous work.
- Defines ID, subsystem, priority, effort, status, description, notes fields.
- Adds validation and generation scripts.
- Adds duplicate-safe GitHub Issue creation.
- Documents L/XL decomposition rules and planning-first Phase 1 behavior.

### AUTO-004: Create GitHub Issue templates and label taxonomy for autonomous work

Labels: `roadmap`, `type: feature`, `priority: p0`, `effort: s`, `domain: production`, `phase: 1-issue-os`, `github`

Make issues usable as agent work contracts.

Acceptance criteria:

- Adds templates for epic, story, agent shard, validation, bug, and product decision.
- Adds labels for priority, effort, phase, domain, type, autonomy, and YJackCore.
- Documents label meanings.
- Ensures every autonomous issue can state owner intent, scope, dependencies, write set, validation, and handoff.

### AUTO-005: Define the agent work contract schema

Labels: `roadmap`, `type: feature`, `priority: p0`, `effort: m`, `domain: orchestration`, `phase: 1-issue-os`, `autonomy`

Define the machine-readable contract agents use before starting work.

Acceptance criteria:

- Defines required fields: owner goal, success criteria, non-goals, dependencies, write ownership, read context, validation, manual checks, doc impact, YJackCore layer.
- Provides a markdown issue form and optional YAML/JSON representation.
- Documents how agents update status and hand off partial work.
- Supports parallel execution without shared-file collisions.

### AUTO-006: Add dependency graph and file ownership protocol for parallel agents

Labels: `roadmap`, `type: feature`, `priority: p0`, `effort: l`, `domain: orchestration`, `phase: 2-parallel-execution`, `autonomy`

Prevent parallel agents from conflicting.

Acceptance criteria:

- Defines issue dependencies and blocked/unblocked states.
- Defines file ownership and read-only consultation rules.
- Defines conflict handling when two agents need the same file.
- Adds checks or scripts that can detect overlapping write sets before work starts.
- Includes guidance for Unity `.meta` files and YJackCore package boundaries.

### AUTO-007: Add autonomous sprint planner and issue scheduler

Labels: `roadmap`, `type: feature`, `priority: p1`, `effort: l`, `domain: production`, `phase: 2-parallel-execution`, `automation`

Turn backlog into parallelizable sprint work.

Acceptance criteria:

- Reads roadmap/issues and proposes a sprint based on priority, dependencies, effort, and available agent lanes.
- Separates sequential blockers from parallel sidecar tasks.
- Produces a sprint plan with owner approval required only at sprint boundary.
- Marks issue readiness before scheduling.
- Integrates with `production/sprint-status.yaml`.

### AUTO-008: Refactor team skills into issue-driven execution planners

Labels: `roadmap`, `type: epic`, `priority: p1`, `effort: xl`, `domain: skills`, `phase: 2-parallel-execution`, `autonomy`

Convert `team-*` skills from conversational coordination into issue-backed plans.

Acceptance criteria:

- Starts with a planning/docs-first child issue.
- Defines a common team orchestration pattern for all `team-*` skills.
- Produces child issues for design, architecture, implementation, tests, art/audio/UX, and QA.
- Preserves explicit owner decision points for creative and high-risk tradeoffs.
- Allows agents to execute independent child issues in parallel.

### AUTO-009: Add YJackCore-backed Unity project bootstrap templates

Labels: `roadmap`, `type: feature`, `priority: p1`, `effort: m`, `domain: yjackcore`, `phase: 2-parallel-execution`, `yjackcore`

Create a first-class setup path for Unity + YJackCore games.

Acceptance criteria:

- Provides templates for `AGENTS.md`, `ARCHITECTURE.md`, technical preferences, and framework docs.
- Supports UPM, sibling checkout, submodule, vendor, and inline framework layouts.
- Records YJackCore version, source, package path, and layer routing.
- Includes YJackCore low-code authoring defaults: ScriptableObjects, UnityEvents, Visual Scripting, inspector-first setup.
- Clearly separates game repo changes from YJackCore package changes.

### AUTO-010: Build autonomous validation gates

Labels: `roadmap`, `type: feature`, `priority: p1`, `effort: l`, `domain: validation`, `phase: 3-validation-evidence`, `automation`

Let agents verify work without implying unrun tests.

Acceptance criteria:

- Defines standard validation evidence for docs, skills, hooks, Unity/YJackCore work, and issue lifecycle work.
- Adds scripts or checklists for static validation.
- Records checks run, checks unavailable, and manual validation still required.
- Integrates with `/story-done`, `/gate-check`, and `/team-qa`.
- Provides YJackCore-specific manual validation templates for Unity scene/prefab/package checks.

### AUTO-011: Turn skill-test framework into executable CI

Labels: `roadmap`, `type: feature`, `priority: p1`, `effort: m`, `domain: validation`, `phase: 3-validation-evidence`, `ci`

Move skill quality from documented intent to automated enforcement.

Acceptance criteria:

- Adds a scriptable validator for static skill checks.
- Adds CI workflow for skill and agent catalog consistency.
- Records test results back to the catalog only through an explicit update step.
- Flags count drift between README, workflow docs, and actual files.
- Produces a concise report usable in PR review.

### AUTO-012: Create autonomous run memory and handoff model

Labels: `roadmap`, `type: feature`, `priority: p1`, `effort: m`, `domain: memory`, `phase: 3-validation-evidence`, `autonomy`

Make long-running parallel work resumable.

Acceptance criteria:

- Defines short-term run notes, handoff summaries, and durable lessons.
- Aligns with YJackCore Sleep/Note separation.
- Avoids making chat history the only source of truth.
- Adds retention rules so memory does not become unbounded.
- Supports per-issue handoff notes for agents joining active work.

### AUTO-013: Add owner dashboard and autonomous status report

Labels: `roadmap`, `type: feature`, `priority: p2`, `effort: m`, `domain: owner-experience`, `phase: 3-validation-evidence`, `reporting`

Give the owner a concise view of the studio.

Acceptance criteria:

- Shows active issues, blocked issues, validation debt, decisions needed, and risks.
- Separates facts from recommendations.
- Includes "what agents can do next without me" and "what needs owner decision."
- Can be generated from issues and production state.
- Does not require reading every agent transcript.

### AUTO-014: Add risk register and escalation policy

Labels: `roadmap`, `type: feature`, `priority: p1`, `effort: s`, `domain: production`, `phase: 3-validation-evidence`, `autonomy`

Define when autonomous agents must stop and escalate.

Acceptance criteria:

- Defines risk classes: architecture, data loss, YJackCore package boundary, Unity scene/prefab wiring, scope creep, legal/release, monetization, player safety.
- Defines stop conditions and owner approval triggers.
- Adds issue labels for blocked, needs-owner, and risk categories.
- Integrates with agent work contract and validation reports.

### AUTO-015: Add autonomous brownfield adoption for YJackCore-backed Unity projects

Labels: `roadmap`, `type: feature`, `priority: p1`, `effort: l`, `domain: yjackcore`, `phase: 2-parallel-execution`, `yjackcore`

Upgrade `/adopt` for existing Unity projects that already consume YJackCore.

Acceptance criteria:

- Detects YJackCore by package manifest, submodule, local package path, or explicit technical preferences.
- Audits game artifacts without modifying YJackCore package files.
- Produces a migration plan split into parallelizable issues.
- Maps game systems to YJackCore GameLayer, LevelLayer, PlayerLayer/CoreLayer, ViewLayer, and Shared.
- Flags what requires manual Unity validation.

### AUTO-016: Fix documentation and product-positioning drift

Labels: `roadmap`, `type: docs`, `priority: p1`, `effort: s`, `domain: docs`, `phase: 0-product-alignment`, `documentation`

Clean up inconsistencies found during the repo dive.

Acceptance criteria:

- Aligns README, WORKFLOW-GUIDE, and CCGS testing docs on agent/skill/template counts.
- Updates old "48 agents / 68 skills / 66 commands" references where incorrect.
- Explains collaborative vs autonomous modes consistently.
- Links the new roadmap and issue operating model.
- Keeps existing collaborative protocol available as a safe default.

### AUTO-017: Create autonomous asset pipeline issue generation

Labels: `roadmap`, `type: feature`, `priority: p2`, `effort: m`, `domain: assets`, `phase: 4-studio-operations`, `automation`

Turn art bible and asset specs into production-ready asset issues.

Acceptance criteria:

- Reads art bible, asset manifest, GDDs, and UX docs.
- Creates asset issues with owner intent, style constraints, file targets, generation/authoring prompts, acceptance criteria, and validation.
- Separates concept art, production assets, UI assets, VFX, audio, and implementation hookup.
- Includes YJackCore/Unity import and `.meta` handling rules where relevant.

### AUTO-018: Add multi-agent QA and playtest evidence workflow

Labels: `roadmap`, `type: feature`, `priority: p1`, `effort: l`, `domain: qa`, `phase: 3-validation-evidence`, `automation`

Make QA evidence scalable across parallel agents.

Acceptance criteria:

- Defines evidence artifacts for unit, integration, UI, visual/feel, playtest, and release checks.
- Allows `qa-tester` lanes to run independent story evidence tasks.
- Aggregates evidence into sprint and milestone sign-off.
- Flags unverifiable criteria and manual checks without overclaiming.
- Feeds `/gate-check` and owner dashboard.

## Recommended Implementation Order

Contracts, validation, and ownership come before autonomous scheduling.
The order below reflects that dependency.

| Step | Issues | Rationale |
|------|--------|-----------|
| 1 | AUTO-001 | Define what autonomous means — gate on this before everything else |
| 2 | AUTO-002 | YJackCore routing must be explicit before any Unity work is scheduled |
| 3 | AUTO-016 | Fix doc/positioning drift so later docs are grounded in consistent facts |
| 4 | AUTO-005 | Work contract schema is the contract layer — needed before issues or scheduling |
| 5 | AUTO-004 | Issue templates and label taxonomy encode the contract in GitHub |
| 6 | AUTO-006 | File ownership and dependency rules prevent parallel conflicts |
| 7 | AUTO-010 | Validation evidence must be defined before autonomous runs claim completion |
| 8 | AUTO-003 | Roadmap OS can now be built on top of the contract + validation layer |
| 9 | AUTO-007 | Sprint scheduler only makes sense once contracts and labels exist |
| 10 | AUTO-009 | YJackCore Unity bootstrap builds on the routing + contract layer |
| 11 | AUTO-015 | Brownfield adoption requires the manifest spec and bootstrap templates |
| 12 | AUTO-008 | Team skill refactor is safest after contract schema and ownership rules exist |
| 13 | AUTO-011 | CI for skills — builds on the validation evidence framework |
| 14 | AUTO-012 | Memory and handoff model — builds on validation and contract output |
| 15 | AUTO-014 | Risk register and escalation policy — informed by real contract experience |
| 16 | AUTO-018 | Multi-agent QA workflow — builds on validation + parallel execution |
| 17 | AUTO-013 | Owner dashboard — synthesizes issue and validation state |
| 18 | AUTO-017 | Asset pipeline issue generation — studio ops, last phase |

## Architecture Impact

This roadmap changes the Game Studio operating model and AI infrastructure. It does not change game runtime code directly.

YJackCore impact is integration-facing only: Game Studio should consume YJackCore guidance, package boundaries, layer rules, and low-code authoring priorities. It should not modify the YJackCore package unless a future issue explicitly targets that repo.

## Doc Impact

Expected docs affected:

- `README.md`
- `CLAUDE.md`
- `.claude/docs/coordination-rules.md`
- `.claude/docs/yjackcore-support.md`
- `.claude/docs/workflow-catalog.yaml`
- `docs/COLLABORATIVE-DESIGN-PRINCIPLE.md`
- `docs/WORKFLOW-GUIDE.md`
- new roadmap and issue operating docs under `docs/`
- possible updates under `CCGS Skill Testing Framework/`

## Manual Validation Still Required

- Confirm the owner wants GitHub Issues to remain enabled for this public repo.
- Confirm the preferred autonomy default: collaborative, supervised autonomous, or trusted autonomous.
- Validate YJackCore bootstrap behavior against at least one real Unity project consuming `com.ygamedev.yjack`.
- Validate any Unity/YJackCore generated guidance in Unity Editor, including package resolution, scene/prefab wiring, and manual Play Mode flows.
