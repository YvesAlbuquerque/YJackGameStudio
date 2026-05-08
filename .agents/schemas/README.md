# Agent Schemas

Machine-readable schemas for autonomous agent validation and data exchange.

## Overview

This directory contains JSON Schema files that define the structure of all data exchanged between autonomous agents and validation scripts. These schemas enable agents to:

- Validate their own outputs before committing
- Parse validation results without regex text parsing
- Understand error contracts and remediation paths
- Self-correct from documented errors

## Available Schemas

### Core Schemas

| Schema File | Purpose | Used By |
|-------------|---------|---------|
| `validation-output.schema.json` | Standard JSON output for all validation scripts | All validation scripts with `--format=json` |
| `error-codes.json` | Error code registry with remediation guidance | All scripts, error handling |
| `validation-evidence-packet.schema.json` | Evidence packet structure | `validate-evidence-packet.sh`, QA workflows |

### Validation

To validate a file against a schema:

```bash
# Using validate-schema.sh (coming soon)
.agents/scripts/validate-schema.sh <schema-type> <file>

# Using ajv-cli directly
npm install -g ajv-cli
ajv validate -s .agents/schemas/validation-output.schema.json -d output.json
```

## JSON Output Format

All validation scripts support the `--format=json` flag to output machine-parseable results:

```bash
# Human-readable (default)
.agents/scripts/validate-skill-static.sh my-skill

# Machine-parseable JSON
.agents/scripts/validate-skill-static.sh my-skill --format=json

# Save for agent consumption
.agents/scripts/validate-skill-static.sh my-skill --format=json > result.json
```

### JSON Output Structure

All scripts follow the `validation-output.schema.json` structure:

```json
{
  "schema_version": "1.0",
  "timestamp": "2026-05-08T10:30:00Z",
  "command": "validate-skill-static.sh my-skill",
  "exit_code": 0,
  "summary": {
    "verdict": "PASS",
    "total_items": 1,
    "passed": 1,
    "failed": 0,
    "warnings": 0
  },
  "items": [
    {
      "id": "my-skill",
      "path": ".agents/skills/my-skill/SKILL.md",
      "verdict": "COMPLIANT",
      "checks": [...]
    }
  ],
  "errors": [],
  "remediation": {
    "available": false,
    "suggestions": []
  }
}
```

## Error Handling

Errors follow the `error-codes.json` registry structure:

```json
{
  "errors": [
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
  ]
}
```

## Schema Versioning

All schemas include a `version` field using semantic versioning (MAJOR.MINOR.PATCH):

- **MAJOR**: Breaking changes to schema structure
- **MINOR**: Backward-compatible additions
- **PATCH**: Documentation or clarification updates

Agents should check `schema_version` in outputs to ensure compatibility.

## Adding New Schemas

When adding a new schema:

1. Create `<name>.schema.json` following JSON Schema Draft 07
2. Include required `$schema`, `$id`, `title`, `description`, `version` fields
3. Add validation examples to this README
4. Update relevant scripts to reference the schema
5. Add CI validation in `.github/workflows/schema-validation.yml`

## References

- [JSON Schema Specification](https://json-schema.org/specification.html)
- [Understanding JSON Schema](https://json-schema.org/understanding-json-schema/)
- [AJV JSON Schema Validator](https://ajv.js.org/)
