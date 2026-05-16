---
name: ai-improvement
description: "Diagnose and improve the repo's agentic AI framework: agents, skills, rules, prompts, routing, validation, memory, and tool adapters. Use when AI outputs are low quality, misrouted, under-validated, inconsistent across tools, or when creating an evidence-backed auto-improvement loop for project AI behavior."
argument-hint: "[symptom|agent|skill|workflow|adapter]"
user-invocable: true
allowed-tools: Read, Glob, Grep, Write, Edit, Bash
---

# AI Improvement

Improve the project's AI framework with a small, evidence-backed loop:
diagnose -> patch -> validate -> document.

This skill improves agentic workflow assets. It does not implement gameplay AI.
Use `ai-programmer` for in-game AI behavior.

## Phase 1: Scope The Symptom

Identify what is being improved:

- output quality: vague, generic, incomplete, or off-tone artifacts
- routing: wrong agent/skill selected, missing escalation, duplicated ownership
- validation: claims without proof, missing tests, weak review gates
- context: too much irrelevant context, missing critical docs, stale memory
- compatibility: `.agents/` and tool adapters drift, or one tool cannot follow the workflow
- safety: over-broad edits, hidden destructive actions, missing approval boundaries

Write one sentence:

```text
Improvement target: [specific recurring AI behavior or framework gap]
```

If the issue is a one-off result with no repeatable value, fix the immediate task
instead of changing framework assets.

## Phase 2: Collect Evidence

Inspect the smallest relevant evidence set:

- user feedback or failed output
- affected agent files in `.agents/agents/`
- affected skill files in `.agents/skills/*/SKILL.md`
- related rules in `.agents/rules/`
- shared docs in `.agents/docs/`
- adapter files: `AGENTS.md`, `CLAUDE.md`, `GEMINI.md`, `.github/*`, `.agent/*`, `.claude/*`
- validation artifacts: skill tests, hooks, QA evidence, review workflows, CI logs

Separate:

- Facts: directly observed files, outputs, checks, failures
- Inferences: likely cause or missing routing
- Open questions: what cannot be proven from available evidence

## Phase 3: Find The Owner Surface

Choose the smallest asset that owns the behavior:

| Symptom | Prefer Editing |
| ---- | ---- |
| Wrong role selected | Agent roster, coordination map, or agent description |
| Skill produces weak artifact | Specific `SKILL.md` |
| Missing validation behavior | Skill phase, rule, hook, or QA/review workflow |
| Cross-tool drift | `.agents/` source first, then adapter mirror |
| Repeated instruction gap | Root `AGENTS.md`, scoped `AGENTS.md`, or rule file |
| Poor domain output | Domain-specific agent/skill, not a global meta rule |
| Poor prompt hygiene | Agent collaboration protocol or skill phase wording |

Do not create a new agent, skill, rule, or abstraction until checking whether an
existing asset can be clarified instead.

## Phase 4: Design The Patch

Make the smallest patch that improves the symptom.

Patch types, from lowest to highest risk:

1. Add or clarify routing wording.
2. Tighten one skill phase.
3. Add a validation requirement or output contract.
4. Update roster/reference docs.
5. Mirror shared behavior to provider-specific adapters.
6. Add a new rule.
7. Add a new skill.
8. Add a new agent.

For each patch, define:

- expected behavior change
- files touched
- risk of overfitting to one incident
- compatibility impact across Codex, Copilot, Gemini, Antigravity, and Claude
- validation to run

## Phase 5: Apply With Mirror Discipline

Before writing files, ask:

```text
May I write this AI-framework improvement to [file list]?
```

If the user already explicitly asked you to implement the improvement, proceed
with the smallest safe patch and report the touched files.

When editing shared AI behavior:

- Update `.agents/` first.
- Mirror to `.claude/` only when Claude compatibility assets exist for the same surface.
- Update roster/reference docs when adding or renaming agents or skills.
- Keep frontmatter fields consistent with nearby files.
- Keep skill bodies concise; use progressive disclosure instead of large context dumps.
- Preserve existing terminology unless the old term is causing the defect.

If editing a skill, consider running or following:

```text
/skill-test static [skill-name]
/skill-test category [skill-name]
/skill-improve [skill-name]
```

## Phase 6: Validate

Run the smallest honest proof available:

- `git diff --check` for whitespace/diff hygiene
- `/skill-test static [skill-name]` when a skill changes and the runner is available
- `/skill-test category [skill-name]` when category coverage exists
- tool-specific validation scripts if the repo provides them
- manual review against this skill's improvement target when no automated check exists

Report exactly what ran. Do not imply runtime, hook, CI, or tool-adapter validation
if it was not actually performed.

## Phase 7: Report Result

Use this format:

```markdown
Conclusion: [changed / no change / blocked]

Evidence:
- [facts observed]

Change:
- [files and behavior changed]

Validation:
- [checks actually run]
- [manual validation still required]

Follow-up:
- [next improvement candidate, only if useful]
```

## Quality Gate

Verdict: **PASS** only if the change improves at least one of these:

- correct routing
- output quality
- validation integrity
- context efficiency
- cross-tool compatibility
- maintainability
- safety

Verdict: **FAIL** if no dimension improves. Revert or do not apply the patch.
