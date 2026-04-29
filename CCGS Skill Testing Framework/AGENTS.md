# Skill Testing Framework Instructions

This directory is the QA layer for the Game Studio agent/skill system. It is not
runtime game code.

Use this directory when validating skill structure, behavioral specs, test cases,
and quality rubrics.

When cross-checking a live skill, prefer the shared path:

`.agents/skills/[name]/SKILL.md`

If validating Claude Code compatibility specifically, also compare against:

`.claude/skills/[name]/SKILL.md`

Do not change generated or historical test fixtures unless the validation goal
requires it. Keep findings concrete and path-referenced.
