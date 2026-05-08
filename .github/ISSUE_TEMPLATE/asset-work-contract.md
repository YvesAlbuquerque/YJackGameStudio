---
name: Asset Work Contract
about: Structured asset production issue generated from /asset-spec outputs.
title: "[Asset] "
labels: type:shard, status:proposed, phase:pre-production
assignees: ''
---

## Asset Work Contract

Use this template for one `(asset_id, track)` issue. Reference approved specs; do not duplicate full spec content.

## Identity

- contract_id: ASSET-001-CONCEPT
- asset_id: ASSET-001
- track: concept-art | production-asset | ui-asset | vfx | audio | implementation-hookup
- idempotency_key: asset-issue:[target-type]:[target-name]:[asset-id]:[track]
- parent_issue: #22
- spec_reference: design/assets/specs/[target-name]-assets.md#ASSET-###
- manifest_reference: design/assets/asset-manifest.md

## Owner Intent

[One clear sentence describing the intended asset outcome.]

## Style Constraints (Art Bible Anchors)

- design/art/art-bible.md §[x] [constraint]
- design/art/art-bible.md §[y] [constraint]

## Generation / Authoring Prompt Reference

- Prompt reference (visual): design/assets/specs/[target-name]-assets.md#ASSET-###
- Prompt reference (audio): [sonic direction anchor if track=audio]

## File Targets (Write Set)

- Assets/[...]/[asset-file]
- Assets/[...]/[asset-file].meta
- [additional outputs if needed]

## Dependencies

- [ ] None
- [ ] Depends on issue #[concept/prod/ui/vfx/audio issue id]
- [ ] Depends on approved source docs (GDD/UX/spec)

## Acceptance Criteria

- [ ] Asset output matches approved spec reference and track scope
- [ ] Naming convention and format match technical preferences/art bible
- [ ] File targets are complete (including `.meta` where Unity applies)
- [ ] Handoff notes include implementation usage path

## Validation

- validation_packet: production/qa/validation-packets/[asset-id]-[track].md
- validation_criteria:
  - [ ] Lint/static checks for changed metadata files pass
  - [ ] No duplicate idempotency key issue exists
  - [ ] Dependency links resolve to existing issues/contracts
  - [ ] Manual checks captured where engine/editor validation is required

## YJackCore / Unity Alignment

- note: use `host-only` (same canonical layer value used in `.github/ISSUE_TEMPLATE/agent_work_contract.yml`) for host-game-only asset work
- authority: host | framework
- yjackcore_layer: host-only | GameLayer | LevelLayer | PlayerLayer | ViewLayer | Shared | framework-change
- package_boundary: none | Packages/YJackCore/** | Packages/com.ygamedev.yjack/**
- unity_meta_rules:
  - [ ] `.meta` files are preserved/moved with asset files (no manual GUID regeneration)
  - [ ] Package boundary untouched unless owner-approved (HIGH risk if touched)

## Label Tokens (for automation)

Set exactly one domain token by track:
- concept-art / production-asset: `domain:art`
- ui-asset / implementation-hookup: `domain:ui`
- audio: `domain:audio`
- vfx: `domain:art` (or `domain:implementation` when primarily engine-hookup work)

priority:medium
auto:medium
effort:S
phase:pre-production
status:proposed

Risk labels (optional; add only if applicable as explicit token lines):
- risk:architecture
- risk:yjackcore-boundary
- risk:unity-scene-prefab
- risk:scope-creep

## Handoff Criteria

- [ ] Acceptance criteria are complete
- [ ] Validation packet path is committed/linked
- [ ] Dependencies and rollout order are clear for sprint scheduling
