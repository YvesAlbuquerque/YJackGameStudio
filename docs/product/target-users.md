# Target Users

## Conclusion

The initial target should be solo Unity developers and technical designers using
AI-assisted workflows. They can understand production plans, evaluate architecture
tradeoffs, inspect generated work, and benefit immediately from YJackCore-aware
planning without requiring full no-code game generation.

## Priority order

1. Solo Unity developer / technical designer using AI-assisted workflows.
2. Existing YJackCore user.
3. Small indie team.
4. AI-native prototyper.
5. Non-technical dream-game creator, later.

## Solo Unity developer

Profile:

- Builds games mostly alone or with lightweight contractor help.
- Uses Unity and AI coding tools but needs better production structure.
- Cares about maintainability, scope control, and not painting the project into
  an architecture corner.

Primary need:

- Convert a game idea into a scoped, realistic, YJackCore-aware vertical-slice
  plan with clear issues, risks, dependencies, and validation.

Why now:

- This user can judge whether the plan is useful and can execute or supervise
  the next steps.

## Technical designer

Profile:

- Understands systems, player experience, authoring UX, and tool workflows.
- May not want to write all gameplay code directly.
- Values inspector-first, low-code, ScriptableObject, UnityEvent, and Visual
  Scripting-friendly workflows.

Primary need:

- Map game intent into systems, authoring surfaces, content workflows, and
  validation gates.

Why now:

- YJackCore's low-code direction aligns with this persona, and
  YJackGameStudio can translate design intent into production contracts.

## Small indie team

Profile:

- Two to ten people with mixed design, engineering, art, audio, and production
  responsibilities.
- Uses AI tools but lacks formal production overhead.
- Needs clear ownership and fewer coordination failures.

Primary need:

- Decompose work into owner-approved contracts with dependencies, file
  ownership, validation evidence, and status reporting.

Why next:

- The autonomous foundation supports this, but the first wedge should prove value
  for a smaller user before packaging team workflows.

## Existing YJackCore user

Profile:

- Already builds Unity games with YJackCore or wants the YJack ecosystem path.
- Values low-code Unity authoring and framework-aware routing.
- Needs help planning a vertical slice without violating framework boundaries.

Primary need:

- A YJackCore-aware plan that maps systems to GameLayer, LevelLayer, PlayerLayer,
  ViewLayer, and Shared surfaces, while separating game-repo work from framework
  work.

Why important:

- This is the most differentiated Unity path for YJackGameStudio.

## AI-native prototyper

Profile:

- Comfortable using Codex, Claude Code, Copilot, Cursor, Windsurf, Gemini CLI,
  asset generators, and prompt-first workflows.
- Wants speed but can tolerate rough edges.
- May not yet have strong production discipline.

Primary need:

- A way to keep rapid AI output from becoming unmaintainable.

Why later:

- This persona is likely to appreciate the product but may over-index on speed
  unless the first wedge demonstrates concrete value.

## Non-technical dream-game creator, later

Profile:

- Has game ideas but limited engine, programming, or production experience.
- Expects natural-language creation and immediate visual feedback.
- Is attracted to prompt-to-game products.

Primary need:

- Guided idea shaping, scope reduction, templates, and safe creation paths.

Why not first:

- This persona needs a much more constrained UX, stronger templates, and safer
  execution surfaces. Serving this user too early would pressure
  YJackGameStudio toward prompt-to-game claims it should avoid.

## Initial target statement

YJackGameStudio is initially for solo Unity developers and technical designers
who already use AI-assisted workflows and want a maintainable, owner-directed
path from game idea to production-ready vertical-slice plan.
