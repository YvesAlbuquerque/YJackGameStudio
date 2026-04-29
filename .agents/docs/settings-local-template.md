# Local Agent Notes Template

Use tracked files for team/project rules and ignored local files for personal or
machine-specific notes.

## Recommended Local Files

| File | Purpose |
|------|---------|
| `AGENTS.local.md` | Personal local notes for any agentic tool |
| `GEMINI.local.md` | Gemini-family local notes if your client is configured to read them |
| `CLAUDE.local.md` | Claude Code local notes |
| `.claude/settings.local.json` | Claude Code local permissions/hooks |
| `.gemini/.env` | Gemini CLI environment values; never commit secrets |

## What Belongs Here

- Local engine executable paths
- Personal editor preferences
- Machine-specific build shortcuts
- Temporary notes that should not affect the team

## What Does Not Belong Here

- Shared coding standards
- Architecture decisions
- GDD requirements
- Validation policy
- Secrets in tracked files

Keep shared instructions in `AGENTS.md` and `.agents/`.
