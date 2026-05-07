# AUTO-012 Validation Test Scenario

**Test Goal:** Verify that the autonomous memory model enables multi-agent handoff
and crash recovery without relying on chat history.

---

## Test 1: Clean Start → Clean End

**Scenario:** Agent starts work on a new issue, completes some work, ends session cleanly.

### Steps

1. Agent A starts session
2. Hook displays "no active.md, no handoff files"
3. Agent A picks up issue #999 (hypothetical)
4. Agent A creates `handoff-999.md` using template
5. Agent A creates `active.md` with current task
6. Agent A completes first milestone (creates a file)
7. Agent A updates `active.md` (mark milestone complete)
8. Agent A updates `handoff-999.md`:
   - Move milestone to "Completed" section
   - Update "Next Scheduled Action"
   - Update `last_updated` timestamp
   - Commit handoff update
9. Agent A ends session cleanly
10. Hook archives `active.md` to session-logs
11. Hook deletes `active.md`
12. Hook reminds agent to update handoff (already done)

### Expected Outcomes

- ✅ `production/session-state/active.md` does not exist after session end
- ✅ `production/session-state/handoff-999.md` exists and is committed
- ✅ `production/session-logs/session-log.md` contains archived active.md content
- ✅ Handoff file contains accurate "Last Validated State"
- ✅ Handoff file contains clear "Next Scheduled Action"

---

## Test 2: Resume from Handoff Only

**Scenario:** Agent B resumes work on issue #999 from handoff file alone (no chat history).

### Steps

1. Agent B starts new session (different session, different context window)
2. Hook displays "no active.md, handoff-999.md found"
3. Hook previews handoff goal: "Owner Goal: {from handoff}"
4. Agent B reads `handoff-999.md` fully
5. Agent B understands:
   - What was completed (reads "Completed" section)
   - What remains (reads "Remaining" section)
   - What to do next (reads "Next Scheduled Action")
   - Any blockers or risks (reads those sections)
6. Agent B creates new `active.md` for this session
7. Agent B continues work from "Next Scheduled Action"
8. Agent B completes next milestone
9. Agent B updates handoff, commits
10. Agent B ends session cleanly

### Expected Outcomes

- ✅ Agent B successfully resumed without chat history
- ✅ Agent B did not repeat work already completed by Agent A
- ✅ Agent B correctly identified next step from handoff
- ✅ Work progressed logically from where Agent A left off
- ✅ Handoff file now contains updates from both Agent A and Agent B

---

## Test 3: Crash Recovery

**Scenario:** Session crashes mid-work; next session recovers from stale active.md.

### Steps

1. Agent C starts session
2. Agent C reads handoff-999.md (from previous sessions)
3. Agent C creates `active.md` with current task
4. Agent C makes progress, updates active.md
5. **Session crashes** (simulated: stop without running session-stop hook)
6. active.md still exists (was not deleted)
7. Agent D starts new session
8. Hook detects stale `active.md` and displays warning:
   - "⚠️ Possible crash recovery"
   - "Recovery steps: read active.md, read handoff-999.md, reconcile..."
9. Agent D reads both files
10. Agent D compares timestamps:
    - active.md file mtime (when it was last written)
    - handoff-999.md `last_updated` field
11. Agent D determines which is newer
12. **If active.md is newer:**
    - Active contains progress not yet in handoff
    - Agent D updates handoff with active's progress
    - Agent D commits handoff
13. **If handoff is newer:**
    - Active is stale from before crash
    - Agent D ignores active
14. Agent D archives stale active.md to session-logs
15. Agent D deletes active.md
16. Agent D creates fresh active.md based on reconciled state
17. Agent D continues work

### Expected Outcomes

- ✅ Stale active.md was detected by hook
- ✅ Agent successfully reconciled active.md and handoff-999.md
- ✅ No progress was lost
- ✅ Agent resumed correctly from reconciled state
- ✅ active.md was archived and deleted before continuing

---

## Test 4: Multi-Agent Parallel Work

**Scenario:** Two agents work on different contracts within same epic simultaneously.

### Setup
- Epic EPIC-001 with 3 stories: STORY-001, STORY-002, STORY-003
- Agent E works on STORY-001 (writes `design/combat/melee.md`)
- Agent F works on STORY-002 (writes `design/combat/ranged.md`)
- No write-set collision (different files)

### Steps

1. Agent E starts, creates `handoff-STORY-001.md`
2. Agent F starts (parallel), creates `handoff-STORY-002.md`
3. Both agents work independently
4. Agent E completes milestone, updates `handoff-STORY-001.md`, commits
5. Agent F completes milestone, updates `handoff-STORY-002.md`, commits
6. No git conflicts (different files)
7. Both agents end sessions cleanly
8. Active session state for both is archived and deleted
9. Both handoff files persist

### Expected Outcomes

- ✅ Both agents worked in parallel without blocking each other
- ✅ Both handoff files exist with independent state
- ✅ No git merge conflicts
- ✅ Each handoff accurately reflects its contract's progress
- ✅ No write-set collision (different files)

---

## Test 5: Issue Close → Archive Handoff

**Scenario:** Issue closes; handoff file is archived and durable lessons are extracted.

### Steps

1. Agent G completes final work on issue #999
2. All success criteria are met
3. Agent G updates handoff-999.md with final state:
   - All items in "Completed" section
   - "Remaining" section is empty
   - Status updated to `validated`
4. Agent G commits handoff
5. Owner closes issue #999 in GitHub
6. Cleanup workflow runs (manual or automated):
   ```bash
   # Update handoff frontmatter
   # Add closed: timestamp, archived: timestamp, final_status: validated

   # Move to archive
   mv production/session-state/handoff-999.md \
      production/session-logs/handoff-archive/handoff-999.md
   ```
7. Agent extracts durable lessons from handoff:
   - Conventions discovered
   - Patterns learned
   - Commit to GitHub memory API or agent MEMORY.md
8. Active handoff file is deleted

### Expected Outcomes

- ✅ handoff-999.md moved to handoff-archive/
- ✅ handoff-999.md includes close and archive timestamps
- ✅ Active handoff file no longer exists in session-state/
- ✅ Durable lessons extracted to GitHub memory or MEMORY.md
- ✅ Archive is gitignored (not tracked in version control)

---

## Test 6: Handoff Archive Cleanup

**Scenario:** Old archives are deleted per retention policy.

### Setup
- Create test archives with different ages:
  - `handoff-archive/handoff-100.md` (91 days old)
  - `handoff-archive/handoff-101.md` (89 days old)
  - `handoff-archive/handoff-102.md` (91 days old, has `# KEEP` marker)
  - `handoff-archive/handoff-103.md` (50 days old)

### Steps

1. Run cleanup script:
   ```bash
   HANDOFF_RETENTION_DAYS=90 .agents/scripts/cleanup-handoff-archives.sh
   ```
2. Script finds archives older than 90 days:
   - handoff-100.md (91 days, no KEEP marker)
   - handoff-102.md (91 days, has KEEP marker)
3. Script checks for `# KEEP` markers
4. Script deletes handoff-100.md
5. Script preserves handoff-102.md (marked KEEP)
6. Script preserves handoff-101.md (89 days, under retention)
7. Script preserves handoff-103.md (50 days, under retention)

### Expected Outcomes

- ✅ handoff-100.md deleted (old, no KEEP)
- ✅ handoff-101.md preserved (under retention)
- ✅ handoff-102.md preserved (has KEEP marker)
- ✅ handoff-103.md preserved (under retention)
- ✅ Script reports summary: "1 deleted, 1 kept (marked), 2 kept (under retention)"

---

## Test 7: GitHub Memory Integration

**Scenario:** Agent stores durable lessons to GitHub memory API.

### Steps

1. Agent discovers a YJackCore layer routing rule while working
2. Agent uses `store_memory` tool:
   ```yaml
   subject: "YJackCore layer routing"
   fact: "Combat systems always map to GameLayer or LevelLayer; never directly to CoreLayer"
   citations: [".agents/docs/yjackcore-support.md:45-50"]
   reason: "Prevents host-game logic from coupling to YJackCore package internals. Future agents working on combat features need this routing rule to avoid architectural violations."
   ```
3. GitHub memory API stores the fact
4. Later session: different agent working on combat feature
5. GitHub memory API loads stored facts automatically
6. Agent sees the YJackCore routing rule
7. Agent applies rule correctly (maps to GameLayer, not CoreLayer)

### Expected Outcomes

- ✅ Fact stored successfully via GitHub memory API
- ✅ Fact loaded automatically in later session
- ✅ Agent applied rule correctly without rediscovering it
- ✅ No duplicate facts stored (idempotent)

---

## Success Criteria

All tests pass when:

1. ✅ Clean start/end workflow works (active.md created and deleted)
2. ✅ Resume from handoff works (no chat history needed)
3. ✅ Crash recovery works (stale active.md reconciled)
4. ✅ Multi-agent parallel work succeeds (no conflicts)
5. ✅ Issue close archives handoff correctly
6. ✅ Archive cleanup respects retention policy and KEEP markers
7. ✅ GitHub memory integration works (store and load durable lessons)

---

## Failure Cases to Test

### Handoff file corruption
**Scenario:** Handoff file has invalid YAML frontmatter

**Expected:** Agent detects invalid handoff, warns owner, continues with best effort

### Write-set collision with handoff update
**Scenario:** Two agents try to update same handoff file simultaneously

**Expected:** Git conflict resolution required; agents serialize via lock

### Missing handoff for IN_PROGRESS contract
**Scenario:** Contract is IN_PROGRESS but handoff file is missing

**Expected:** Agent creates handoff file on first session, continues work

### Handoff timestamp drift
**Scenario:** Handoff `last_updated` is older than claimed progress

**Expected:** Agent notices drift, reconciles state, warns in handoff notes

---

## Validation Checklist

- [ ] Test 1: Clean start → clean end
- [ ] Test 2: Resume from handoff only
- [ ] Test 3: Crash recovery
- [ ] Test 4: Multi-agent parallel work
- [ ] Test 5: Issue close → archive
- [ ] Test 6: Handoff archive cleanup
- [ ] Test 7: GitHub memory integration
- [ ] Failure case: Invalid handoff YAML
- [ ] Failure case: Concurrent handoff update
- [ ] Failure case: Missing handoff for IN_PROGRESS
- [ ] Failure case: Handoff timestamp drift

---

## Notes

This validation can be run manually by simulating the scenarios, or automated
by creating test fixtures and running agent sessions in CI.

For manual validation:
1. Create test issue #999 (or use existing issue)
2. Run scenarios step-by-step
3. Verify outcomes at each step
4. Document deviations or failures

For automated validation:
1. Create test fixtures in `tests/autonomous-memory/`
2. Use CI to spawn agent sessions with test data
3. Assert outcomes match expected results
4. Fail CI if any test fails
