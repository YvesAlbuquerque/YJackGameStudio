#!/usr/bin/env bash
# .agents/scripts/check-catalog-consistency.sh
#
# Validates that the CCGS Skill Testing Framework catalog.yaml is consistent
# with the actual skill and agent files on disk.  Designed to run in CI.
#
# Checks performed:
#   1. Every skill listed in catalog.yaml has a SKILL.md file under
#      .agents/skills/<name>/SKILL.md
#   2. Every .agents/skills/*/SKILL.md has a corresponding catalog entry
#      (detects count drift / unlisted skills)
#   3. README.md skill/agent counts match catalog counts
#   4. Catalog skill count matches the number of SKILL.md files on disk
#   5. Every catalog entry whose spec: field is non-empty points to a file
#      that exists on disk
#
# NOTE: This script NEVER writes to catalog.yaml.  Recording test results back
#       to the catalog is an explicit manual or agent-driven step, not a CI side
#       effect.
#
# Usage:
#   .agents/scripts/check-catalog-consistency.sh [catalog_path]
#
# Arguments:
#   catalog_path  Path to catalog.yaml
#                 Default: "CCGS Skill Testing Framework/catalog.yaml"
#
# Exit codes:
#   0 — Catalog is consistent with the filesystem
#   1 — Inconsistencies found (drift, missing files, count mismatch)
#   2 — Usage error or required file not found
#
# ─────────────────────────────────────────────────────────────────────────────

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"

if [[ $# -gt 1 ]]; then
  echo "Error: too many arguments." >&2
  echo "Usage: $0 [catalog_path]" >&2
  exit 2
fi

CATALOG_PATH="${1:-CCGS Skill Testing Framework/catalog.yaml}"
# Resolve relative paths from REPO_ROOT
if [[ ! -f "$CATALOG_PATH" ]]; then
  CATALOG_PATH="$REPO_ROOT/$CATALOG_PATH"
fi

if [[ ! -f "$CATALOG_PATH" ]]; then
  echo "Error: catalog file not found: $CATALOG_PATH" >&2
  exit 2
fi

README_PATH="$REPO_ROOT/CCGS Skill Testing Framework/README.md"
if [[ ! -f "$README_PATH" ]]; then
  echo "Error: README not found at: $README_PATH" >&2
  exit 2
fi

python3 - "$REPO_ROOT" "$CATALOG_PATH" "$README_PATH" <<'PYTHON'
import sys
import re
import os

def parse_catalog(path):
    """
    Minimal YAML parser for catalog.yaml.
    Returns {'skills': [{'name':..., 'spec':...}, ...],
             'agents': [{'name':..., 'spec':...}, ...]}
    """
    try:
        import yaml
        with open(path, encoding='utf-8') as f:
            data = yaml.safe_load(f)
        skills = [
            {'name': s.get('name', ''), 'spec': s.get('spec', '') or ''}
            for s in (data.get('skills') or [])
        ]
        agents = [
            {'name': a.get('name', ''), 'spec': a.get('spec', '') or ''}
            for a in (data.get('agents') or [])
        ]
        return skills, agents
    except ImportError:
        pass

    # Fallback regex parser
    skills = []
    agents = []
    current = None
    section = None

    with open(path, encoding='utf-8') as f:
        lines = f.readlines()

    for line in lines:
        stripped = line.rstrip()
        if re.match(r'^skills:\s*$', stripped):
            section = 'skills'
            continue
        if re.match(r'^agents:\s*$', stripped):
            section = 'agents'
            continue
        if section is None:
            continue
        m = re.match(r'^\s{2}-\s+name:\s+(\S+)', stripped)
        if m:
            current = {'name': m.group(1), 'spec': ''}
            if section == 'skills':
                skills.append(current)
            else:
                agents.append(current)
            continue
        if current is not None:
            m = re.match(r'^\s{4}spec:\s+(.*)', stripped)
            if m:
                current['spec'] = m.group(1).strip().strip('"').strip("'")

    return skills, agents


def find_readme_counts(readme_path):
    """
    Extract claimed skill and agent counts from the README.
    Looks for lines like: "72 skills + 49 agents" or "|72|" patterns.
    Returns (skill_count, agent_count) or (None, None) if not found.
    """
    with open(readme_path, encoding='utf-8') as f:
        text = f.read()

    # Match patterns like "72 skills + 49 agents" or "all 72 skills"
    skill_match = re.search(r'(?:all\s+)?(\d+)\s+skills?', text)
    agent_match = re.search(r'(?:all\s+)?(\d+)\s+agents?', text)
    sc = int(skill_match.group(1)) if skill_match else None
    ac = int(agent_match.group(1)) if agent_match else None
    return sc, ac


def find_actual_skills(repo_root):
    """Return sorted list of skill names from .agents/skills/*/SKILL.md"""
    skills_dir = os.path.join(repo_root, '.agents', 'skills')
    names = []
    if not os.path.isdir(skills_dir):
        return names
    for entry in sorted(os.listdir(skills_dir)):
        skill_file = os.path.join(skills_dir, entry, 'SKILL.md')
        if os.path.isfile(skill_file):
            names.append(entry)
    return sorted(names)


def run(repo_root, catalog_path, readme_path):
    print("=== Catalog Consistency Check ===")
    print(f"  Catalog: {os.path.relpath(catalog_path, repo_root)}")
    print()

    skills, agents = parse_catalog(catalog_path)
    catalog_skill_names = {s['name'] for s in skills}
    actual_skill_names = set(find_actual_skills(repo_root))

    issues = 0

    # ── Check 1: Skills in catalog that have no SKILL.md on disk ─────────────
    missing_on_disk = sorted(catalog_skill_names - actual_skill_names)
    if missing_on_disk:
        print(f"  [FAIL] Catalog lists {len(missing_on_disk)} skill(s) with no SKILL.md on disk:")
        for name in missing_on_disk:
            print(f"         - {name}")
        issues += 1
    else:
        print("  [PASS] All catalog skills have a SKILL.md on disk")

    # ── Check 2: SKILL.md files not listed in catalog (drift) ────────────────
    missing_in_catalog = sorted(actual_skill_names - catalog_skill_names)
    if missing_in_catalog:
        print(f"  [WARN] {len(missing_in_catalog)} skill file(s) on disk are not in catalog.yaml:")
        for name in missing_in_catalog:
            print(f"         - {name}  (.agents/skills/{name}/SKILL.md)")
        print("         Add these entries to catalog.yaml via /skill-test audit or a manual update step.")
        issues += 1
    else:
        print("  [PASS] All skill files on disk are registered in catalog.yaml")

    # ── Check 3: README claimed counts vs catalog counts ─────────────────────
    readme_skill_count, readme_agent_count = find_readme_counts(readme_path)
    catalog_skill_count = len(skills)
    catalog_agent_count = len(agents)
    disk_skill_count = len(actual_skill_names)

    if readme_skill_count is not None and readme_skill_count != catalog_skill_count:
        print(f"  [WARN] README claims {readme_skill_count} skills but catalog has {catalog_skill_count}")
        issues += 1
    elif readme_skill_count is not None:
        print(f"  [PASS] README skill count matches catalog ({readme_skill_count} skills)")

    if readme_agent_count is not None and readme_agent_count != catalog_agent_count:
        print(f"  [WARN] README claims {readme_agent_count} agents but catalog has {catalog_agent_count}")
        issues += 1
    elif readme_agent_count is not None:
        print(f"  [PASS] README agent count matches catalog ({readme_agent_count} agents)")

    # ── Check 4: Catalog count vs disk count ─────────────────────────────────
    if catalog_skill_count != disk_skill_count:
        print(f"  [WARN] Catalog has {catalog_skill_count} skills; disk has {disk_skill_count} SKILL.md files")
        issues += 1
    else:
        print(f"  [PASS] Catalog skill count matches disk ({catalog_skill_count} skills)")

    # ── Check 5: Spec files exist for non-empty spec: fields ─────────────────
    missing_specs = []
    for entry in skills + agents:
        spec = entry.get('spec', '')
        if spec:
            spec_path = os.path.join(repo_root, spec)
            if not os.path.isfile(spec_path):
                missing_specs.append((entry['name'], spec))

    if missing_specs:
        print(f"  [FAIL] {len(missing_specs)} catalog spec file(s) are missing on disk:")
        for name, spec in missing_specs:
            print(f"         - {name}: {spec}")
        issues += 1
    else:
        print(f"  [PASS] All catalog spec paths resolve to files on disk")

    # ── Summary ───────────────────────────────────────────────────────────────
    print()
    print(f"  Catalog  : {catalog_skill_count} skills, {catalog_agent_count} agents")
    print(f"  Disk     : {disk_skill_count} skills in .agents/skills/")
    if readme_skill_count is not None:
        print(f"  README   : claims {readme_skill_count} skills, {readme_agent_count or '?'} agents")
    print()

    if issues == 0:
        print("  Overall: CONSISTENT — catalog matches filesystem")
    else:
        print(f"  Overall: {issues} ISSUE(S) FOUND — see details above")
        print("  NOTE: Update catalog.yaml via /skill-test audit or a manual step (not auto-updated by CI).")

    return 1 if issues else 0


sys.exit(run(sys.argv[1], sys.argv[2], sys.argv[3]))
PYTHON
