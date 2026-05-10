# Packaging

## Conclusion

Package YJackGameStudio as an open-source reference architecture and reusable
template ecosystem. Commercial product packaging belongs to Loomlight Studio or
another separate product surface, not this repo.

## Stage 1: GitHub template / repo distribution

Purpose:

- Make the system usable by cloning or templating the repo.
- Keep the operating model transparent and easy to inspect.
- Support provider-neutral agent workflows.
- Preserve engine neutrality.

Best fit:

- Early adopters.
- Solo developers and small studios.
- Technical designers.
- Educators.
- AI workflow researchers.

Requirements:

- Clear README positioning.
- Repo positioning, scope, and ecosystem-map docs.
- Work contract examples.
- Provider/tool adapter guidance.
- Optional YJackCore routing docs.
- Demo scripts and reference pipelines.

Risk:

- Setup friction remains high.

## Stage 2: Local bootstrap scripts

Purpose:

- Help users install or copy YJackGameStudio contracts, docs, and routing into an
  existing game repo.
- Detect project structure without assuming engine, provider, YJackCore, or
  Loomlight Studio.
- Produce a dry-run report before writing files.

Best fit:

- Brownfield projects.
- Teams adapting the template into their own workflow.
- Educators creating class project scaffolds.

Requirements:

- Safe path detection.
- Dry-run mode.
- No YJackCore package edits unless explicitly authorized.
- Output report listing files created or changed.
- Clear manual follow-up steps.

Risk:

- Incorrect detection can create bad routing assumptions.

## Stage 3: Reference pipelines

Purpose:

- Provide small, inspectable examples of the operating model in action.

Best fit:

- Users evaluating whether the repo fits their workflow.
- Contributors adding new engines, providers, or validation patterns.

Requirements:

- Engine/provider assumptions stated upfront.
- Work contracts and validation evidence included.
- Manual validation debt documented.
- Optional framework adapters isolated from generic paths.

Risk:

- Examples can accidentally look like endorsed product promises if validation is
  not documented honestly.

## Stage 4: Optional adapters

Purpose:

- Add clearly scoped compatibility layers for specific AI tools, engines, or
  frameworks.

Best fit:

- Codex, Copilot, Gemini, Antigravity, Claude Code, and future AI coding tools.
- Godot, Unity, Unreal, and custom engine users.
- Optional YJackCore Unity users.

Requirements:

- Adapter docs explain what is generic vs. tool-specific.
- Shared workflow changes happen in `.agents/` first.
- Provider-specific files remain compatibility layers, not new sources of truth.

Risk:

- Adapter drift can fragment the public operating model.

## Out of scope for this repo

The following belong to Loomlight Studio or separate product repos:

- Commercial dashboard UI.
- Hosted orchestration.
- Billing and account management.
- Proprietary scheduler services.
- Private platform analytics.
- Productized support workflows.
- Loomlight-specific implementation code.

## Packaging recommendation

Optimize this repo for trust, clarity, portability, and adaptation. When a
feature needs a commercial product shell, implement it outside YJackGameStudio
and link back only to reusable public standards when appropriate.
