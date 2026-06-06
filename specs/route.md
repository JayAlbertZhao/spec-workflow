# Spec Router

**Audience: the orchestrator agent.** This file is your routing rulebook when the project CLAUDE.md has an empty `## Specs in Use` section. You read it, apply the rules below to the project's `## Brief`, and write the chosen spec set back into the project CLAUDE.md.

Do not ask the user to pick specs — they wrote the brief; routing is your job. If the brief is too thin to route confidently, ask one targeted clarifying question rather than guessing.

## Trigger Rules

For each rule below, decide independently whether the brief satisfies it. Specs are **orthogonal** — combine any subset.

| If the brief implies… | Add spec |
|---|---|
| Work advances through autonomous phases punctuated by user checkpoints (RFC → design → build, or research-phase → implementation-phase) | `./specs/phased-workflow/CLAUDE.md` |
| Heavy compute — GPU/TPU runs, large model checkpoints, datasets, training that needs reproducibility; or an external `ref/` library of cloned repos | `./specs/experiment/CLAUDE.md` |
| Deliverable is a multi-section authored document where later sections cite earlier ones (research narrative, design doc, RFC, technical proposal) | `./specs/story-telling/CLAUDE.md` |
| Implementation needs a separate generator + independent evaluator with bounded retries; or you'll need a Project Acceptance pass | `./specs/pge-orchestration/CLAUDE.md` |
| Deliverable includes user-facing screens or pages with navigation/state transitions (web UI, desktop app, even a CLI with multi-screen TUI counts) | `./specs/ui-design/CLAUDE.md` |

If no rule fires: write `<none — defaults sufficient>` into `## Specs in Use`. Most quick fixes, single-file changes, or questions land here.

## Composition Sanity-Check

After picking, verify against these common shapes. If your set doesn't match any, re-read the brief — you may have under- or over-routed.

| Brief shape | Specs |
|---|---|
| Academic / heavy-experiment research with a paper deliverable | `phased-workflow` + `story-telling` + `experiment` + `pge-orchestration` |
| Theoretical / lightweight research narrative (no GPU) | `phased-workflow` + `story-telling` |
| Pure baseline reproduction or model evaluation (no paper) | `experiment` + `pge-orchestration` |
| Engineering project with phase gates (RFC → design → build) | `phased-workflow` + `pge-orchestration` |
| Research with frontend demo | `phased-workflow` + `story-telling` + `experiment` + `ui-design` (+ `pge-orchestration`) |
| Multi-file feature build with separate verification | `pge-orchestration` |
| Frontend feature / UI demo / desktop app | `ui-design` + `pge-orchestration` |
| Design RFC | `story-telling` |
| Quick fix / single-file change / question | none |

## Write-Back Format

Once decided, write into the project CLAUDE.md, replacing the entire `## Specs in Use` section:

```
## Specs in Use

- ./specs/<chosen-1>/CLAUDE.md
- ./specs/<chosen-2>/CLAUDE.md
...

(Routed automatically from `## Brief` via specs/route.md. Edit this list freely — add, remove, reorder; the orchestrator follows whatever you leave here.)
```

Also write one sentence to `.agents/status.md`:

```
- <date> 路由：基于 brief 选用 <list>，理由 <one-line>。
```

## Adding a New Rule

If the brief implies a concern none of these rules covers, and that concern is reusable across projects (not project-specific):

1. Create `specs/<new-name>/CLAUDE.md` (+ `prompts/` if it mandates sub-agents)
2. Add a row to the Trigger Rules table
3. Add a row to Composition Sanity-Check if there's a non-obvious combination

Project-specific rules belong in the project CLAUDE.md's `## Project-Specific Overrides`, never here.
