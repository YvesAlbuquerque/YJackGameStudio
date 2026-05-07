#!/bin/bash
# agent tool Stop hook: Log session summary when AI agent finishes
# Records what was worked on for audit trail and sprint tracking

TIMESTAMP=$(date +%Y%m%d_%H%M%S)
SESSION_LOG_DIR="production/session-logs"

mkdir -p "$SESSION_LOG_DIR" 2>/dev/null

# Log recent git activity from this session (check up to 8 hours for long sessions)
RECENT_COMMITS=$(git log --oneline --since="8 hours ago" 2>/dev/null)
MODIFIED_FILES=$(git diff --name-only 2>/dev/null)

# --- Archive and delete active session state (AUTO-012) ---
# See .agents/docs/autonomous-memory-model.md for memory tier lifecycle
# active.md is ephemeral and should be deleted on clean exit
STATE_FILE="production/session-state/active.md"
if [ -f "$STATE_FILE" ]; then
    # Archive to session-logs
    {
        echo "## Archived Session State: $TIMESTAMP"
        cat "$STATE_FILE"
        echo "---"
        echo ""
    } >> "$SESSION_LOG_DIR/session-log.md" 2>/dev/null

    # DELETE active.md to ensure clean start next session
    rm "$STATE_FILE" 2>/dev/null
    echo "Archived and deleted active.md (ephemeral state cleared)"
fi

# --- Handoff file reminder ---
HANDOFF_FILES=$(ls production/session-state/handoff-*.md 2>/dev/null || true)
if [ -n "$HANDOFF_FILES" ]; then
    echo ""
    echo "⚠️  REMINDER: Update handoff files before ending session:"
    for file in $HANDOFF_FILES; do
        echo "  - $(basename "$file")"
    done
    echo ""
    echo "Handoff files should reflect:"
    echo "  - Last validated state (what was completed this session)"
    echo "  - Next scheduled action (what to do next session)"
    echo "  - Updated timestamp in frontmatter"
    echo ""
    echo "Commit handoff updates to git after updating."
    echo "See .agents/docs/handoff-record-schema.md for update protocol."
fi

if [ -n "$RECENT_COMMITS" ] || [ -n "$MODIFIED_FILES" ]; then
    {
        echo "## Session End: $TIMESTAMP"
        if [ -n "$RECENT_COMMITS" ]; then
            echo "### Commits"
            echo "$RECENT_COMMITS"
        fi
        if [ -n "$MODIFIED_FILES" ]; then
            echo "### Uncommitted Changes"
            echo "$MODIFIED_FILES"
        fi
        echo "---"
        echo ""
    } >> "$SESSION_LOG_DIR/session-log.md" 2>/dev/null
fi

exit 0
