# Sprint Scheduler — Autonomous Issue Scheduling System

This directory contains the autonomous sprint scheduler skill that turns backlog
work contracts into parallelizable sprint work.

## What It Does

The sprint scheduler reads work contracts (GitHub issues or YAML files in
`production/contracts/`), applies dependency ordering and write-set collision
detection, and produces a machine-readable sprint schedule that respects:

- **Dependency ordering** — contracts can't start until dependencies are validated
- **Write-set isolation** — prevents parallel file conflicts
- **Priority tiers** — Must Have → Should Have → Nice to Have
- **Agent lane capacity** — distributes work across specialist agents
- **Autonomy mode boundaries** — escalates per GUIDED/SUPERVISED/AUTONOMOUS mode
- **YJackCore awareness** — flags manual validation and package boundary tasks

## Usage

```bash
# Basic usage (uses mode from production/autonomy-config.md)
/sprint-scheduler

# Override autonomy mode for this run
/sprint-scheduler --mode SUPERVISED

# Generate schedule without writing files (for testing)
/sprint-scheduler --dry-run
```

## Input Sources

The scheduler collects approved work contracts from two locations:

1. **GitHub issues** with label `status:approved` using the `agent_work_contract` template
2. **YAML files** in `production/contracts/*.yml`

If both exist for the same `contract_id`, the GitHub issue is authoritative.

## Output Files

The scheduler produces three files:

1. **YAML schedule** — `production/sprints/schedule-sprint-NNN.yml`
   - Machine-readable format consumed by agents
   - Includes lanes (scheduled), deferred, not_ready, collision_blocked sections

2. **Human-readable sprint plan** — `production/sprints/sprint-NNN.md`
   - Markdown format for owner review
   - Same format as `/sprint-plan` output

3. **Sprint status tracker** — `production/sprint-status.yaml`
   - Story-level status tracking for `/sprint-status` integration

## Dependency and Collision Checks

Before scheduling, the skill runs:

1. **Dependency check** — reads `production/dependency-graph.yml`
   - Only schedules contracts where all dependencies are `validated` or `closed`
   - Blocks contracts with unsatisfied dependencies in `not_ready` section

2. **Write-set collision check** — calls `.agents/scripts/check-write-sets.sh`
   - Detects parallel write conflicts using prefix/ancestor algorithm
   - Blocks conflicting contracts in `collision_blocked` section
   - Always escalates collision resolution to owner

## Autonomy Mode Integration

The scheduler respects the active autonomy mode from `production/autonomy-config.md`:

| Mode | Behavior |
|------|----------|
| **GUIDED** | All decisions escalate to owner before writing |
| **SUPERVISED** | LOW risk auto-approved; MEDIUM+ escalate |
| **AUTONOMOUS** | LOW and MEDIUM auto-approved; HIGH always escalates |

**Hard gates (never bypassed):**
- Sprint commitment (writing the schedule) is always MEDIUM risk minimum
- Any contract with `risk_tier: HIGH` always escalates
- YJackCore package boundary tasks always escalate
- Write-set collision resolution always escalates

## YJackCore Awareness

For YJackCore-backed projects, the scheduler:

1. **Detects YJackCore projects** via `.yjack-workspace.json`
2. **Sequences by layer depth** — CoreLayer → GameLayer → LevelLayer → PlayerLayer → ViewLayer → Shared
   - `CoreLayer` is treated as the most coordination-sensitive/foundational layer and should be scheduled first when present
3. **Flags package boundary tasks** — `yjackcore.package_boundary: true` is always HIGH risk
4. **Flags manual validation** — Unity Play Mode, domain reload, Inspector wiring
5. **Always escalates** package modifications regardless of autonomy mode

## Priority-Based Sequencing

Within each priority tier (Must Have / Should Have / Nice to Have), contracts
are sorted by:

1. **YJackCore layer depth** (if applicable) — deeper layers first
2. **Effort estimate** — smaller tasks first for faster feedback loops
3. **Risk tier** — LOW before MEDIUM before HIGH

## Capacity Management

The scheduler:

1. Reads sprint capacity from the current milestone
2. Sums effort estimates for all scheduled contracts
3. Defers lowest-priority tasks when capacity is exceeded
4. Moves deferred contracts to the `deferred` section with reason

## Example Contract

See `production/contracts/STORY-EXAMPLE-001.yml` for a minimal test contract.

To test the scheduler:

1. Add a contract to `production/contracts/` or create a GitHub issue
2. Update `production/dependency-graph.yml` with the contract
3. Run `/sprint-scheduler --dry-run` to see the schedule without writing
4. Review the output and adjust contracts as needed
5. Run `/sprint-scheduler` to commit the schedule

## Skill Test Spec

See `CCGS Skill Testing Framework/skills/sprint/sprint-scheduler.md` for the
complete test specification with 8 test cases covering:

- Happy path autonomous scheduling
- Write-set collision detection
- YJackCore package boundary escalation
- Capacity management and deferral
- Dependency blocking
- Dry-run mode
- Manual validation flagging
- GUIDED mode escalation

## Integration Points

| Tool/Skill | Relationship |
|------------|--------------|
| `/sprint-plan` | Manual sprint authoring; scheduler is the autonomous upgrade |
| `/sprint-status` | Reads the YAML schedule to report progress |
| `/story-readiness` | Validates single contracts; scheduler validates all |
| `/dev-story` | Executes contracts from the schedule |
| `.agents/scripts/check-write-sets.sh` | Pre-flight collision detector |
| `production/dependency-graph.yml` | Dependency ordering source |
| `production/autonomy-config.md` | Autonomy mode configuration |

## Next Steps After Scheduling

After the sprint schedule is written:

1. **Validate stories** — `/story-readiness <contract-id>`
2. **Begin implementation** — `/dev-story <contract-id>`
3. **Check progress** — `/sprint-status`
4. **Re-check collisions** — `.agents/scripts/check-write-sets.sh` before advancing contracts to `in_progress`

## Roadmap Integration

This skill fulfills [AUTO-007] from `docs/AUTONOMOUS_GAME_STUDIO_ROADMAP.md`:

> **AUTO-007: Autonomous Sprint Planner and Issue Scheduler**
>
> Upgrade the `/sprint-plan` skill to operate autonomously within owner-set
> constraints. Given a set of approved work contracts, the sprint planner
> selects, sequences, and assigns contracts to specialist agents based on
> dependency graph, write-set collision avoidance, priority, effort, and
> autonomy mode boundaries.
