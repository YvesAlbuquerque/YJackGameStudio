# Skill Test Spec: /asset-spec

## Skill Summary

`/asset-spec` reads approved source context (GDD/level/character), art bible,
asset manifest, and related UX docs to produce per-asset specs and then generate
asset work-contract issues (draft or create mode) for autonomous production.

Issue output must be track-separated (`concept-art`, `production-asset`,
`ui-asset`, `vfx`, `audio`, `implementation-hookup`), idempotent by
`asset-issue:*` key, and aligned to YJackCore/Unity package + `.meta` integrity
rules when applicable.

---

## Static Assertions (Structural)

Verified automatically by `/skill-test static` (no fixture needed).

- [ ] Has required frontmatter fields: `name`, `description`, `argument-hint`, `user-invocable`, `allowed-tools`
- [ ] Has ≥2 phase headings
- [ ] Contains verdict keyword(s): `PASS`, `FAIL`, `CONCERNS`, `APPROVED`, `BLOCKED`, `COMPLETE`, `READY`, `COMPLIANT`, `NON-COMPLIANT`
- [ ] Contains ask-before-write language (e.g., "May I write")
- [ ] Has a next-step handoff section
- [ ] Frontmatter includes `allowed-tools` with `Bash`
- [ ] Argument hint includes `--issues draft|create|skip`
- [ ] Skill includes a dedicated phase for asset issue generation
- [ ] Skill includes explicit idempotency-key guidance
- [ ] Skill includes YJackCore/Unity `.meta` handling guidance
- [ ] Skill includes sample-manifest validation guidance

---

## Test Cases

### Case 1: Happy Path — Spec + issue drafts for mixed asset set

**Fixture:**
- `design/art/art-bible.md` exists
- `design/assets/asset-manifest.md` exists
- Source GDD exists for target system
- `design/ux/*.md` exists
- No existing issues with matching `asset-issue:*` keys

**Input:** `/asset-spec system:tower-defense --review full --issues draft`

**Expected behavior:**
1. Reads art bible, asset manifest, source doc, and UX docs.
2. Produces approved asset specs and updates manifest.
3. Produces per-track issue drafts with required fields:
   owner intent, style constraints, file targets, prompt reference,
   acceptance criteria, validation criteria, dependencies, idempotency key.
4. Shows rollup grouped by track.

**Assertions:**
- [ ] All required source categories are read (art bible, manifest, source doc, UX docs)
- [ ] Draft issues are separated by required tracks
- [ ] Each issue includes idempotency key and validation packet path
- [ ] Rollup table includes counts by track

---

### Case 2: Idempotency — Existing issue is updated, not duplicated

**Fixture:**
- Same as Case 1
- Existing GitHub issue body already contains:
  `idempotency_key: asset-issue:system:tower-defense:ASSET-021:production-asset`

**Input:** `/asset-spec system:tower-defense --issues create`

**Expected behavior:**
1. Searches existing issues by idempotency key before create.
2. Updates existing issue for matching key.
3. Creates only missing keys.

**Assertions:**
- [ ] Matching key does not create duplicate issue
- [ ] Existing issue is updated with current dependency/validation content
- [ ] New issues are created only for missing keys

---

### Case 3: YJackCore + Unity boundary handling

**Fixture:**
- Unity/YJackCore project context
- At least one asset targets `Assets/UI/...`
- At least one request attempts package-boundary target

**Input:** `/asset-spec system:inventory --issues draft`

**Expected behavior:**
1. Host assets include matching `.meta` entries in write targets.
2. Package-boundary targets are flagged as HIGH risk with escalation.
3. Issue text distinguishes host vs framework authority.

**Assertions:**
- [ ] Unity asset write targets include `.meta`
- [ ] Package-boundary issue includes `risk:yjackcore-boundary` escalation
- [ ] Host/framework classification is explicit

---

### Case 4: Sample-manifest validation gate

**Fixture:**
- Sample manifest includes at least UI, VFX, and Audio assets.

**Input:** `/asset-spec system:sample --issues create`

**Expected behavior:**
1. Runs sample-manifest validation checks before final issue creation.
2. Confirms label tokens, dependencies, and validation criteria in each issue.
3. Stops with `FAIL` if checks fail.

**Assertions:**
- [ ] Validation checks inspect label tokens (`priority`, `auto`, `effort`, `phase`, `domain`, `status`)
- [ ] Validation checks inspect dependencies and evidence path
- [ ] Failure path is explicit and blocks final create

---

## Protocol Compliance

- [ ] Uses ask-before-write before spec/manifest writes
- [ ] Uses approval checkpoint before issue creation in `create` mode
- [ ] Keeps issue content as references to approved specs (no full spec duplication)
- [ ] Ends with next-step handoff options
