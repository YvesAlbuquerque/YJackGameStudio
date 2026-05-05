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

The original Claude Code template assigned Haiku/Sonnet/Opus by task complexity.
In the provider-neutral layer, treat these as capability tiers instead of model
requirements:

| Tier | Capability | When to use |
|------|------------|-------------|
| Fast | Low-latency model | Read-only status checks, formatting, simple lookups |
| Standard | Default coding model | Implementation, design authoring, individual-system analysis |
| Deep reasoning | Strongest available model | Multi-document synthesis, phase gates, high-stakes architecture review |

When a tool supports explicit model selection, choose the nearest equivalent.
When it does not, use the tool default and preserve the review/delegation intent.

## Subagents vs Agent Teams

This project uses two distinct multi-agent patterns:

### Subagents (when supported)
Spawned through the active tool's delegation mechanism within a single session.
Used by all `team-*` skills and orchestration skills. Subagents typically share
the session's permission context, run sequentially or in parallel within the
session, and return results to the parent.

**When to spawn in parallel**: If two subagents' inputs are independent (neither
needs the other's output to begin), spawn both Task calls simultaneously rather
than waiting. Example: `/review-all-gdds` Phase 1 (consistency) and Phase 2
(design theory) are independent — spawn both at the same time.

### Agent Teams (experimental / tool-specific)
Multiple independent agent sessions running simultaneously, coordinated via a
shared task list. Each session has its own context window and token budget.
Use only when the active tool explicitly supports this mode.

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
