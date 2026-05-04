#!/usr/bin/env python3
"""
Roadmap OS — Task File Validator
=================================
Validates all YAML task files in docs/roadmap/tasks/ against the schema
defined in docs/roadmap/task-schema.yaml.

Usage:
    python3 docs/roadmap/scripts/validate.py [--dir <tasks-dir>] [--file <path>]

Exit codes:
    0 — all task files are valid
    1 — one or more validation errors found

Examples:
    # Validate all task files
    python3 docs/roadmap/scripts/validate.py

    # Validate a single task file
    python3 docs/roadmap/scripts/validate.py --file docs/roadmap/tasks/autonomous/AUTO-003.yaml

    # Validate a specific subdirectory
    python3 docs/roadmap/scripts/validate.py --dir docs/roadmap/tasks/autonomous
"""

import argparse
import os
import re
import sys

# ---------------------------------------------------------------------------
# Inline schema — mirrors docs/roadmap/task-schema.yaml
# Using an inline definition avoids a PyYAML dependency for the schema itself.
# ---------------------------------------------------------------------------

REQUIRED_FIELDS = {
    "id", "type", "title", "subsystem", "priority", "effort",
    "status", "description",
}

OPTIONAL_FIELDS = {
    "notes", "github_issue", "labels", "dependencies",
    "acceptance_criteria", "artifacts", "parent_id", "subtasks",
}

ALL_FIELDS = REQUIRED_FIELDS | OPTIONAL_FIELDS

ENUM_CONSTRAINTS = {
    "type":     {"autonomous", "bug", "improvement", "feature"},
    "priority": {"P1", "P2", "P3"},
    "effort":   {"S", "M", "L", "XL"},
    "status":   {"PROPOSED", "APPROVED", "IN_PROGRESS", "BLOCKED", "VALIDATED", "CLOSED"},
}

ID_PATTERNS = {
    # Autonomous roadmap items are never split with a letter suffix.
    # Decomposition of an AUTO task produces new AUTO-NNN IDs, not AUTO-NNNa.
    "autonomous":  re.compile(r"^AUTO-[0-9]{3}$"),
    # Bug, improvement, and feature subtasks append a letter suffix (e.g., BUG-003a).
    "bug":         re.compile(r"^BUG-[0-9]{3}[a-z]?$"),
    "improvement": re.compile(r"^IMP-[0-9]{3}[a-z]?$"),
    "feature":     re.compile(r"^FEAT-[0-9]{3}[a-z]?$"),
}

LIST_FIELDS = {"labels", "dependencies", "acceptance_criteria", "artifacts", "subtasks"}

# BLOCKED status requires a notes field explaining the blocker.
BLOCKED_REQUIRES_NOTES = True

# L/XL tasks must have subtasks or a parent_id (decomposition required).
# This is a soft warning, not a hard error, because decomposition may be in progress.
EFFORT_DECOMP_WARNING = {"L", "XL"}


# ---------------------------------------------------------------------------
# YAML parsing — minimal parser for simple flat/nested YAML without dependencies
# ---------------------------------------------------------------------------

def _try_import_yaml():
    """Attempt to import PyYAML; return the module or None."""
    try:
        import yaml  # noqa: PLC0415
        return yaml
    except ImportError:
        return None


def load_yaml(path):
    """Load a YAML file, returning a dict. Uses PyYAML if available."""
    yaml_mod = _try_import_yaml()
    if yaml_mod is not None:
        with open(path, encoding="utf-8") as fh:
            return yaml_mod.safe_load(fh) or {}

    # Fallback: minimal line-by-line parser for the simple task YAML format.
    # Supports: scalar strings, block scalars (>), null, integers, and simple lists.
    return _minimal_yaml_load(path)


def _minimal_yaml_load(path):
    """
    A minimal YAML loader for the task file format.
    Supports the subset of YAML used by task files:
      - Top-level key: scalar value
      - key: > block scalar (folded)
      - key: null / integer / quoted string
      - key: (list follows on next lines with "  - item")
    Raises ValueError on unsupported constructs.
    """
    result = {}
    with open(path, encoding="utf-8") as fh:
        lines = fh.readlines()

    i = 0
    while i < len(lines):
        line = lines[i].rstrip("\n")
        # Skip comments and blank lines
        stripped = line.strip()
        if not stripped or stripped.startswith("#"):
            i += 1
            continue

        # Top-level key: value
        if re.match(r"^[a-zA-Z_][a-zA-Z0-9_]*\s*:", line):
            key_match = re.match(r"^([a-zA-Z_][a-zA-Z0-9_]*)\s*:(.*)", line)
            key = key_match.group(1)
            rest = key_match.group(2).strip()

            if rest == ">":
                # Block scalar — collect until indent drops
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
                # List value
                i += 1
                items = []
                while i < len(lines):
                    bl = lines[i].rstrip("\n")
                    if bl.startswith("  - "):
                        items.append(bl[4:].strip().strip('"').strip("'"))
                        i += 1
                    elif bl.startswith("    "):
                        # Multi-line list item continuation — append to last
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
                # Strip quotes
                result[key] = rest.strip('"').strip("'")

        i += 1

    return result


# ---------------------------------------------------------------------------
# Validation logic
# ---------------------------------------------------------------------------

class ValidationError:
    def __init__(self, path, field, message):
        self.path = path
        self.field = field
        self.message = message

    def __str__(self):
        rel = self.path
        return f"  [{rel}] {self.field}: {self.message}"


def validate_task(path, data):
    """Validate a task dict loaded from *path*. Returns list of ValidationError."""
    errors = []

    def err(field, msg):
        errors.append(ValidationError(path, field, msg))

    # 1. Required fields present
    for field in sorted(REQUIRED_FIELDS):
        if field not in data or data[field] is None or data[field] == "":
            err(field, f"required field is missing or empty")

    if errors:
        # Cannot continue meaningful validation without required fields
        return errors

    # 2. No unknown fields
    for field in data:
        if field not in ALL_FIELDS:
            err(field, f"unknown field '{field}' — not in schema")

    # 3. Enum constraints
    for field, allowed in ENUM_CONSTRAINTS.items():
        if field in data and data[field] not in allowed:
            err(field, f"value '{data[field]}' is not in {sorted(allowed)}")

    # 4. ID format matches type
    task_type = data.get("type")
    task_id = data.get("id", "")
    if task_type in ID_PATTERNS:
        if not ID_PATTERNS[task_type].match(task_id):
            expected = ID_PATTERNS[task_type].pattern
            err("id", f"'{task_id}' does not match expected pattern '{expected}' for type '{task_type}'")

    # 5. BLOCKED requires notes
    if BLOCKED_REQUIRES_NOTES and data.get("status") == "BLOCKED":
        notes = data.get("notes", "")
        if not notes or not notes.strip():
            err("notes", "status is BLOCKED but notes field is empty — must explain the blocker")

    # 6. List fields must be lists
    for field in LIST_FIELDS:
        if field in data and data[field] is not None:
            if not isinstance(data[field], list):
                err(field, f"must be a list (found {type(data[field]).__name__})")

    # 7. github_issue must be integer or null
    gi = data.get("github_issue")
    if gi is not None and not isinstance(gi, int):
        err("github_issue", f"must be an integer or null (found {type(gi).__name__}: {gi!r})")

    # 8. parent_id format check (if present)
    pid = data.get("parent_id")
    if pid and isinstance(pid, str):
        if not re.match(r"^(AUTO|BUG|IMP|FEAT)-[0-9]{3}$", pid):
            err("parent_id", f"'{pid}' does not match any valid ID pattern")

    # 9. Soft warning: L/XL without subtasks or parent_id
    if data.get("effort") in EFFORT_DECOMP_WARNING:
        has_subtasks = bool(data.get("subtasks"))
        has_parent = bool(data.get("parent_id"))
        if not has_subtasks and not has_parent:
            status = data.get("status", "")
            if status in ("IN_PROGRESS", "VALIDATED", "CLOSED"):
                errors.append(ValidationError(
                    path, "effort",
                    f"effort is '{data['effort']}' and status is '{status}' but no subtasks or parent_id — "
                    "L/XL tasks must be decomposed before work starts (see ROADMAP-OS.md § Effort Sizing)"
                ))

    return errors


def collect_task_files(root_dir):
    """Walk root_dir and return all .yaml/.yml file paths."""
    task_files = []
    for dirpath, _, filenames in os.walk(root_dir):
        for fname in sorted(filenames):
            if fname.endswith(".yaml") or fname.endswith(".yml"):
                task_files.append(os.path.join(dirpath, fname))
    return task_files


def validate_dependency_ids(all_tasks):
    """
    Cross-validate that dependency IDs and subtask IDs reference existing tasks.
    Returns list of ValidationError.
    """
    errors = []
    known_ids = {t["id"] for t in all_tasks.values() if "id" in t}

    for path, data in all_tasks.items():
        deps = data.get("dependencies") or []
        for dep_id in deps:
            if dep_id not in known_ids:
                errors.append(ValidationError(path, "dependencies",
                    f"dependency '{dep_id}' does not match any known task ID"))

        subtasks = data.get("subtasks") or []
        for sub_id in subtasks:
            if sub_id not in known_ids:
                errors.append(ValidationError(path, "subtasks",
                    f"subtask '{sub_id}' does not match any known task ID"))

        pid = data.get("parent_id")
        if pid and pid not in known_ids:
            errors.append(ValidationError(path, "parent_id",
                f"parent_id '{pid}' does not match any known task ID"))

    return errors


# ---------------------------------------------------------------------------
# CLI
# ---------------------------------------------------------------------------

def parse_args():
    p = argparse.ArgumentParser(
        description="Validate Roadmap OS task files against the schema.",
        formatter_class=argparse.RawDescriptionHelpFormatter,
        epilog=__doc__,
    )
    p.add_argument(
        "--dir", metavar="DIR",
        help="Directory to scan for task YAML files (default: docs/roadmap/tasks/)",
    )
    p.add_argument(
        "--file", metavar="PATH",
        help="Validate a single task YAML file instead of a directory.",
    )
    p.add_argument(
        "--no-cross-validate", action="store_true",
        help="Skip cross-file dependency ID validation.",
    )
    return p.parse_args()


def main():
    args = parse_args()

    # Locate the repo root relative to this script's location.
    script_dir = os.path.dirname(os.path.abspath(__file__))
    repo_root = os.path.abspath(os.path.join(script_dir, "..", "..", ".."))
    default_tasks_dir = os.path.join(repo_root, "docs", "roadmap", "tasks")

    if args.file:
        task_files = [os.path.abspath(args.file)]
        cross_validate = False
    else:
        tasks_dir = os.path.abspath(args.dir) if args.dir else default_tasks_dir
        if not os.path.isdir(tasks_dir):
            print(f"ERROR: tasks directory not found: {tasks_dir}", file=sys.stderr)
            sys.exit(1)
        task_files = collect_task_files(tasks_dir)
        cross_validate = not args.no_cross_validate

    if not task_files:
        print("No task files found. Nothing to validate.")
        sys.exit(0)

    all_errors = []
    all_tasks = {}  # path → data

    for path in task_files:
        rel = os.path.relpath(path, repo_root)
        try:
            data = load_yaml(path)
        except Exception as exc:  # noqa: BLE001
            all_errors.append(ValidationError(rel, "<file>", f"failed to parse YAML: {exc}"))
            continue

        if not isinstance(data, dict):
            all_errors.append(ValidationError(rel, "<file>", "YAML root must be a mapping (dict)"))
            continue

        all_tasks[rel] = data
        errors = validate_task(rel, data)
        all_errors.extend(errors)

    # Cross-file validation
    if cross_validate and len(all_tasks) > 1:
        cross_errors = validate_dependency_ids(all_tasks)
        all_errors.extend(cross_errors)

    # Report
    if all_errors:
        print(f"Validation FAILED — {len(all_errors)} error(s) in {len(task_files)} file(s):\n")
        for err in all_errors:
            print(err)
        print(f"\n{len(all_errors)} error(s) total.")
        sys.exit(1)
    else:
        print(f"Validation PASSED — {len(task_files)} file(s) checked, 0 errors.")
        sys.exit(0)


if __name__ == "__main__":
    main()
