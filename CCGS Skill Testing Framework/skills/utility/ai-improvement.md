# Skill Test Spec: /ai-improvement
## Skill Summary
/ai-improvement diagnoses repeatable failures in the repository's agentic AI
framework, chooses the smallest owning surface, applies a targeted fix, and
documents what proof was or was not gathered. It is a meta-framework skill:
it improves agents, skills, rules, routing, validation, memory, and adapters,
not gameplay AI behavior.
Verdicts are outcome-oriented rather than phase-gate oriented: the run should
end with a clear changed / no change / blocked conclusion plus explicit
validation notes. No director gate applies by default.
---
## Static Assertions (Structural)
- [ ] Has required frontmatter fields: name, description, argument-hint, user-invocable, allowed-tools
- [ ] Has 2+ phase headings
- [ ] Contains verdict keywords including PASS and FAIL
- [ ] Contains "May I write" language before applying changes
- [ ] Ends with a reporting / handoff phase
---
## Director Gate Checks
None by default. /ai-improvement may coordinate with technical-director,
producer, or qa-lead, but it does not itself perform a formal phase gate.
---
## Test Cases
### Case 1: Happy Path - skill routing defect fixed in-place
**Fixture:**
- A skill has a repeatable routing defect or stale instruction
- Evidence exists in the affected SKILL.md, rule, or adapter doc
**Input:** /ai-improvement skill-improve
**Expected behavior:**
1. Identifies the concrete improvement target
2. Separates facts, inferences, and open questions
3. Chooses the smallest owning surface instead of inventing a new abstraction
4. Asks to write, or proceeds only if the user explicitly requested implementation
5. Reports the exact files changed and the proof gathered
**Assertions:**
- [ ] Improvement target is stated in one sentence
- [ ] Owning surface is named explicitly
- [ ] Patch scope stays limited to the responsible files
- [ ] Validation notes distinguish actual checks from manual follow-up
### Case 2: One-off issue - no framework patch made
**Fixture:**
- The observed defect is a one-time bad answer with no repeatable framework gap
**Input:** /ai-improvement vague output from yesterday
**Expected behavior:**
1. Recognizes the issue is not a reusable framework problem
2. Recommends fixing the immediate task instead of mutating shared workflow assets
3. Produces a no change / blocked conclusion
**Assertions:**
- [ ] Does not edit .agents/, .claude/, or repo rules
- [ ] States why the issue is not worth encoding into the framework
- [ ] Avoids adding new meta-process
### Case 3: Cross-tool drift - shared source updated before adapter mirror
**Fixture:**
- .agents/ and .claude/ disagree on a mirrored behavior
**Input:** /ai-improvement skills-reference drift
**Expected behavior:**
1. Identifies .agents/ as the source of truth
2. Updates the shared asset first
3. Mirrors only the corresponding Claude adapter surface
4. Reports compatibility impact
**Assertions:**
- [ ] Shared source-of-truth file is updated first
- [ ] Adapter mirror is limited to the matching surface
- [ ] Report calls out cross-tool compatibility explicitly
### Case 4: Validation gap - proof remains honest
**Fixture:**
- A change is proposed but only manual review is available
**Input:** /ai-improvement missing validation note
**Expected behavior:**
1. Applies the smallest viable patch
2. Runs the smallest available proof, if any
3. States exactly what was not validated
**Assertions:**
- [ ] No runtime/build/CI validation is implied unless it actually ran
- [ ] Manual validation needs are listed plainly
- [ ] Conclusion does not overclaim quality improvement
### Case 5: New asset threshold - existing patterns checked first
**Fixture:**
- The user suggests creating a brand-new skill or agent
**Input:** /ai-improvement add another meta skill
**Expected behavior:**
1. Checks nearby agents, skills, rules, and docs first
2. Prefers extending an existing asset when it can own the behavior
3. Only recommends a new skill/agent if no current surface fits
**Assertions:**
- [ ] Existing repo patterns are inspected before new asset creation
- [ ] Reason for any new asset is explicit and evidence-backed
- [ ] Avoids broad framework rewrites
---
## Protocol Compliance
- [ ] Starts from evidence, not guesses
- [ ] Uses "May I write" before edits unless the user already explicitly asked to implement
- [ ] Keeps changes minimal and scoped to the owning surface
- [ ] Reports facts, inferences, and open questions distinctly
- [ ] States validation honestly and names remaining manual checks
---
## Coverage Notes
- This spec validates workflow behavior, not whether a specific improvement is
  objectively optimal.
- Cross-tool compatibility still requires manual inspection of the mirrored
  adapter files after each change.
