# Path-Specific Rules

Rules in `.agents/rules/` define expected behavior for matching paths. Automatic
enforcement depends on the active tool. Claude Code wires its legacy copies
through `.claude/settings.json`; other tools should read or configure these
rules explicitly.

| Rule File | Path Pattern | Enforces |
| ---- | ---- | ---- |
| `gameplay-code.md` | `src/gameplay/**` | Data-driven values, delta time, no UI references |
| `engine-code.md` | `src/core/**` | Zero allocs in hot paths, thread safety, API stability |
| `ai-code.md` | `src/ai/**` | Performance budgets, debuggability, data-driven params |
| `network-code.md` | `src/networking/**` | Server-authoritative, versioned messages, security |
| `ui-code.md` | `src/ui/**` | No game state ownership, localization-ready, accessibility |
| `design-docs.md` | `design/gdd/**` | Required 8 sections, formula format, edge cases |
| `narrative.md` | `design/narrative/**` | Lore consistency, character voice, canon levels |
| `data-files.md` | `assets/data/**` | JSON validity, naming conventions, schema rules |
| `test-standards.md` | `tests/**` | Test naming, coverage requirements, fixture patterns |
| `prototype-code.md` | `prototypes/**` | Relaxed standards, README required, hypothesis documented |
| `shader-code.md` | `assets/shaders/**` | Naming conventions, performance targets, cross-platform rules |
| `yjackcore-unity.md` | `src/**`, `Packages/YJackCore/**`, `Packages/com.ygamedev.yjack/**` | YJackCore workspace manifest detection, authority routing (YJackCore > yjackcore-support > unity-specialist), layer boundaries, inspector-first authoring, package integrity, manual validation expectations |
