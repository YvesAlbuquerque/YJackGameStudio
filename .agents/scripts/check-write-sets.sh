#!/usr/bin/env bash
# .agents/scripts/check-write-sets.sh
#
# Detects overlapping write sets across all active (approved + in_progress)
# work contracts in the dependency graph.
#
# Usage:
#   .agents/scripts/check-write-sets.sh [OPTIONS] [graph_file]
#
# Options:
#   --format=text    Output human-readable text (default)
#   --format=json    Output machine-parseable JSON
#
# Arguments:
#   graph_file   Path to the YAML dependency graph.
#                Default: production/dependency-graph.yml
#
# Exit codes:
#   0  — No collisions found (safe to schedule)
#   1  — One or more collisions detected (must resolve before scheduling)
#   2  — Usage error or graph file not found
#
# Requirements:
#   - bash 3.2+ (no bash 4-specific features are used)
#   - python3 stdlib (sys, re). PyYAML (third-party) is used automatically
#     when installed — it is faster and more robust. The script falls back to
#     a built-in regex parser when PyYAML is not available.
#
# Notes:
#   - Collision detection uses the prefix/ancestry rule:
#     path A collides with path B if A == B, A is a prefix of B, or B is a
#     prefix of A (where "prefix" means the other path starts with this path
#     followed by "/" or is identical).
#   - Only contracts with status "approved" or "in_progress" are checked.
#     Proposed, blocked, validated, and closed contracts are skipped.
#   - All detected collisions are printed. The script does NOT resolve them.
#     Collision resolution always requires owner approval.
#
# ─────────────────────────────────────────────────────────────────────────────

set -euo pipefail

# Parse options
OUTPUT_FORMAT="text"
POSITIONAL_ARGS=()

while [[ $# -gt 0 ]]; do
  case "$1" in
    --format=*)
      OUTPUT_FORMAT="${1#*=}"
      if [[ "$OUTPUT_FORMAT" != "text" && "$OUTPUT_FORMAT" != "json" ]]; then
        echo "Error: invalid format '$OUTPUT_FORMAT'. Use 'text' or 'json'." >&2
        exit 2
      fi
      shift
      ;;
    --format)
      echo "Error: --format requires a value (--format=text or --format=json)" >&2
      exit 2
      ;;
    -*)
      echo "Error: unknown option '$1'" >&2
      echo "Usage: $0 [--format=text|json] [production/dependency-graph.yml]" >&2
      exit 2
      ;;
    *)
      POSITIONAL_ARGS+=("$1")
      shift
      ;;
  esac
done

# Restore positional parameters
set -- "${POSITIONAL_ARGS[@]}"

# Validate argument count (extra arguments are not accepted).
if [[ $# -gt 1 ]]; then
  echo "Error: too many arguments." >&2
  echo "Usage: $0 [--format=text|json] [production/dependency-graph.yml]" >&2
  exit 2
fi

# Require python3.
if ! command -v python3 >/dev/null 2>&1; then
  echo "Error: python3 is required but was not found in PATH." >&2
  exit 2
fi

GRAPH_FILE="${1:-production/dependency-graph.yml}"

if [[ ! -f "$GRAPH_FILE" ]]; then
  echo "Error: graph file not found: $GRAPH_FILE" >&2
  echo "Usage: $0 [production/dependency-graph.yml]" >&2
  exit 2
fi

# ---------------------------------------------------------------------------
# Python helper — parse the YAML graph and run collision detection.
# Written inline so the script has no external file dependencies.
# Supports both text and JSON output modes.
# ---------------------------------------------------------------------------
python3 - "$GRAPH_FILE" "$OUTPUT_FORMAT" <<'PYTHON'
import sys
import re
import json
from datetime import datetime

def parse_graph(path):
    """
    Minimal YAML parser for the dependency-graph format.
    Relies on the indentation-based structure defined in the schema.
    Falls back to PyYAML if available for reliability.
    """
    try:
        import yaml
        with open(path) as f:
            return yaml.safe_load(f)
    except ImportError:
        pass

    # Fallback: line-by-line regex parser for the expected schema structure.
    # This handles the common case without PyYAML installed.
    graph = {"contracts": {}}
    current_contract = None
    in_write_set = False
    in_dependencies = False
    indent_write_set = 0

    with open(path) as f:
        for line in f:
            stripped = line.rstrip()
            # Skip blank lines and comment lines, but do NOT reset section
            # flags — blank lines and comments may appear inside a write_set
            # or dependencies block without ending the section.
            if not stripped or stripped.lstrip().startswith("#"):
                continue

            indent = len(line) - len(line.lstrip())

            # Top-level "contracts:" key
            if re.match(r'^contracts:\s*$', stripped):
                continue
            if re.match(r'^contracts:\s*\{\}', stripped):
                continue

            # Contract ID (2-space indent, ends with colon)
            m = re.match(r'^  (\S.*?):\s*$', stripped)
            if m and indent == 2:
                current_contract = m.group(1)
                graph["contracts"][current_contract] = {
                    "write_set": [],
                    "dependencies": [],
                    "status": "proposed",
                    "title": "",
                    "specialist_agent": "",
                }
                in_write_set = False
                in_dependencies = False
                continue

            if current_contract is None:
                continue

            # Fields at 4-space indent
            if indent == 4:
                in_write_set = False
                in_dependencies = False
                m = re.match(r'^\s{4}(\w+):\s*(.*)', stripped)
                if m:
                    key, raw_val = m.group(1), m.group(2).strip()
                    # Strip inline YAML comment (e.g. "approved  # ready" → "approved")
                    val = re.sub(r'\s+#.*$', '', raw_val).strip().strip('"').strip("'")
                    if key == "write_set":
                        in_write_set = True
                        indent_write_set = 6
                    elif key == "dependencies":
                        in_dependencies = True
                    elif key in ("status", "title", "specialist_agent",
                                 "blocked_by", "github_issue"):
                        # Skip empty values (e.g. `status: ""  # comment`)
                        if val:
                            graph["contracts"][current_contract][key] = val
                continue

            # write_set list items (6-space indent)
            if in_write_set and indent == 6:
                # Capture the list item, then strip inline YAML comments.
                m = re.match(r'^\s{6}-\s+"?(.*?)"?\s*$', stripped)
                if m:
                    item = re.sub(r'\s+#.*$', '', m.group(1)).strip()
                    if item:
                        graph["contracts"][current_contract]["write_set"].append(item)
                continue

            # dependencies list items (6-space indent)
            if in_dependencies and indent == 6:
                m = re.match(r'^\s{6}-\s+contract_id:\s+"?(.*?)"?\s*$', stripped)
                if m:
                    dep = {"contract_id": m.group(1).strip()}
                    graph["contracts"][current_contract]["dependencies"].append(dep)
                continue

    return graph


def paths_collide(a, b):
    """
    Return True if path a and path b overlap under the prefix/ancestry rule.
    Normalise both paths to end without a trailing slash for the comparison,
    then check for equality or one being a parent of the other.
    """
    a = a.rstrip("/")
    b = b.rstrip("/")
    if a == b:
        return True
    # a is a parent of b
    if b.startswith(a + "/"):
        return True
    # b is a parent of a
    if a.startswith(b + "/"):
        return True
    return False


def run_check(graph_path, output_format):
    graph = parse_graph(graph_path)
    contracts = graph.get("contracts") or {}

    if not contracts:
        if output_format == "json":
            result = {
                "schema_version": "1.0",
                "timestamp": datetime.utcnow().isoformat() + "Z",
                "command": f"check-write-sets.sh {graph_path}",
                "exit_code": 0,
                "summary": {
                    "verdict": "PASS",
                    "total_items": 0,
                    "passed": 0,
                    "failed": 0,
                    "warnings": 0
                },
                "items": [],
                "errors": [],
                "remediation": {
                    "available": False,
                    "suggestions": []
                }
            }
            print(json.dumps(result, indent=2))
        else:
            print("No contracts found in graph. Nothing to check.")
        return 0

    active_states = {"approved", "in_progress"}
    active = {
        cid: data
        for cid, data in contracts.items()
        if str(data.get("status", "")).lower() in active_states
    }

    if output_format == "text":
        print(f"Checking write-set collisions for {len(active)} active contract(s)...")
        print()

    ids = sorted(active.keys())
    collisions = []

    for i in range(len(ids)):
        for j in range(i + 1, len(ids)):
            id_a = ids[i]
            id_b = ids[j]
            ws_a = active[id_a].get("write_set") or []
            ws_b = active[id_b].get("write_set") or []

            for pa in ws_a:
                for pb in ws_b:
                    if paths_collide(pa, pb):
                        collision = {
                            "contract_a": id_a,
                            "contract_b": id_b,
                            "path_a": pa,
                            "path_b": pb,
                            "reason": "exact match" if pa.rstrip("/") == pb.rstrip("/")
                                      else (f"{pa} is an ancestor of {pb}" if pb.startswith(pa.rstrip("/") + "/")
                                      else f"{pb} is an ancestor of {pa}")
                        }
                        collisions.append(collision)

                        if output_format == "text":
                            print(f"[COLLISION] {id_a} <-> {id_b}")
                            print(f"  {id_a} owns: {pa}")
                            print(f"  {id_b} owns: {pb}")
                            print(f"  Reason: {collision['reason']}")
                            print()

    if output_format == "json":
        result = {
            "schema_version": "1.0",
            "timestamp": datetime.utcnow().isoformat() + "Z",
            "command": f"check-write-sets.sh {graph_path}",
            "exit_code": 1 if collisions else 0,
            "summary": {
                "verdict": "FAIL" if collisions else "PASS",
                "total_items": len(active),
                "passed": 0 if collisions else len(active),
                "failed": len(collisions),
                "warnings": 0
            },
            "items": [
                {
                    "id": cid,
                    "status": active[cid].get("status"),
                    "write_set": active[cid].get("write_set") or [],
                    "verdict": "PASS"
                }
                for cid in ids
            ],
            "errors": [
                {
                    "code": "WRITE_SET_COLLISION",
                    "severity": "FAIL",
                    "message": f"Write-set collision between {c['contract_a']} and {c['contract_b']}",
                    "context": {
                        "contract_a": c["contract_a"],
                        "contract_b": c["contract_b"],
                        "path_a": c["path_a"],
                        "path_b": c["path_b"],
                        "reason": c["reason"]
                    },
                    "remediation": {
                        "action": "owner_resolution",
                        "command": "Owner must resolve: defer one contract, merge them, or grant explicit parallel write permission",
                        "documentation": ".agents/docs/work-contract-schema.md#parallel-execution-rules"
                    }
                }
                for c in collisions
            ],
            "remediation": {
                "available": False,
                "suggestions": [
                    "All write-set collisions require owner approval to resolve",
                    "Options: defer one contract, merge contracts, or grant explicit parallel write permission"
                ] if collisions else []
            }
        }
        print(json.dumps(result, indent=2))
    else:
        if collisions:
            print(f"{len(collisions)} collision(s) found. Resolve before scheduling parallel execution.")
            print("Owner must approve all collision resolutions.")
        else:
            print("No collisions found. Safe to schedule parallel execution.")

    return 1 if collisions else 0


sys.exit(run_check(sys.argv[1], sys.argv[2]))
PYTHON
