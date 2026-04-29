---
applyTo: "AGENTS.md,GEMINI.md,CLAUDE.md,.agents/**,.agent/**,.gemini/**,.github/copilot-instructions.md,.github/instructions/**"
---

AI-agent configuration files must preserve the shared-source model:

- `AGENTS.md` is the cross-agent source of truth.
- `.agents/` is the provider-neutral shared layer.
- `.claude/` is compatibility-only unless a Claude-specific change is requested.
- Provider adapters should point to shared files rather than duplicate long rules.
- When editing shared skills, preserve frontmatter unless intentionally changing compatibility behavior.
- Check `.agents/docs/tool-compatibility.md` before replacing tool capability names such as `Task`, `AskUserQuestion`, `Read`, `Glob`, or `WebSearch`.
