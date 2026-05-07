#!/bin/bash
# Cleanup old handoff archives
# Part of autonomous memory model (AUTO-012)
# See .agents/docs/autonomous-memory-model.md for retention policy

set -e

ARCHIVE_DIR="production/session-logs/handoff-archive"
RETENTION_DAYS="${HANDOFF_RETENTION_DAYS:-90}"  # Default 90 days, override via env var

# Color output
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

echo "=== Handoff Archive Cleanup ==="
echo "Archive directory: $ARCHIVE_DIR"
echo "Retention period: $RETENTION_DAYS days"
echo ""

# Check if archive directory exists
if [ ! -d "$ARCHIVE_DIR" ]; then
    echo -e "${YELLOW}Archive directory does not exist. Nothing to clean up.${NC}"
    exit 0
fi

# Validate retention input to prevent malformed find predicates
if ! [[ "$RETENTION_DAYS" =~ ^[0-9]+$ ]]; then
    echo -e "${RED}Invalid HANDOFF_RETENTION_DAYS: '$RETENTION_DAYS' (must be a non-negative integer).${NC}"
    exit 1
fi

# Find archives older than retention period
ARCHIVES_TO_DELETE=$(find "$ARCHIVE_DIR" -name "handoff-*.md" -mtime "+$RETENTION_DAYS" 2>/dev/null || true)

if [ -z "$ARCHIVES_TO_DELETE" ]; then
    echo -e "${GREEN}No archives older than ${RETENTION_DAYS} days found.${NC}"
    exit 0
fi

# Count archives
ARCHIVE_COUNT=$(echo "$ARCHIVES_TO_DELETE" | wc -l)
echo -e "${YELLOW}Found ${ARCHIVE_COUNT} archive(s) older than ${RETENTION_DAYS} days:${NC}"
echo "$ARCHIVES_TO_DELETE"
echo ""

# Check for KEEP markers
KEPT_ARCHIVES=()
DELETED_ARCHIVES=()

while IFS= read -r archive; do
    # Check if file has # KEEP marker in header
    if head -5 "$archive" 2>/dev/null | grep -q "# KEEP"; then
        KEPT_ARCHIVES+=("$archive")
        echo -e "${GREEN}KEEPING (marked): $archive${NC}"
    else
        DELETED_ARCHIVES+=("$archive")
        echo -e "${RED}DELETING: $archive${NC}"
        rm "$archive"
    fi
done <<< "$ARCHIVES_TO_DELETE"

echo ""
echo "=== Summary ==="
echo "Archives deleted: ${#DELETED_ARCHIVES[@]}"
echo "Archives kept (marked): ${#KEPT_ARCHIVES[@]}"
echo ""

if [ ${#DELETED_ARCHIVES[@]} -gt 0 ]; then
    echo -e "${GREEN}Cleanup complete.${NC}"
else
    echo -e "${YELLOW}No archives deleted (all marked to KEEP or none found).${NC}"
fi

exit 0
