---
name: provider-neutrality-audit
description: "Audit YJackGameStudio shared agents, skills, rules, docs or templates for provider/engine lock-in, private-repository dependencies and adapter leakage."
argument-hint: "[skill | agent | rule | docs | full]"
user-invocable: true
---

# Provider Neutrality Audit

## Audit

1. Identify whether the target is shared `.agents/` behavior or a provider-specific adapter.
2. For shared behavior, flag hard requirements on Codex, Claude, Gemini, Copilot, Antigravity or another vendor when the requirement can be expressed provider-neutrally.
3. Flag assumptions that every project uses Unity, Loomlight Flux, `.yjack-workspace.json`, Godot or Unreal unless the target is explicitly engine-specific.
4. Flag links or instructions that require private YFramework/Loomlight repositories for public operation.
5. Verify vendor adapters defer to shared `.agents` behavior rather than redefining it.
6. Verify private commercial Loomlight Game Studio capabilities are not presented as implemented in this public template.
7. Verify public documentation uses anonymously accessible references.
8. Distinguish intentional engine/provider-specific references in scoped adapters from shared lock-in.

## Verdict

`PASS`, `ADAPTER_DRIFT`, `PROVIDER_LOCK_IN`, `ENGINE_LOCK_IN`, `PRIVATE_DEPENDENCY`, or `COMMERCIAL_BOUNDARY_LEAK` with the smallest correction and validation required.
