#!/usr/bin/env bash
# .agents/scripts/check-write-sets.sh
#
# Detects overlapping write sets across all active (approved + in_progress)
# work contracts in the dependency graph.
#
# Usage:
#   .agents/scripts/check-write-sets.sh [graph_file]
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
#   - bash 4+
#   - python3 (for YAML parsing; no third-party packages required — uses
#     only stdlib: sys, yaml if available, else falls back to regex parsing)
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

GRAPH_FILE="${1:-production/dependency-graph.yml}"

if [[ ! -f "$GRAPH_FILE" ]]; then
  echo "Error: graph file not found: $GRAPH_FILE" >&2
  echo "Usage: $0 [production/dependency-graph.yml]" >&2
  exit 2
fi

# ---------------------------------------------------------------------------
# Python helper — parse the YAML graph and run collision detection.
# Written inline so the script has no external file dependencies.
# ---------------------------------------------------------------------------
python3 - "$GRAPH_FILE" <<'PYTHON'
import sys
import re

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
            if not stripped or stripped.lstrip().startswith("#"):
                in_write_set = False
                in_dependencies = False
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
                    key, val = m.group(1), m.group(2).strip()
                    if key == "write_set":
                        in_write_set = True
                        indent_write_set = 6
                    elif key == "dependencies":
                        in_dependencies = True
                    elif key in ("status", "title", "specialist_agent",
                                 "blocked_by", "github_issue"):
                        graph["contracts"][current_contract][key] = val.strip('"').strip("'")
                continue

            # write_set list items (6-space indent)
            if in_write_set and indent == 6:
                m = re.match(r'^\s{6}-\s+"?(.*?)"?\s*$', stripped)
                if m:
                    graph["contracts"][current_contract]["write_set"].append(
                        m.group(1).strip()
                    )
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


def run_check(graph_path):
    graph = parse_graph(graph_path)
    contracts = graph.get("contracts") or {}

    if not contracts:
        print("No contracts found in graph. Nothing to check.")
        return 0

    active_states = {"approved", "in_progress"}
    active = {
        cid: data
        for cid, data in contracts.items()
        if str(data.get("status", "")).lower() in active_states
    }

    print(f"Checking write-set collisions for {len(active)} active contract(s)...")
    print()

    ids = sorted(active.keys())
    collisions = 0

    for i in range(len(ids)):
        for j in range(i + 1, len(ids)):
            id_a = ids[i]
            id_b = ids[j]
            ws_a = active[id_a].get("write_set") or []
            ws_b = active[id_b].get("write_set") or []

            for pa in ws_a:
                for pb in ws_b:
                    if paths_collide(pa, pb):
                        collisions += 1
                        print(f"[COLLISION] {id_a} <-> {id_b}")
                        print(f"  {id_a} owns: {pa}")
                        print(f"  {id_b} owns: {pb}")
                        if pa.rstrip("/") == pb.rstrip("/"):
                            print(f"  Reason: exact match")
                        elif pb.startswith(pa.rstrip("/") + "/"):
                            print(f"  Reason: {pa} is an ancestor of {pb}")
                        else:
                            print(f"  Reason: {pb} is an ancestor of {pa}")
                        print()
                        break  # report one collision per pair, then move on

    if collisions == 0:
        print("No collisions found. Safe to schedule parallel execution.")
        return 0
    else:
        print(f"{collisions} collision(s) found. Resolve before scheduling parallel execution.")
        print("Owner must approve all collision resolutions.")
        return 1


sys.exit(run_check(sys.argv[1]))
PYTHON
PYTHON_EXIT=$?
exit $PYTHON_EXIT
