# Owner-Directed Autonomy Modes and Approval Boundaries

**Version:** 1.0  
**Last Updated:** 2026-05-04  
**Source:** [AUTO-001] from `docs/AUTONOMOUS_GAME_STUDIO_ROADMAP.md`

---

## Overview

This document defines the three autonomy modes an owner may select and the
approval boundaries that govern agent behavior in each mode. It is the product
contract for collaborative, supervised autonomous, and trusted autonomous
operation within Agentic Game Studios.

The owner is always the creative director and final arbiter. Autonomy modes
control the _delegation surface_ — the set of decisions agents may execute
without pausing for owner review. Modes do not replace owner authority; they
extend the delegation scope within boundaries the owner sets explicitly.

---

## Modes at a Glance

| Mode | Tag | Default? | Summary |
|------|-----|----------|---------|
| Guided | `GUIDED` | ✅ Yes | Every decision surfaced. Classic Question → Options → Decision → Draft → Approval loop. |
| Supervised | `SUPERVISED` | — | LOW-risk decisions executed autonomously. MEDIUM and HIGH still require owner approval. |
| Autonomous | `AUTONOMOUS` | — | LOW and MEDIUM decisions executed autonomously. HIGH decisions always pause for owner. |

> **Hard rule**: No mode — not even `AUTONOMOUS` — bypasses owner approval for
> HIGH-risk decisions. The owner can never be removed from HIGH-risk actions.

---

## Setting the Mode

The active mode is stored in `production/autonomy-config.md` (created on first
use; see [Configuration File Format](#configuration-file-format) below).

Agents read this file at the start of every session. If the file is absent, the
mode defaults to `GUIDED`.

The owner may change the mode at any time by editing `production/autonomy-config.md`.
File edits take effect at the start of the next session. To switch modes
immediately within the current session, ask any agent to apply the change:

```
"Set autonomy mode to SUPERVISED for this session."
"Switch to AUTONOMOUS mode."
"Return to GUIDED mode."
```

An in-session instruction takes effect immediately for the remainder of the
session. It does not modify `production/autonomy-config.md` unless the owner
asks to persist the change. In-flight work is not interrupted; the new boundary
applies to the next pending decision.

---

## Risk Tier Classification

All agent decisions and actions are classified into three risk tiers.

### LOW — Execute autonomously in SUPERVISED and AUTONOMOUS modes

| Category | Examples |
|----------|---------|
| Read-only analysis | Analyzing existing files, summarizing docs, consistency checks |
| Internal planning | Decomposing tasks, writing a sprint plan draft, generating a checklist |
| Non-persistent drafts | Holding a design draft in memory before owner reviews it |
| Formatting / linting | Whitespace fixes, import ordering, comment updates |
| Status reports | Progress summaries, session-state updates, test result summaries |
| Template population | Filling in document templates where all values are owner-supplied |
| Research queries | Asking clarifying questions to gather owner intent |

### MEDIUM — Execute autonomously in AUTONOMOUS mode only; pause in SUPERVISED

| Category | Examples |
|----------|---------|
| File writes — docs/design | Writing or updating GDD sections, ADRs, UX docs, level-design docs |
| File writes — agent config | Updating `.agents/docs/technical-preferences.md`, skills, agent definitions |
| Test scaffolding | Creating test file stubs, populating test helpers |
| Refactoring — isolated | Renaming within a single system, extracting a method |
| GitHub issues | Opening, closing, or labelling implementation issues |
| Local branches | Creating a local branch for in-flight work |

### HIGH — Always pause and surface to the owner, regardless of mode

| Category | Examples |
|----------|---------|
| **Game start** | Starting a new game project (brainstorm → concept phase) |
| **Phase transitions** | Advancing through any production phase gate (Concept → Pre-production, Pre-production → Production, Production → Release, etc.) |
| File writes — game source | Writing or modifying any file under `src/` |
| File writes — package code | Modifying anything under `Packages/YJackCore/**` or `Packages/com.ygamedev.yjack/**` |
| Architecture decisions | Creating or overriding an ADR, changing the master architecture document |
| GitHub pull requests | Opening a PR, requesting review, or merging a PR |
| Releases | Creating a release tag, drafting release notes, publishing a release |
| Sprint commitment | Committing a sprint backlog, changing sprint scope |
| Secrets or credentials | Reading, writing, or referencing `.env`, credentials, or keys |
| Destructive operations | Deleting files, force-pushing, resetting history |
| YJackCore package modifications | Any change to YJackCore package internals or its low-code authoring model |

---

## Per-Mode Action Table

The table below shows exactly what agents may do without asking the owner.

| Action | GUIDED | SUPERVISED | AUTONOMOUS |
|--------|--------|------------|------------|
| Read files, analyze, summarize | ✅ Always | ✅ Always | ✅ Always |
| Draft in memory (not written) | ✅ Always | ✅ Always | ✅ Always |
| Write status / session-state files | Ask first | ✅ Auto | ✅ Auto |
| Write design / GDD sections | Ask first | Ask first | ✅ Auto |
| Write agent config / preferences | Ask first | Ask first | ✅ Auto |
| Open / close GitHub issues | Ask first | Ask first | ✅ Auto |
| Create a local branch | Ask first | Ask first | ✅ Auto |
| Write game source files (`src/`) | Ask first | Ask first | Ask first |
| Open / merge a GitHub PR | Ask first | Ask first | Ask first |
| Create a release | Ask first | Ask first | Ask first |
| Start a game / first brainstorm session | Ask first | Ask first | Ask first |
| Advance a phase gate | Ask first | Ask first | Ask first |
| Modify YJackCore package files | Ask first | Ask first | Ask first |
| Commit a sprint backlog | Ask first | Ask first | Ask first |

> "Ask first" means the agent must surface the decision to the owner and wait
> for explicit approval before proceeding. Read-only access (inspecting files,
> analyzing content, summarizing) is always allowed in every mode; agents must
> be able to inspect the repository before asserting structure or intent.

---

## Gating Rules for Specific Artifacts

### File Writes

- **`production/session-state/`** — allowed in SUPERVISED and AUTONOMOUS; in GUIDED, ask first.  
- **`production/autonomy-config.md`** — always write only when the owner instructs it.  
- **`design/`, `docs/`** — allowed in AUTONOMOUS; ask first in GUIDED and SUPERVISED.  
- **`src/`** — always ask first regardless of mode.  
- **`.agents/`** — MEDIUM risk: auto in AUTONOMOUS, ask in GUIDED and SUPERVISED.  
- **Packages paths** — always ask first; YJackCore package boundaries are a hard gate.

### GitHub Issues

- **Opening an issue** — MEDIUM risk: auto in AUTONOMOUS, ask in GUIDED and SUPERVISED.  
- **Closing or labelling an issue** — MEDIUM risk: same as above.  
- **Creating issue templates or label taxonomy** — MEDIUM risk.

### Branches and Commits

- **Creating a local branch** — MEDIUM risk.  
- **Committing to the branch** — MEDIUM risk in AUTONOMOUS; ask in SUPERVISED and GUIDED.  
- **Pushing a branch** — HIGH risk: always ask first.

### Pull Requests

- **Opening a PR** — HIGH risk: always ask first.  
- **Requesting review on a PR** — HIGH risk: always ask first.  
- **Merging a PR** — HIGH risk: always ask first.

### Releases

- **Creating a release tag** — HIGH risk: always ask first.  
- **Drafting release notes** — MEDIUM risk.  
- **Publishing / deploying a release** — HIGH risk: always ask first.

---

## Hard Gates — Never Bypassed by Any Mode

The following actions require explicit owner approval in every mode, including
`AUTONOMOUS`. These are non-negotiable:

1. **Starting a new game** — No agent may initiate a brainstorm session,
   create a new game concept, or create any foundational design artifact for a
   new game without the owner explicitly starting the session.

2. **Advancing a phase gate** — No agent may advance the project through any
   production phase transition (Concept → Pre-production, Pre-production →
   Production, Production → Alpha, Alpha → Beta, Beta → Release) without
   explicit owner approval. `/gate-check` must always surface results to the
   owner for a go/no-go decision.

3. **Publishing code to `src/`** — Writing game source files always requires
   the owner to approve the approach first. Agents may propose code, hold
   drafts, and discuss options, but cannot write to `src/` autonomously.

4. **Merging or releasing** — No PR merge, tag, or release may happen without
   an owner sign-off.

5. **YJackCore package boundaries** — Agents must never modify files under
   `Packages/YJackCore/**` or `Packages/com.ygamedev.yjack/**` without explicit
   owner authorization. The low-code authoring model and Unity manual-validation
   expectations must be preserved.

---

## Escalation Protocol

An **escalation** occurs when an agent determines that a decision exceeds the
current autonomy mode boundary.

### Escalation Trigger

Before executing any action, agents must classify the risk tier and compare it
to the active mode:

```
Tier is LOW   AND mode is SUPERVISED or AUTONOMOUS → execute
Tier is MEDIUM AND mode is AUTONOMOUS               → execute
Tier is MEDIUM AND mode is SUPERVISED or GUIDED     → ESCALATE
Tier is HIGH   (any mode)                           → ESCALATE
```

### Escalation Behaviour

When an escalation triggers, the agent must:

1. **Stop** — do not execute the action.
2. **Surface** — describe the action, its risk tier, and why it requires owner
   input. Example:

   ```
   ⚠️ APPROVAL REQUIRED [HIGH risk — Phase Gate]
   
   The sprint plan is complete and all acceptance criteria for Pre-production
   are met. Advancing to Production requires your approval.
   
   Ready to advance? (yes / no / hold)
   ```

3. **Wait** — do not proceed until the owner responds.
4. **Record** — after approval or rejection, log the decision in
   `production/session-state/active.md` for auditability.

### Escalation Response Options

| Owner Response | Agent Action |
|----------------|-------------|
| **Yes / Approve** | Execute the action, log it. |
| **No / Reject** | Drop the action, propose alternatives if relevant. |
| **Hold** | Pause the action; carry forward its pending state in session-state. |
| **Modify then proceed** | Owner provides revised scope; agent adjusts and re-proposes. |

---

## Rollback and Recovery

### When an Autonomous Action Causes a Problem

If an action executed autonomously (LOW or MEDIUM risk in the appropriate mode)
turns out to be incorrect or unwanted:

1. **Report immediately** — surface the issue and the action that caused it.
2. **Propose rollback** — identify the files or states changed and the steps to
   reverse them.
3. **Wait for owner approval** — the rollback itself is always a HIGH-risk action
   that requires owner approval (it modifies potentially committed work).
4. **Escalate risk tier** — after a rollback, the category of action that caused
   the problem should be treated as the next-higher risk tier for the remainder
   of the session.

### Session-Level Override

The owner may override the current mode downward at any time:

```
"Pause autonomous mode — ask me before everything for the rest of this session."
```

This immediately sets the effective mode to GUIDED for the remainder of the
session without modifying `production/autonomy-config.md`.

---

## YJackCore Alignment

For projects backed by YJackCore, the following constraints apply regardless of
autonomy mode:

- **Package authority**: YJackCore's own `AGENTS.md` and skill files take
  precedence over the generic Game Studio Unity specialist. Any autonomous action
  touching YJackCore paths must route through the YJackCore-aware agent path.

- **Low-code authoring**: Agents must never auto-generate Unity inspector-driven
  data (ScriptableObjects, prefabs, scene state) in place of the owner doing it
  manually. Proposing a structure is MEDIUM risk; generating the asset is HIGH risk.

- **Manual validation**: Any action that would normally require Unity manual
  validation (play-mode testing, editor operation, visual inspection) is HIGH risk
  and must be escalated to the owner regardless of mode.

- **Package boundaries**: Modifying anything under `Packages/YJackCore/**` or
  `Packages/com.ygamedev.yjack/**` is always HIGH risk, regardless of mode.

---

## Configuration File Format

`production/autonomy-config.md` stores the active mode and per-skill overrides.

```markdown
# Autonomy Configuration

## Active Mode

GUIDED

## Notes

<!-- Owner can write free-form notes about why this mode was chosen. -->

## Overrides

<!-- Per-session or per-skill overrides.
     Per-skill format:
       SKILL: <skill-name> → <mode>  (applies to every run of that skill)
       Example: SKILL: smoke-check → SUPERVISED
     Per-session overrides are not stored here; tell any agent
       "Set autonomy mode to <mode> for this session only."
     Session overrides last only until the session ends.
-->
```

Valid values for Active Mode: `GUIDED`, `SUPERVISED`, `AUTONOMOUS`.

If `production/autonomy-config.md` does not exist, agents default to `GUIDED`.

---

## Integration with Existing Systems

### Review Modes (`production/review-mode.txt`)

The review mode (`full`, `lean`, `solo`) in `.agents/docs/director-gates.md` controls whether
director review gates fire inside skills. Autonomy mode and review mode are
orthogonal controls:

- Review mode governs which _internal skill gates_ activate (director agents, QA
  leads, etc.).
- Autonomy mode governs which _actions_ require owner approval before execution.

Concrete examples:

| Autonomy mode | Review mode | Effect |
|---------------|-------------|--------|
| `AUTONOMOUS` | `full` | Agents execute LOW/MEDIUM actions automatically **and** run all internal director-review gates at each workflow step. |
| `AUTONOMOUS` | `lean` | Agents execute LOW/MEDIUM actions automatically; director gates fire only at phase-gate milestones. |
| `GUIDED` | `solo` | Owner approves every action; no internal director/QA review gates fire. |
| `SUPERVISED` | `lean` | Owner approves MEDIUM/HIGH actions; internal director gates fire at phase milestones only. |

### Gate Check (`/gate-check`)

`/gate-check` results are always surfaced to the owner for a go/no-go decision
regardless of autonomy mode, because phase transitions are HIGH-risk hard gates.

### Session State (`production/session-state/active.md`)

Every autonomous action and every escalation decision must be logged in
`production/session-state/active.md` so that the owner has a complete audit
trail of what was executed and what was approved.

---

## Scenario Walkthroughs

### Scenario 1: Docs-Only Work (SUPERVISED mode)

Owner sets mode to SUPERVISED and asks the agent to write a GDD for the
movement system.

1. Agent decomposes the task — LOW risk, executes without asking.
2. Agent asks clarifying questions — LOW risk, executes.
3. Agent presents three design options — LOW risk, presents to owner.
4. Owner picks Option B.
5. Agent writes `design/gdd/movement-system.md` — **MEDIUM risk in SUPERVISED,
   agent asks first**: "May I write to `design/gdd/movement-system.md`?"
6. Owner approves.
7. Agent writes the file, logs the action in session-state.

### Scenario 2: Game Implementation (AUTONOMOUS mode)

Owner sets mode to AUTONOMOUS and asks the agent to implement the movement
story `story-001-player-movement.md`.

1. Agent reads the story, architecture, and design docs — LOW risk, auto.
2. Agent proposes implementation approach to owner — LOW risk, presents.
3. Owner approves the approach.
4. Agent creates a local branch `feat/player-movement` — MEDIUM risk, auto in
   AUTONOMOUS mode, logs it.
5. Agent writes the implementation in `src/` — **HIGH risk, always asks**:
   "I'm ready to write `src/player/movement.gd`. Shall I proceed?"
6. Owner approves.
7. Agent writes the file, commits to the branch, logs both actions.
8. Agent proposes opening a PR — **HIGH risk, always asks**.
9. Owner approves; PR is opened.

### Scenario 3: Phase Transition (any mode)

Work on Pre-production milestones is complete. `/gate-check` passes all
criteria.

Regardless of the active mode, the agent **must** surface:

```
⚠️ APPROVAL REQUIRED [HIGH risk — Phase Gate]

Pre-production gate check PASSED. All acceptance criteria are met.

Advancing to Production phase will:
- Commit the sprint backlog to production/sprints/sprint-01.md
- Archive Pre-production milestone artifacts
- Enable /dev-story execution for sprint stories

Ready to advance to Production? (yes / no / hold)
```

The owner responds before any phase artifact is written.

### Scenario 4: YJackCore-Adjacent Work (AUTONOMOUS mode)

Owner is in AUTONOMOUS mode. Agent detects that a story touches a YJackCore
ScriptableObject definition.

1. Agent identifies the file path: `Packages/YJackCore/Runtime/Config/SkillConfig.cs`.
2. Path matches `Packages/YJackCore/**` — **HIGH risk hard gate**, escalates
   immediately regardless of mode:

   ```
   ⚠️ APPROVAL REQUIRED [HIGH risk — YJackCore package boundary]
   
   Story 014 requires modifying SkillConfig.cs inside the YJackCore package.
   This exceeds AUTONOMOUS mode boundaries and requires explicit authorization.
   
   Proceed? (yes / no / route to YJackCore specialist instead)
   ```

---

## Reference

| Document | Purpose |
|----------|---------|
| `production/autonomy-config.md` | Active mode storage (created on first use) |
| `production/session-state/active.md` | Audit log of autonomous actions and escalation decisions |
| `production/review-mode.txt` | Director-gate review mode (orthogonal to autonomy mode) |
| `.agents/docs/director-gates.md` | Director review gate definitions |
| `docs/COLLABORATIVE-DESIGN-PRINCIPLE.md` | Core collaborative philosophy |
| `docs/AUTONOMOUS_GAME_STUDIO_ROADMAP.md` | Source roadmap for the autonomy work items |
