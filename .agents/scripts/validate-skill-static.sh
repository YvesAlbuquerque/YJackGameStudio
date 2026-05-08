#!/usr/bin/env bash
# .agents/scripts/validate-skill-static.sh
#
# Runs the 7 static structural checks defined in /skill-test static mode on one
# or more SKILL.md files.  This script is the scriptable equivalent of the
# agent-driven /skill-test static command and is designed to run in CI.
#
# Usage:
#   .agents/scripts/validate-skill-static.sh [OPTIONS] [all | <skill-name> | <path/to/SKILL.md>]
#
# Options:
#   --format=text    Output human-readable text (default)
#   --format=json    Output machine-parseable JSON conforming to validation-output.schema.json
#
# Arguments:
#   all              Check every .agents/skills/*/SKILL.md (default when omitted)
#   <skill-name>     Check .agents/skills/<name>/SKILL.md
#   <path/to/SKILL.md>  Check the given file directly (useful for fixtures)
#
# Exit codes:
#   0 — All checked skills COMPLIANT or WARNINGS (no hard FAILs)
#   1 — At least one skill NON-COMPLIANT (contains a hard FAIL)
#   2 — Usage error or file not found
#
# Checks (mirrors /skill-test static):
#   1. Required frontmatter fields  (name, description, argument-hint,
#                                    user-invocable, allowed-tools)
#   2. Multiple phases              (≥2 phase headings)
#   3. Verdict keywords             (PASS|FAIL|CONCERNS|APPROVED|BLOCKED|
#                                    COMPLETE|READY|COMPLIANT|NON-COMPLIANT)
#   4. Collaborative protocol       ("May I write" / ask-before-write language)
#   5. Next-step handoff            (recommended follow-up at end of skill)
#   6. Fork context complexity      (context: fork → ≥5 phases)
#   7. Argument hint plausibility   (argument-hint must be non-empty)
#
# ─────────────────────────────────────────────────────────────────────────────

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"

usage() {
  echo "Usage: $0 [OPTIONS] [all | <skill-name> | <path/to/SKILL.md>]" >&2
  echo "" >&2
  echo "Options:" >&2
  echo "  --format=text      Human-readable output (default)" >&2
  echo "  --format=json      Machine-parseable JSON output" >&2
  echo "" >&2
  echo "Arguments:" >&2
  echo "  all                Check all .agents/skills/*/SKILL.md (default)" >&2
  echo "  <skill-name>       Check .agents/skills/<name>/SKILL.md" >&2
  echo "  <path/to/SKILL.md> Check the specified file" >&2
  echo "" >&2
  echo "Exit codes:" >&2
  echo "  0 — All skills COMPLIANT or WARNINGS only" >&2
  echo "  1 — At least one NON-COMPLIANT skill (has FAIL)" >&2
  echo "  2 — Usage error or file not found" >&2
}

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
      usage
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

if [[ $# -gt 1 ]]; then
  echo "Error: too many arguments." >&2
  usage
  exit 2
fi

ARG="${1:-all}"

# ---------------------------------------------------------------------------
# Collect the list of SKILL.md files to validate
# ---------------------------------------------------------------------------
SKILL_FILES=()

if [[ "$ARG" == "all" ]]; then
  while IFS= read -r f; do
    SKILL_FILES+=("$f")
  done < <(find "$REPO_ROOT/.agents/skills" -name "SKILL.md" | sort)
elif [[ "$ARG" == *.md || "$ARG" == */SKILL.md ]]; then
  # Direct path given (absolute or relative)
  if [[ -f "$ARG" ]]; then
    SKILL_FILES+=("$ARG")
  elif [[ -f "$REPO_ROOT/$ARG" ]]; then
    SKILL_FILES+=("$REPO_ROOT/$ARG")
  else
    echo "Error: file not found: $ARG" >&2
    exit 2
  fi
else
  # Treat as a skill name
  CANDIDATE="$REPO_ROOT/.agents/skills/$ARG/SKILL.md"
  if [[ -f "$CANDIDATE" ]]; then
    SKILL_FILES+=("$CANDIDATE")
  else
    echo "Error: skill not found: $ARG (tried $CANDIDATE)" >&2
    exit 2
  fi
fi

if [[ ${#SKILL_FILES[@]} -eq 0 ]]; then
  echo "Error: no SKILL.md files found under $REPO_ROOT/.agents/skills/" >&2
  exit 2
fi

# ---------------------------------------------------------------------------
# Python validator — all 7 checks, inline so the script has no external deps
# Supports both text and JSON output modes
# ---------------------------------------------------------------------------
python3 - "${SKILL_FILES[@]}" "$OUTPUT_FORMAT" <<'PYTHON'
import sys
import re
import os
import json
from datetime import datetime

VERDICT_KEYWORDS = re.compile(
    r'\b(PASS|FAIL|CONCERNS|APPROVED|BLOCKED|COMPLETE|READY|COMPLIANT|NON-COMPLIANT'
    r'|CLEAR TO SHIP|FIX CRITICALS FIRST|DO NOT SHIP'  # security-audit release verdicts
    r'|MIGRATION COMPLETE|ADOPTION COMPLETE'            # adopt completion verdicts
    r')\b'
)

ASK_WRITE_PATTERNS = [
    re.compile(r'May I write', re.IGNORECASE),
    re.compile(r'May I (?:write|update|append|create|modify|remove|delete|overwrite|generate)', re.IGNORECASE),
    re.compile(r'before writing', re.IGNORECASE),
    re.compile(r'\bapproval\b.*\bwrite\b|\bwrite\b.*\bapproval\b', re.IGNORECASE | re.DOTALL),
    re.compile(r'\bask\b.*\bwrite\b|\bwrite\b.*\bask\b', re.IGNORECASE),
]

PHASE_HEADING = re.compile(
    r'^##\s+(Phase\s+\d|Phase\s+[A-Z]\d?|\d+\.\s)',
    re.MULTILINE
)
ANY_H2 = re.compile(r'^##\s+\S', re.MULTILINE)

HANDOFF_PATTERNS = [
    re.compile(r'Recommended next', re.IGNORECASE),
    re.compile(r'next step', re.IGNORECASE),
    re.compile(r'Follow-[Uu]p|After this', re.IGNORECASE),
    re.compile(r'`/\w[\w-]+`'),   # references another slash command
]

REQUIRED_FM_FIELDS = ['name', 'description', 'argument-hint', 'user-invocable', 'allowed-tools']

WRITE_TOOLS = re.compile(r'\b(Write|Edit)\b')


def fm_has_field(fm, key):
    """Return True if key appears as a YAML field (line-anchored) in the frontmatter."""
    return bool(re.search(r'^' + re.escape(key) + r'\s*:', fm, re.MULTILINE))


def parse_frontmatter(text):
    """Extract the YAML frontmatter between the first pair of '---' lines."""
    lines = text.split('\n')
    if not lines or lines[0].strip() != '---':
        return ''
    end = -1
    for i in range(1, len(lines)):
        if lines[i].strip() == '---':
            end = i
            break
    if end == -1:
        return ''
    return '\n'.join(lines[1:end])


def count_phases(text):
    phase_matches = PHASE_HEADING.findall(text)
    if len(phase_matches) >= 2:
        return len(phase_matches)
    # Fall back: count any ## headings if explicit Phase N not used
    h2_matches = ANY_H2.findall(text)
    return len(h2_matches)


def check_skill(path):
    try:
        with open(path, encoding='utf-8') as f:
            text = f.read()
    except OSError as e:
        return None, f"Cannot read file: {e}"

    fm = parse_frontmatter(text)
    results = []   # list of (check_id, label, level, detail)
    # level: PASS | WARN | FAIL

    # ── Check 1: Required frontmatter fields ──────────────────────────────────
    missing = [key for key in REQUIRED_FM_FIELDS if not fm_has_field(fm, key)]
    if missing:
        results.append((1, 'Frontmatter Fields', 'FAIL',
                         f"missing: {', '.join(k + ':' for k in missing)}"))
    else:
        results.append((1, 'Frontmatter Fields', 'PASS', ''))

    # ── Check 2: Multiple phases ───────────────────────────────────────────────
    phase_count = count_phases(text)
    if phase_count < 2:
        results.append((2, 'Multiple Phases', 'FAIL',
                         f"only {phase_count} phase heading(s) found; need ≥2"))
    else:
        results.append((2, 'Multiple Phases', 'PASS',
                         f"{phase_count} heading(s) found"))

    # ── Check 3: Verdict keywords ──────────────────────────────────────────────
    verdict_hits = VERDICT_KEYWORDS.findall(text)
    if not verdict_hits:
        results.append((3, 'Verdict Keywords', 'FAIL', 'no verdict keyword found'))
    else:
        uniq = sorted(set(verdict_hits))
        results.append((3, 'Verdict Keywords', 'PASS',
                         ', '.join(uniq[:5]) + ('…' if len(uniq) > 5 else '')))

    # ── Check 4: Collaborative protocol (ask-before-write) ────────────────────
    has_write_tool = bool(WRITE_TOOLS.search(fm))
    has_ask = any(p.search(text) for p in ASK_WRITE_PATTERNS)
    if not has_ask:
        level = 'FAIL' if has_write_tool else 'WARN'
        detail = (
            'allowed-tools includes Write/Edit but no ask-before-write language'
            if has_write_tool
            else 'no ask-before-write language (acceptable for read-only skills)'
        )
        results.append((4, 'Collaborative Protocol', level, detail))
    else:
        results.append((4, 'Collaborative Protocol', 'PASS', '"May I write" / approval language found'))

    # ── Check 5: Next-step handoff ─────────────────────────────────────────────
    has_handoff = any(p.search(text) for p in HANDOFF_PATTERNS)
    if not has_handoff:
        results.append((5, 'Next-Step Handoff', 'WARN', 'no follow-up / next-step section found'))
    else:
        results.append((5, 'Next-Step Handoff', 'PASS', ''))

    # ── Check 6: Fork context complexity ──────────────────────────────────────
    is_fork = bool(re.search(r'^context:\s*fork', fm, re.MULTILINE))
    if is_fork:
        if phase_count < 5:
            results.append((6, 'Fork Context Complexity', 'WARN',
                             f"context: fork set but only {phase_count} phases (expect ≥5)"))
        else:
            results.append((6, 'Fork Context Complexity', 'PASS',
                             f"{phase_count} phases, context: fork set"))
    else:
        results.append((6, 'Fork Context Complexity', 'PASS', 'context: fork not set'))

    # ── Check 7: Argument hint plausibility ───────────────────────────────────
    hint_match = re.search(r'^argument-hint:\s*"?(.*?)"?\s*$', fm, re.MULTILINE)
    hint = hint_match.group(1).strip() if hint_match else ''
    if not hint:
        results.append((7, 'Argument Hint', 'WARN', 'argument-hint is empty'))
    else:
        results.append((7, 'Argument Hint', 'PASS', f'"{hint[:60]}"'))

    return results, None


def format_single(skill_label, results):
    """Pretty-print the 7-check table for one skill."""
    lines = [f"=== Skill Static Check: {skill_label} ===", ""]
    fails = 0
    warns = 0
    for check_id, label, level, detail in results:
        suffix = f"  ({detail})" if detail else ''
        lines.append(f"  Check {check_id} — {label:<30} {level}{suffix}")
        if level == 'FAIL':
            fails += 1
        elif level == 'WARN':
            warns += 1
    lines.append("")
    if fails:
        lines.append(f"  Verdict: NON-COMPLIANT ({fails} failure(s), {warns} warning(s))")
    elif warns:
        lines.append(f"  Verdict: WARNINGS ({warns} warning(s), 0 failures)")
    else:
        lines.append("  Verdict: COMPLIANT")
    return '\n'.join(lines), fails, warns


def run(paths, output_format):
    single = len(paths) == 1

    total = 0
    compliant = 0
    warnings_only = 0
    non_compliant = 0
    rows = []
    all_items = []
    all_errors = []

    for path in paths:
        total += 1
        # Derive a short label for the skill
        parts = path.replace('\\', '/').split('/')
        if 'SKILL.md' in parts:
            idx = parts.index('SKILL.md')
            label = '/' + parts[idx - 1] if idx > 0 else path
        else:
            label = os.path.basename(os.path.dirname(path))

        results, err = check_skill(path)
        if err:
            if output_format != "json":
                print(f"ERROR processing {path}: {err}", file=sys.stderr)
            non_compliant += 1
            rows.append((label, 'ERROR', err))
            all_errors.append({
                "code": "FILE_NOT_FOUND" if "Cannot read" in err else "VALIDATION_ERROR",
                "severity": "FAIL",
                "message": err,
                "context": {"file": path}
            })
            continue

        output, fails, warns = format_single(label, results)

        if fails:
            verdict = 'NON-COMPLIANT'
            non_compliant += 1
        elif warns:
            verdict = 'WARNINGS'
            warnings_only += 1
        else:
            verdict = 'COMPLIANT'
            compliant += 1

        # Build item for JSON output
        item = {
            "id": label,
            "path": path,
            "verdict": verdict,
            "checks": [
                {
                    "check_id": r[0],
                    "name": r[1],
                    "result": r[2],
                    "detail": r[3],
                    "required": r[2] == 'FAIL'
                }
                for r in results
            ]
        }
        all_items.append(item)

        # Collect errors for JSON
        for r in results:
            if r[2] in ('FAIL', 'WARN'):
                error_code = {
                    1: "MISSING_FRONTMATTER_FIELD",
                    2: "INSUFFICIENT_PHASES",
                    3: "NO_VERDICT_KEYWORDS",
                    4: "MISSING_COLLABORATIVE_PROTOCOL",
                    5: "MISSING_NEXT_STEP_HANDOFF",
                    6: "FORK_COMPLEXITY_MISMATCH",
                    7: "EMPTY_ARGUMENT_HINT"
                }.get(r[0], "UNKNOWN_ERROR")

                all_errors.append({
                    "code": error_code,
                    "severity": r[2],
                    "message": f"Check {r[0]} — {r[1]}: {r[3]}" if r[3] else f"Check {r[0]} — {r[1]} failed",
                    "context": {
                        "file": path,
                        "check_id": r[0],
                        "check_name": r[1]
                    }
                })

        if single and output_format == "text":
            print(output)
        elif output_format == "text":
            issues = '; '.join(
                f"Check {r[0]}: {r[3]}" for r in results if r[2] in ('FAIL', 'WARN')
            )
            rows.append((label, verdict, issues))

    # Output results
    if output_format == "json":
        result = {
            "schema_version": "1.0",
            "timestamp": datetime.utcnow().isoformat() + "Z",
            "command": "validate-skill-static.sh " + " ".join(sys.argv[1:-1]),
            "exit_code": 1 if non_compliant else 0,
            "summary": {
                "verdict": "FAIL" if non_compliant else ("WARNINGS" if warnings_only else "PASS"),
                "total_items": total,
                "passed": compliant,
                "failed": non_compliant,
                "warnings": warnings_only
            },
            "items": all_items,
            "errors": all_errors,
            "remediation": {
                "available": any(e["code"] in ["MISSING_FRONTMATTER_FIELD", "INSUFFICIENT_PHASES"] for e in all_errors),
                "suggestions": [
                    "Run with --format=text for detailed check output",
                    "See .agents/docs/skills-reference.md for skill structure requirements"
                ] if all_errors else []
            }
        }
        print(json.dumps(result, indent=2))
    elif not single:
        print(f"=== Skill Static Check: All {total} Skills ===")
        print()
        col = max(len(r[0]) for r in rows) + 2
        header = f"  {'Skill':<{col}}  {'Result':<15}  Issues"
        print(header)
        print('  ' + '-' * (len(header) - 2))
        for label, verdict, issues in rows:
            print(f"  {label:<{col}}  {verdict:<15}  {issues}")
        print()
        print(f"  Summary: {compliant} COMPLIANT, {warnings_only} WARNINGS, {non_compliant} NON-COMPLIANT")
        if non_compliant:
            print(f"  Aggregate Verdict: {non_compliant} FAILURE(S)")
        else:
            print("  Aggregate Verdict: PASS (no hard failures)")

    return 1 if non_compliant else 0


sys.exit(run(sys.argv[1:-1], sys.argv[-1]))
PYTHON
