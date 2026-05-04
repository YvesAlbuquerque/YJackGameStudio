# Label Taxonomy

This document defines every label used in this repository. Labels are grouped by category.

**Required label groups** (every issue must have one label from each):

| Group | Examples |
|---|---|
| **Type** | `type:story`, `type:bug`, `type:epic` |
| **Priority** | `priority:high`, `priority:medium` |
| **Autonomy** | `auto:low`, `auto:medium`, `auto:high` *(autonomous work items only)* |

Recommended groups: **Domain**, **Effort**. Optional groups: **Phase**, **Status**, **YJackCore**.

Every
autonomous work item should have at least one label from each **required** group.

To bootstrap all labels at once, use [`labels.yml`](labels.yml) with
[`github-label-sync`](https://github.com/Financial-Times/github-label-sync):

```bash
github-label-sync --access-token $GITHUB_TOKEN \
  --labels .github/labels.yml \
  YvesAlbuquerque/Claude-Code-Game-Studios
```

Or create individual labels with the `gh` CLI:

```bash
gh label create "priority:high" --color "D93F0B" \
  --description "Must be in the current sprint" \
  --repo YvesAlbuquerque/Claude-Code-Game-Studios
```

> **Note:** `priority:*`, `auto:*`, `effort:*`, `phase:*`, `domain:*`, and `status:*` labels are
> applied automatically by the `.github/workflows/issue-labels.yml` workflow when an issue is
> opened or edited from a structured template. `type:*` labels are applied by the template itself.
> You do not need to apply these labels manually for templated issues.

---

## Type Labels *(required — pick one)*

Identifies what kind of work item this issue represents.

| Label | Colour | Meaning |
|---|---|---|
| `type:epic` | `#6E40C9` (purple) | Large owner-scoped deliverable spanning multiple stories |
| `type:story` | `#0075CA` (blue) | Implementable work unit for one specialist agent |
| `type:shard` | `#005CC5` (dark blue) | Parallelisable atomic sub-task derived from a story |
| `type:validation` | `#238636` (green) | Validation gate report for a story, shard, or epic |
| `type:decision` | `#BF8700` (amber) | Owner product/architecture decision or escalation request |
| `type:bug` | `#D73A4A` (red) | Something is broken or incorrect |
| `type:feature` | `#A2EEEF` (cyan) | New capability request |
| `type:improvement` | `#84b6EB` (light blue) | Enhancement to an existing component |
| `type:chore` | `#E4E669` (yellow) | Maintenance, dependency update, or non-functional change |
| `type:docs` | `#0075CA` (blue) | Documentation-only change |

---

## Priority Labels *(required — pick one)*

Controls scheduling order for the autonomous sprint planner.

| Label | Colour | Meaning |
|---|---|---|
| `priority:critical` | `#B60205` (dark red) | Blocks other work or is a release stopper |
| `priority:high` | `#D93F0B` (orange-red) | Must be in the current sprint |
| `priority:medium` | `#E4E669` (yellow) | Should be in the current sprint if capacity allows |
| `priority:low` | `#0E8A16` (green) | Nice to have; schedule in a future sprint |

---

## Effort Labels *(recommended — pick one)*

Rough size estimate. Used by the sprint planner to avoid overloading a sprint.

| Label | Colour | Meaning |
|---|---|---|
| `effort:XL` | `#5319E7` (violet) | > 5 days — requires phase-level planning before starting |
| `effort:L` | `#5319E7` (violet) | 3–5 days — requires decomposition into shards |
| `effort:M` | `#5319E7` (violet) | 1–3 days |
| `effort:S` | `#5319E7` (violet) | < 1 day |

---

## Phase Labels *(optional — pick one)*

Identifies which development phase this issue belongs to.

| Label | Colour | Meaning |
|---|---|---|
| `phase:concept` | `#BFD4F2` (light blue) | Concept and ideation phase |
| `phase:pre-production` | `#BFD4F2` (light blue) | Pre-production: design, architecture, planning |
| `phase:production` | `#BFD4F2` (light blue) | Active production sprint |
| `phase:alpha` | `#BFD4F2` (light blue) | Alpha milestone |
| `phase:beta` | `#BFD4F2` (light blue) | Beta milestone |
| `phase:release` | `#BFD4F2` (light blue) | Release candidate / ship phase |
| `phase:post-launch` | `#BFD4F2` (light blue) | Post-launch live-ops and maintenance |

---

## Domain Labels *(recommended — pick one)*

Identifies which discipline or system area owns this issue.

| Label | Colour | Meaning |
|---|---|---|
| `domain:design` | `#F9D0C4` (salmon) | Game design, GDDs, balance, systems design |
| `domain:architecture` | `#F9D0C4` (salmon) | Technical architecture, ADRs, engine decisions |
| `domain:implementation` | `#F9D0C4` (salmon) | Code implementation |
| `domain:qa` | `#F9D0C4` (salmon) | Testing, validation, quality assurance |
| `domain:infrastructure` | `#F9D0C4` (salmon) | CI/CD, tooling, build pipeline, agent framework |
| `domain:narrative` | `#F9D0C4` (salmon) | Writing, dialogue, lore, story |
| `domain:art` | `#F9D0C4` (salmon) | Visual assets, art direction |
| `domain:audio` | `#F9D0C4` (salmon) | Sound effects, music, audio integration |
| `domain:ui` | `#F9D0C4` (salmon) | User interface and UX |
| `domain:live-ops` | `#F9D0C4` (salmon) | Live-ops, telemetry, monetisation, events |

---

## Autonomy Labels *(required for autonomous work items)*

Maps to the approval boundary model from [AUTO-001](../docs/AUTONOMOUS_GAME_STUDIO_ROADMAP.md#auto-001-owner-directed-autonomy-modes-and-approval-boundaries).

| Label | Colour | Meaning |
|---|---|---|
| `auto:low` | `#C2E0C6` (light green) | Agents execute; owner approves all outputs before merge |
| `auto:medium` | `#FEF2C0` (light yellow) | LOW-risk decisions execute autonomously; MEDIUM pauses for owner approval |
| `auto:high` | `#F1C6C6` (light red) | LOW+MEDIUM decisions execute autonomously; HIGH always escalates |

---

## Status Labels *(used by agents to track work contract lifecycle)*

| Label | Colour | Meaning |
|---|---|---|
| `status:proposed` | `#EDEDED` (grey) | Issue created; not yet approved for execution |
| `status:approved` | `#0075CA` (blue) | Owner has approved; ready for agent pickup |
| `status:in-progress` | `#FEF2C0` (yellow) | Agent is actively working on this |
| `status:blocked` | `#D93F0B` (orange-red) | Execution is blocked; needs owner or dependency resolution |
| `status:in-review` | `#BFD4F2` (light blue) | Work complete; awaiting validation or owner review |
| `status:validated` | `#238636` (green) | Validation gate passed |
| `status:closed` | `#EDEDED` (grey) | Work is complete and merged |
| `status:deferred` | `#E4E669` (yellow) | Postponed to a future sprint |
| `status:wont-fix` | `#EDEDED` (grey) | Will not be addressed |

---

## YJackCore Labels *(conditional — apply when YJackCore is involved)*

Applies when an issue touches the YJackCore framework integration.

| Label | Colour | Meaning |
|---|---|---|
| `yjackcore:layer` | `#7057FF` (violet) | Issue touches a YJackCore layer boundary |
| `yjackcore:package` | `#7057FF` (violet) | Issue touches a YJackCore package boundary |
| `yjackcore:host-game` | `#7057FF` (violet) | Issue involves host-game / YJackCore separation concerns |
| `yjackcore:workspace` | `#7057FF` (violet) | Issue involves `.yjack-workspace.json` or workspace routing |

---

## Roadmap Labels *(informational)*

| Label | Colour | Meaning |
|---|---|---|
| `roadmap` | `#0075CA` (blue) | Issue derives from `docs/AUTONOMOUS_GAME_STUDIO_ROADMAP.md` |
| `autonomous` | `#6E40C9` (purple) | Issue is part of the autonomous studio operating model |

---

## Standard GitHub Labels *(kept for compatibility)*

| Label | Colour | Meaning |
|---|---|---|
| `bug` | `#D73A4A` (red) | Alias for `type:bug`; kept for existing workflows |
| `enhancement` | `#A2EEEF` (cyan) | Alias for `type:feature`; kept for existing workflows |
| `good first issue` | `#7057FF` (violet) | Good entry point for new contributors |
| `help wanted` | `#008672` (teal) | Extra attention or contribution is welcome |
| `question` | `#D876E3` (pink) | Further information is requested |
| `duplicate` | `#CFD3D7` (light grey) | This issue already exists |
| `invalid` | `#E4E669` (yellow) | This issue is invalid or a mistake |
| `wontfix` | `#FFFFFF` (white) | This will not be fixed |

---

## Label Naming Conventions

- Use `category:value` format for all non-standard labels.
- Category names are lowercase singular nouns: `type`, `priority`, `effort`, `phase`, `domain`, `auto`, `status`, `yjackcore`.
- Values are lowercase kebab-case.
- Labels are additive: an issue can carry multiple labels from different categories.
- Never apply two labels from the same category unless the issue genuinely spans both (e.g., a story can have `domain:implementation` and `domain:qa` if it covers both).

---

## Query Examples

```bash
# All autonomous stories ready for agent pickup
gh issue list --label "type:story,status:approved,auto:medium"

# All blocked items in the current production phase
gh issue list --label "phase:production,status:blocked"

# All critical bugs
gh issue list --label "type:bug,priority:critical"

# All YJackCore layer boundary issues
gh issue list --label "yjackcore:layer"

# All unresolved escalations awaiting owner decision
gh issue list --label "type:decision,status:proposed"
```
