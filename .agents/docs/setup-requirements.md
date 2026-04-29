# Setup Requirements

This template is mostly Markdown and shell scripts. The exact AI tool is optional;
use the adapter files for the system you prefer.

## Required

| Tool | Purpose |
|------|---------|
| Git | Version control and repository operations |
| One agentic coding tool | Codex, GitHub Copilot, Gemini CLI, Google Antigravity, Claude Code, or equivalent |

## Recommended

| Tool | Used By | Purpose |
|------|---------|---------|
| Bash | Hook scripts | Execute scripts under `.agents/hooks/` or `.claude/hooks/` |
| jq | Hook scripts | JSON parsing in validation/audit hooks |
| Python 3 | Hook scripts | JSON validation for data files |

## Tool Entrypoints

| Tool | File |
|------|------|
| Codex | `AGENTS.md` |
| GitHub Copilot | `.github/copilot-instructions.md` |
| Gemini CLI | `GEMINI.md` and `.gemini/settings.json` |
| Google Antigravity | `AGENTS.md`, `GEMINI.md`, `.agents/rules/`; `.agent/rules/game-studio.md` is a compatibility pointer |
| Claude Code | `CLAUDE.md` and `.claude/settings.json` |

## Hook Notes

Claude Code has automatic hook wiring through `.claude/settings.json`. The shared
`.agents/hooks/` scripts are portable copies; configure or run them manually in
other tools.

All hook scripts should fail gracefully if optional tools are missing. Missing
optional tools reduce validation coverage; they should not block normal editing.

## Verify Local Tools

```bash
git --version
bash --version
jq --version
python3 --version
```

On Windows, Git for Windows provides Git Bash, which is sufficient for the hook
scripts when `bash.exe` is on `PATH`.
