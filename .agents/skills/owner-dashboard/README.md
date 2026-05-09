# Owner Dashboard Skill

**Skill Name:** `owner-dashboard`

**Purpose:** Generate a concise, owner-facing view of autonomous studio activity that separates facts from recommendations and clearly distinguishes what agents can do autonomously from what requires owner decision.

## What This Skill Does

The owner dashboard provides:

1. **Facts Section** — Objective measurements:
   - Active issues count and status breakdown
   - Blocked issues with blocker descriptions
   - Validation debt requiring manual checks
   - Current autonomy mode and sprint goal

2. **Autonomous Next Actions** — What agents can proceed with:
   - Items within the current autonomy boundary (LOW risk in SUPERVISED, LOW/MEDIUM in AUTONOMOUS)
   - Next scheduled action from handoff files or issue bodies
   - Dependencies satisfied and ready for pickup

3. **Owner Decisions Needed** — Items blocked on owner input:
   - Blocked issues with escalation context
   - Approvals required above autonomy boundary
   - Pending decisions from handoff files
   - Validation approvals awaiting owner review

4. **Risks** — Aggregated from handoff files and issue state:
   - HIGH/MEDIUM/LOW severity classification
   - Sprint goal impact assessment
   - Mitigation suggestions

5. **Recommendations** — Exactly one concrete next action for the owner

## Usage

### Basic Invocation

```bash
/owner-dashboard
```

Generates `production/dashboard.md` with standard summary.

### With Options

```bash
/owner-dashboard --verbose
```

Generates extended dashboard with full handoff file excerpts at `production/dashboard-verbose.md`.

```bash
/owner-dashboard --include-closed
```

Includes recently closed issues (within 7 days) for context after sprint wrap-ups.

## When to Run

The dashboard should be regenerated:
- After any contract transitions to `blocked` or `validated`
- After owner approval of a HIGH-risk decision
- After a new sprint starts
- At least once per day during active sprints
- On manual invocation for ad-hoc status checks

## Data Sources

The skill reads from:
1. **GitHub issues** (via `gh issue list` when available)
2. **`production/dependency-graph.yml`** (contract status and dependencies)
3. **`production/session-state/handoff-*.md`** (agent context and blockers)
4. **`production/qa/validation-packets/*.md`** (validation debt)
5. **`production/autonomy-config.md`** (autonomy mode)
6. **`.agents/docs/technical-preferences.md`** (YJackCore detection)

## YJackCore Integration

For YJackCore-backed Unity projects, the dashboard includes a dedicated **YJackCore Status** section that:
- Separates host-game work from package boundary writes
- Tracks manual Unity validation debt (domain reload, Play Mode, builds)
- Flags package boundary integrity risks (HIGH priority)
- Lists validation by YJackCore layer (GameLayer, ViewLayer, etc.)

## Output Format

The dashboard uses a structured markdown format with these top-level sections:

1. **Summary** — Key metrics at a glance
2. **Facts** — Objective state (active issues, blocked issues, validation debt)
3. **Autonomous Next Actions** — What agents can proceed with
4. **Owner Decisions Needed** — Items blocked on owner input
5. **Risks** — HIGH/MEDIUM/LOW sorted by severity
6. **YJackCore Status** — (if applicable) Framework-specific validation and routing
7. **Recommendations** — One concrete action for the owner

## Relationship to Other Skills

- **`/sprint-status`** — Detailed sprint progress with burndown assessment
- **`/gate-check`** — Phase gate validation
- **`/project-stage-detect`** — Overall project stage detection
- **`/milestone-review`** — End-of-milestone comprehensive review

Use `/owner-dashboard` for high-level situational awareness. Use the related skills for deep-dives into specific areas.

## Read-Only Nature

This skill is **read-only** except for writing the dashboard file itself. It does not:
- Change issue status or labels
- Modify work contracts
- Approve or reject decisions
- Update handoff files

The dashboard surfaces state; it does not change state.

## Error Handling

- If GitHub CLI is unavailable, falls back to `production/dependency-graph.yml`
- If dependency graph is missing, proceeds with handoff files and validation packets only
- Notes any data source limitations in the dashboard header

## Example Output

See `.agents/docs/templates/owner-dashboard.md` for a complete annotated example.

## Skill Metadata

- **Allowed Tools:** Read, Glob, Grep, Bash
- **Model:** Sonnet (requires cross-file synthesis and risk assessment)
- **User-Invocable:** Yes
- **Arguments:** `[--verbose] [--include-closed]`
