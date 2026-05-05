# Agent Dependency Graph and Write-Set Protocol

**Version:** 1.0  
**Last Updated:** 2026-05-04  
**Source:** [AUTO-006] from `docs/AUTONOMOUS_GAME_STUDIO_ROADMAP.md`

---

## Overview

This document defines the project-wide **dependency graph** that agents use to
determine safe execution order before scheduling parallel work contracts. It
extends the per-contract `dependencies` and `write_set` fields defined in
[work-contract-schema.md](work-contract-schema.md) into a project-level,
machine-readable adjacency list that can be checked before any contract advances
to `IN_PROGRESS`.

The dependency graph has two responsibilities:

1. **Ordering** — Contract B cannot start until all contracts it depends on are
   `VALIDATED` or `CLOSED`.
2. **Isolation** — No two contracts with overlapping `write_set` entries may
   execute concurrently.

Both checks must pass before an agent may transition a contract to `IN_PROGRESS`.
Neither check may be bypassed by any autonomy mode.

---

## Graph Format

The dependency graph is stored as a YAML file at
`production/dependency-graph.yml`.

### Top-Level Structure

```yaml
# production/dependency-graph.yml
schema_version: "1.0"
last_updated: "<ISO-8601 timestamp>"
updated_by: "<agent or owner>"

contracts:
  <CONTRACT_ID>:
    title: "<Human-readable title>"
    status: <proposed|approved|in_progress|blocked|validated|closed>
    specialist_agent: "<agent name>"
    write_set:
      - "<path/to/file.ext>"
      - "<path/to/directory/>"     # covers all files under this directory
    dependencies:
      - contract_id: "<OTHER-ID>"
        status: "<last-known status; agent re-checks on pickup>"
    blocked_by: "<contract_id or description, if status is blocked>"
    github_issue: <number>          # optional
```

### Field Definitions

| Field | Required | Description |
|-------|----------|-------------|
| `schema_version` | ✅ | Always `"1.0"` until a breaking schema change is made. |
| `last_updated` | ✅ | ISO-8601 timestamp of last edit. Agents update this on every write. |
| `updated_by` | ✅ | GitHub username or agent name that wrote the last edit. |
| `contracts` | ✅ | Map of `contract_id` → contract entry. |
| `contracts.<id>.title` | ✅ | Human-readable description of the contract. |
| `contracts.<id>.status` | ✅ | Mirrors the `status` field in the matching work contract. Must be kept in sync. |
| `contracts.<id>.specialist_agent` | ✅ | Agent assigned to this contract. |
| `contracts.<id>.write_set` | ✅ | All files and directories exclusively written by this contract. A directory path (e.g. `src/systems/crafting/`) covers all descendants. |
| `contracts.<id>.dependencies` | — | List of contracts that must be `VALIDATED` or `CLOSED` before this contract may start. |
| `contracts.<id>.blocked_by` | — | Required when `status` is `blocked`. Identifies the blocker. |
| `contracts.<id>.github_issue` | — | GitHub issue number for queryability. |

---

## Blocked and Unblocked States

### Blocked

A contract is **blocked** when:

- An escalation condition was triggered during execution, **or**
- A dependency has not yet reached `VALIDATED` or `CLOSED`, **or**
- A write-set collision was detected at scheduling time.

When a contract transitions to `blocked`:
1. The agent sets `status: blocked` in the dependency graph.
2. The agent sets `blocked_by` to the blocking contract ID or a description.
3. The agent populates `partial_work` in the work contract (see
   [work-contract-schema.md §Handoff Protocol](work-contract-schema.md#handoff-protocol)).
4. The agent surfaces the block to the owner immediately — never silently skips.

### Unblocked

A contract transitions from `blocked` to `approved` (and becomes eligible for
`IN_PROGRESS`) when:

- The blocking contract reaches `VALIDATED` or `CLOSED`, **or**
- The owner explicitly resolves the block (via a GitHub comment or label update), **or**
- The write-set collision is resolved (one contract deferred, merged, or granted
  explicit parallel write permission by the owner).

The agent re-checks dependency status and collision status at pickup time, before
writing `IN_PROGRESS` to the status log.

---

## Write-Set Collision Detection Algorithm

Before any contract advances to `IN_PROGRESS`, the agent (or the pre-flight
check script) must run the following algorithm. The same logic is implemented in
`.agents/scripts/check-write-sets.sh`.

```
CollisionCheck(candidate_contract, graph):
  candidate_paths = candidate_contract.write_set
  active_contracts = [C for C in graph.contracts
                       if C.status in {approved, in_progress}
                       and C.contract_id != candidate_contract.contract_id]

  for path P in candidate_paths:
    for contract C in active_contracts:
      for path Q in C.write_set:
        if P == Q:                          → COLLISION (exact match)
        if P is_prefix_of Q:               → COLLISION (P covers Q)
        if Q is_prefix_of P:               → COLLISION (Q covers P)

  If any COLLISION found:
    → Surface to owner with details of both contracts and conflicting paths
    → Do NOT advance to IN_PROGRESS
    → Owner must resolve: defer one, merge them, or grant explicit permission
```

**Prefix rule**: Path A is a prefix of path B when B starts with A and the next
character is `/` or the end of string. For example:
- `src/systems/crafting/` is a prefix of `src/systems/crafting/RecipeResolver.cs`
- `src/systems/` is a prefix of `src/systems/crafting/RecipeResolver.cs`
- `src/systems/crafting` is **not** a prefix of `src/systems/crafting2/Foo.cs`

---

## How Agents Read the Dependency Graph

### At Session Start

1. Read `production/dependency-graph.yml`.
2. For every contract with `status: blocked`: surface to owner if not previously
   surfaced this session.
3. Identify contracts with `status: approved` and all dependencies `validated` or
   `closed` — these are **ready for pickup**.

### Before Advancing a Contract to IN_PROGRESS

1. Re-read `production/dependency-graph.yml` (state may have changed since session start).
2. Confirm all `dependencies` of the candidate contract are `validated` or `closed`.
3. Run the write-set collision check algorithm above against all `approved` and
   `in_progress` contracts.
4. Only if both checks pass: write `in_progress` to the graph and to the work
   contract's `status_log`.

### After Completing a Contract (VALIDATED → CLOSED)

1. Update the contract's `status` in `production/dependency-graph.yml` to `closed`.
2. Remove `blocked_by` if present.
3. Update `last_updated` and `updated_by`.
4. Identify any contracts whose only remaining unresolved dependency was this one —
   they are now unblocked and may be scheduled.

---

## Four-Shard Simulation — Collision Detection Proof

The following simulation demonstrates the protocol catching overlapping write sets
in a realistic four-shard parallel feature plan.

### Scenario

**Feature:** Player crafting system implemented in parallel across four shards.

| Contract | Specialist | Write Set |
|----------|------------|-----------|
| `SHARD-A` | team:combat | `src/systems/crafting/RecipeResolver.cs`, `tests/systems/crafting/` |
| `SHARD-B` | team:ui | `src/ui/crafting/CraftingPanel.cs`, `src/ui/crafting/CraftingPanelTests.cs` |
| `SHARD-C` | team:qa | `tests/systems/crafting/RecipeResolverIntegrationTests.cs` |
| `SHARD-D` | copilot | `design/systems/crafting.md`, `src/systems/crafting/` |

### Collision Detection Walkthrough

**Step 1 — SHARD-A vs SHARD-C**

```
SHARD-A write_set: [src/systems/crafting/RecipeResolver.cs, tests/systems/crafting/]
SHARD-C write_set: [tests/systems/crafting/RecipeResolverIntegrationTests.cs]

Check: is tests/systems/crafting/RecipeResolverIntegrationTests.cs
       under tests/systems/crafting/ ?
→ YES — tests/systems/crafting/ is a prefix of
         tests/systems/crafting/RecipeResolverIntegrationTests.cs

⚠️  COLLISION: SHARD-A (write_set: tests/systems/crafting/)
              vs SHARD-C (write_set: tests/systems/crafting/RecipeResolverIntegrationTests.cs)
```

**Step 2 — SHARD-A vs SHARD-D**

```
SHARD-A write_set: [src/systems/crafting/RecipeResolver.cs, tests/systems/crafting/]
SHARD-D write_set: [design/systems/crafting.md, src/systems/crafting/]

Check: is src/systems/crafting/RecipeResolver.cs
       under src/systems/crafting/ ?
→ YES — src/systems/crafting/ is a prefix of
         src/systems/crafting/RecipeResolver.cs

⚠️  COLLISION: SHARD-A (write_set: src/systems/crafting/RecipeResolver.cs)
              vs SHARD-D (write_set: src/systems/crafting/)
```

**Step 3 — SHARD-B vs SHARD-C, SHARD-B vs SHARD-D**

```
SHARD-B write_set: [src/ui/crafting/CraftingPanel.cs, src/ui/crafting/CraftingPanelTests.cs]
No overlap with SHARD-C or SHARD-D write sets.
→ SHARD-B has no collisions.
```

### Result

| Pair | Collision | Reason |
|------|-----------|--------|
| SHARD-A ↔ SHARD-B | ❌ None | Disjoint paths |
| SHARD-A ↔ SHARD-C | ✅ **Detected** | `tests/systems/crafting/` covers SHARD-C's path |
| SHARD-A ↔ SHARD-D | ✅ **Detected** | `src/systems/crafting/` covers SHARD-A's path |
| SHARD-B ↔ SHARD-C | ❌ None | Disjoint paths |
| SHARD-B ↔ SHARD-D | ❌ None | Disjoint paths |
| SHARD-C ↔ SHARD-D | ❌ None | Disjoint paths |

**Protocol outcome:**
- SHARD-A and SHARD-D cannot run in parallel as declared. Owner must resolve
  (e.g., merge them into one contract, or restrict SHARD-D's write_set to
  `design/systems/crafting.md` only and remove `src/systems/crafting/`).
- SHARD-A and SHARD-C cannot run in parallel. Owner must resolve (e.g., assign
  integration tests to SHARD-A, or have SHARD-C depend on SHARD-A being `closed`).
- SHARD-B is safe to run in parallel with any of the other shards.

The script output for this scenario would be:

```
$ .agents/scripts/check-write-sets.sh production/dependency-graph.yml

Checking write-set collisions for 4 active contracts...

[COLLISION] SHARD-A <-> SHARD-C
  SHARD-A owns: tests/systems/crafting/
  SHARD-C owns: tests/systems/crafting/RecipeResolverIntegrationTests.cs
  Reason: tests/systems/crafting/ is an ancestor of
          tests/systems/crafting/RecipeResolverIntegrationTests.cs

[COLLISION] SHARD-A <-> SHARD-D
  SHARD-A owns: src/systems/crafting/RecipeResolver.cs
  SHARD-D owns: src/systems/crafting/
  Reason: src/systems/crafting/ is an ancestor of
          src/systems/crafting/RecipeResolver.cs

2 collision(s) found. Resolve before scheduling parallel execution.
Owner must approve all collision resolutions.
```

---

## Relationship to Other Documents

| Document | Relationship |
|----------|--------------|
| [work-contract-schema.md](work-contract-schema.md) | Defines the per-contract fields (`write_set`, `dependencies`, `status`) that feed this graph |
| [file-ownership-protocol.md](file-ownership-protocol.md) | Defines read-only consultation rules, conflict handling, and Unity/YJackCore boundary rules |
| [coordination-rules.md](coordination-rules.md) | References this document for parallel task write-set checks |
| [autonomy-modes.md](autonomy-modes.md) | Collision resolution always escalates to the owner regardless of autonomy mode |
| `production/dependency-graph.yml` | The live project-wide graph file |
| `.agents/scripts/check-write-sets.sh` | Automated pre-flight script that runs the collision algorithm |
| AUTO-007 Sprint Planner | Reads this graph to schedule approved contracts into sprints |
