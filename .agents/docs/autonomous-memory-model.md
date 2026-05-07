# Autonomous Memory Model

**Version:** 1.0
**Last Updated:** 2026-05-07
**Source:** [AUTO-012] from `docs/AUTONOMOUS_GAME_STUDIO_ROADMAP.md`

---

## Overview

This document defines how agents persist memory across sessions and hand off state
to other agents or future sessions. The model separates ephemeral working memory
from persistent context transfer and durable learnings.

The design is informed by YJackCore's Sleep/Note separation pattern: short-term
working notes vanish on clean exit, handoff summaries persist for context transfer,
and durable lessons accumulate as long-term agent knowledge.

## Problem Statement

Without a structured memory model:
- Chat history becomes the only source of truth (fragile, compacts unpredictably)
- Agents joining active issue work lack context to resume effectively
- Session crashes lose all working state
- Memory accumulates unbounded, degrading performance over time
- No clear handoff protocol between agents or sessions

## Memory Tiers

The model defines three memory tiers with distinct retention and access patterns:

### 1. Short-Term Run Notes

**Purpose:** Ephemeral working memory for the current session.

**Lifecycle:** Created when a session starts work; cleared on clean session end.

**Storage:** `production/session-state/active.md` (gitignored)

**Contents:**
- Current task and progress checklist
- Files being actively worked on
- Key decisions made this session
- Open questions awaiting user input
- Unresolved blockers
- Test results from this session
- Status line block (Production+ only)

**Retention:** Deleted or archived when:
- Session ends cleanly and work is committed
- Explicitly superseded by a new session
- Owner manually clears state

**Access Pattern:** Read at session start (via `session-start.sh` hook); updated
incrementally throughout the session.

### 2. Handoff Summaries

**Purpose:** Context transfer between agents, sessions, or across interruptions.

**Lifecycle:** Created when work on an issue begins; persists until issue closes.

**Storage:** `production/session-state/handoff-{issue-id}.md` (tracked in git)

**Contents:**
- Issue/contract ID and owner goal
- Active contracts related to this issue
- Last validated state (what is complete, what remains)
- Next scheduled action
- Risk items requiring owner attention
- Pending decisions awaiting owner input
- Cross-references to related issues/contracts
- Agent handoff notes (what the next agent needs to know)

**Retention:** Retained until:
- Issue is closed → archived to `production/session-logs/handoff-archive/`
- Explicitly superseded by a newer handoff for the same issue
- 90 days after issue close (archive cleanup policy)

**Access Pattern:** Read when an agent picks up an issue; updated when state changes
significantly (milestone reached, blocker encountered, session ends, escalation).

### 3. Durable Lessons

**Purpose:** Long-term learnings, patterns, conventions, and architectural decisions
that persist across the entire project lifetime.

**Lifecycle:** Accumulated over time; curated periodically; no auto-expiry.

**Storage:**
- GitHub memory API (for repo-wide and user-specific facts)
- `.agents/agent-memory/{agent-role}/MEMORY.md` (tracked, for agent-specific context)

**Contents:**
- Coding conventions discovered from the codebase
- Architectural patterns and their rationale
- Framework-specific best practices (e.g., YJackCore routing rules)
- Common pitfalls and how to avoid them
- Owner preferences (user-scoped memory)
- Build/test/validation commands
- File ownership patterns

**Retention:** Never auto-deleted. Curated manually or via `/memory-review` skill
when memory count exceeds thresholds or contradictions are detected.

**Access Pattern:** Loaded automatically by GitHub memory API; referenced explicitly
when an agent needs domain-specific context.

---

## File Paths and Gitignore Policy

| Path | Tracked in Git | Reason |
|------|----------------|--------|
| `production/session-state/active.md` | ❌ Gitignored | Ephemeral working state; valid only for current session |
| `production/session-state/handoff-*.md` | ✅ Tracked | Persistent context for issue resumption |
| `production/session-logs/` | ❌ Gitignored | Audit trail; too noisy for version control |
| `production/session-logs/handoff-archive/` | ❌ Gitignored | Historical handoffs; useful for audit, not for active work |
| `.agents/agent-memory/{agent}/MEMORY.md` | ✅ Tracked | Durable agent knowledge base |

### Rationale

**Why gitignore `active.md`?**
- Ephemeral by design; only valid during active session
- Session crashes should not leave stale tracked state
- Hook scripts detect presence and warn; agents self-recover from handoff files

**Why track `handoff-*.md`?**
- Must survive session crashes and context switches
- Enables multi-agent resumption without human retelling
- Audit trail of who worked on what and when

**Why gitignore `session-logs/`?**
- High churn; every session appends
- Useful for local debugging but not for shared history
- Archive policy prevents unbounded growth

---

## Memory Lifecycle Workflows

### Session Start (Resuming Work)

1. `session-start.sh` hook runs
2. Check for `production/session-state/active.md`:
   - If present: warn agent; show preview; agent reads full file to recover context
   - If absent: clean start; check for handoff file
3. Check for `production/session-state/handoff-{current-issue}.md`:
   - If present: agent reads handoff to understand where previous agent left off
   - If absent: agent is first to work on this issue; create handoff file when work begins
4. GitHub memory API loads durable lessons automatically
5. Agent proceeds with full context

### During Session (Incremental Updates)

1. Agent updates `active.md` after each milestone:
   - Design section approved and written
   - Architecture decision made
   - Implementation milestone reached
   - Test results obtained
2. Agent updates status line block when focus shifts (Production+ only)
3. Agent updates handoff file when:
   - Contract status changes
   - Blocker encountered
   - Risk escalation required
   - Significant decision made

### Session End (Clean Exit)

1. `session-stop.sh` hook runs
2. Archive `active.md` to `production/session-logs/session-log.md` (gitignored)
3. Update handoff file with final state:
   - What was completed this session
   - What remains for next session
   - Open blockers or questions
4. Commit handoff file update (tracked)
5. Delete `active.md` (clean slate for next session)

### Session Crash (Unclean Exit)

1. Next session starts
2. `session-start.sh` detects stale `active.md`
3. Agent reads both `active.md` and `handoff-{issue}.md`
4. Agent reconciles state:
   - If `active.md` is more recent: use it to update handoff, then delete active
   - If handoff is more recent: active is stale; ignore it and proceed from handoff
5. Continue work from recovered state

### Issue Close (Cleanup)

1. Owner or agent closes issue/contract
2. Handoff file is moved to `production/session-logs/handoff-archive/{issue-id}.md`
3. Archive includes final state and close timestamp
4. Active handoff file is deleted
5. Durable lessons from this issue are committed to GitHub memory API or agent MEMORY.md

---

## Handoff Record Schema

See [handoff-record-schema.md](handoff-record-schema.md) for the complete schema.

Quick summary of required sections:
- **Contract/Issue Identity**
- **Owner Goal** (copied from contract)
- **Last Validated State** (what is done, what remains)
- **Active Blockers** (if any)
- **Pending Decisions** (awaiting owner input)
- **Next Scheduled Action** (what the next agent should do)
- **Risk Items** (HIGH/MEDIUM escalations)
- **Agent Notes** (context that doesn't fit elsewhere)

---

## Retention Rules

### Short-Term Run Notes
- **Created:** When session starts work on a task
- **Updated:** Incrementally after each milestone
- **Deleted:** On clean session end after archiving to session-logs
- **Max Age:** N/A (deleted on session end)

### Handoff Summaries
- **Created:** When first agent picks up an issue
- **Updated:** On contract status change, blocker, escalation, or session end
- **Archived:** When issue closes (moved to `session-logs/handoff-archive/`)
- **Deleted:** 90 days after archive (cleanup script in `.agents/scripts/cleanup-handoff-archives.sh`)
- **Max Count:** No limit while issue is open; archive prevents unbounded growth

### Durable Lessons
- **Created:** When an agent discovers a pattern or convention worth remembering
- **Updated:** When a fact becomes stale or contradictory
- **Deleted:** Only via manual curation or `/memory-review` skill
- **Max Count:** 200 per repo (GitHub memory API soft limit); agent MEMORY.md has no hard limit but should be curated when it exceeds ~500 lines

---

## Integration with GitHub Memory API

GitHub's memory API provides repo-scoped and user-scoped memory that persists
across all sessions. The autonomous memory model leverages this for durable lessons:

- **Repo Memory:** Project-wide conventions, architecture decisions, build commands
- **User Memory:** Owner preferences, workflow habits, communication style

Agents use `store_memory` tool to commit durable lessons:
```yaml
subject: "YJackCore layer routing"
fact: "Combat systems always map to GameLayer or LevelLayer; never directly to CoreLayer"
citations: ".agents/docs/yjackcore-support.md:45-50"
reason: "Prevents host-game logic from coupling to YJackCore package internals"
scope: "repository"
```

---

## Per-Issue Handoff Notes

When multiple agents collaborate on a single issue:

1. First agent creates `handoff-{issue-id}.md` when work begins
2. Each agent updates the handoff before stopping work:
   - What they completed
   - What they discovered
   - What the next agent needs to know
3. Next agent reads the handoff to understand context
4. Handoff accumulates notes from all agents until issue closes

This enables:
- Parallel work on different contracts within the same epic
- Session interruptions without losing context
- Agent specialization (one agent designs, another implements, third tests)
- Clear accountability (who worked on what and when)

---

## Validation

The model is considered validated when:

1. A simulated multi-agent workflow succeeds:
   - Agent A starts work on an issue, creates handoff, stops mid-session
   - Agent B resumes from handoff file alone (no chat history)
   - Agent B completes the work and validates against success criteria
2. A session crash recovery succeeds:
   - Agent starts work, updates active.md and handoff
   - Session crashes (simulated by deleting agent context)
   - New session starts, recovers from files alone, continues work
3. Memory retention rules are enforced:
   - Short-term notes are gitignored
   - Handoff files are tracked
   - Durable lessons persist in GitHub memory or agent MEMORY.md
4. No secrets or credentials are stored in any memory tier

---

## Related Documents

- [handoff-record-schema.md](handoff-record-schema.md) — Complete handoff file schema
- [session-state-lifecycle.md](session-state-lifecycle.md) — Detailed state transition rules
- [work-contract-schema.md](work-contract-schema.md) — Contract lifecycle and handoff protocol
- [context-management.md](context-management.md) — File-backed state strategy
- [autonomy-modes.md](autonomy-modes.md) — Approval boundaries and escalation rules

---

## Migration from Current Model

Current state:
- `production/session-state/active.md` exists but is tracked (has `.gitkeep`)
- No structured handoff files
- Session logs exist but are gitignored
- No per-issue context transfer mechanism

Migration steps:
1. Add `production/session-state/active.md` to `.gitignore`
2. Update `session-start.sh` and `session-stop.sh` hooks to implement new lifecycle
3. Create handoff file template in `.agents/docs/templates/handoff-record.md`
4. Update skills that create session state to use new structure
5. Add cleanup script for handoff archives
6. Update coordination rules to reference handoff files for parallel agent work

---

## Implementation Checklist

- [x] Memory model specification (this document)
- [ ] Handoff record schema document
- [ ] Session state lifecycle document
- [ ] Update `.gitignore` to exclude `active.md`
- [ ] Update `session-start.sh` hook
- [ ] Update `session-stop.sh` hook
- [ ] Create handoff record template
- [ ] Create cleanup script for archives
- [ ] Update context-management.md to reference new model
- [ ] Update coordination-rules.md to reference handoff files
- [ ] Create validation test scenario
- [ ] Document GitHub memory integration best practices
