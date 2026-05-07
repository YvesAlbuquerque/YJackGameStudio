#!/usr/bin/env bash
set -euo pipefail

if [[ $# -lt 1 ]]; then
  echo "Usage: $0 <validation-packet.md> [more packets...]"
  exit 2
fi

required_headers=(
  "## Scope and Change Type"
  "## Checks Run (Static + Automated)"
  "## Checks Unavailable"
  "## Manual Validation Still Required"
  "## Verdict and Escalation"
)

status=0

for file in "$@"; do
  if [[ ! -f "$file" ]]; then
    echo "FAIL: $file (file not found)"
    status=1
    continue
  fi

  missing=0
  for header in "${required_headers[@]}"; do
    if ! grep -Fq "$header" "$file"; then
      echo "FAIL: $file (missing section: $header)"
      missing=1
      status=1
    fi
  done

  if ! grep -Eq "PASS|FAIL|WARN|NOT RUN|BLOCKED|CONCERNS" "$file"; then
    echo "FAIL: $file (no explicit status keyword found)"
    missing=1
    status=1
  fi

  if [[ "$missing" -eq 0 ]]; then
    echo "PASS: $file"
  fi
done

exit "$status"
