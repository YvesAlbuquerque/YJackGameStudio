# Skill Test Spec: /qa-evidence-assign

## Skill Summary

`/qa-evidence-assign` converts scoped stories into independent QA evidence tasks,
assigns them to qa-tester lanes, and produces a master tracker under
`production/qa/`. It supports Logic, Integration, UI, Visual/Feel, Config/Data,
Playtest, and Release story types.

The skill must ask before writing evidence task files and before writing the
master tracking document.

---

## Static Assertions (Structural)

- [ ] Has required frontmatter fields
- [ ] Has ≥2 phase headings
- [ ] Contains ask-before-write language for task files and tracker output
- [ ] Includes mapping for `playtest-session` and `release-check`
- [ ] Includes lane assignment guidance for BLOCKING vs ADVISORY evidence

---

## Director Gate Checks

None. This is a QA orchestration utility.

---

## Test Cases

### Case 1: Mixed story types generate full evidence set

**Input:** `/qa-evidence-assign sprint`

**Expected behavior:**
1. Reads sprint stories and extracts acceptance criteria.
2. Generates one task per story with task types mapped by story type.
3. Includes `playtest-session` for Playtest stories and `release-check` for Release stories.
4. Assigns BLOCKING tasks to high-priority lane.
5. Asks before writing files and tracker.

### Case 2: GitHub issue storage mode uses existing labels

**Input:** `/qa-evidence-assign sprint` then select GitHub issues

**Expected behavior:**
1. Uses repository labels (`domain:qa`, `type:validation`, status labels).
2. Stores `task_type`, `gate`, and scope metadata in issue body fields.
3. Does not require undeclared custom labels.

