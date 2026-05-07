# Team Skill Orchestration: Issue-Driven Execution Plan (with Conversational Checkpoints)

This protocol is the shared execution contract for all `team-*` skills.

## 1) Create/attach parent scope

- Use the incoming feature/scope argument to identify a parent work item (existing GitHub issue or explicit scope record).
- Keep execution idempotent: derive a stable scope slug and never create duplicate child issues for the same `(team-skill, scope-slug, track)` tuple.

## 2) Start with a planning/docs-first child issue

Before any execution shard is created, create or update a **planning/docs-first** child issue.

Required output of the planning issue:
- scope summary
- constraints and dependencies
- decomposition plan
- preliminary risk review
- proposed child-issue dependency graph

## 3) Generate child issues (execution shards)

Every team skill must produce child issues covering these tracks (mark `N/A` only when truly out of scope):

1. Design
2. Architecture
3. Implementation
4. Tests
5. Discipline track (Art / Audio / UX, whichever applies to the team)
6. QA

Each child issue must include:
- `specialist_agent`
- `write_set`
- `dependencies`
- `validation_criteria`
- `risk_tier` (`LOW` / `MEDIUM` / `HIGH`)
- idempotency key: `team-skill:<name>|scope:<slug>|track:<track>`

## 4) Preserve owner decision points

Owner sign-off must remain explicit for:
- creative direction choices (tone, visual identity, narrative framing, UX direction)
- high-risk decisions (`risk_tier: HIGH`)
- medium/high-risk transitions to active execution when autonomy rules require escalation

`AskUserQuestion` checkpoints remain mandatory for these decisions.

## 5) Parallel execution of independent shards

After planning/docs and required gates are approved:
- execute child issues with no dependency edge in parallel
- wait for all parallel shards to return before advancing dependent shards
- surface BLOCKED shards immediately and keep partial rollup output

When write sets are available, run `.agents/scripts/check-write-sets.sh production/dependency-graph.yml` before parallel dispatch to avoid collisions.

## 6) Dual-mode behavior (required)

Team skills must support both:
- **Issue-driven mode (primary):** create/maintain child issues and track execution against them
- **Conversational coordination mode (secondary):** keep human-readable summaries, options, and approvals in-chat

Even in conversational-heavy runs, issue shards must still be produced before execution begins.

## 7) YJackCore alignment for Unity work

For Unity-scoped child issues, include YJackCore routing metadata:
- classify each shard as `framework` (YJackCore package/layer) or `host` (`src/**` game code)
- include `yjackcore.layer` and `yjackcore.package_boundary` where relevant
- flag framework/package-boundary updates as high-coordination-risk and escalate per autonomy rules
