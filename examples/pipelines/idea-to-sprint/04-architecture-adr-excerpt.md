# 04 Architecture / ADR Excerpt

## ADR-EX-001: Use Data-Driven Order Definitions

### Status
Proposed (pending owner approval)

### Decision
Represent orders, station recipes, and spirit traits as external data assets rather than hardcoded logic.

### Why
- Faster balancing without code edits.
- Cleaner separation between design iteration and implementation.
- Better testability for simulation rules.

### Tradeoffs
- Requires up-front schema discipline.
- Requires validation scripts for malformed data.
