# Session State Lifecycle

**Version:** 1.0
**Last Updated:** 2026-05-07
**Source:** [AUTO-012] from `docs/AUTONOMOUS_GAME_STUDIO_ROADMAP.md`

---

## Overview

This document defines the detailed state transition rules for the autonomous memory
model's ephemeral and persistent state files. It covers normal operation, crash
recovery, multi-agent handoff, and cleanup protocols.

See [autonomous-memory-model.md](autonomous-memory-model.md) for the overall
architecture and [handoff-record-schema.md](handoff-record-schema.md) for the
handoff file schema.

---

## State Files

### Ephemeral State

**File:** `production/session-state/active.md`
**Tracked:** ❌ Gitignored
**Lifetime:** Current session only

**Purpose:** Working memory for the current agent session. Contains current task,
progress checklist, open questions, test results, and status line block.

**Created:** When agent starts work on a task
**Updated:** Incrementally after each milestone
**Deleted:** On clean session end (after archiving to session-logs)

### Persistent State

**File:** `production/session-state/handoff-{issue-id}.md`
**Tracked:** ✅ Committed to git
**Lifetime:** Entire issue lifetime (until close, then archived)

**Purpose:** Context transfer between agents and sessions. Contains validated state,
blockers, pending decisions, next action, and agent notes.

**Created:** When first agent picks up an issue
**Updated:** On contract status change, blocker, escalation, or session end
**Deleted:** When issue closes (moved to archive first)

### Audit Trail

**File:** `production/session-logs/session-log.md`
**Tracked:** ❌ Gitignored
**Lifetime:** Indefinite (local only)

**Purpose:** Append-only log of all session activity. Useful for debugging and
local audit; not synchronized across machines.

---

## State Diagram

```
                    ┌─────────────────────────────────────┐
                    │   SESSION START                     │
                    └─────────────────┬───────────────────┘
                                      │
                    ┌─────────────────▼────────────────────┐
                    │ Check for active.md                  │
                    │ Check for handoff-{issue}.md         │
                    └─────────────────┬────────────────────┘
                                      │
                    ┌─────────────────▼────────────────────┐
         ┌──────────┤  State Recovery Decision             ├─────────┐
         │          └──────────────────────────────────────┘         │
         │                          │                                │
         │                          │                                │
    ┌────▼─────┐          ┌─────────▼────────┐           ┌──────────▼────────┐
    │ Clean    │          │ Resume from      │           │ Resume from       │
    │ Start    │          │ Handoff Only     │           │ Active + Handoff  │
    │          │          │                  │           │ (Crash Recovery)  │
    └────┬─────┘          └─────────┬────────┘           └──────────┬────────┘
         │                          │                                │
         │                          │                                │
         │          ┌───────────────▼────────────────────────────────▼────┐
         └──────────► Create/Update active.md with current task           │
                    │ Load handoff context (if exists)                    │
                    └───────────────┬─────────────────────────────────────┘
                                    │
                    ┌───────────────▼─────────────────────────────────────┐
                    │   WORK IN PROGRESS                                  │
                    │   - Update active.md incrementally                  │
                    │   - Update handoff on milestones                    │
                    └───────────────┬─────────────────────────────────────┘
                                    │
                    ┌───────────────▼─────────────────────────────────────┐
         ┌──────────┤   SESSION END (how?)                                ├─────────┐
         │          └─────────────────────────────────────────────────────┘         │
         │                                                                           │
    ┌────▼──────────┐                                              ┌─────────────────▼────┐
    │ Clean Exit    │                                              │ Crash / Unclean Exit │
    │               │                                              │                      │
    └────┬──────────┘                                              └──────────────────────┘
         │                                                                  │
         │ 1. Archive active.md → session-logs                              │ (no cleanup)
         │ 2. Update handoff with final state                               │
         │ 3. Commit handoff update                                         │ Next session:
         │ 4. Delete active.md                                              │ Detect stale active.md
         │                                                                  │ Reconcile with handoff
         └─────────────────────┬────────────────────────────────────────────┘
                               │
                    ┌──────────▼────────────────────────────┐
                    │  Session closed cleanly               │
                    │  active.md deleted                    │
                    │  handoff.md updated and committed     │
                    └───────────────────────────────────────┘
```

---

## State Transition Rules

### Transition: Session Start → Clean Start

**Condition:** No `active.md` and no `handoff-{issue}.md` exist for current work

**Actions:**
1. Agent identifies the issue/contract to work on
2. Agent creates `handoff-{issue}.md` with initial state:
   - Frontmatter with issue metadata
   - Owner Goal (from contract/issue)
   - Last Validated State: Completed = empty, Remaining = full scope
   - Next Scheduled Action: first step from contract
3. Agent creates `active.md` with:
   - Current task
   - Progress checklist
   - Files to work on
4. Agent begins work

**Postcondition:** Both `active.md` (gitignored) and `handoff-{issue}.md` (tracked) exist

---

### Transition: Session Start → Resume from Handoff Only

**Condition:** No `active.md`, but `handoff-{issue}.md` exists

**Actions:**
1. Hook script (`session-start.sh`) displays handoff preview
2. Agent reads full `handoff-{issue}.md` to understand context:
   - What was completed (Last Validated State)
   - Active blockers (if any)
   - Pending decisions
   - Next Scheduled Action
3. Agent creates new `active.md` based on handoff context
4. Agent continues work from Next Scheduled Action

**Postcondition:** Agent has full context; work resumes seamlessly

---

### Transition: Session Start → Resume from Active + Handoff (Crash Recovery)

**Condition:** Both `active.md` and `handoff-{issue}.md` exist

**Actions:**
1. Hook script warns: "ACTIVE SESSION STATE DETECTED — possible crash"
2. Agent reads both files:
   - Compare timestamps (`last_updated` in handoff vs. file mtime for active)
   - Check for content divergence
3. Reconciliation decision:
   - **If active.md is newer:** Active contains progress not yet in handoff
     - Update handoff with active's progress
     - Commit handoff update
     - Archive active to session-logs
     - Delete active.md
     - Create fresh active.md for new session
   - **If handoff is newer:** Active is stale (from previous crash)
     - Ignore active.md
     - Archive it to session-logs for audit
     - Delete active.md
     - Create fresh active.md based on handoff
   - **If timestamps are equal:** Active and handoff are in sync
     - Archive active to session-logs
     - Delete active.md
     - Create fresh active.md based on handoff
4. Agent continues work

**Postcondition:** Stale state is resolved; agent has correct context

---

### Transition: Work in Progress → Milestone Reached

**Condition:** Agent completes a significant unit of work

**Actions:**
1. Agent updates `active.md`:
   - Mark milestone as complete in checklist
   - Update current task to next item
2. Agent updates `handoff-{issue}.md`:
   - Move completed item from "Remaining" to "Completed" in Last Validated State
   - Update Next Scheduled Action to reflect new current focus
   - Update `last_updated` timestamp
   - Append to Session Log if applicable
3. Agent commits handoff update:
   ```
   git add production/session-state/handoff-{issue}.md
   git commit -m "Update handoff for issue #{id}: completed {milestone}"
   ```
4. Agent continues work

**Postcondition:** Progress is persisted; crash recovery point is current

---

### Transition: Work in Progress → Blocker Encountered

**Condition:** Agent cannot proceed without owner input or external dependency

**Actions:**
1. Agent updates `active.md`:
   - Mark current task as blocked
   - Document blocker in notes
2. Agent updates `handoff-{issue}.md`:
   - Add/update Active Blockers section:
     - Description of blocker
     - Blocked Since timestamp
     - Impact statement
     - Escalation action taken
   - Update status in frontmatter: `status: blocked`
   - Update Last Validated State (what is done before block)
   - Update Next Scheduled Action (what to do when unblocked)
   - Update `last_updated` timestamp
3. Agent commits handoff update
4. Agent escalates to owner:
   - Comment on issue
   - Update contract status to `blocked` if applicable
   - Surface in owner dashboard
5. Agent stops work (or switches to another task)

**Postcondition:** Blocker is documented and escalated; state is preserved for resumption

---

### Transition: Work in Progress → Clean Session End

**Condition:** Agent completes session normally (user ends session, work pause, switch tasks)

**Actions:**
1. Hook script (`session-stop.sh`) runs
2. Archive `active.md` to `production/session-logs/session-log.md`:
   ```bash
   echo "## Archived Session State: $(date)" >> session-logs/session-log.md
   cat production/session-state/active.md >> session-logs/session-log.md
   echo "---" >> session-logs/session-log.md
   ```
3. Update `handoff-{issue}.md`:
   - Update Last Validated State with latest progress
   - Update Next Scheduled Action for next session
   - Update `last_updated` timestamp
   - Append to Session Log: session end time and who worked
4. Commit handoff update
5. Delete `active.md`:
   ```bash
   rm production/session-state/active.md
   ```
6. Hook script logs session summary to `session-logs/session-log.md`

**Postcondition:** Ephemeral state is archived and deleted; persistent state is current

---

### Transition: Issue Close → Archive Handoff

**Condition:** Issue is closed (contract reaches `CLOSED` status)

**Actions:**
1. Agent or owner closes issue in GitHub
2. Cleanup workflow runs (manual or automated):
   ```bash
   # Update handoff frontmatter
   # Add closed and archived timestamps, final_status

   # Move to archive
   mkdir -p production/session-logs/handoff-archive
   mv production/session-state/handoff-{issue}.md \
      production/session-logs/handoff-archive/handoff-{issue}.md

   # Commit the move
   git add production/session-state/handoff-{issue}.md
   git add production/session-logs/handoff-archive/handoff-{issue}.md
   git commit -m "Archive handoff for closed issue #{issue}"
   ```
3. Extract durable lessons from handoff:
   - Conventions discovered
   - Patterns learned
   - Pitfalls avoided
   - Commit to GitHub memory API or agent MEMORY.md
4. Delete active handoff file

**Postcondition:** Handoff is archived (gitignored); durable lessons are preserved

---

## Hook Integration Points

### session-start.sh

**Current behavior:** Displays branch, recent commits, sprint, milestone, bug count

**New behavior:**
1. Keep existing context display
2. Add active.md detection:
   ```bash
   STATE_FILE="production/session-state/active.md"
   if [ -f "$STATE_FILE" ]; then
       echo "=== ACTIVE SESSION STATE DETECTED ==="
       echo "Possible crash recovery. Read active.md and handoff file to reconcile."
       head -20 "$STATE_FILE"
       echo "=== END PREVIEW ==="
   fi
   ```
3. Add handoff detection:
   ```bash
   # Detect handoff files for current branch/issue
   HANDOFF_FILES=$(ls production/session-state/handoff-*.md 2>/dev/null)
   if [ -n "$HANDOFF_FILES" ]; then
       echo "=== ACTIVE HANDOFF FILES ==="
       echo "$HANDOFF_FILES"
       echo "Read these to understand work in progress."
   fi
   ```

### session-stop.sh

**Current behavior:** Archives active.md and logs git activity to session-logs

**New behavior:**
1. Keep existing archive behavior (already archives active.md)
2. Add explicit delete of active.md after archiving:
   ```bash
   if [ -f "$STATE_FILE" ]; then
       # Archive (existing)
       cat "$STATE_FILE" >> "$SESSION_LOG_DIR/session-log.md"

       # DELETE active.md to ensure clean start next session
       rm "$STATE_FILE"
       echo "Archived and deleted active.md"
   fi
   ```
3. Add reminder to update handoff:
   ```bash
   HANDOFF_FILES=$(ls production/session-state/handoff-*.md 2>/dev/null)
   if [ -n "$HANDOFF_FILES" ]; then
       echo ""
       echo "REMINDER: Update handoff files before ending session:"
       echo "$HANDOFF_FILES"
   fi
   ```

---

## Crash Recovery Protocol

### Detection

Session crashed if:
1. New session starts and `active.md` exists
2. Hook script displays warning: "ACTIVE SESSION STATE DETECTED"

### Recovery Steps

1. **Read both files:**
   ```
   active.md → ephemeral state from crashed session
   handoff-{issue}.md → persistent state from last commit
   ```

2. **Compare timestamps:**
   - `active.md` file mtime vs. `handoff.md` `last_updated` field
   - Determine which is more recent

3. **Reconcile state:**
   - If active is newer: contains progress not yet persisted
     - Update handoff with active's progress
     - Commit handoff
   - If handoff is newer: active is stale
     - Ignore active

4. **Archive stale active.md:**
   ```bash
   cat production/session-state/active.md >> production/session-logs/crash-recovery.md
   rm production/session-state/active.md
   ```

5. **Create fresh active.md:**
   - Based on reconciled state
   - Continue work from Next Scheduled Action in handoff

### Prevention

Best practices to minimize crash recovery complexity:
- Update handoff file after every milestone (not just at session end)
- Commit handoff updates immediately
- Keep active.md focused on current session only (don't accumulate history)
- Use session-logs for audit trail, not active.md

---

## Multi-Agent Coordination

### Scenario: Agent A starts, Agent B resumes

**Agent A:**
1. Creates `handoff-{issue}.md` on first pickup
2. Creates `active.md` for session working notes
3. Works on task, updates active incrementally
4. Reaches milestone → updates handoff, commits
5. Ends session cleanly → archives active, updates handoff, deletes active

**Agent B:**
1. Starts new session
2. Hook detects handoff file, displays preview
3. Agent B reads handoff to understand context:
   - What Agent A completed
   - What remains
   - Next Scheduled Action
4. Agent B creates new `active.md` for their session
5. Continues work from handoff's Next Scheduled Action

**No chat history required.** Agent B has full context from handoff file alone.

### Scenario: Parallel agents on different contracts within same epic

**Setup:**
- Epic-001 with 3 stories: STORY-001, STORY-002, STORY-003
- Agent A works on STORY-001
- Agent B works on STORY-002 (different write_set, no collision)

**Each agent:**
1. Creates own handoff file: `handoff-STORY-001.md`, `handoff-STORY-002.md`
2. Works independently
3. Updates own handoff on milestones
4. Commits handoff updates (no conflicts; different files)

**Epic-level coordination:**
- Epic may have its own handoff: `handoff-EPIC-001.md`
- Epic handoff references story handoffs
- Producer or lead agent updates epic handoff with rollup status

**No synchronization bottleneck.** Each agent owns their handoff file.

---

## Retention and Cleanup

### Active.md Cleanup

**Policy:** Delete on every clean session end

**Reason:** Ephemeral by design; valid only for current session

**Exception:** On crash, archive to `session-logs/crash-recovery.md` before deleting

### Handoff File Cleanup

**Policy:** Retain until issue closes, then archive

**Archive retention:** 90 days (configurable in `production/autonomy-config.md`)

**Cleanup script:** `.agents/scripts/cleanup-handoff-archives.sh`

**Run frequency:** Weekly (via cron or CI scheduled job)

**Logic:**
```bash
# Find archives older than 90 days
find production/session-logs/handoff-archive/ -name "handoff-*.md" -mtime +90 -delete
```

**Override:** Owner may extend retention for specific issues by adding `# KEEP` comment
to archive file header

### Session-logs Cleanup

**Policy:** Never auto-delete

**Reason:** Local audit trail; useful for debugging; already gitignored (not synchronized)

**Manual cleanup:** Owner may delete old session-logs when disk space is constrained

---

## Validation Criteria

The session state lifecycle is considered validated when:

1. **Clean start works:**
   - Agent creates handoff and active files
   - Work proceeds normally
   - Session ends cleanly
   - active.md is deleted
   - handoff is updated and committed

2. **Resume from handoff works:**
   - Agent reads handoff file
   - Continues work from Next Scheduled Action
   - No context loss

3. **Crash recovery works:**
   - Stale active.md detected
   - State reconciled with handoff
   - Agent resumes correctly

4. **Multi-agent handoff works:**
   - Agent A creates handoff
   - Agent B resumes from handoff alone (no chat history)
   - Work completes successfully

5. **Issue close archival works:**
   - Handoff moved to archive
   - Durable lessons extracted
   - Active handoff deleted

6. **Cleanup script works:**
   - Archives older than 90 days are deleted
   - Archives with `# KEEP` are preserved
   - Script runs without errors

---

## Migration Checklist

- [ ] Add `production/session-state/active.md` to `.gitignore`
- [ ] Update `session-start.sh` to detect active.md and handoff files
- [ ] Update `session-stop.sh` to delete active.md after archiving
- [ ] Create handoff template in `.agents/docs/templates/handoff-record.md`
- [ ] Create cleanup script `.agents/scripts/cleanup-handoff-archives.sh`
- [ ] Update context-management.md to reference new lifecycle
- [ ] Add lifecycle diagram to autonomous-memory-model.md
- [ ] Test clean start workflow
- [ ] Test crash recovery workflow
- [ ] Test multi-agent handoff workflow
- [ ] Test issue close archival workflow

---

## Related Documents

- [autonomous-memory-model.md](autonomous-memory-model.md) — Overall memory architecture
- [handoff-record-schema.md](handoff-record-schema.md) — Handoff file schema
- [work-contract-schema.md](work-contract-schema.md) — Contract lifecycle
- [context-management.md](context-management.md) — File-backed state strategy
