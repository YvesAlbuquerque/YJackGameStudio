---
name: owner-dashboard
description: "Generate a concise owner dashboard showing active issues, blocked items, validation debt, decisions needed, and risks. Separates facts from recommendations. Can be generated from GitHub issues and production state without reading every agent transcript."
argument-hint: "[options: --include-closed --verbose]"
user-invocable: true
allowed-tools: Read, Glob, Grep, Bash
model: sonnet
---

# Owner Dashboard

**Purpose:** Give the owner a high-level view of autonomous studio activity,
surfacing what agents can do next autonomously and what requires owner decision.

This skill generates a concise dashboard that separates:
- **Facts** (current state, objective measurements)
- **Autonomous next actions** (what agents can proceed with under current autonomy mode)
- **Owner decisions needed** (items blocked on owner input)
- **Risks** (escalations, validation debt, technical debt)

The dashboard is regenerated after significant state changes and can be run
on-demand via `/owner-dashboard`.

---

## 1. Read Autonomy Configuration

Read `production/autonomy-config.md` to determine the active autonomy mode:
- GUIDED: every decision surfaces
- SUPERVISED: LOW auto-executes; MEDIUM requires approval
- AUTONOMOUS: LOW and MEDIUM auto-execute; HIGH always requires approval

Record the active mode in the dashboard header.

---

## 2. Scan GitHub Issues

**If GitHub CLI is available**, query issues to identify:

```bash
# Active issues (all open issues)
gh issue list --state open --json number,title,labels,assignees,updatedAt --limit 100

# Blocked issues (status:blocked label)
gh issue list --label "status:blocked" --state open --json number,title,labels,assignees,updatedAt

# Approval needed (auto:high or auto:medium when in SUPERVISED mode)
gh issue list --label "auto:high" --state open --json number,title,labels,assignees
gh issue list --label "auto:medium" --state open --json number,title,labels,assignees
```

**If GitHub CLI is not available or returns errors**, fall back to reading
`production/dependency-graph.yml` for contract status.

### Issue Classification

For each open issue, extract:
- **Issue number and title**
- **Status** from labels (`status:*`)
- **Risk tier** from labels (`auto:low`, `auto:medium`, `auto:high`)
- **Type** from labels (`type:*`)
- **Assignee** (specialist agent or owner)
- **Last updated** timestamp

Classify each issue into one of these categories:
1. **In Progress** — `status:in-progress`
2. **Blocked** — `status:blocked`
3. **Awaiting Owner Go-Ahead (mode boundary)** — `status:approved` + risk tier above the current autonomy mode threshold (e.g., MEDIUM or HIGH in SUPERVISED mode; HIGH in AUTONOMOUS mode)
4. **Ready for Pickup** — `status:approved` + risk tier within autonomy boundary
5. **Proposed** — `status:proposed` (needs owner approval to move to `approved`)

---

## 3. Scan Handoff Files

Read `production/session-state/handoff-*.md` files to extract:
- Active blockers (§Active Blockers section)
- Pending decisions (§Pending Decisions section)
- Risk items (§Risk Items section with HIGH or MEDIUM severity)
- Next scheduled action (§Next Scheduled Action section)

Cross-reference handoff files with GitHub issues by issue number or contract_id.

**If a handoff file exists for an issue**, prefer its content over inferring from
GitHub labels alone. Handoff files contain agent-authored context that GitHub
labels cannot capture.

---

## 4. Check Validation Debt

Scan for validation evidence packets that indicate manual validation is required:

```bash
# Find all validation packets
find production/qa/validation-packets/ -name "*.md" -type f 2>/dev/null

# Grep for "Manual Validation Still Required" (standard section header) and Unity markers
grep -r "## Manual Validation Still Required" production/qa/validation-packets/ 2>/dev/null
grep -r "Unity Editor" production/qa/validation-packets/ 2>/dev/null
```

**For YJackCore projects**, also check for:
- Changes to `Packages/YJackCore/**` or `Packages/com.ygamedev.yjack/**` (package boundary — HIGH risk)
- Domain reload requirements (script compilation)
- Play Mode tests (scene/prefab wiring)
- Build validation (Development or Release)

Read `.agents/docs/technical-preferences.md` to detect if this is a YJackCore project:
- Framework field contains `YJackCore` (any value starting with `[None configured` is treated as unset)
- Or `.yjack-workspace.json` exists at the repository root

If YJackCore is active, include a **YJackCore Validation Debt** section in the
dashboard that lists:
- Package boundary changes awaiting Unity validation
- Host-game wiring changes awaiting Play Mode tests
- Compile symbol branches awaiting build tests

---

## 5. Identify Autonomous Next Actions

**Autonomous next actions** are work items the current autonomy mode permits
without requiring owner decision.

Rules by mode:
- **GUIDED**: No autonomous actions (all decisions surface)
- **SUPERVISED**: Items with `auto:low` risk tier
- **AUTONOMOUS**: Items with `auto:low` or `auto:medium` risk tier

For each qualifying item, read the handoff file's **Next Scheduled Action**
section (if present) or the GitHub issue body to extract the next step.

List up to 5 autonomous next actions in priority order:
1. Unblocked `in_progress` items with a clear next action
2. `approved` items within autonomy boundary, ordered by priority labels
3. Items with dependencies now satisfied (check dependency-graph.yml)

---

## 6. Identify Owner Decisions Needed

**Owner decisions** are items blocked on owner input, regardless of autonomy mode.

Categories:
1. **Blocked issues** — `status:blocked` + blocker description from handoff file
2. **Above autonomy boundary** — `status:approved` + risk tier above current mode threshold
3. **Pending decisions** — extracted from handoff files' Pending Decisions sections
4. **Validation approval** — validation packets marked "awaiting owner review"
5. **Escalations** — handoff Risk Items marked HIGH

For each decision, include:
- **What** needs deciding
- **Why** it's blocked or escalated
- **Impact** if delayed
- **Suggested deadline** (if applicable)

---

## 7. Compile Risk Register Summary

Aggregate risks from:
- Handoff files (§Risk Items section)
- Blocked issues with unresolved blockers
- Validation debt (HIGH priority items)
- Stale in-progress items (no update in >3 days)

Classify by severity:
- **HIGH** — blocks current sprint goal or introduces instability
- **MEDIUM** — delays non-critical work or introduces technical debt
- **LOW** — quality-of-life or future-facing concerns

Sort by severity (HIGH first), then by impact on current sprint.

---

## 8. Output Format

Generate `production/dashboard.md` with this structure:

```markdown
# Owner Dashboard — [Date]

**Generated:** [ISO timestamp]
**Autonomy Mode:** [GUIDED | SUPERVISED | AUTONOMOUS]
**Active Sprint:** [sprint number and goal, or "No active sprint"]

---

## Summary

- **Active Issues:** [N]
- **Blocked Issues:** [N]
- **Decisions Needed:** [N]
- **Validation Debt:** [N items]
- **Autonomous Next Actions:** [N items]

---

## Facts

### Active Issues ([N])

| Issue | Title | Status | Risk | Assignee | Last Updated |
|-------|-------|--------|------|----------|--------------|
| #42   | [title] | in_progress | LOW | copilot | 2 hours ago |
| #43   | [title] | approved | MEDIUM | team:combat | 1 day ago |

### Blocked Issues ([N])

| Issue | Title | Blocked By | Days Blocked | Escalated? |
|-------|-------|-----------|--------------|------------|
| #44   | [title] | Owner decision on API choice | 2 | Yes |
| #45   | [title] | Dependency STORY-012 | 1 | No |

### Validation Debt ([N items])

| Item | Type | Manual Checks Required | Escalation Priority |
|------|------|------------------------|---------------------|
| STORY-042 | YJackCore package change | Unity domain reload, Play Mode test | HIGH |
| STORY-043 | New UI screen | Manual UX review | MEDIUM |

---

## Autonomous Next Actions

**What agents can proceed with under [CURRENT MODE] autonomy:**

1. **[Issue #X]**: [Next action from handoff or issue body]
   - Risk: LOW | Estimated effort: [from issue] | No blockers
2. **[Issue #Y]**: [Next action]
   - Risk: MEDIUM | Dependencies satisfied | Agent: copilot

*(Limit to 5 items)*

---

## Owner Decisions Needed

**Items requiring owner input before agents can proceed:**

### 1. [Decision title or issue #Z]
- **What:** [Brief description]
- **Why Blocked:** [Reason from handoff or blocker field]
- **Impact:** [What's delayed; sprint goal risk]
- **Suggested By:** [Date or "ASAP"]

### 2. [Decision title]
- **What:** Approve MEDIUM-risk design change to movement.md
- **Why Blocked:** SUPERVISED mode requires owner approval for design file writes
- **Impact:** Movement implementation story cannot start
- **Suggested By:** Before sprint day 3

*(All items, ordered by priority)*

---

## Risks

### HIGH

- **[Risk title]**: [Description from handoff Risk Items or inferred from blocked issues]
  - **Likelihood:** [if recorded] | **Impact:** [sprint goal, stability, etc.]
  - **Mitigation:** [from handoff or "TBD"]

### MEDIUM

- **Validation debt accumulation**: 3 YJackCore stories awaiting manual Unity validation
  - **Impact:** Cannot mark stories Done; sprint burndown inaccurate
  - **Mitigation:** Schedule Unity validation session

### LOW

*(Omit if no LOW risks)*

---

## YJackCore Status

*(Include this section only if technical-preferences.md Framework field is "YJackCore")*

**Framework Integration:** Active
**Package Boundary Writes:** [N pending owner review]
**Host-Game Wiring:** [N stories in progress]
**Manual Unity Validation Required:** [N items]

### Validation Debt Breakdown

| Item | Layer | Manual Validation Type | Priority |
|------|-------|------------------------|----------|
| STORY-042 | GameLayer | Domain reload + Play Mode | HIGH |
| STORY-043 | ViewLayer | UI rendering + input routing | MEDIUM |

---

## Recommendations

*(Exactly one recommendation, or "No action needed.")*

**Action:** [Concrete next step for the owner]

**Rationale:** [Why this action is the highest priority]

**Expected Impact:** [What unblocks or accelerates]

---

**Notes:**
- This dashboard is regenerated after each significant state change.
- For detailed story status, run `/sprint-status`.
- For detailed risk analysis, run `/gate-check` or see `production/risks/`.
```

---

## 9. Update Frequency

The dashboard should be regenerated:
- After any contract transitions to `blocked` or `validated`
- After owner approval of a HIGH-risk decision
- After a new sprint starts
- On manual invocation via `/owner-dashboard`
- At least once per day during active sprints

The skill writes to `production/dashboard.md` (tracked in git). Previous dashboard
content is overwritten; no append-only log is maintained here (use session logs
for history).

---

## 10. Collaborative Protocol

This skill is **read-only** with one write: the dashboard file itself.

It does not:
- Change issue status or labels
- Modify work contracts
- Approve or reject decisions
- Update handoff files

It surfaces state; it does not change state.

**Exception:** If `--verbose` flag is passed, the skill also generates
`production/dashboard-verbose.md` with full handoff file excerpts and complete
issue lists. Use this for deep-dive analysis, not daily owner review.

---

## 11. Argument Handling

**`--include-closed`**: Include recently closed issues (within 7 days) in the
Active Issues table for context. Useful after a major sprint wrap-up.

**`--verbose`**: Generate extended dashboard with full details. Writes to
`production/dashboard-verbose.md` in addition to the standard dashboard.

**No arguments**: Generate standard dashboard only.

---

## 12. Error Handling

If GitHub CLI is unavailable:
- Fall back to `production/dependency-graph.yml` for contract status
- Note in dashboard header: "GitHub API unavailable — using local contract data only"

If `production/dependency-graph.yml` does not exist:
- Note: "No dependency graph found — limited status available"
- Proceed with handoff files and validation packets only

If no handoff files exist:
- Note: "No active handoff records — agents may not be using handoff protocol"
- Recommend running `/help` for workflow guidance

---

## 13. YJackCore Integration

For YJackCore-backed Unity projects, the dashboard must call out:
- **Host-game work** vs. **framework-package work** (check `yjackcore.layer` in contracts)
- **Manual Unity validation debt** (domain reload, Play Mode, build, Odin Inspector)
- **Package boundary integrity** (any writes to `Packages/YJackCore/**`)

Read `.agents/docs/yjackcore-authority.md` to verify routing correctness when
analyzing YJackCore-related issues.

---

## Related Skills

- `/sprint-status` — Detailed sprint progress and burndown
- `/gate-check` — Phase gate validation
- `/project-stage-detect` — Overall project stage and readiness
- `/milestone-review` — End-of-milestone comprehensive review

---

## Skill Completion

The skill outputs `production/dashboard.md` with status **COMPLETE** when the
dashboard is generated successfully. If data sources are unavailable or the
dashboard cannot be produced, output status is **BLOCKED** and the reason is
noted in the dashboard header.
