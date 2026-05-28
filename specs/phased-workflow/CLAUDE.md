# Spec: Phased Workflow

**Load when**: project advances through multiple autonomous phases, with the user acting as a gate between phases (research, multi-stage feature builds, RFC → design → implementation tracks).

This spec governs **process** — the gated phase machine. It says nothing about what the phases produce or how work is built; it composes with deliverable specs (`story-telling`, `ui-design`) and build specs (`pge-orchestration`, `experiment`).

## Phase Machine

A project advances through phases. Within a phase the orchestrator runs **autonomously**. Between phases the user must **explicitly confirm**.

```
Input
  ↓
Phase 1   (autonomous; deliverable spec governs what gets produced)
  ↓
CHECKPOINT 1   (user gate; not skippable)
  ↓
Phase 2   (autonomous; build spec governs how work is done)
  ↓
CHECKPOINT 2
  ↓
... further phases
```

Phase boundaries are project-specific — the project's `CLAUDE.md` lists them. The rule from this spec: **a phase boundary is a hard stop; the orchestrator presents and waits.**

## Checkpoint Protocol

At each checkpoint, present to the user:

1. The current state of the deliverable (e.g. full `story.md`, `ui.md`, sprint summary)
2. Verdict / convergence summary from the prior phase
3. Unresolved issues or flags (if any) — surface every one, do not bury
4. Resource implications of the next phase (datasets, compute, time, budget)
5. The specific decision being requested

Do not proceed until the user explicitly acknowledges. A user message that doesn't address the checkpoint does **not** count — re-present.

## Autonomous Phase Conduct

Inside a phase, do not interrupt the user except when:

- A capped convergence loop has hit its cap and still failed
- A required external resource is missing (dataset, compute, credentials)
- The work has hit a fundamental blocker that requires a scope change

For routine ambiguities, make the reasonable call and continue. Log the call in `.agents/status.md` so the user can redirect at the next checkpoint.

## Communication Files

```
.agents/
└── status.md   # orchestrator → user (中文); phase entry/exit, checkpoints, decisions made autonomously
```

## Composition Notes

- **With `story-telling`**: phases drive when each section gets authored. Phase 1 typically produces the document; later phases revise via story-telling's revision protocol.
- **With `pge-orchestration`**: each implementation phase contains one or more PGE sprint loops. Phase boundary stops happen between sprints, not within one.
- **With `experiment`**: experiment-track phases load both this spec and `experiment/CLAUDE.md`. Resource implications surfaced at the checkpoint come partly from the experiment spec's environment detect.
- **With `ui-design`**: UI design can be its own phase, with a checkpoint after `ui.md` is drafted but before implementation.

## NEVER

- Cross a phase boundary without an explicit user acknowledgment
- Hide blockers or unresolved flags inside the deliverable rather than surfacing them at the checkpoint
- Treat a user message that doesn't address the checkpoint as approval

## ALWAYS

- Update `.agents/status.md` on phase entry, phase exit, every checkpoint, every autonomously-decided ambiguity
- Re-present the checkpoint if the user replies on something else
- List phase boundaries explicitly in the project's CLAUDE.md
