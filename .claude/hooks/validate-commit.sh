#!/bin/bash
# Claude compatibility wrapper that delegates to provider-neutral hook.

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
exec "$SCRIPT_DIR/../../.agents/hooks/validate-commit.sh" "$@"
