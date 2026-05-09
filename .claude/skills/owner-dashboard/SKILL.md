---
name: owner-dashboard
description: "Generate owner dashboard showing active issues, blocked items, validation debt, decisions needed, and risks."
argument-hint: "[--verbose --include-closed]"
user-invocable: true
allowed-tools: Read, Glob, Grep, Bash
model: sonnet
---

# Owner Dashboard (Claude Code Wrapper)

**Read `.agents/skills/owner-dashboard/SKILL.md` for the full specification.**

This wrapper delegates to the provider-neutral skill implementation.

---

## Execution

Follow all phases from `.agents/skills/owner-dashboard/SKILL.md` exactly. The definitive phase list is in that file; do not rely on any partial enumeration here.

---

## Claude-Specific Notes

- Use `Read` tool for file reading (maps to the provider-neutral capability)
- Use `Glob` for pattern-based file discovery
- Use `Grep` for content searching
- Use `Bash` tool for GitHub CLI commands when available

---

## Template Reference

Use `.agents/docs/templates/owner-dashboard.md` as the output format template.

---

## Related Skills

- `/sprint-status` — Detailed sprint progress
- `/gate-check` — Phase gate validation
- `/project-stage-detect` — Project stage detection
