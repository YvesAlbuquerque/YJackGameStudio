# Autonomy Configuration

<!-- Read by all agents at the start of every session.                        -->
<!-- Valid values for Active Mode: GUIDED | SUPERVISED | AUTONOMOUS           -->
<!-- If this file is absent, all agents default to GUIDED.                    -->
<!-- Full specification: .agents/docs/autonomy-modes.md                       -->

## Active Mode

GUIDED

## Notes

Default mode. Every decision is surfaced to the owner before execution.
Change this to SUPERVISED or AUTONOMOUS to extend agent delegation.

## Overrides

<!-- Per-skill overrides. Format:
     SKILL: <skill-name> → <mode>  (applies to every run of that skill)
     Example:
     SKILL: smoke-check → SUPERVISED
-->
