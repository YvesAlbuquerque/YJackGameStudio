## Summary

Brief description of what this PR does.

## Type of Change

- [ ] New agent
- [ ] New skill / workflow
- [ ] New hook or rule
- [ ] Agent-system adapter change
- [ ] Bug fix
- [ ] Documentation improvement
- [ ] Other:

## Changes

-
-
-

## Checklist

- [ ] I checked the relevant entrypoint (`AGENTS.md`, `GEMINI.md`, `CLAUDE.md`, or `.github/copilot-instructions.md`)
- [ ] Shared behavior changes are made in `.agents/` first, not only in `.claude/`
- [ ] New agents include the collaboration protocol expectations
- [ ] New shared skills use `.agents/skills/<name>/SKILL.md`
- [ ] Claude Code compatibility is mirrored in `.claude/` if this affects Claude users
- [ ] Reference docs are updated where relevant (`agent-roster`, `skills-reference`, `hooks-reference`, `rules-reference`, `tool-compatibility`)
- [ ] Hooks use `grep -E` where possible and fail gracefully without jq/python
- [ ] No hardcoded local paths, secrets, or platform-specific assumptions
- [ ] I state exactly what validation I ran, or why validation was not applicable
