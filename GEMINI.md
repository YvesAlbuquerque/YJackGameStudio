# Gemini And Antigravity Adapter

Read `AGENTS.md` first. It is the shared project instruction file.

Gemini CLI project settings in `.gemini/settings.json` configure both
`AGENTS.md` and `GEMINI.md` as context files. If your Gemini client has not
loaded `AGENTS.md`, explicitly read it before making changes.

For Google Antigravity, treat this file as the Gemini-family adapter and use
`.agents/rules/` as workspace rule supplements. `.agent/rules/game-studio.md`
is only a compatibility pointer for clients that inspect the older singular
rules path. Root `AGENTS.md` remains the source of truth; this file only adds
tool-specific loading guidance.

## Memory Checks

- Gemini CLI: use `/memory show` to verify loaded context when behavior looks off.
- Gemini CLI: use `/memory refresh` after editing `AGENTS.md`, `GEMINI.md`, or files under `.agents/`.
- Antigravity: verify workspace rules are visible in the IDE customizations/rules surface if available.

## Execution

Follow the validation rules in `AGENTS.md`. Do not use YOLO/auto-approve modes
for destructive shell commands, dependency upgrades, migrations, or git publish actions.
