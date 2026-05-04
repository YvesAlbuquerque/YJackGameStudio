# File Ownership Protocol for Parallel Agents

**Version:** 1.0  
**Last Updated:** 2026-05-04  
**Source:** [AUTO-006] from `docs/AUTONOMOUS_GAME_STUDIO_ROADMAP.md`

---

## Overview

This document defines the rules that govern which agents may write to which
files, how agents consult files they do not own, and how conflicts are resolved
when two agents need the same file. It also specifies special handling for Unity
`.meta` files and YJackCore package boundaries.

These rules apply to every autonomous agent session, regardless of the active
autonomy mode. The goal is to prevent silent corruption of shared files and to
make all write decisions auditable and reversible.

---

## Core Ownership Rules

### Rule 1 — Exclusive Write Ownership

A file is **exclusively owned** by the contract whose `write_set` includes that
file or an ancestor directory. No other agent may write to an exclusively owned
file while the owning contract is `IN_PROGRESS`.

**Ownership is active** from the moment the contract transitions to `IN_PROGRESS`
until it transitions to `VALIDATED` or `CLOSED`.

**Ownership is released** when the contract reaches `CLOSED`. Any follow-on
contract that needs to modify the same file must declare it in its own `write_set`
and receive a new `APPROVED` status before starting.

### Rule 2 — Read-Only Consultation

Any agent may **read** any file at any time, regardless of who owns it. Reading
does not require ownership. This is how agents reference shared design documents,
architecture docs, and existing source files.

```
read_context:                   # ← any agent may list any file here
  - path: design/systems/crafting.md
    section: "§3 Recipe Table"
```

Reading a file does not grant write permission. If the agent needs to update
it, that file must appear in the contract's `write_set`.

### Rule 3 — No Implicit Ownership

A file is not owned by virtue of being adjacent to owned files, being in the
same directory, or being a natural dependency. Ownership is explicit and
`write_set`-driven only.

Example:

```yaml
# SHARD-A owns RecipeResolver.cs — NOT CraftingManager.cs
write_set:
  - src/systems/crafting/RecipeResolver.cs

# An agent working on SHARD-A must NOT write to CraftingManager.cs
# even if they discover a bug there. They must escalate to the owner.
```

### Rule 4 — Scope Creep is a Violation

An agent must never write to a file outside its declared `write_set`. If the
agent discovers that additional files must change to complete the contract, it
must:

1. Stop and surface the expanded scope to the owner.
2. Wait for the owner to either update the `write_set` (re-approve) or create a
   new linked contract.

This applies regardless of autonomy mode.

---

## Read-Only Consultation Rules

### Shared Input Artifacts

Some files are consulted by many contracts but owned by none during a sprint.
Examples: `design/` documents, `docs/architecture/`, `AGENTS.md`,
`production/dependency-graph.yml`.

These files may be freely read. If a contract needs to update them, it declares
them explicitly in its `write_set` and no other contract may write to them
concurrently.

### Consultation vs. Dependency

| Situation | Use |
|-----------|-----|
| Agent reads an existing doc to understand context | `read_context` entry — no ownership needed |
| Agent must update a doc as part of its work | `doc_impact` entry **and** add the doc to `write_set` |
| Agent's work cannot start until another contract updates a doc | `dependencies` entry |

### Stale Read Protection

When an agent reads a `read_context` file that is owned (in the `write_set`) by
an `IN_PROGRESS` contract, it must note in its `status_log` that the file may
change before the current contract finishes. This signals that a re-read may be
needed before `VALIDATED`.

---

## Conflict Handling

### Conflict Type 1 — Scheduling Conflict (Write-Set Collision)

**When it occurs:** Two contracts are both `APPROVED` or `IN_PROGRESS` with
overlapping `write_set` entries.

**Protocol:**
1. The agent or pre-flight script detects the collision before `IN_PROGRESS`
   (see [dependency-graph.md §Write-Set Collision Detection Algorithm](dependency-graph.md#write-set-collision-detection-algorithm)).
2. Agent surfaces the conflict to the owner immediately.
3. Owner chooses one resolution:
   - **Defer**: Move one contract to `PROPOSED` until the other is `CLOSED`.
   - **Merge**: Combine both contracts into one with a unified `write_set`.
   - **Partition**: Restrict one contract's `write_set` to non-overlapping paths.
   - **Serial ordering**: Add the colliding contract as a `dependency` of the other.
4. No agent may unilaterally choose a resolution. All resolutions require owner
   approval regardless of the active autonomy mode.

### Conflict Type 2 — Runtime Discovery

**When it occurs:** An agent is `IN_PROGRESS` and discovers it needs to write a
file that is already owned by another `IN_PROGRESS` contract (collision missed
at scheduling time, or a new contract was approved mid-execution).

**Protocol:**
1. Agent immediately stops writing and transitions its contract to `BLOCKED`.
2. Agent populates `partial_work` with what is complete and what remains.
3. Agent surfaces the newly discovered collision to the owner.
4. Owner resolves as in Conflict Type 1.
5. Agent resumes from `partial_work.remaining` once the conflict is resolved.

### Conflict Type 3 — Design/Intent Conflict

**When it occurs:** Two agents reach contradictory conclusions about what a file
should contain (e.g., two agents attempting to set a game constant to different
values).

**Protocol:**
1. Neither agent writes without owner approval.
2. The agent that detects the contradiction escalates to the owner, citing both
   contracts and the specific conflict.
3. For design conflicts: escalate to `creative-director`.
4. For technical conflicts: escalate to `technical-director`.
5. Owner or director decides; the resolution is documented in both contracts'
   `status_log`.

---

## Unity .meta File Rules

Unity generates a `.meta` file for every asset file and directory. These files
contain GUIDs that Unity uses internally to track asset references. Corrupting
or duplicating a `.meta` file breaks asset references across the entire project.

### Rules

1. **Always include `.meta` files in the write_set alongside their asset.**

   ```yaml
   write_set:
     - Assets/Scripts/Player/PlayerMovement.cs
     - Assets/Scripts/Player/PlayerMovement.cs.meta   # ← always paired
   ```

2. **Never write a `.meta` file for an asset you do not own.** Writing a `.meta`
   without owning the asset corrupts GUID assignment.

3. **Never delete a `.meta` file without owner approval.** Orphaned `.meta` files
   can be cleaned up by Unity tooling; manual deletion risks breaking references.

4. **Directory-level write_set entries cover `.meta` files in that directory.**
   A `write_set` entry of `Assets/Scripts/Player/` covers all `.cs`, `.asset`,
   and `.meta` files under that path.

5. **When two contracts own adjacent files in the same directory**, both must
   declare the directory-level `.meta` (if it exists and will be modified) or
   use explicit per-file entries to avoid collision.

6. **`.meta` collisions are treated as file-level write-set collisions.** The
   collision detection algorithm applies equally to `.meta` paths.

7. **Generated `.meta` files from new scripts** are owned by the contract that
   creates the script. If Unity auto-generates a `.meta` during a build step,
   the contract that triggered the build owns the resulting `.meta`.

### Practical Checklist for Unity Contracts

- [ ] Every new script or asset file has its `.meta` in the `write_set`.
- [ ] Every moved or renamed file has both the old and new `.meta` in the `write_set`.
- [ ] No two parallel contracts list the same `.meta` file.
- [ ] Directory entries cover `.meta` files implicitly; per-file entries are preferred
      when the scope is narrow to reduce collision surface.

---

## YJackCore Package Boundary Rules

YJackCore is a Unity framework package. Editing its package files is `HIGH` risk
and has different ownership semantics from host-game code.

### Package Boundary Definition

The YJackCore package boundary consists of:

- `Packages/YJackCore/**`
- `Packages/com.ygamedev.yjack/**`
- Any path resolved by `.yjack-workspace.json` as the YJackCore source root.

### Rules

1. **Package boundary writes are always HIGH risk.** Any contract with a
   `write_set` entry under `Packages/YJackCore/` or `Packages/com.ygamedev.yjack/`
   must set `yjackcore.package_boundary: true` and `risk_tier: HIGH`.

2. **Package boundary writes always escalate to the owner.** No autonomy mode
   allows unilateral writes to the YJackCore package boundary.

3. **Host-game code and package code are never owned by the same contract.**
   A contract may own `src/player/PlayerMovement.cs` or
   `Packages/YJackCore/Runtime/Core/PlayerBase.cs`, but never both. Contracts
   that span the boundary must be split.

4. **YJackCore `.meta` files require the same pairing rule as all Unity `.meta`
   files.** Additionally, if the YJackCore package is managed via UPM and lives
   in `Library/PackageCache/`, its files are read-only and must not appear in
   any `write_set`.

5. **YJackCore submodule or sibling checkout paths** must be declared explicitly
   in the `write_set` using the resolved path from `.yjack-workspace.json` (see
   [yjackcore-authority.md](yjackcore-authority.md)).

6. **Host-game separation check.** Any contract with
   `yjackcore.host_game_separation: true` must verify — before `VALIDATED` — that
   no YJackCore `CoreLayer` imports appear in host-game (`src/`) files added by
   the contract. This check is a required `handoff` condition.

### YJackCore Write-Set Examples

```yaml
# ✅ Host-game contract — no package boundary
write_set:
  - src/player/PlayerMovement.cs
  - src/player/PlayerMovement.cs.meta
yjackcore:
  layer: PlayerLayer
  package_boundary: false
  host_game_separation: true

# ✅ Package boundary contract — HIGH risk
write_set:
  - Packages/YJackCore/Runtime/Core/PlayerBase.cs
  - Packages/YJackCore/Runtime/Core/PlayerBase.cs.meta
yjackcore:
  layer: CoreLayer
  package_boundary: true
  host_game_separation: false
risk_tier: HIGH

# ❌ INVALID — spans host-game and package boundary
write_set:
  - src/player/PlayerMovement.cs
  - Packages/YJackCore/Runtime/Core/PlayerBase.cs  # ← not allowed in same contract
```

---

## Ownership Summary Table

| File Type | Ownership Rule | Collision Risk |
|-----------|---------------|----------------|
| Source files (`src/**`) | Exclusive; must be in `write_set` | High — always check |
| Test files (`tests/**`) | Exclusive; must be in `write_set` | High — test dirs are often broad |
| Design docs (`design/**`) | Exclusive when being written; read-only otherwise | Medium |
| Architecture docs (`docs/**`) | Exclusive when being written; read-only otherwise | Low in parallel sprints |
| Unity `.meta` files | Always paired with asset; exclusive | High — missed `.meta` breaks GUID |
| YJackCore package files | Exclusive; `HIGH` risk; always escalates | Critical |
| `production/dependency-graph.yml` | Updated by the orchestrating agent only | Low — sequential update |
| `production/session-state/active.md` | Updated by the active agent; serialized | Low |
| Config and CI files (`.github/**`) | Treat as HIGH risk; explicit ownership required | High |

---

## Protocol Checklist for Agents

Before transitioning any contract to `IN_PROGRESS`:

- [ ] All `dependencies` in `production/dependency-graph.yml` are `validated` or `closed`.
- [ ] Write-set collision check passed (see [dependency-graph.md §Algorithm](dependency-graph.md#write-set-collision-detection-algorithm) or run `.agents/scripts/check-write-sets.sh`).
- [ ] All `read_context` files read; any owned-by-another noted in `status_log`.
- [ ] Unity `.meta` files paired for every asset in `write_set`.
- [ ] YJackCore boundary flag confirmed (set `package_boundary: true` if applicable).
- [ ] `status_log` entry written with `IN_PROGRESS` transition.

---

## Relationship to Other Documents

| Document | Relationship |
|----------|--------------|
| [dependency-graph.md](dependency-graph.md) | Defines the dependency graph format and collision detection algorithm |
| [work-contract-schema.md](work-contract-schema.md) | Defines the per-contract `write_set`, `read_context`, and `yjackcore` fields |
| [coordination-rules.md](coordination-rules.md) | Parallel task protocol that references this document |
| [autonomy-modes.md](autonomy-modes.md) | Risk tiers and approval boundaries referenced throughout this document |
| [yjackcore-support.md](yjackcore-support.md) | YJackCore detection and specialist routing |
| [yjackcore-authority.md](yjackcore-authority.md) | YJackCore workspace manifest and authority hierarchy |
| `.agents/scripts/check-write-sets.sh` | Script implementing the collision detection algorithm |
