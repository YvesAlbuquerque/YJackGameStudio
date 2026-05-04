# Claude Code Adapter

Read `AGENTS.md` first. It is the cross-agent source of truth.

Claude Code-native assets remain available here for compatibility:

- `.claude/agents/` - Claude subagent definitions
- `.claude/skills/` - Claude slash-command skills
- `.claude/hooks/` - hooks wired by `.claude/settings.json`
- `.claude/rules/` - Claude path rules
- `.claude/docs/` - legacy Claude docs and templates

When changing shared behavior, update `.agents/` first and mirror to `.claude/`
only when Claude Code compatibility requires it.

## Claude-Specific References

@.claude/docs/directory-structure.md
@.claude/docs/technical-preferences.md

## Framework Integration

<!-- When a framework is configured (e.g., YJackCore for Unity projects), additional guidance will be listed here. -->

If `.claude/docs/technical-preferences.md` contains `- **Framework**: YJackCore` in the Framework Integration section, read:

@.claude/docs/yjackcore-support.md

## Coordination Rules

@.claude/docs/coordination-rules.md
@.claude/docs/coding-standards.md
@.claude/docs/context-management.md
