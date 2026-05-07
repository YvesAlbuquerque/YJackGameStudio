# Handoff Record Schema

**Version:** 1.0
**Last Updated:** 2026-05-07
**Source:** [AUTO-012] from `docs/AUTONOMOUS_GAME_STUDIO_ROADMAP.md`

---

## Overview

A **handoff record** is a persistent context transfer document that enables agents
to resume work on an issue without requiring chat history or human retelling.

Handoff records are stored at `production/session-state/handoff-{issue-id}.md` and
tracked in git. They persist until the issue closes, then are archived.

---

## File Naming Convention

```
production/session-state/handoff-{issue-id}.md
```

Examples:
- `handoff-44.md` — handoff for GitHub issue #44
- `handoff-STORY-042.md` — handoff for work contract STORY-042
- `handoff-epic-combat.md` — handoff for epic-level coordination

**Rule:** Use the GitHub issue number when available; otherwise use the contract_id
from the work contract.

---

## Required Sections

Every handoff record must contain these sections in order:

### 1. Header (Frontmatter)

```yaml
---
handoff_id: "44"  # or "STORY-042"
issue_url: "https://github.com/owner/repo/issues/44"
contract_id: "STORY-042"  # if applicable
created: "2026-05-07T10:30:00Z"
last_updated: "2026-05-07T15:45:00Z"
status: "in_progress"  # proposed | approved | in_progress | blocked | validated | closed
---
```

### 2. Owner Goal

One-sentence summary of what the owner wants from this issue/contract. Copied from
the work contract or issue description.

```markdown
## Owner Goal

Implement autonomous run memory and handoff model to make long-running parallel
work resumable without chat history.
```

### 3. Last Validated State

What has been completed and verified. This section grows as work progresses.

```markdown
## Last Validated State

### Completed
- [x] Autonomous memory model specification created
- [x] Handoff record schema documented
- [x] Gitignore policy updated

### Remaining
- [ ] Session state lifecycle document
- [ ] Hook scripts updated
- [ ] Validation test scenario executed
```

### 4. Active Blockers

If the contract is blocked, this section is required. Otherwise omit.

```markdown
## Active Blockers

**Blocker:** Waiting for owner approval on gitignore policy for active.md

**Blocked Since:** 2026-05-07T14:00:00Z

**Impact:** Cannot update hooks until policy is confirmed

**Escalation:** Surfaced to owner via comment on issue #44
```

### 5. Pending Decisions

Owner decisions awaiting input. High-priority items first.

```markdown
## Pending Decisions

1. **Handoff archive retention period** — 90 days or indefinite?
   - Options: 90-day auto-cleanup | manual curation only | owner-configurable
   - Impact: Disk usage vs. audit trail completeness
   - Decision needed by: Next session (before cleanup script implementation)

2. **GitHub memory vs. agent MEMORY.md** — which for durable lessons?
   - Current: Using both; GitHub for cross-agent facts, MEMORY.md for agent-specific
   - Alternative: Consolidate to GitHub memory only
   - Decision needed by: Before validation test
```

### 6. Next Scheduled Action

The very next step the resuming agent should take. Be specific.

```markdown
## Next Scheduled Action

**What:** Create session-state-lifecycle.md document

**Where:** `.agents/docs/session-state-lifecycle.md`

**Context:** Use autonomous-memory-model.md §Memory Lifecycle Workflows as source;
expand each workflow into detailed state transition rules

**Success:** Document includes state diagram, transition rules, hook integration
points, and crash recovery protocol
```

### 7. Risk Items

High or medium risk items requiring owner attention. Sorted by severity.

```markdown
## Risk Items

### HIGH
None currently

### MEDIUM
- **Gitignore policy change:** Moving active.md from tracked to gitignored requires
  careful migration; existing repos may have stale active.md files that need manual cleanup
- **Hook script changes:** session-start.sh and session-stop.sh changes affect all
  sessions; test thoroughly before merge

### LOW
- Documentation volume increasing; may need consolidated index
```

### 8. Agent Notes

Context that doesn't fit elsewhere. Used for:
- Implementation decisions and their rationale
- Discoveries about the codebase
- Patterns observed during work
- Warnings for the next agent
- Cross-references to related work

```markdown
## Agent Notes

### Implementation Decisions
- Chose YAML frontmatter for handoff files to enable machine parsing while keeping
  the body human-readable markdown
- Archive path is gitignored to prevent unbounded git growth; local audit trail only

### Discoveries
- Session hooks already archive active.md content to session-logs on shutdown
- YJackCore Sleep/Note pattern mentioned in roadmap but not documented in this repo;
  pattern inferred from description only

### Cross-References
- Related to AUTO-005 (work contract schema) — handoff protocol section
- Builds on context-management.md — file-backed state strategy
- Integrates with autonomy-modes.md — escalation rules

### Warnings
- Do not delete handoff files manually; use issue close workflow
- Handoff files are tracked; commit updates after significant state changes
```

---

## Optional Sections

### Write-Set Status

When working on a contract with declared write_set, track file-level completion:

```markdown
## Write-Set Status

| File | Status | Notes |
|------|--------|-------|
| `.agents/docs/autonomous-memory-model.md` | ✅ Complete | Initial version written |
| `.agents/docs/handoff-record-schema.md` | ✅ Complete | Schema documented |
| `.agents/docs/session-state-lifecycle.md` | 🚧 In Progress | Outline created |
| `.gitignore` | ⏸️ Pending | Waiting on policy decision |
```

### Session Log

Brief log of who worked when. Append-only.

```markdown
## Session Log

- **2026-05-07 10:30-12:00** — @claude[agent] — Created memory model spec and handoff schema
- **2026-05-07 14:00-15:45** — @claude[agent] — Drafted lifecycle doc; blocked on gitignore policy
```

---

## Update Protocol

### When to Update

Update the handoff file when:
1. Contract status changes (approved → in_progress, in_progress → blocked, etc.)
2. Blocker encountered or resolved
3. Risk escalation required
4. Significant decision made (architecture choice, implementation approach)
5. Session ends (update Last Validated State and Next Scheduled Action)
6. Milestone reached (major component complete)

### How to Update

1. Read the current handoff file
2. Update the `last_updated` timestamp in frontmatter
3. Update relevant sections (Last Validated State, Next Scheduled Action, etc.)
4. Append to Session Log if applicable
5. Commit the update with a clear message: `"Update handoff for issue #44: completed memory model spec"`

### Atomic Updates

If multiple agents might update the same handoff concurrently:
1. Always pull latest before updating
2. Use git conflict resolution if necessary
3. Prefer append-only sections (Session Log, Agent Notes) to minimize conflicts
4. Serialize contract status changes via dependency graph write-set locks

---

## Archival Protocol

When an issue closes:

1. Move handoff file to `production/session-logs/handoff-archive/{issue-id}.md`
2. Append final metadata to frontmatter:
   ```yaml
    closed: "2026-05-08T09:00:00Z"
    archived: "2026-05-08T09:01:00Z"
    final_status: "validated"
    ```
3. Delete the active handoff file from `production/session-state/` and commit the tracked deletion (`git add -u`) so the open handoff is removed from git history
4. Keep the archive as local-only history (`production/session-logs/` is gitignored)
5. Extract durable lessons and commit to GitHub memory API or agent MEMORY.md

After 90 days (configurable), the cleanup script may delete archives to prevent
unbounded growth. Archives are gitignored, so this does not affect version history.

---

## Example Handoff Record

See `.agents/docs/templates/handoff-record.md` for a complete annotated example.

---

## Integration with Work Contracts

Handoff records complement work contracts:

| Concern | Work Contract | Handoff Record |
|---------|---------------|----------------|
| **Purpose** | Define scope, success criteria, boundaries | Enable resumption, track progress |
| **Lifecycle** | PROPOSED → CLOSED | Created on first pickup → archived on close |
| **Storage** | GitHub issue or `production/contracts/*.yml` | `production/session-state/handoff-*.md` |
| **Updates** | Status transitions, owner decisions | Every milestone, blocker, session end |
| **Audience** | Owner approval, scheduling, validation gates | Agent-to-agent context transfer |

**Rule:** Every work contract in `IN_PROGRESS` or `BLOCKED` state must have a
corresponding handoff file. If the handoff is missing, the agent creates one
before starting work.

---

## Integration with Session State

Session state and handoff records serve different purposes:

| Concern | `active.md` (Session State) | `handoff-{issue}.md` (Handoff Record) |
|---------|----------------------------|--------------------------------------|
| **Scope** | Current session only | Entire issue lifetime |
| **Lifetime** | Ephemeral (deleted on clean exit) | Persistent (until issue closes) |
| **Tracked** | ❌ Gitignored | ✅ Tracked in git |
| **Contents** | Current task, open questions, test results | Validated state, blockers, next action |
| **Reader** | Same agent resuming after crash | Different agent picking up work |

**Workflow:**
1. Agent starts session → reads handoff file to understand where work left off
2. Agent creates `active.md` for current session working notes
3. Agent works → updates `active.md` incrementally
4. Agent reaches milestone → updates handoff file with validated state
5. Session ends cleanly → archive `active.md` to session-logs, update handoff, delete active
6. Session crashes → next session reads both active and handoff; reconciles state

---

## Validation Criteria

A handoff record is considered valid when:

1. All required sections are present
2. Frontmatter includes all required fields
3. Last Validated State accurately reflects completed work
4. Next Scheduled Action is specific and actionable
5. No secrets or credentials appear in any section
6. File is tracked in git and committed after updates
7. If status is `blocked`, Active Blockers section is present

Invalid handoff files should trigger a warning but not block work. The agent
should fix the invalid handoff before proceeding.

---

## Related Documents

- [autonomous-memory-model.md](autonomous-memory-model.md) — Overall memory architecture
- [session-state-lifecycle.md](session-state-lifecycle.md) — State transition rules
- [work-contract-schema.md](work-contract-schema.md) — Contract handoff protocol
- [context-management.md](context-management.md) — File-backed state strategy
