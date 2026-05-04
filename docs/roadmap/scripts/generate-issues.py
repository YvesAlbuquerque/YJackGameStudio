#!/usr/bin/env python3
"""
Roadmap OS — GitHub Issue Generator
=====================================
Creates GitHub Issues from Roadmap OS task YAML files.
Duplicate-safe: checks existing issues before creating new ones.

Requirements:
    - GitHub CLI (gh) must be installed and authenticated:
        gh auth login
    - PyYAML is optional but recommended:
        pip install pyyaml

Usage:
    python3 docs/roadmap/scripts/generate-issues.py [options]

Options:
    --dry-run          Preview issues that would be created; do not hit GitHub.
    --type TYPE        Only process tasks of this type (autonomous|bug|improvement|feature).
    --id ID            Only process the task with this ID (e.g. AUTO-003).
    --status STATUS    Only process tasks with this lifecycle status (default: APPROVED).
    --dir DIR          Tasks directory to scan (default: docs/roadmap/tasks/).
    --repo OWNER/REPO  GitHub repository to create issues in (default: from git remote).
    --verbose          Show detailed output for each task.

Examples:
    # Dry run — preview without touching GitHub
    python3 docs/roadmap/scripts/generate-issues.py --dry-run

    # Create issues for all APPROVED tasks
    python3 docs/roadmap/scripts/generate-issues.py

    # Create issues for autonomous tasks only
    python3 docs/roadmap/scripts/generate-issues.py --type autonomous

    # Create issue for a single task
    python3 docs/roadmap/scripts/generate-issues.py --id AUTO-003

    # Preview PROPOSED tasks (useful for planning)
    python3 docs/roadmap/scripts/generate-issues.py --status PROPOSED --dry-run
"""

import argparse
import json
import os
import re
import subprocess
import sys
import textwrap

# ---------------------------------------------------------------------------
# YAML loading (same helper as validate.py — no shared import needed)
# ---------------------------------------------------------------------------

def _try_import_yaml():
    try:
        import yaml  # noqa: PLC0415
        return yaml
    except ImportError:
        return None


def load_yaml(path):
    """Load a YAML file. Uses PyYAML if available, else minimal fallback."""
    yaml_mod = _try_import_yaml()
    if yaml_mod is not None:
        with open(path, encoding="utf-8") as fh:
            return yaml_mod.safe_load(fh) or {}
    return _minimal_yaml_load(path)


def _minimal_yaml_load(path):
    """Minimal YAML loader for task file format (no dependencies)."""
    result = {}
    with open(path, encoding="utf-8") as fh:
        lines = fh.readlines()
    i = 0
    while i < len(lines):
        line = lines[i].rstrip("\n")
        stripped = line.strip()
        if not stripped or stripped.startswith("#"):
            i += 1
            continue
        if re.match(r"^[a-zA-Z_][a-zA-Z0-9_]*\s*:", line):
            key_match = re.match(r"^([a-zA-Z_][a-zA-Z0-9_]*)\s*:(.*)", line)
            key = key_match.group(1)
            rest = key_match.group(2).strip()
            if rest == ">":
                i += 1
                scalar_lines = []
                while i < len(lines):
                    bl = lines[i].rstrip("\n")
                    if bl.startswith("  ") or bl.strip() == "":
                        scalar_lines.append(bl.strip())
                        i += 1
                    else:
                        break
                result[key] = " ".join(s for s in scalar_lines if s)
                continue
            elif rest == "" and i + 1 < len(lines) and lines[i + 1].startswith("  -"):
                i += 1
                items = []
                while i < len(lines):
                    bl = lines[i].rstrip("\n")
                    if bl.startswith("  - "):
                        items.append(bl[4:].strip().strip('"').strip("'"))
                        i += 1
                    elif bl.startswith("    "):
                        if items:
                            items[-1] = items[-1] + " " + bl.strip()
                        i += 1
                    else:
                        break
                result[key] = items
                continue
            elif rest.lower() == "null":
                result[key] = None
            elif re.match(r"^-?[0-9]+$", rest):
                result[key] = int(rest)
            else:
                result[key] = rest.strip('"').strip("'")
        i += 1
    return result


# ---------------------------------------------------------------------------
# Task file collection
# ---------------------------------------------------------------------------

def collect_task_files(root_dir, task_type=None, task_id=None):
    """Return list of (path, data) tuples for matching task files."""
    results = []
    for dirpath, _, filenames in os.walk(root_dir):
        for fname in sorted(filenames):
            if not (fname.endswith(".yaml") or fname.endswith(".yml")):
                continue
            path = os.path.join(dirpath, fname)
            try:
                data = load_yaml(path)
            except Exception as exc:  # noqa: BLE001
                print(f"WARNING: could not parse {path}: {exc}", file=sys.stderr)
                continue
            if not isinstance(data, dict):
                continue
            if task_type and data.get("type") != task_type:
                continue
            if task_id and data.get("id") != task_id:
                continue
            results.append((path, data))
    return results


# ---------------------------------------------------------------------------
# GitHub CLI helpers
# ---------------------------------------------------------------------------

def gh_available():
    """Return True if the `gh` CLI is available and authenticated."""
    try:
        result = subprocess.run(
            ["gh", "auth", "status"],
            capture_output=True, text=True, timeout=10,
        )
        return result.returncode == 0
    except (FileNotFoundError, subprocess.TimeoutExpired):
        return False


def gh_detect_repo():
    """Detect the GitHub repository from the git remote."""
    try:
        result = subprocess.run(
            ["gh", "repo", "view", "--json", "nameWithOwner", "-q", ".nameWithOwner"],
            capture_output=True, text=True, timeout=10,
        )
        if result.returncode == 0:
            return result.stdout.strip()
    except (FileNotFoundError, subprocess.TimeoutExpired):
        pass
    return None


def gh_search_issues(repo, title_prefix, verbose=False):
    """
    Search GitHub issues (open + closed) for issues whose title starts with
    title_prefix. Returns list of dicts with 'number', 'title', 'state', 'url'.
    """
    query = f'repo:{repo} in:title "{title_prefix}"'
    cmd = [
        "gh", "issue", "list",
        "--repo", repo,
        "--search", query,
        "--state", "all",
        "--json", "number,title,state,url",
        "--limit", "10",
    ]
    if verbose:
        print(f"  [gh] {' '.join(cmd)}")
    try:
        result = subprocess.run(cmd, capture_output=True, text=True, timeout=30)
        if result.returncode != 0:
            print(f"WARNING: gh issue list failed: {result.stderr.strip()}", file=sys.stderr)
            return []
        issues = json.loads(result.stdout or "[]")
        # Filter to exact prefix match
        prefix_lower = title_prefix.lower()
        return [i for i in issues if i["title"].lower().startswith(prefix_lower)]
    except (subprocess.TimeoutExpired, json.JSONDecodeError, FileNotFoundError) as exc:
        print(f"WARNING: issue search failed: {exc}", file=sys.stderr)
        return []


def gh_create_issue(repo, title, body, labels, dry_run=False, verbose=False):
    """
    Create a GitHub issue. Returns the issue URL string, or a dry-run preview string.
    """
    if dry_run:
        label_str = ", ".join(labels) if labels else "(none)"
        return f"[DRY RUN] Would create issue: {title!r} with labels: {label_str}"

    cmd = ["gh", "issue", "create", "--repo", repo, "--title", title, "--body", body]
    for label in labels:
        cmd += ["--label", label]

    if verbose:
        print(f"  [gh] {' '.join(cmd[:8])} ...")

    try:
        result = subprocess.run(cmd, capture_output=True, text=True, timeout=60)
        if result.returncode != 0:
            raise RuntimeError(result.stderr.strip() or "gh issue create failed")
        return result.stdout.strip()
    except subprocess.TimeoutExpired as exc:
        raise RuntimeError("gh issue create timed out") from exc


def gh_ensure_labels(repo, labels, dry_run=False):
    """
    Ensure that the given labels exist in the repository.
    Creates missing labels with a default grey colour.
    """
    if dry_run:
        return

    # Get existing labels
    try:
        result = subprocess.run(
            ["gh", "label", "list", "--repo", repo, "--json", "name", "--limit", "200"],
            capture_output=True, text=True, timeout=30,
        )
        existing = {item["name"] for item in json.loads(result.stdout or "[]")}
    except Exception:  # noqa: BLE001
        existing = set()

    for label in labels:
        if label not in existing:
            subprocess.run(
                ["gh", "label", "create", label, "--repo", repo,
                 "--color", "ededed", "--description", f"Roadmap OS label: {label}"],
                capture_output=True, text=True, timeout=30,
            )


# ---------------------------------------------------------------------------
# Issue body formatting
# ---------------------------------------------------------------------------

DEFAULT_LABELS = {
    "autonomous":  ["autonomous", "roadmap"],
    "bug":         ["bug"],
    "improvement": ["enhancement"],
    "feature":     ["feature"],
}


def build_issue_labels(data):
    """Combine default type labels with any task-specific labels."""
    task_type = data.get("type", "feature")
    defaults = list(DEFAULT_LABELS.get(task_type, []))
    extras = data.get("labels") or []
    # Deduplicate while preserving order
    seen = set()
    result = []
    for lbl in defaults + extras:
        if lbl not in seen:
            seen.add(lbl)
            result.append(lbl)
    return result


def format_list(items, indent=""):
    """Format a list as a Markdown checklist."""
    if not items:
        return f"{indent}_None specified._"
    return "\n".join(f"{indent}- [ ] {item}" for item in items)


def format_plain_list(items, indent=""):
    """Format a list as a plain Markdown bullet list."""
    if not items:
        return f"{indent}_None specified._"
    return "\n".join(f"{indent}- `{item}`" for item in items)


def build_issue_body(data, task_file_path):
    """Render the GitHub issue body from task data."""
    task_id   = data.get("id", "")
    task_type = data.get("type", "")
    desc      = (data.get("description") or "").strip()
    subsystem = data.get("subsystem", "")
    priority  = data.get("priority", "")
    effort    = data.get("effort", "")
    notes     = (data.get("notes") or "").strip()
    ac        = data.get("acceptance_criteria") or []
    artifacts = data.get("artifacts") or []
    deps      = data.get("dependencies") or []

    effort_labels = {
        "S": "Small (< 1 day)",
        "M": "Medium (1–3 days)",
        "L": "Large (3–5 days) — requires decomposition",
        "XL": "Extra Large (> 5 days) — requires Phase 1 Planning",
    }
    effort_desc = effort_labels.get(effort, effort)

    rel_path = os.path.relpath(task_file_path) if task_file_path else f"docs/roadmap/tasks/{task_type}/{task_id}.yaml"

    body = textwrap.dedent(f"""\
        <!-- Auto-generated from {rel_path} -->
        <!-- Do not edit this body directly; update the YAML file and re-run generate-issues.py -->

        ## Description

        {desc}

        ## Subsystem

        `{subsystem}`

        ## Priority / Effort

        **Priority:** {priority} | **Effort:** {effort_desc}

        ## Acceptance Criteria

        {format_list(ac)}

        ## Artifacts

        {format_plain_list(artifacts)}

        ## Dependencies

        {format_plain_list(deps)}
        """)

    if notes:
        body += f"\n## Notes\n\n{notes}\n"

    body += f"\n---\n_Task file: `{rel_path}`_\n"
    return body


# ---------------------------------------------------------------------------
# Main logic
# ---------------------------------------------------------------------------

def parse_args():
    p = argparse.ArgumentParser(
        description="Generate GitHub Issues from Roadmap OS task YAML files.",
        formatter_class=argparse.RawDescriptionHelpFormatter,
        epilog=__doc__,
    )
    p.add_argument("--dry-run", action="store_true",
                   help="Preview issues without creating them on GitHub.")
    p.add_argument("--type", dest="task_type", metavar="TYPE",
                   help="Only process tasks of this type.")
    p.add_argument("--id", dest="task_id", metavar="ID",
                   help="Only process the task with this ID.")
    p.add_argument("--status", dest="status", metavar="STATUS", default="APPROVED",
                   help="Only process tasks with this status (default: APPROVED).")
    p.add_argument("--dir", dest="tasks_dir", metavar="DIR",
                   help="Tasks directory to scan.")
    p.add_argument("--repo", metavar="OWNER/REPO",
                   help="GitHub repository (default: detected from git remote).")
    p.add_argument("--verbose", "-v", action="store_true",
                   help="Show detailed output.")
    return p.parse_args()


def main():
    args = parse_args()

    script_dir = os.path.dirname(os.path.abspath(__file__))
    repo_root  = os.path.abspath(os.path.join(script_dir, "..", "..", ".."))
    default_tasks_dir = os.path.join(repo_root, "docs", "roadmap", "tasks")
    tasks_dir  = os.path.abspath(args.tasks_dir) if args.tasks_dir else default_tasks_dir

    if not os.path.isdir(tasks_dir):
        print(f"ERROR: tasks directory not found: {tasks_dir}", file=sys.stderr)
        sys.exit(1)

    # Check gh availability (skip in dry-run)
    if not args.dry_run:
        if not gh_available():
            print(
                "ERROR: GitHub CLI (gh) is not available or not authenticated.\n"
                "Install: https://cli.github.com/\n"
                "Authenticate: gh auth login\n"
                "Or use --dry-run to preview without hitting GitHub.",
                file=sys.stderr,
            )
            sys.exit(1)

    # Detect repository
    repo = args.repo
    if not repo and not args.dry_run:
        repo = gh_detect_repo()
        if not repo:
            print(
                "ERROR: could not detect GitHub repository. Use --repo OWNER/REPO.",
                file=sys.stderr,
            )
            sys.exit(1)

    if repo:
        print(f"Repository: {repo}")
    else:
        print("Repository: (dry run — not required)")

    # Collect tasks
    tasks = collect_task_files(tasks_dir, task_type=args.task_type, task_id=args.task_id)

    # Filter by status
    valid_statuses = {"PROPOSED", "APPROVED", "IN_PROGRESS", "BLOCKED", "VALIDATED", "CLOSED"}
    filter_status = args.status.upper()
    if filter_status not in valid_statuses:
        print(f"ERROR: --status '{filter_status}' is not a valid status.", file=sys.stderr)
        print(f"       Valid values: {sorted(valid_statuses)}", file=sys.stderr)
        sys.exit(1)

    tasks = [(path, data) for (path, data) in tasks if data.get("status") == filter_status]

    if not tasks:
        print(f"No tasks found with status '{filter_status}'. Nothing to do.")
        sys.exit(0)

    print(f"Found {len(tasks)} task(s) with status '{filter_status}'.\n")

    created = 0
    skipped_duplicate = 0
    skipped_has_issue = 0
    errors = 0

    # Pre-ensure labels exist (skip in dry-run)
    if not args.dry_run and repo:
        all_labels = set()
        for _, data in tasks:
            all_labels.update(build_issue_labels(data))
        gh_ensure_labels(repo, sorted(all_labels), dry_run=False)

    for path, data in tasks:
        task_id = data.get("id", "<unknown>")
        title   = data.get("title", "")
        rel     = os.path.relpath(path, repo_root)

        issue_title  = f"[{task_id}] {title}"
        title_prefix = f"[{task_id}]"

        print(f"Task: {task_id} — {title}")
        if args.verbose:
            print(f"  File: {rel}")

        # Skip if github_issue already set
        if data.get("github_issue"):
            print(f"  SKIP — github_issue already set: #{data['github_issue']}\n")
            skipped_has_issue += 1
            continue

        # Duplicate detection
        if not args.dry_run and repo:
            existing = gh_search_issues(repo, title_prefix, verbose=args.verbose)
            if existing:
                for iss in existing:
                    print(f"  SKIP — existing issue found: #{iss['number']} [{iss['state']}] {iss['url']}")
                print()
                skipped_duplicate += 1
                continue

        # Build labels and body
        labels = build_issue_labels(data)
        body   = build_issue_body(data, path)

        if args.verbose:
            print(f"  Labels: {labels}")

        # Create (or dry-run preview)
        try:
            result = gh_create_issue(
                repo or "OWNER/REPO",
                issue_title,
                body,
                labels,
                dry_run=args.dry_run,
                verbose=args.verbose,
            )
            if args.dry_run:
                print(f"  {result}")
                if args.verbose:
                    print(f"  Body preview ({len(body)} chars):")
                    for line in body.split("\n")[:12]:
                        print(f"    {line}")
                    if body.count("\n") > 12:
                        print(f"    ... ({body.count(chr(10)) - 12} more lines)")
            else:
                print(f"  CREATED — {result}")
            created += 1
        except RuntimeError as exc:
            print(f"  ERROR — {exc}", file=sys.stderr)
            errors += 1

        print()

    # Summary
    print("─" * 60)
    action = "Would create" if args.dry_run else "Created"
    print(f"{action}: {created}")
    print(f"Skipped (github_issue already set): {skipped_has_issue}")
    print(f"Skipped (duplicate found on GitHub): {skipped_duplicate}")
    if errors:
        print(f"Errors: {errors}")
        sys.exit(1)


if __name__ == "__main__":
    main()
