#!/bin/bash
# agent tool SessionStart hook: Load project context at session start
# Outputs context information that AI agent sees when a session begins
#
# Input schema (SessionStart): No stdin input

echo "=== Agentic Game Studios — Session Context ==="

# Current branch
BRANCH=$(git rev-parse --abbrev-ref HEAD 2>/dev/null)
if [ -n "$BRANCH" ]; then
    echo "Branch: $BRANCH"

    # Recent commits
    echo ""
    echo "Recent commits:"
    git log --oneline -5 2>/dev/null | while read -r line; do
        echo "  $line"
    done
fi

# Current sprint (find most recent sprint file)
LATEST_SPRINT=$(ls -t production/sprints/sprint-*.md 2>/dev/null | head -1)
if [ -n "$LATEST_SPRINT" ]; then
    echo ""
    echo "Active sprint: $(basename "$LATEST_SPRINT" .md)"
fi

# Current milestone
LATEST_MILESTONE=$(ls -t production/milestones/*.md 2>/dev/null | head -1)
if [ -n "$LATEST_MILESTONE" ]; then
    echo "Active milestone: $(basename "$LATEST_MILESTONE" .md)"
fi

# Open bug count
BUG_COUNT=0
for dir in tests/playtest production; do
    if [ -d "$dir" ]; then
        count=$(find "$dir" -name "BUG-*.md" 2>/dev/null | wc -l)
        BUG_COUNT=$((BUG_COUNT + count))
    fi
done
if [ "$BUG_COUNT" -gt 0 ]; then
    echo "Open bugs: $BUG_COUNT"
fi

# Code health quick check
if [ -d "src" ]; then
    TODO_COUNT=$(grep -r "TODO" src/ 2>/dev/null | wc -l)
    FIXME_COUNT=$(grep -r "FIXME" src/ 2>/dev/null | wc -l)
    if [ "$TODO_COUNT" -gt 0 ] || [ "$FIXME_COUNT" -gt 0 ]; then
        echo ""
        echo "Code health: ${TODO_COUNT} TODOs, ${FIXME_COUNT} FIXMEs in src/"
    fi
fi

# --- Active session state recovery (AUTO-012) ---
# See .agents/docs/autonomous-memory-model.md for memory tier details
STATE_FILE="production/session-state/active.md"
if [ -f "$STATE_FILE" ]; then
    echo ""
    echo "=== ACTIVE SESSION STATE DETECTED ==="
    echo "⚠️  Possible crash recovery — active.md should not exist at session start"
    echo ""
    echo "Recovery steps:"
    echo "1. Read active.md (ephemeral state from crashed session)"
    echo "2. Read handoff-*.md files (persistent state from last commit)"
    echo "3. Reconcile state (compare timestamps, update handoff if active is newer)"
    echo "4. Archive active.md to session-logs, then delete it"
    echo "5. Create fresh active.md based on reconciled state"
    echo ""
    echo "Quick preview of active.md:"
    head -20 "$STATE_FILE" 2>/dev/null
    TOTAL_LINES=$(wc -l < "$STATE_FILE" 2>/dev/null)
    if [ "$TOTAL_LINES" -gt 20 ]; then
        echo "  ... ($TOTAL_LINES total lines — read the full file for complete context)"
    fi
    echo "=== END ACTIVE.MD PREVIEW ==="
fi

# --- Handoff file detection ---
HANDOFF_FILES=$(ls production/session-state/handoff-*.md 2>/dev/null || true)
if [ -n "$HANDOFF_FILES" ]; then
    echo ""
    echo "=== ACTIVE HANDOFF FILES ==="
    echo "Found persistent handoff records for in-progress work:"
    echo ""
    for file in $HANDOFF_FILES; do
        basename "$file"
        # Show owner goal from handoff if available
        GOAL=$(grep -A 1 "^## Owner Goal" "$file" 2>/dev/null | tail -1)
        if [ -n "$GOAL" ]; then
            echo "  Goal: $GOAL"
        fi
    done
    echo ""
    echo "Read these files to understand work context and resume from last validated state."
    echo "See .agents/docs/handoff-record-schema.md for handoff file structure."
    echo "=== END HANDOFF FILES ==="
fi

echo "==================================="
exit 0
