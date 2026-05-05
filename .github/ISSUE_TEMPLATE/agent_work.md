---
name: Agent Work
about: A structured work contract for autonomous or supervised agent execution
title: "[AGENT] "
labels: type:agent-work
assignees: ''

---

## Owner Intent

<!-- One sentence: what does the owner want to achieve? -->


## Scope

<!-- What is explicitly in scope for this work unit? -->


## Non-Goals

<!-- What does this contract explicitly NOT cover? -->


## Work Contract

<!-- Fill in the fields below. Required fields are marked with *. -->

- **specialist_agent***: <!-- e.g., engine-programmer, qa-tester, technical-writer -->
- **autonomy_mode***: <!-- collaborative | supervised | trusted -->
- **risk_tier***: <!-- LOW | MEDIUM | HIGH -->
- **approval_boundary**: <!-- What may the agent do without asking vs. what needs owner sign-off? -->

### YJackCore Classification (Required When YJackCore Is Active)

- **yjackcore_relevance**: <!-- none | consumer | framework-change -->
- **yjackcore_layer**: <!-- GameLayer | LevelLayer | PlayerLayer | ViewLayer | Shared | n/a -->
- **framework_change_vs_game_change**: <!-- game-repo-work | framework-work | both -->

## Dependencies

<!-- List issue IDs or contract IDs that must be VALIDATED before this work starts. -->
- None

## File Ownership

**Read set** (files this agent will read for context):
- 

**Write set** (files this agent has exclusive write permission for):
- 

## Expected Outputs

<!-- Concrete artifacts this contract produces. -->
- 

## Validation Plan

<!-- Checks the agent will run. Be honest — only list checks that can actually be run. -->
- [ ] `git diff --check`
- [ ] Static doc review
- [ ] 

## Manual Validation Still Required

<!-- Checks that must be done by a human with Unity open. Do not skip this section for Unity work. -->
- [ ] Unity domain reload (no compile errors)
- [ ] Play Mode (runtime behavior)
- [ ] Scene/prefab wiring (component references valid)

## Escalation Conditions

<!-- When must the agent stop and notify the owner? -->
- Scope change required beyond the approved write set
- A HIGH-risk action not pre-approved in this contract
- Any required change to YJackCore package files (unless `framework-work` is authorized)

## Handoff Notes

<!-- What the next agent or owner needs to know to continue from this contract's end state. -->


## Validation Evidence

<!-- Filled in by the agent when closing the contract. -->

- **checks_run**: 
- **checks_unavailable**: 
- **static_inspection**: 
- **manual_validation_still_required**: 
- **known_risks**: 
- **confidence**: <!-- HIGH | MEDIUM | LOW -->

---
*See `.agents/docs/work-contract-schema.md` for field definitions and lifecycle states.*
*See `.agents/docs/validation-evidence.md` for evidence packet guidance.*
