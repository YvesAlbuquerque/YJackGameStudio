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

No framework-specific integration guidance is enabled by default.
Add framework support docs only when the project actually uses them.
For example, include `@.claude/docs/yjackcore-support.md` only after
`/setup-engine` selects or detects YJackCore for this project.

If `.claude/docs/technical-preferences.md` contains `- **Framework**: YJackCore` in the Framework Integration section, read:

@.claude/docs/yjackcore-support.md

@.claude/docs/yjackcore-consumer-authority.md

## Coordination Rules

@.claude/docs/coordination-rules.md
@.claude/docs/coding-standards.md
@.claude/docs/context-management.md
