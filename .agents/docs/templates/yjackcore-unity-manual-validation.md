# YJackCore Unity Manual Validation Template

Use this checklist when scope type is `unity-yjackcore`.

> **Task / story**: [identifier]  
> **Date**: [YYYY-MM-DD]  
> **Tester / owner**: [name]

---

## Scene Validation Checklist

- [ ] Scene opens without missing script references
- [ ] Domain reload succeeds (no compile errors)
- [ ] Play Mode behavior matches expected scene wiring
- [ ] Asset database refresh completed without broken references

## Prefab Validation Checklist

- [ ] Prefab instances keep expected serialized references
- [ ] Prefab overrides apply cleanly and persist
- [ ] Inspector-exposed fields/events are correctly wired
- [ ] `.meta` GUID integrity verified after changes

## Package Validation Checklist (YJackCore / UPM)

- [ ] Package Manager resolves dependencies cleanly
- [ ] Compile symbol branches validated for active modules
- [ ] Package boundary respected (`Packages/YJackCore/**` edits explicitly approved)
- [ ] Development and/or release build validation completed in Unity Editor/CI

## Manual Sign-Off

| Validation area | Status | Notes |
| --- | --- | --- |
| Scene | Pending / Confirmed | |
| Prefab | Pending / Confirmed | |
| Package | Pending / Confirmed | |
