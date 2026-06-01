# Provider Compatibility Matrix

This matrix summarizes how YJackGameStudio works across currently supported
agent systems and where each system should read canonical instructions.

The provider-neutral source of truth remains:

- `AGENTS.md`
- `.agents/agents/`
- `.agents/skills/`
- `.agents/rules/`
- `.agents/docs/tool-compatibility.md`

Capability terms used in shared skills (for example `Task`, `AskUserQuestion`,
`Read`, `Glob`, `Grep`, `Write`, `Edit`, `Bash`, and `WebSearch`) are labels
that must be mapped to tool-native behavior using
[`.agents/docs/tool-compatibility.md`](../../.agents/docs/tool-compatibility.md).

## Matrix

| Tool / provider | Primary entrypoint | Skill/workflow support | Agent/delegation support | Hooks/validation support | Known limitations | Source-of-truth files | Support status |
|---|---|---|---|---|---|---|---|
| Codex (OpenAI) | `AGENTS.md` | `/skill-name` workflow via `.agents/skills/*/SKILL.md` | Subagent delegation if available; otherwise role executed locally | Native shell/file tooling plus repo validators (for example `git diff --check`) | Tool-native delegation varies by runtime; no implied engine/runtime validation without evidence | `AGENTS.md`, `.agents/`, `.agents/docs/tool-compatibility.md` | Native |
| GitHub Copilot | `.github/copilot-instructions.md` + `AGENTS.md` | Skill workflows followed via reading `.agents/skills/*/SKILL.md` | Copilot agent task flow when available; otherwise sequential/manual role execution | Validation via terminal/CI and repo scripts; path-specific instructions in `.github/instructions/` | Feature surface depends on host (VS Code/GitHub); slash command parity is not guaranteed | `.github/copilot-instructions.md`, `.github/instructions/`, `AGENTS.md`, `.agents/` | Native adapter |
| Gemini CLI | `GEMINI.md` + `AGENTS.md` (via `.gemini/settings.json`) | Skill workflows executed by reading `.agents/skills/*/SKILL.md` | No default native subagent equivalent; team flows executed locally or split into approved sessions | Uses shell/tooling available in the session plus repo validators | Delegation semantics differ from Claude-style `Task`; depends on available Gemini tools | `GEMINI.md`, `.gemini/settings.json`, `AGENTS.md`, `.agents/` | Native adapter |
| Google Antigravity | `AGENTS.md`, `GEMINI.md`, `.agents/rules/` | Skill workflows through shared `.agents/skills/` layer | Agent Manager task flow when available; otherwise role executed in-thread | Rule/workflow validation plus repo scripts and manual evidence reporting | Uses `.agent/rules/game-studio.md` as compatibility pointer only; depends on workspace integration | `AGENTS.md`, `GEMINI.md`, `.agents/rules/`, `.agent/rules/game-studio.md`, `.agents/` | Native adapter |
| Claude Code | `CLAUDE.md` + `AGENTS.md` | Supports slash-command workflows and shared skill docs | Native `Task` delegation and optional team workflows | Native Claude hooks (`.claude/settings.json`) plus shared validators | `.claude/` is compatibility layer; shared policy/workflow changes must originate in `.agents/` | `CLAUDE.md`, `.claude/`, `AGENTS.md`, `.agents/` | Native + compatibility layer |

Support status legend:
- `Native`: First-class support without adapter layers in this repository.
- `Native adapter`: Provider is supported via native tool features plus repo-specific instruction adapters.
- `Native + compatibility layer`: Native support with a compatibility layer maintained for cross-provider alignment.

## Notes

- This matrix documents support posture for this repository only.
- It does not imply feature parity across external products.
- It does not imply runtime/build/editor validation unless that validation was
  explicitly run and recorded.
