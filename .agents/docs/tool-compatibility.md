# Tool Compatibility Guide

The shared `.agents/` layer uses common procedural names. Some names come from
Claude Code because this template started there. Treat them as capability labels,
not hard dependencies, unless you are running Claude Code.

## Provider Directories

| Provider | Config Directory | Entry Point |
|----------|-----------------|-------------|
| Claude (Anthropic) | `.claude/` | `CLAUDE.md` |
| Codex / GPT (OpenAI) | `.codex/` (if present) | `AGENTS.md` (root) |
| Gemini (Google) | provider reads `.agents/` | `AGENTS.md` (root) |
| Copilot (GitHub) | `.github/copilot-instructions.md` (if present) | `AGENTS.md` (root) |
| Any other provider | `.agents/` | `AGENTS.md` (root) |

The root `AGENTS.md` is the universal entry point. All providers should read it.

## Canonical Source of Truth

`.agents/` docs are the canonical, provider-neutral source of truth for:

- Autonomy modes and approval boundaries
- Work contract schema
- YJackCore authority rules
- Workspace manifest specification
- Validation evidence requirements
- This tool compatibility guide

**Do not make shared workflow changes only in `.claude/`.** If a rule applies to
all agents regardless of provider, put it in `.agents/` first, then mirror or
reference it in provider-specific directories.

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

## Claude Code Specific

Claude Code reads both `.agents/` and `.claude/`. When there is a conflict,
`.agents/` takes precedence for policy and authority rules. `.claude/` may
supplement with Claude-specific configuration (hooks, settings, model tier
assignments).

Claude-specific capabilities available:

| Capability | Available | Notes |
|-----------|-----------|-------|
| Subagent spawning (Task tool) | Yes | Used by all `team-*` skills |
| Hooks (PreToolUse, PostToolUse) | Yes | See `.claude/hooks/` |
| Session-scoped memory | Yes | See `.claude/agent-memory/` |
| Slash commands / skills | Yes | See `.claude/skills/` |
| Settings and permissions | Yes | See `.claude/settings.json` |
| Agent teams (experimental) | Opt-in | Requires `CLAUDE_CODE_EXPERIMENTAL_AGENT_TEAMS=1` |

## Provider-Specific Files

- `AGENTS.md`: cross-agent source of truth.
- `.github/copilot-instructions.md`: Copilot repository-wide instructions.
- `.github/instructions/*.instructions.md`: Copilot path-specific instructions.
- `GEMINI.md`: Gemini/Antigravity adapter.
- `.gemini/settings.json`: Gemini CLI context-file configuration.
- `.agent/rules/game-studio.md`: Antigravity compatibility pointer.
- `CLAUDE.md`: Claude Code adapter.
- `.claude/`: Claude Code-native compatibility layer.

## Capabilities Not Available to Agents (Any Provider)

These capabilities require a human with a development environment:

| Capability | Why Unavailable to Agents |
|-----------|--------------------------|
| Unity Editor (GUI) | Requires installed Unity + display environment |
| Play Mode execution | Requires Unity Editor open and running |
| Unity build pipeline | Requires Unity license + build configuration |
| Device testing | Requires physical or emulated device |
| Live server testing | Requires deployed infrastructure |

Any validation claim for the above is invalid unless the human owner explicitly
confirms they ran those checks and reported results back to the agent.

## Static Validation Tools (Available to Agents)

These tools can be used by agents for honest lightweight validation:

| Tool | Purpose | Availability |
|------|---------|-------------|
| `git diff --check` | Whitespace and syntax check | Standard git (always available) |
| `jq` | JSON validation and querying | Optional (graceful fallback if absent) |
| Python 3 | JSON schema validation, doc scripts | Optional |
| Bash/PowerShell | Hook scripts, local validators | Available per platform |
| `grep` / `ripgrep` | Stale reference detection, link inspection | Available |

All hooks in `.claude/hooks/` fail gracefully if optional tools are missing.

## Unity Manual Validation Protocol

When a work contract includes Unity work, agents must:

1. List all required manual validation steps in `manual_validation_still_required`.
2. Provide the owner with exact steps to validate (what to open, what to look for).
3. Not mark the work `VALIDATED` until the owner confirms manual checks pass,
   or explicitly accepts the risk of pending validation debt.

Example handoff message for Unity work:

```
Manual validation still required before merging:
1. Open the Unity project in Unity 6000.0.
2. Wait for domain reload — confirm no compile errors.
3. Open the Settings scene — confirm SettingsManager component is wired.
4. Enter Play Mode — confirm settings save/load without errors.
5. Report results back to close the work contract.
```
