# Handoff Record Template

<!-- Copy this template to production/session-state/handoff-{issue-id}.md -->
<!-- Replace all {placeholders} with actual values -->
<!-- Delete this header comment block before using -->

---
handoff_id: "{issue-number or contract-id}"
issue_url: "https://github.com/{owner}/{repo}/issues/{number}"
contract_id: "{STORY-XXX or EPIC-XXX if applicable}"
created: "{ISO 8601 timestamp}"
last_updated: "{ISO 8601 timestamp}"
status: "{proposed | approved | in_progress | blocked | validated | closed}"
---

## Owner Goal

{One-sentence summary of what the owner wants from this issue/contract}

## Last Validated State

### Completed
- [ ] {First completed item}
- [ ] {Second completed item}

### Remaining
- [ ] {First remaining item}
- [ ] {Second remaining item}

## Active Blockers

<!-- Include this section only if status is "blocked" -->
<!-- Otherwise delete this section -->

**Blocker:** {Clear description of what is blocking progress}

**Blocked Since:** {ISO 8601 timestamp}

**Impact:** {What cannot proceed until this is resolved}

**Escalation:** {What action was taken to surface this to owner}

## Pending Decisions

<!-- Delete this section if no decisions are pending -->

1. **{Decision topic}** — {brief context}
   - Options: {Option A} | {Option B} | {Option C}
   - Impact: {Why this decision matters}
   - Decision needed by: {Deadline or milestone}

## Next Scheduled Action

**What:** {Specific next step — be concrete}

**Where:** {File path, section, or location}

**Context:** {Brief explanation of why this is next and what to consider}

**Success:** {How to know this action is complete}

## Risk Items

### HIGH
<!-- Delete if no HIGH risks -->
- **{Risk description}:** {Impact and mitigation}

### MEDIUM
<!-- Delete if no MEDIUM risks -->
- **{Risk description}:** {Impact and mitigation}

### LOW
<!-- Delete if no LOW risks -->
- **{Risk description}:** {Impact and mitigation}

## Agent Notes

### Implementation Decisions
<!-- Delete if none -->
- {Decision made and rationale}

### Discoveries
<!-- Delete if none -->
- {Pattern or convention discovered during work}

### Cross-References
<!-- Delete if none -->
- Related to {other issue/contract} — {relationship}

### Warnings
<!-- Delete if none -->
- {Important context for next agent to avoid mistakes}

---

## Optional Sections

<!-- Include these sections if they add value; delete otherwise -->

### Write-Set Status

| File | Status | Notes |
|------|--------|-------|
| {path/to/file.md} | ✅ Complete | {Brief note} |
| {path/to/other.md} | 🚧 In Progress | {What remains} |
| {path/to/blocked.md} | ⏸️ Pending | {What it's waiting for} |

### Session Log

- **{YYYY-MM-DD HH:MM-HH:MM}** — {Agent identifier} — {Brief summary of work done}
