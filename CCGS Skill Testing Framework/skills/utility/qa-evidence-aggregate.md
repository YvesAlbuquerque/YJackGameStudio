# Skill Test Spec: /qa-evidence-aggregate

## Skill Summary

`/qa-evidence-aggregate` collects evidence tasks by scope (`sprint-[id]`,
`milestone-[id]`, or `gate: [name]`), applies deterministic BLOCKING/ADVISORY
verdict rules, and generates a QA sign-off report for gate consumers.

It must surface unverifiable criteria, distinguish advisory concerns from
blocking failures, and ask before writing report outputs.

---

## Static Assertions (Structural)

- [ ] Has required frontmatter fields
- [ ] Parses accepted scope formats: `sprint-[id]`, `milestone-[id]`, `gate: [name]`
- [ ] Contains verdict logic for sprint/milestone/gate scopes
- [ ] Includes release-check handling in BLOCKING evidence sets
- [ ] Contains ask-before-write language for sign-off output

---

## Director Gate Checks

None. This skill produces evidence for downstream gate skills.

---

## Test Cases

### Case 1: Sprint aggregation with mixed evidence

**Input:** `/qa-evidence-aggregate sprint-03`

**Expected behavior:**
1. Loads sprint evidence tasks.
2. Computes pass/fail/blocked counts by task type.
3. Applies BLOCKING vs ADVISORY rules to produce verdict.
4. Includes unresolved/unverifiable criteria section.
5. Asks before writing sign-off report.

### Case 2: GitHub issue mode parses metadata from body fields

**Input:** `/qa-evidence-aggregate sprint-03` with issue-backed tasks

**Expected behavior:**
1. Lists `domain:qa,type:validation` issues.
2. Reads `task_type`, `status`, `gate`, and scope data from issue body.
3. Does not rely on undeclared custom labels for evidence metadata.

