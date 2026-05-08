---
name: asset-spec
description: "Generate per-asset visual specifications and AI generation prompts from GDDs, level docs, or character profiles. Produces structured spec files and updates the master asset manifest. Run after art bible and GDD/level design are approved, before production begins."
argument-hint: "[system:<name> | level:<name> | character:<name>] [--review full|lean|solo] [--issues draft|create|skip]"
user-invocable: true
allowed-tools: Read, Glob, Grep, Write, Edit, Task, AskUserQuestion, Bash
---

If no argument is provided, check whether `design/assets/asset-manifest.md` exists:
- If it exists: read it, find the first context (system/level/character) with any asset at status "Needed" but no spec file written yet, and use `AskUserQuestion`:
  - Prompt: "The next unspecced context is **[target]**. Generate asset specs for it?"
  - Options: `[A] Yes — spec [target]` / `[B] Pick a different target` / `[C] Stop here`
- If no manifest: fail with:
  > "Usage: `/asset-spec system:<name>` — e.g., `/asset-spec system:tower-defense`
  > Or: `/asset-spec level:iron-gate-fortress` / `/asset-spec character:frost-warden`
  > Run after your art bible and GDDs are approved."

---

## Phase 0: Parse Arguments

Extract:
- **Target type**: `system`, `level`, or `character`
- **Target name**: the name after the colon (normalize to kebab-case)
- **Review mode**: `--review [full|lean|solo]` if present
- **Issue mode**: `--issues [draft|create|skip]` if present

**Mode behavior:**
- `full` (default): spawn both `art-director` and `technical-artist` in parallel
- `lean`: spawn `art-director` only — faster, skips technical constraint pass
- `solo`: no agent spawning — main session writes specs from art bible rules alone. Use for simple asset categories or when speed matters more than depth.

**Issue behavior:**
- `draft` (default): produce issue bodies and a rollup preview in-chat (no GitHub issue creation).
- `create`: produce issue bodies, ask for approval, then create/update GitHub issues idempotently.
- `skip`: stop after spec + manifest updates; no issue generation.

---

## Phase 1: Gather Context

Read all source material **before** asking the user anything.

### Required reads:
- **Art bible**: Read `design/art/art-bible.md` — fail if missing:
  > "No art bible found. Run `/art-bible` first — asset specs are anchored to the art bible's visual rules and asset standards."
  Extract: Visual Identity Statement, Color System (semantic colors), Shape Language, Asset Standards (Section 8 — dimensions, formats, polycount budgets, texture resolution tiers).

- **Technical preferences**: Read `.claude/docs/technical-preferences.md` — extract performance budgets and naming conventions.

### Source doc reads (by target type):
- **system**: Read `design/gdd/[target-name].md`. Extract the **Visual/Audio Requirements** section. If it doesn't exist or reads `[To be designed]`:
  > "The Visual/Audio section of `design/gdd/[target-name].md` is empty. Either run `/design-system [target-name]` to complete the GDD, or describe the visual needs manually."
  Use `AskUserQuestion`: `[A] Describe needs manually` / `[B] Stop — complete the GDD first`
- **level**: Read `design/levels/[target-name].md`. Extract art requirements, asset list, VFX needs, and the art-director's production concept specs from Step 4.
- **character**: Read `design/narrative/characters/[target-name].md` or search `design/narrative/` for the character profile. Extract visual description, role, and any specified distinguishing features.

### Optional reads:
- **Existing manifest**: Read `design/assets/asset-manifest.md` if it exists — extract already-specced assets for this target to avoid duplicates.
- **Related specs**: Glob `design/assets/specs/*.md` — scan for assets that could be shared (e.g., a common UI element specced for one system might apply here too).
- **UX docs**: Glob `design/ux/*.md` — extract UI states, interaction notes, and accessibility constraints that affect UI asset issues.

### Present context summary:
> **Asset Spec: [Target Type] — [Target Name]**
> - Source doc: [path] — [N] asset types identified
> - Art bible: found — Asset Standards at Section 8
> - UX docs: [N files found / none]
> - Existing specs for this target: [N already specced / none]
> - Shared assets found in other specs: [list or "none"]

---

## Phase 2: Asset Identification

From the source doc, extract every asset type mentioned — explicit and implied.

**For systems**: look for VFX events, sprite references, UI elements, audio triggers, particle effects, icon needs, and any "visual feedback" language.

**For levels**: look for unique environment props, atmospheric VFX, lighting setups, ambient audio, skybox/background, and any area-specific materials.

**For characters**: look for sprite sheets (idle, walk, attack, death), portrait/avatar, VFX attached to abilities, UI representation (icon, health bar skin).

Group assets into categories:
- **Sprite / 2D Art** — character sprites, UI icons, tile sheets
- **VFX / Particles** — hit effects, ambient particles, screen effects
- **Environment** — props, tiles, backgrounds, skyboxes
- **UI** — HUD elements, menu art, fonts (if custom)
- **Audio** — SFX, music tracks, ambient loops *(note: audio specs are descriptions only — no generation prompts)*
- **3D Assets** — meshes, materials (if applicable per engine)

Present the full identified list to the user. Use `AskUserQuestion`:
- Prompt: "I identified [N] assets across [N] categories for **[target]**. Review before speccing:"
- Show the grouped list in conversation text first
- Options: `[A] Proceed — spec all of these` / `[B] Remove some assets` / `[C] Add assets I didn't catch` / `[D] Adjust categories`

Do NOT proceed to Phase 3 without user confirmation of the asset list.

---

## Phase 3: Spec Generation

Spawn specialist agents based on review mode. **Issue all Task calls simultaneously — do not wait for one before starting the next.**

### Full mode — spawn in parallel:

**`art-director`** via Task:
- Provide: full asset list from Phase 2, art bible Visual Identity Statement, Color System, Shape Language, the source doc's visual requirements, and any reference games/art mentioned in the art bible Section 9
- Ask: "For each asset in this list, produce: (1) a 2–3 sentence visual description anchored to the art bible's shape language and color system — be specific enough that two different artists would produce consistent results; (2) a generation prompt ready for use with AI image tools (Midjourney/Stable Diffusion style — include style keywords, composition, color palette anchors, negative prompts); (3) which art bible rules directly govern this asset (cite by section). For audio assets, describe the sonic character instead of a generation prompt."

**`technical-artist`** via Task:
- Provide: full asset list, art bible Asset Standards (Section 8), technical-preferences.md performance budgets, engine name and version
- Ask: "For each asset in this list, specify: (1) exact dimensions or polycount (match the art bible Asset Standards tiers — do not invent new sizes); (2) file format and export settings; (3) naming convention (from technical-preferences.md); (4) any engine-specific constraints this asset type must respect; (5) LOD requirements if applicable. Flag any asset type where the art bible's preferred standard conflicts with the engine's constraints."

### Lean mode — spawn art-director only (skip technical-artist).

### Solo mode — skip both. Derive specs from art bible rules alone, noting that technical constraints were not validated.

**Collect both responses before Phase 4.** If any conflict exists between art-director and technical-artist (e.g., art-director specifies 4K textures but technical-artist flags the engine budget requires 512px), surface it explicitly — do NOT silently resolve.

---

## Phase 4: Compile and Review

Combine the agent outputs into a draft spec per asset. Present all specs in conversation text using this format:

```
## ASSET-[NNN] — [Asset Name]

| Field | Value |
|-------|-------|
| Category | [Sprite / VFX / Environment / UI / Audio / 3D] |
| Dimensions | [e.g. 256×256px, 4-frame sprite sheet] |
| Format | [PNG / SVG / WAV / etc.] |
| Naming | [e.g. vfx_frost_hit_01.png] |
| Polycount | [if 3D — e.g. <800 tris] |
| Texture Res | [e.g. 512px — matches Art Bible §8 Tier 2] |

**Visual Description:**
[2–3 sentences. Specific enough for two artists to produce consistent results.]

**Art Bible Anchors:**
- §3 Shape Language: [relevant rule applied]
- §4 Color System: [color role — e.g. "uses Threat Blue per semantic color rules"]

**Generation Prompt:**
[Ready-to-use prompt. Include: style keywords, composition notes, color palette anchors, lighting direction, negative prompts.]

**Status:** Needed
```

After presenting all specs, use `AskUserQuestion`:
- Prompt: "Asset specs for **[target]** — [N] assets. Review complete?"
- Options: `[A] Approve all — write to file` / `[B] Revise a specific asset` / `[C] Regenerate with different direction`

If [B]: ask which asset and what to change. Revise inline and re-present. Do NOT re-spawn agents for minor text revisions — only re-spawn if the visual direction itself needs to change.

If [C]: ask what direction to change. Re-spawn the relevant agent with the updated brief.

---

## Phase 5: Write Spec File

After approval, ask: "May I write the spec to `design/assets/specs/[target-name]-assets.md`?"

Write the file with:

```markdown
# Asset Specs — [Target Type]: [Target Name]

> **Source**: [path to source GDD/level/character doc]
> **Art Bible**: design/art/art-bible.md
> **Generated**: [date]
> **Status**: [N] assets specced / [N] approved / [N] in production / [N] done

[all asset specs in ASSET-NNN format]
```

Then update `design/assets/asset-manifest.md`. If it doesn't exist, create it:

```markdown
# Asset Manifest

> Last updated: [date]

## Progress Summary

| Total | Needed | In Progress | Done | Approved |
|-------|--------|-------------|------|----------|
| [N] | [N] | [N] | [N] | [N] |

## Assets by Context

### [Target Type]: [Target Name]
| Asset ID | Name | Category | Status | Spec File |
|----------|------|----------|--------|-----------|
| ASSET-001 | [name] | [category] | Needed | design/assets/specs/[target]-assets.md |
```

If the manifest already exists, append the new context block and update the Progress Summary counts.

Ask: "May I update `design/assets/asset-manifest.md`?"

---

## Phase 6: Generate Asset Work Contract Issues

Skip this phase only when `--issues skip` is selected.

### 6.1 Required issue-generation inputs

Before drafting issues, read:
- `design/art/art-bible.md` (style constraints + section anchors)
- `design/assets/asset-manifest.md` (asset IDs, statuses, spec path)
- the source doc used in Phase 1 (`design/gdd/*`, `design/levels/*`, or `design/narrative/*`)
- related UX docs (`design/ux/*.md`) when UI assets are present
- the approved spec file from Phase 5 (`design/assets/specs/[target-name]-assets.md`)

If any input is missing, surface a `CONCERNS` note and continue with available data.
If `--issues create` is selected, confirm GitHub CLI is available in the environment before issue creation commands.

### 6.2 Track classification (must be separate)

Create separate issue tracks for each relevant asset:
- **Concept Art** — moodboards, silhouettes, style exploration before production asset build
- **Production Asset** — final in-game visual asset (sprite, prop, environment art, mesh/material)
- **UI Asset** — HUD/menu/input-state visual elements grounded in UX docs
- **VFX** — particles, shader-driven feedback, hit/ambient effects
- **Audio** — SFX/music/loops and implementation-ready metadata (no AI image prompt)
- **Implementation Hookup** — engine import/wiring tasks that connect produced files to runtime usage

Do not merge these tracks into one issue. One issue per `(asset_id, track)`.

### 6.3 Issue body requirements

Use `.github/ISSUE_TEMPLATE/asset-work-contract.md` as the structure.
Each generated issue must include:
- owner intent
- style constraints (art bible anchors)
- file targets (exact paths)
- generation/authoring prompt reference (for audio: sonic direction reference)
- acceptance criteria
- validation criteria + evidence path
- dependencies
- idempotency key

Issue titles should follow:
- `[Asset][Concept] ASSET-### [Name]`
- `[Asset][Production] ASSET-### [Name]`
- `[Asset][UI] ASSET-### [Name]`
- `[Asset][VFX] ASSET-### [Name]`
- `[Asset][Audio] ASSET-### [Name]`
- `[Asset][Hookup] ASSET-### [Name]`

### 6.4 Dependency and idempotency rules

- Idempotency key format:
  - `asset-issue:[target-type]:[target-name]:[asset-id]:[track]`
- Resolve repository owner/name first (run this command):
  - `gh repo view --json nameWithOwner -q .nameWithOwner`
- Search existing open issues for this key before creating a new one:
  - `gh issue list --search "repo:<owner>/<repo> in:body <idempotency-key>" --state open`
  - Replace `<owner>/<repo>` with the value from `nameWithOwner`.
  - Replace `<idempotency-key>` with the fully interpolated `asset-issue:...` key for the current `(target, asset_id, track)`.
  - If search indexing is delayed, cross-check against the latest `production/assets/asset-issue-rollup.md` entries before creating a new issue.
- If found: update the existing issue body (do not duplicate).
- If not found: create new issue.

Track dependency ordering:
- `Concept Art` → no asset dependency
- `Production Asset` depends on `Concept Art` (if concept track exists for that asset)
- `UI Asset`, `VFX`, `Audio` depend on approved spec + related UX/GDD references
- `Implementation Hookup` depends on all production tracks needed by runtime integration

Also add dependency links to `production/dependency-graph.yml` contract IDs when those contracts already exist.

### 6.5 YJackCore + Unity import and `.meta` rules

For Unity-scoped projects and/or YJackCore usage, each relevant issue must include:
- Asset authority classification:
  - `host` for `Assets/**`
  - `framework` for `Packages/YJackCore/**` or `Packages/com.ygamedev.yjack/**`
- Package-boundary protection:
  - Never target `Packages/YJackCore/**` or `Packages/com.ygamedev.yjack/**` unless owner explicitly approved.
  - If targeted, mark `risk_tier: HIGH`, add `risk:yjackcore-boundary`, and require owner escalation.
- `.meta` integrity:
  - Every Unity asset file target in `Assets/**` must include its matching `.meta` file in `write_set`.
  - Never regenerate/delete `.meta` manually; move/rename asset + `.meta` together.
  - Validation must include "Unity importer reports no GUID regeneration for retained assets."

### 6.6 Rollup view output

After drafting/creating issues, present a rollup table grouped by track:

| Track | Issues | Ready | Blocked (deps) | Validation Owner |
|-------|--------|-------|----------------|------------------|
| Concept Art | [N] | [N] | [N] | [agent/owner] |
| Production Asset | [N] | [N] | [N] | [agent/owner] |
| UI Asset | [N] | [N] | [N] | [agent/owner] |
| VFX | [N] | [N] | [N] | [agent/owner] |
| Audio | [N] | [N] | [N] | [agent/owner] |
| Implementation Hookup | [N] | [N] | [N] | [agent/owner] |

Ask: "May I write this rollup to `production/assets/asset-issue-rollup.md`?"

### 6.7 Validation check (sample manifest required)

Before closing, run a sample-manifest dry run:
1. Use a sample target context containing at least one UI asset, one VFX asset, and one audio asset.
2. Generate issue drafts (or create issues in a dedicated test repository/sandbox project).
3. Confirm each issue contains:
   - required label tokens (`priority:*`, `auto:*`, `effort:*`, `phase:*`, `domain:*`, `status:*`)
   - explicit dependencies
   - explicit validation criteria and evidence path
4. Confirm no duplicate issue for the same idempotency key.

If any check fails, surface `FAIL` with the offending asset IDs and stop before final issue creation.

---

## Phase 7: Close

Use `AskUserQuestion`:
- Prompt: "Asset specs complete for **[target]**. What's next?"
- Options:
  - `[A] Generate/create asset issues now (if skipped) — /asset-spec [target] --issues create`
  - `[B] Spec another system — /asset-spec system:[next-system]`
  - `[C] Spec a level — /asset-spec level:[level-name]`
  - `[D] Spec a character — /asset-spec character:[character-name]`
  - `[E] Run /asset-audit — validate delivered assets against specs`
  - `[F] Stop here`

---

## Asset ID Assignment

Asset IDs are assigned sequentially across the entire project — not per-context. Read the manifest before assigning IDs to find the current highest number:

```
Grep pattern="ASSET-" path="design/assets/asset-manifest.md"
```

Start new assets from `ASSET-[highest + 1]`. This ensures IDs are stable and unique across the whole project.

If no manifest exists yet, start from `ASSET-001`.

---

## Shared Asset Protocol

Before speccing an asset, check if an equivalent already exists in another context's spec:

- Common UI elements (health bars, score displays) are often shared across systems
- Generic environment props may appear in multiple levels
- Character VFX (hit sparks, death effects) may reuse a base spec with color variants

If a match is found: reference the existing ASSET-ID rather than creating a duplicate. Note the shared usage in the manifest's referenced-by column.

> "ASSET-012 (Generic Hit Spark) already specced for Combat system. Reusing for Tower Defense — adding tower-defense to referenced-by."

---

## Error Recovery Protocol

If any spawned agent returns BLOCKED or cannot complete:

1. Surface immediately: "[AgentName]: BLOCKED — [reason]"
2. In `lean` mode or if `technical-artist` blocks: proceed with art-director output only — note that technical constraints were not validated
3. In `solo` mode or if `art-director` blocks: derive descriptions from art bible rules — flag as "Art director not consulted — verify against art bible before production"
4. Always produce a partial spec — never discard work because one agent blocked

---

## Collaborative Protocol

Every phase follows: **Identify → Confirm → Generate → Review → Approve → Write → Issue**

- Never spec assets without first confirming the asset list with the user
- Always anchor specs to the art bible — a spec that contradicts the art bible is wrong
- Surface all agent disagreements — do not silently pick one
- Write the spec file only after explicit approval
- Update the manifest immediately after writing the spec
- Asset issues must reference approved specs; do not duplicate full spec content in issue bodies
- Issue creation must be idempotent per `asset-issue:*` key

---

## Recommended Next Steps

- Run `/asset-spec [next-context]` to continue speccing remaining systems, levels, or characters
- Run `/asset-spec [same-context] --issues create` to publish GitHub asset work contracts after draft review
- Run `/asset-audit` to validate delivered assets against the written specs and identify gaps or mismatches
