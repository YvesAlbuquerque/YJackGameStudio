# Agent Coordination Rules

1. **Vertical Delegation**: Leadership agents delegate to department leads, who
   delegate to specialists. Never skip a tier for complex decisions.
2. **Horizontal Consultation**: Agents at the same tier may consult each other
   but must not make binding decisions outside their domain.
3. **Conflict Resolution**: When two agents disagree, escalate to the shared
   parent. If no shared parent, escalate to `creative-director` for design
   conflicts or `technical-director` for technical conflicts.
4. **Change Propagation**: When a design change affects multiple domains, the
   `producer` agent coordinates the propagation.
5. **No Unilateral Cross-Domain Changes**: An agent must never modify files
   outside its designated directories without explicit delegation.

## Model Tier Assignment

Skills and agents are assigned to model tiers based on task complexity:

| Tier | Model | When to use |
|------|-------|-------------|
| **Haiku** | `claude-haiku-4-5-20251001` | Read-only status checks, formatting, simple lookups — no creative judgment needed |
| **Sonnet** | `claude-sonnet-4-6` | Implementation, design authoring, analysis of individual systems — default for most work |
| **Opus** | `claude-opus-4-6` | Multi-document synthesis, high-stakes phase gate verdicts, cross-system holistic review |

Skills with `model: haiku`: `/help`, `/sprint-status`, `/story-readiness`, `/scope-check`,
`/project-stage-detect`, `/changelog`, `/patch-notes`, `/onboard`

Skills with `model: opus`: `/review-all-gdds`, `/architecture-review`, `/gate-check`

All other skills default to Sonnet. When creating new skills, assign Haiku if the
skill only reads and formats; assign Opus if it must synthesize 5+ documents with
high-stakes output; otherwise leave unset (Sonnet).

## Subagents vs Agent Teams

This project uses two distinct multi-agent patterns:

### Subagents (current, always active)
Spawned via `Task` within a single Claude Code session. Used by all `team-*` skills
and orchestration skills. Subagents share the session's permission context, run
sequentially or in parallel within the session, and return results to the parent.

**When to spawn in parallel**: If two subagents' inputs are independent (neither
needs the other's output to begin), spawn both Task calls simultaneously rather
than waiting. Example: `/review-all-gdds` Phase 1 (consistency) and Phase 2
(design theory) are independent — spawn both at the same time.

### Agent Teams (experimental — opt-in)
Multiple independent Claude Code *sessions* running simultaneously, coordinated
via a shared task list. Each session has its own context window and token budget.
Requires `CLAUDE_CODE_EXPERIMENTAL_AGENT_TEAMS=1` environment variable.

**Use agent teams when**:
- Work spans multiple subsystems that will not touch the same files
- Each workstream would take >30 minutes and benefits from true parallelism
- A senior agent (technical-director, producer) needs to coordinate 3+ specialist
  sessions working on different epics simultaneously

**Do not use agent teams when**:
- One session's output is required as input for another (use sequential subagents)
- The task fits in a single session's context (use subagents instead)
- Cost is a concern — each team member burns tokens independently

**Current status**: Not yet used in this project. Document usage here when first adopted.

## Parallel Task Protocol

When an orchestration skill spawns multiple independent agents:

1. Issue all independent Task calls before waiting for any result
2. Collect all results before proceeding to dependent phases
3. If any agent is BLOCKED, surface it immediately — do not silently skip
4. Always produce a partial report if some agents complete and others block

### Write-Set Collision Rule

Before scheduling two contracts to run in parallel, verify that their
`write_set` entries do not overlap. Two contracts whose write sets share a
file or a directory ancestry must not execute concurrently.

**Pre-flight check**: Run `.agents/scripts/check-write-sets.sh production/dependency-graph.yml`
before advancing any contract to `IN_PROGRESS`. Exit code 1 means collisions were
found; do not proceed without owner resolution.

Full collision-detection algorithm and the four-shard simulation proving it:
[dependency-graph.md](../../.agents/docs/dependency-graph.md)  
File ownership, read-only consultation, Unity `.meta` handling, and YJackCore
package boundary rules: [file-ownership-protocol.md](../../.agents/docs/file-ownership-protocol.md)

### Dependency Pre-flight

Before a contract advances to `IN_PROGRESS`, all contracts it lists in
`dependencies` must have `status: validated` or `status: closed` in
`production/dependency-graph.yml`. The agent re-checks dependency status at
pickup time, not just at scheduling time.

## Work Contracts

Every unit of autonomous agent work must be backed by a **work contract** that
declares its write scope, success criteria, validation requirements, and
escalation conditions. This prevents silent scope creep, parallel file
collisions, and incomplete handoffs.

Schema and lifecycle: [`.agents/docs/work-contract-schema.md`](../../.agents/docs/work-contract-schema.md)  
Dependency graph and collision detection: [`.agents/docs/dependency-graph.md`](../../.agents/docs/dependency-graph.md)  
File ownership protocol: [`.agents/docs/file-ownership-protocol.md`](../../.agents/docs/file-ownership-protocol.md)  
YAML template: [`.agents/docs/templates/work-contract.yml`](../../.agents/docs/templates/work-contract.yml)  
GitHub issue form: [`.github/ISSUE_TEMPLATE/agent_work_contract.yml`](../../.github/ISSUE_TEMPLATE/agent_work_contract.yml)  
Pre-flight check script: [`.agents/scripts/check-write-sets.sh`](../../.agents/scripts/check-write-sets.sh)

