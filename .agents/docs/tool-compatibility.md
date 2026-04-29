# Tool Compatibility Guide

The shared `.agents/` layer uses common procedural names. Some names come from
Claude Code because this template started there. Treat them as capability labels,
not hard dependencies, unless you are running Claude Code.

## Capability Mapping

| Shared capability term | Codex | GitHub Copilot | Gemini CLI | Google Antigravity | Claude Code |
|---|---|---|---|---|---|
| `Read` | Open/read file | Attach/open file or workspace search | Read file tool or `@path` | Read/open file | `Read` |
| `Glob` | File search/list | Workspace search | Glob/search tool | Explorer/search | `Glob` |
| `Grep` | Text search | Workspace search | Search tool | Search | `Grep` |
| `Write` / `Edit` | Edit files directly | Edit files / propose patch | Write/edit tool | Edit files | `Write` / `Edit` |
| `Bash` | Shell command | Terminal, agent command, or CI step | Shell tool | Terminal action | `Bash` |
| `AskUserQuestion` | Ask concise question | Ask in chat/PR | Ask in chat | Ask in agent thread | `AskUserQuestion` |
| `WebSearch` | Web search if enabled | Browser/search if enabled | Web/search grounding if enabled | Browser/search if enabled | `WebSearch` |
| `Task` / subagent | Spawn delegated subagent if available; otherwise do locally | Copilot coding agent or separate chat/task | Subagent unavailable by default; do locally or use separate session | Agent Manager task | `Task` |
| Hook event names | Manual or configured equivalent | CI/custom workflow equivalent | Manual/configured equivalent | Rule/workflow equivalent | Native hooks via `.claude/settings.json` |

## Skill Frontmatter

Skill files under `.agents/skills/*/SKILL.md` may include keys such as
`allowed-tools`, `user-invocable`, and `argument-hint`. Tools that do not
understand these keys should ignore them and follow the Markdown procedure.

## Slash Commands

If the active tool does not expose slash commands, interpret `/skill-name` as:

1. Read `.agents/skills/skill-name/SKILL.md`.
2. Follow its phases in order.
3. Produce the required artifact or verdict.
4. State which validation was actually run.

## Subagents And Teams

When a skill says to spawn an agent or subagent:

- If the tool supports delegation, use the tool-native delegation mechanism.
- If it does not, perform the role locally by reading `.agents/agents/<role>.md`.
- If the work is too large for one context, split it into separate user-approved sessions.
- Do not invent parallel execution. State when work was done sequentially.

## Hooks

Shared hook scripts live in `.agents/hooks/`; Claude Code-native hook wiring lives
in `.claude/settings.json`. For non-Claude tools, hook scripts are reference
implementations unless explicitly configured in that tool or CI.

## Provider-Specific Files

- `AGENTS.md`: cross-agent source of truth.
- `.github/copilot-instructions.md`: Copilot repository-wide instructions.
- `.github/instructions/*.instructions.md`: Copilot path-specific instructions.
- `GEMINI.md`: Gemini/Antigravity adapter.
- `.gemini/settings.json`: Gemini CLI context-file configuration.
- `.agent/rules/game-studio.md`: Antigravity compatibility pointer.
- `CLAUDE.md`: Claude Code adapter.
- `.claude/`: Claude Code-native compatibility layer.
