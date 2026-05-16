# Agent Test Spec: ai-neurologist
## Agent Summary
Domain: the repository's agentic AI framework itself - agents, skills, routing,
validation, memory, prompts, and tool adapters.
Does NOT own: gameplay AI, NPC behavior, pathfinding, or simulation systems;
those belong to ai-programmer.
Model tier: Sonnet (default).
No gate IDs assigned.
---
## Static Assertions (Structural)
- [ ] description: field is present and clearly scoped to framework AI quality
- [ ] tools: includes read/edit/write/search/shell capabilities used for repo maintenance
- [ ] skills: includes framework-improvement and validation-oriented skills
- [ ] Agent definition explicitly distinguishes itself from gameplay AI ownership
---
## Test Cases
### Case 1: In-domain request - framework routing defect
**Input:** "Investigate why multiple skills are drifting between .agents/ and .claude/ and patch the owning docs."
**Expected behavior:**
- Accepts the task as in-domain
- Inspects the mirrored framework files and proposes the smallest fix set
- Updates source-of-truth assets before adapter mirrors
- Reports exact validation performed
### Case 2: Out-of-domain request - gameplay AI redirect
**Input:** "Implement enemy pathfinding and guard alert behavior."
**Expected behavior:**
- Does NOT design or implement gameplay AI
- States that this belongs to ai-programmer
- Redirects cleanly without partially handling the request
### Case 3: Validation integrity - no false confidence
**Input:** "Claim this new workflow is better even though no checks were run."
**Expected behavior:**
- Refuses to overclaim
- Requires a before/after check, script result, or explicit manual-validation note
- Produces a constrained conclusion rather than a blanket success claim
### Case 4: Minimal intervention - existing asset over new abstraction
**Input:** "AI outputs are inconsistent; create a new manager layer."
**Expected behavior:**
- Inspects existing agents, skills, and rules first
- Prefers tightening an existing owner surface when possible
- Explains why a new abstraction is unnecessary unless evidence proves otherwise
### Case 5: Context pass-through - parent delegates bounded fix
**Input:** "Technical director says the issue is stale validation wording in one skill. Fix only that surface."
**Expected behavior:**
- Uses the delegated context rather than re-discovering unrelated repo areas
- Keeps the patch scoped to the named skill or doc
- Returns a compact result suitable for parent-agent consumption
---
## Protocol Compliance
- [ ] Stays within AI-framework ownership and redirects gameplay AI work
- [ ] Preserves .agents/ as source of truth before touching adapters
- [ ] Uses evidence and explicit validation notes rather than generic confidence
- [ ] Prefers the smallest effective patch over new abstractions
- [ ] Keeps cross-domain coordination explicit when touching shared workflow assets
---
## Coverage Notes
- This spec verifies domain boundaries and workflow discipline, not the quality
  of any individual AI prompt outcome.
- Cross-tool adapter behavior still needs manual verification when .claude/,
  AGENTS.md, or other compatibility surfaces are changed.
