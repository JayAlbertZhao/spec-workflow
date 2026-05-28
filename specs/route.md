# Spec Router

This file decides which specs in `~/prompt/specs/` apply to a given project. It is read by the root `CLAUDE.md`. Specs are **orthogonal** — combine any subset.

## Trigger Table

| Signal in the project | Load spec |
|-----------------------|-----------|
| Project advances through autonomous phases punctuated by user checkpoints | `phased-workflow/` |
| Heavy experiments — GPU/TPU compute, large model checkpoints, datasets, training runs needing reproducibility; maintains an external `ref/` library | `experiment/` |
| Deliverable is a multi-section authored document where later sections cite earlier ones (research narrative, design doc, RFC, technical proposal) | `story-telling/` |
| Implementation needs a separate generator + independent evaluator with bounded retries | `pge-orchestration/` |
| Deliverable includes user-facing screens or pages with navigation/state transitions | `ui-design/` |

If none apply: load nothing — default behavior is sufficient for simple tasks.

## How a Project Loads Specs

A project's own `CLAUDE.md` declares which specs apply, e.g.:

```
## Specs in Use
- ~/prompt/specs/phased-workflow/CLAUDE.md
- ~/prompt/specs/story-telling/CLAUDE.md
- ~/prompt/specs/experiment/CLAUDE.md
- ~/prompt/specs/pge-orchestration/CLAUDE.md
```

Each spec folder contains:
- `CLAUDE.md` — the spec's rules
- `prompts/*.md` — sub-agent prompt templates the spec mandates (when applicable)

The orchestrator reads every declared `CLAUDE.md` at session start. Sub-agent prompts are read on demand when spawning that agent.

## Composition Examples

| Project Type | Specs |
|--------------|-------|
| Academic / heavy-experiment research with a paper deliverable | `phased-workflow` + `story-telling` + `experiment` + `pge-orchestration` |
| Theoretical / lightweight research narrative (no GPU work) | `phased-workflow` + `story-telling` |
| Pure baseline reproduction or model evaluation (no paper) | `experiment` + `pge-orchestration` |
| Engineering project with phase gates (RFC → design → build) | `phased-workflow` + `pge-orchestration` |
| Research with frontend demo | `phased-workflow` + `story-telling` + `experiment` + `ui-design` (+ `pge-orchestration`) |
| Multi-file feature build | `pge-orchestration` |
| Frontend feature build | `pge-orchestration` + `ui-design` |
| Design RFC | `story-telling` |
| Quick fix / single-file change / question | none |

## Adding a New Spec

When a new orthogonal concern emerges:

1. Create `specs/<name>/` with `CLAUDE.md` and `prompts/` if needed
2. Add a row to the Trigger Table above
3. Add a row to Composition Examples if there's a non-obvious combination

A spec belongs here only if it is reusable across projects. Project-specific rules live in the project's own `CLAUDE.md`.
