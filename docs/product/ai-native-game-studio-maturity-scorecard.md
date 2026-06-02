# AI-Native Game Studio Maturity Scorecard

## Purpose

Use this document as a qualitative self-audit for an AI-native game studio
workflow. It is not an external benchmark, market ranking, certification, or
proof that one system is objectively "best."

The goal is to help teams inspect whether a workflow is ad hoc, documented,
operationalized, and honestly validated. YJackGameStudio can be evaluated with
this rubric, but the rubric is written so other systems can be evaluated too.

## What This Scorecard Does Not Claim

- It does not prove commercial viability or product-market fit.
- It does not measure game quality, fun, or shipped commercial success.
- It does not certify runtime reliability, build stability, or engine support.
- It does not validate hosted orchestration, external provider behavior, or AI
  model quality.
- It does not imply Unity AI integration, asset-generation capability, or a
  prompt-to-game workflow.

## Scoring Scale

Score each category from `0` to `3`.

| Score | Meaning |
| --- | --- |
| `0` | Missing or ad hoc. The capability is mostly implied, undocumented, or dependent on individual operator behavior. |
| `1` | Documented in one place, but not consistently operationalized. The idea exists, but evidence and repeatability are weak. |
| `2` | Operationalized through templates, workflows, examples, or explicit rules that another contributor could follow. |
| `3` | Operationalized and audited through validation evidence, owner gates, maintenance guidance, and clear limits on what is and is not proven. |

## How To Use It

1. Pick the workflow or repository you want to evaluate.
2. Score each category using only inspectable artifacts.
3. Record the evidence you used for each score.
4. Treat low scores as improvement opportunities, not branding failures.
5. Re-run the rubric when workflows, tools, engine assumptions, or governance
   rules materially change.

## Scorecard Categories

### 1. Role Coverage

**What good looks like**
The workflow defines distinct roles with clear responsibilities across design,
implementation, QA, production, and release work.

**Evidence to inspect**
- Agent or role definitions
- Workflow docs that route work to the right specialist
- Escalation or hierarchy rules

**Common weak signals**
- One assistant is expected to do everything
- Roles exist only as marketing language
- No boundary exists between design, implementation, and review work

**Relevant YJackGameStudio files**
- [`AGENTS.md`](../../AGENTS.md)
- [`.agents/agents/`](../../.agents/agents/)
- [`docs/WORKFLOW-GUIDE.md`](../WORKFLOW-GUIDE.md)

### 2. Workflow Coverage

**What good looks like**
The lifecycle from idea through release is represented by explicit workflows,
not only general advice.

**Evidence to inspect**
- Procedural skill files
- Workflow catalog or guide
- Phase or milestone documents

**Common weak signals**
- Implementation is emphasized but planning, QA, and release are informal
- Steps depend on tribal knowledge
- Cross-phase handoffs are undefined

**Relevant YJackGameStudio files**
- [`.agents/skills/`](../../.agents/skills/)
- [`docs/WORKFLOW-GUIDE.md`](../WORKFLOW-GUIDE.md)
- [`docs/product/roadmap.md`](roadmap.md)

### 3. Engine Neutrality

**What good looks like**
The workflow remains usable without forcing one engine, while still allowing
optional engine-specific adapters and references.

**Evidence to inspect**
- Engine selection docs
- Engine-specific specialist or adapter guidance
- Statements of what is optional versus mandatory

**Common weak signals**
- One engine is treated as the real path while others are nominal
- Validation claims assume tools are unavailable outside a single engine
- Engine-neutral docs quietly depend on one engine's concepts

**Relevant YJackGameStudio files**
- [`README.md`](../../README.md)
- [`AGENTS.md`](../../AGENTS.md)
- [`docs/product/repo-positioning.md`](repo-positioning.md)

### 4. Provider Neutrality

**What good looks like**
The workflow can be adapted across AI coding tools without one provider owning
the core operating model.

**Evidence to inspect**
- Tool-entrypoint documentation
- Provider compatibility mapping
- Shared source-of-truth guidance

**Common weak signals**
- Core behavior only exists in one vendor-specific layer
- Other providers are listed but not operationally supported
- Workflow language assumes one tool's features without translation rules

**Relevant YJackGameStudio files**
- [`AGENTS.md`](../../AGENTS.md)
- [`.agents/docs/tool-compatibility.md`](../../.agents/docs/tool-compatibility.md)
- [`.github/copilot-instructions.md`](../../.github/copilot-instructions.md)

### 5. Owner Control And Approval Gates

**What good looks like**
The workflow makes clear which decisions remain owner-controlled and which tasks
may execute autonomously.

**Evidence to inspect**
- Autonomy policy
- Hard-gate definitions
- Examples of escalation behavior

**Common weak signals**
- "Autonomous" is used without decision boundaries
- Approval rules are implied rather than written
- High-risk actions do not have explicit stop conditions

**Relevant YJackGameStudio files**
- [`production/autonomy-config.md`](../../production/autonomy-config.md)
- [`.agents/docs/autonomy-modes.md`](../../.agents/docs/autonomy-modes.md)
- [`AGENTS.md`](../../AGENTS.md)

### 6. Validation Evidence

**What good looks like**
The workflow distinguishes between checks that actually ran, checks that could
not run, and manual validation that is still required.

**Evidence to inspect**
- Validation scripts or hooks
- QA evidence docs
- Review templates that separate automated and manual proof

**Common weak signals**
- Validation language overstates what was proven
- Review and testing are collapsed into vague "it works" claims
- Manual editor or engine checks are omitted from the contract

**Relevant YJackGameStudio files**
- [`.agents/docs/tool-compatibility.md`](../../.agents/docs/tool-compatibility.md)
- [`docs/WORKFLOW-GUIDE.md`](../WORKFLOW-GUIDE.md)
- [`.agents/hooks/`](../../.agents/hooks/)

### 7. Work Contracts And Scope Boundaries

**What good looks like**
Tasks define scope, affected files or systems, non-goals, and escalation
conditions clearly enough to reduce hidden coupling and scope creep.

**Evidence to inspect**
- Skill docs that require scope declaration
- Contribution rules
- Planning docs with dependencies and non-goals

**Common weak signals**
- Tasks are broad requests without write boundaries
- Dependencies are discovered only after implementation starts
- No explicit rule prevents unrelated cleanup

**Relevant YJackGameStudio files**
- [`AGENTS.md`](../../AGENTS.md)
- [`docs/product/maintenance-and-scope.md`](maintenance-and-scope.md)
- [`docs/roadmap/ROADMAP-OS.md`](../roadmap/ROADMAP-OS.md)

### 8. Documentation Quality And Navigation

**What good looks like**
Core positioning, workflow, scope, and reference docs are easy to find and do
not contradict each other.

**Evidence to inspect**
- README entrypoints
- Directory-structure or workflow docs
- Product and scope documentation

**Common weak signals**
- Important authority docs are buried or duplicated
- Navigation assumes prior repo knowledge
- Product docs drift away from implementation docs

**Relevant YJackGameStudio files**
- [`README.md`](../../README.md)
- [`docs/product/public-messaging.md`](public-messaging.md)
- [`docs/product/repo-positioning.md`](repo-positioning.md)

### 9. Extensibility And Contribution Fit

**What good looks like**
Contributors can add workflows, providers, engines, or examples without
breaking the repo's core role as a public reference architecture.

**Evidence to inspect**
- Contribution fit guidance
- Shared source-of-truth rules
- Template or adapter directories

**Common weak signals**
- New work must be hard-coded into one provider path
- No clear rule separates reusable infrastructure from product-specific work
- Extensions require implicit maintainer knowledge

**Relevant YJackGameStudio files**
- [`docs/product/maintenance-and-scope.md`](maintenance-and-scope.md)
- [`docs/product/repo-positioning.md`](repo-positioning.md)
- [`.agents/`](../../.agents/)

### 10. Onboarding Clarity

**What good looks like**
A new contributor can determine where to start, which entrypoint to read, and
how to choose the next workflow.

**Evidence to inspect**
- Start or quick-start docs
- Tool entrypoint docs
- Project stage or help workflows

**Common weak signals**
- Setup depends on oral history or prior sessions
- Users must infer the first safe step
- Tool-specific entrypoints disagree about process

**Relevant YJackGameStudio files**
- [`README.md`](../../README.md)
- [`AGENTS.md`](../../AGENTS.md)
- [`.agents/skills/start/SKILL.md`](../../.agents/skills/start/SKILL.md)

### 11. Safety And Escalation Gates

**What good looks like**
The workflow explicitly identifies when agents must stop, surface uncertainty,
or defer to a human or a different process.

**Evidence to inspect**
- Escalation rules
- Risk-tier definitions
- Non-goals and hard-stop conditions

**Common weak signals**
- Failure handling is missing or purely aspirational
- Sensitive actions are treated like ordinary edits
- Approval rules do not map to concrete artifact paths or operations

**Relevant YJackGameStudio files**
- [`.agents/docs/autonomy-modes.md`](../../.agents/docs/autonomy-modes.md)
- [`AGENTS.md`](../../AGENTS.md)
- [`docs/product/maintenance-and-scope.md`](maintenance-and-scope.md)

### 12. Release Discipline

**What good looks like**
The workflow includes explicit release, QA, and sign-off expectations rather
than treating shipping as an afterthought.

**Evidence to inspect**
- Release workflows
- QA aggregation or sign-off docs
- Checklists for readiness and validation

**Common weak signals**
- Release steps are omitted from the lifecycle
- No distinction exists between "implementation complete" and "release ready"
- Validation debt is not surfaced before shipping

**Relevant YJackGameStudio files**
- [`docs/WORKFLOW-GUIDE.md`](../WORKFLOW-GUIDE.md)
- [`.agents/skills/release-checklist/SKILL.md`](../../.agents/skills/release-checklist/SKILL.md)
- [`.agents/skills/qa-evidence-aggregate/SKILL.md`](../../.agents/skills/qa-evidence-aggregate/SKILL.md)

## Optional Scoring Worksheet

Use a simple table when evaluating a workflow:

| Category | Score (0-3) | Evidence Used | Notes |
| --- | --- | --- | --- |
| Role coverage |  |  |  |
| Workflow coverage |  |  |  |
| Engine neutrality |  |  |  |
| Provider neutrality |  |  |  |
| Owner control and approval gates |  |  |  |
| Validation evidence |  |  |  |
| Work contracts and scope boundaries |  |  |  |
| Documentation quality and navigation |  |  |  |
| Extensibility and contribution fit |  |  |  |
| Onboarding clarity |  |  |  |
| Safety and escalation gates |  |  |  |
| Release discipline |  |  |  |

## How YJackGameStudio Should Use This

YJackGameStudio should use this scorecard as a public-facing self-audit tool,
not as proof of category leadership. A strong score should come from inspectable
artifacts such as workflows, docs, templates, examples, and validation
boundaries that a contributor can actually verify.

Good uses:

- Checking whether the public reference layer is becoming easier to adopt
- Finding weak spots in validation honesty or onboarding clarity
- Comparing planned improvements against the repo's stated scope

Bad uses:

- Claiming the repo is objectively the most mature option in the market
- Treating qualitative scores as third-party certification
- Hiding gaps behind broad marketing language

## Related Repo Authority Docs

- [`README.md`](../../README.md)
- [`AGENTS.md`](../../AGENTS.md)
- [`docs/product/public-messaging.md`](public-messaging.md)
- [`docs/product/repo-positioning.md`](repo-positioning.md)
- [`docs/product/maintenance-and-scope.md`](maintenance-and-scope.md)
- [`docs/product/roadmap.md`](roadmap.md)
- [`.agents/docs/tool-compatibility.md`](../../.agents/docs/tool-compatibility.md)
- [`.agents/docs/autonomy-modes.md`](../../.agents/docs/autonomy-modes.md)
