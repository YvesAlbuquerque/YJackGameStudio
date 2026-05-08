# AI-Friendly APIs for Autonomous Agents

This guide explains how autonomous agents should interact with the game studio template's validation and workflow systems using machine-parseable JSON interfaces.

## Overview

Selected validation scripts support `--format=json` (currently `validate-skill-static.sh` and `check-write-sets.sh`) to output structured, schema-validated results that agents can parse programmatically without regex text parsing.

## Core Principle

**The file is the contract, not the conversation.**

Agents should:
1. Call JSON-enabled validation scripts with `--format=json`
2. Parse the JSON output against the published schema
3. Read error codes from the error registry
4. Execute remediation commands programmatically
5. Validate artifacts against schemas before committing

No brittle text parsing. No regex extraction. Pure JSON contracts.

## Available JSON APIs

### 1. Skill Static Validation

**Command:**
```bash
.agents/scripts/validate-skill-static.sh <skill-name> --format=json
```

**Output Schema:** `.agents/schemas/validation-output.schema.json`

**Example:**
```bash
$ .agents/scripts/validate-skill-static.sh brainstorm --format=json | jq '.summary.verdict'
"PASS"

$ .agents/scripts/validate-skill-static.sh brainstorm --format=json | jq '.items[0].checks[] | select(.result == "FAIL")'
# Returns failing checks only
```

**Error Codes:**
- `MISSING_FRONTMATTER_FIELD` - Required frontmatter field missing
- `INSUFFICIENT_PHASES` - Fewer than 2 phase headings
- `NO_VERDICT_KEYWORDS` - No PASS/FAIL/CONCERNS keywords found
- `MISSING_COLLABORATIVE_PROTOCOL` - Write tools without approval language
- `MISSING_NEXT_STEP_HANDOFF` - No follow-up section
- `FORK_COMPLEXITY_MISMATCH` - context:fork but <5 phases
- `EMPTY_ARGUMENT_HINT` - argument-hint is empty

**Agent Workflow:**
```bash
# 1. Validate skill
RESULT=$(.agents/scripts/validate-skill-static.sh my-skill --format=json)

# 2. Check exit code programmatically
EXIT_CODE=$(echo "$RESULT" | jq -r '.exit_code')

# 3. If failed, get errors
if [[ "$EXIT_CODE" != "0" ]]; then
  ERRORS=$(echo "$RESULT" | jq -r '.errors[] | "\(.code): \(.message)"')

  # 4. Get remediation for first error
  REMEDIATION=$(echo "$RESULT" | jq -r '.remediation.suggestions[0]')

  # 5. Execute or escalate
  echo "Remediation: $REMEDIATION"
fi
```

### 2. Write-Set Collision Detection

**Command:**
```bash
.agents/scripts/check-write-sets.sh --format=json [graph_file]
```

**Output Schema:** `.agents/schemas/validation-output.schema.json`

**Example:**
```bash
$ .agents/scripts/check-write-sets.sh --format=json production/dependency-graph.yml | jq '.summary.verdict'
"PASS"

$ .agents/scripts/check-write-sets.sh --format=json | jq '.errors[] | select(.code == "WRITE_SET_COLLISION")'
# Returns collision details with contract IDs and paths
```

**Error Codes:**
- `WRITE_SET_COLLISION` - Write-set paths overlap (requires owner resolution)

**Agent Workflow:**
```bash
# 1. Check for collisions before advancing contract to IN_PROGRESS
RESULT=$(.agents/scripts/check-write-sets.sh --format=json)

# 2. Parse verdict
VERDICT=$(echo "$RESULT" | jq -r '.summary.verdict')

# 3. If collision found, escalate
if [[ "$VERDICT" == "FAIL" ]]; then
  COLLISIONS=$(echo "$RESULT" | jq -r '.errors[] | "\(.context.contract_a) vs \(.context.contract_b): \(.context.reason)"')

  # This ALWAYS requires owner approval
  echo "ESCALATING: Write-set collisions detected"
  echo "$COLLISIONS"
  exit 1
fi

# 4. Safe to proceed
echo "No collisions. Safe to advance contract to IN_PROGRESS"
```

### 3. Evidence Packet Validation (Current: Text Mode)

`validate-evidence-packet.sh` currently outputs text only and does **not** support `--format=json` yet.

**Current Command:**
```bash
.agents/scripts/validate-evidence-packet.sh <packet-file>
```

**Planned Output Schema (future):** `.agents/schemas/validation-output.schema.json`

**Error Codes:**
- `MISSING_OVERALL_VERDICT` - No concrete verdict line
- `NO_COMPLETED_CHECKS` - No completed check rows
- `MISSING_REQUIRED_SECTION` - Required packet section missing

**Agent Workflow:**
```bash
# 1. Validate evidence packet
RESULT=$(.agents/scripts/validate-evidence-packet.sh production/qa/validation-packets/my-packet.md)

# 2. Check if valid
if echo "$RESULT" | grep -q '^PASS:'; then
  echo "Evidence packet valid. Ready to commit."
else
  echo "$RESULT"
fi
```

### 4. Catalog Consistency Check (Current: Text Mode)

`check-catalog-consistency.sh` currently outputs text only and does **not** support `--format=json` yet.

**Current Command:**
```bash
.agents/scripts/check-catalog-consistency.sh
```

**Planned Output Schema (future):** `.agents/schemas/validation-output.schema.json`

**Error Codes:**
- `CATALOG_COUNT_MISMATCH` - Catalog count doesn't match disk
- `SKILL_NOT_IN_CATALOG` - Skill exists but not in catalog
- `CATALOG_ENTRY_MISSING_SKILL` - Catalog entry has no corresponding skill

## Error Registry

All error codes are defined in `.agents/schemas/error-codes.json` with:

- **code**: Unique error identifier
- **severity**: `FAIL` | `WARN` | `INFO`
- **category**: Error classification
- **auto_fix_available**: Whether agent can fix autonomously
- **escalation_required**: Whether owner approval needed
- **remediation_type**: Type of fix required
- **documentation**: Link to relevant docs

**Example Error Object:**
```json
{
  "code": "MISSING_REQUIRED_SECTION",
  "severity": "FAIL",
  "message": "Required section 'Prerequisites' not found",
  "context": {
    "file": ".agents/skills/my-skill/SKILL.md",
    "line": null,
    "section": "Prerequisites"
  },
  "remediation": {
    "action": "add_section",
    "template": ".agents/docs/templates/skill-section-prerequisites.md",
    "command": "Add '## Prerequisites' header at line 12",
    "documentation": ".agents/docs/skills-reference.md#prerequisites"
  }
}
```

## Agent Decision Tree

```
Agent receives validation request
  ↓
Run validation script with --format=json
  ↓
Parse JSON output
  ↓
Check exit_code field
  ├─ 0: Success → Proceed
  ├─ 1: Validation failed
  │   ↓
  │   Read errors array
  │   ↓
  │   For each error:
  │     ├─ Check escalation_required
  │     │   ├─ true: Surface to owner, STOP
  │     │   └─ false: Continue
  │     ├─ Check auto_fix_available
  │     │   ├─ true: Execute remediation.command
  │     │   └─ false: Surface to owner
  │     └─ Read remediation.documentation for context
  │
  └─ 2: Usage error → Fix command syntax
```

## Schema Validation

Before committing any structured data, validate against the schema:

```bash
# Install ajv-cli
npm install -g ajv-cli

# Validate a validation output file
ajv validate -s .agents/schemas/validation-output.schema.json -d output.json

# Validate an evidence packet
ajv validate -s .agents/schemas/validation-evidence-packet.schema.json -d packet.json
```

## Common Patterns

### Pattern 1: Validate Before Commit

```bash
#!/usr/bin/env bash
# Always validate before committing

validate_and_commit() {
  local file="$1"
  local type="$2"  # skill | evidence | contract

  case "$type" in
    skill)
      RESULT=$(.agents/scripts/validate-skill-static.sh "$file" --format=json)
      ;;
    evidence)
      RESULT=$(.agents/scripts/validate-evidence-packet.sh "$file")
      ;;
  esac

  if [[ $(echo "$RESULT" | jq -r '.exit_code') == "0" ]]; then
    git add "$file"
    git commit -m "Add validated $type: $file"
  else
    echo "Validation failed:"
    echo "$RESULT" | jq -r '.errors[] | "- \(.code): \(.message)"'
    exit 1
  fi
}
```

### Pattern 2: Chain Validations

```bash
#!/usr/bin/env bash
# Chain multiple validations

validate_chain() {
  local results=()

  # Run all validations
  results+=("$(.agents/scripts/validate-skill-static.sh all --format=json)")
  results+=("$(.agents/scripts/check-write-sets.sh --format=json)")

  # Aggregate exit codes
  for result in "${results[@]}"; do
    if [[ $(echo "$result" | jq -r '.exit_code') != "0" ]]; then
      echo "Validation chain failed"
      return 1
    fi
  done

  echo "All validations passed"
  return 0
}
```

### Pattern 3: Auto-Remediation

```bash
#!/usr/bin/env bash
# Attempt auto-remediation for fixable errors

auto_fix() {
  local file="$1"

  RESULT=$(.agents/scripts/validate-skill-static.sh "$file" --format=json)

  # Get recommended remediation actions
  ACTIONS=$(echo "$RESULT" | jq -r '.errors[] | .remediation.action // empty')

  if [[ -n "$ACTIONS" ]]; then
    echo "Recommended remediation actions:"
    echo "$ACTIONS"
    # Execute approved fixes here
    # Then re-validate
  fi
}
```

## Exit Code Contracts

JSON-enabled validation scripts follow this contract:

- **0**: All checks passed or warnings only
- **1**: At least one check failed
- **2**: Usage error or file not found

Agents can rely on these codes programmatically:

```bash
if .agents/scripts/validate-skill-static.sh my-skill --format=json; then
  echo "PASS"
else
  case $? in
    1) echo "VALIDATION_FAILED" ;;
    2) echo "USAGE_ERROR" ;;
  esac
fi
```

## Performance Considerations

JSON formatting adds ~5-10% overhead compared to text mode. For batch operations:

1. Use JSON mode for the final validation
2. Use text mode for interactive debugging
3. Cache validation results when safe (idempotent operations)
4. Run validations in parallel when checking independent artifacts

## Migration Path

For existing agents:

1. Add `--format=json` to all validation calls
2. Replace regex parsing with `jq` queries
3. Load error registry for remediation lookup
4. Validate outputs against published schemas
5. Remove text parsing fallbacks once stable

## References

- **Schemas**: `.agents/schemas/`
- **Error Registry**: `.agents/schemas/error-codes.json`
- **Validation Scripts**: `.agents/scripts/validate-*.sh`, `.agents/scripts/check-*.sh`
- **Schema README**: `.agents/schemas/README.md`
- **Work Contract Schema**: `.agents/docs/work-contract-schema.md`
