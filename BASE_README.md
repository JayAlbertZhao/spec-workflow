# spec-workflow

> This `BASE_README.md` belongs to the spec-workflow base. Projects bootstrapped from it write their own `README.md` in the same directory.

A composable Claude Code prompt system organized as **orthogonal specs**. Clone it, drop your project on top, and the orchestrator auto-routes which specs apply based on your brief.

## Idea

Most multi-agent prompt setups are written as one big workflow. That breaks the moment a project's shape doesn't match — a research project that also has a frontend, a frontend project that also runs experiments, an RFC that needs a propose-evaluate loop.

This repo treats workflow concerns as **independent dimensions**:

- **`phased-workflow`** — autonomous phases punctuated by user checkpoints
- **`pge-orchestration`** — Planner / Generator / Evaluator paradigm with bounded retries and an independent acceptance-tester
- **`story-telling`** — multi-section authored documents with cross-section dependencies
- **`experiment`** — heavy ML/DL discipline: ref/ curation, env detection, large-artifact gate, reproducibility
- **`ui-design`** — screen inventory + navigation graph + per-screen contracts; planner / frontend-gen / backend / reviewer roles

A project loads any subset. The agent reads [`specs/route.md`](specs/route.md) on first run and decides for you; you can edit the choice afterward.

## Quickstart

One-liner (no local clone required):

```bash
bash <(curl -fsSL https://raw.githubusercontent.com/JayAlbertZhao/spec-workflow/main/scripts/bootstrap.sh) \
  ./my-project --brief "what this project is in one paragraph"
```

Or, if you already have the repo locally:

```bash
./scripts/bootstrap.sh ./my-project --brief "..."
```

The script:

1. Clones spec-workflow into `./my-project`
2. Discards the upstream git history and inits a fresh repo for your project
3. Appends `## Brief` / `## Specs in Use` / `## Project-Specific Overrides` to `CLAUDE.md`
4. Creates `brief/` (drop-zone for supporting materials) and `.agents/` (orchestrator scratch)
5. Launches `claude` in the new directory

On first session, the orchestrator reads your `## Brief`, lists `brief/`, applies `specs/route.md`, writes the chosen spec set into `## Specs in Use`, and proceeds. You can edit the list anytime afterward.

### Feeding the brief: text, files, anything

`## Brief` in `CLAUDE.md` is the short text description. For anything richer — a chat transcript with stakeholders, requirement docs, slide decks, spreadsheets of test data, screenshots, sample PDFs — drop them into the project's `brief/` directory. The orchestrator reads everything there alongside the text on first-run routing and keeps it available as ongoing context.

You can pre-populate `brief/` at bootstrap time:

```bash
# inline summary + supporting files
./scripts/bootstrap.sh ./my-project \
  --brief "Auto-check QA reports for inconsistencies" \
  --brief-from ./customer-call-transcript.md \
  --brief-from ./sample-reports/

# everything from a folder, no inline summary (agent extracts it)
./scripts/bootstrap.sh ./my-project --brief-from ./research-bundle/
```

`--brief-from` accepts a file or directory; directories are flattened into `brief/`. It's repeatable. Any file type is fine — the agent decides what to do with each. You can also drop new files into `brief/` after bootstrap and they will be picked up on the next session.

## Layout

```
spec-workflow/                            # this repo, also the root of your bootstrapped project
├── BASE_README.md                        # this file; base-level documentation
├── CLAUDE.md                             # base conventions + (after bootstrap) ## Project Layer with brief/specs/overrides
├── LICENSE
├── scripts/
│   └── bootstrap.sh                      # one-liner project starter
├── specs/
│   ├── route.md                          # agent-facing routing rules
│   ├── phased-workflow/CLAUDE.md
│   ├── pge-orchestration/
│   │   ├── CLAUDE.md
│   │   └── prompts/{generator,evaluator}.md
│   ├── story-telling/
│   │   ├── CLAUDE.md
│   │   └── prompts/{section-author,section-evaluator}.md
│   ├── experiment/
│   │   ├── CLAUDE.md
│   │   └── prompts/{ref-curator,env-detector}.md
│   └── ui-design/
│       ├── CLAUDE.md
│       └── prompts/{planner,frontend-gen,backend,reviewer}.md
├── brief/                                # created by bootstrap; drop chat logs / docs / xlsx / pdfs here
└── .agents/                              # created by bootstrap; orchestrator ↔ sub-agent comms
```

Each spec folder has:

- **`CLAUDE.md`** — the rules. Loaded at session start when the project declares the spec.
- **`prompts/*.md`** — sub-agent spawn templates with `<...>` placeholders. Read on demand when spawning.

## Composition Examples

| Project Type | Specs the router picks |
|--------------|------------------------|
| Academic / heavy-experiment research with a paper deliverable | `phased-workflow` + `story-telling` + `experiment` + `pge-orchestration` |
| Theoretical research narrative (no GPU) | `phased-workflow` + `story-telling` |
| Pure baseline reproduction (no paper) | `experiment` + `pge-orchestration` |
| Engineering project with phase gates | `phased-workflow` + `pge-orchestration` |
| Multi-file feature build | `pge-orchestration` |
| Frontend feature / UI demo / desktop app | `ui-design` + `pge-orchestration` |
| Design RFC | `story-telling` |
| Quick fix / question | none — base conventions are enough |

## Conventions This Repo Bakes In

- **Language split**: code, agents, commits in English; user-facing status in 中文. Override in your project's `## Project-Specific Overrides` if needed.
- **TaskList as work board**: cross-session work tracked via Claude Code's `TaskCreate`/`TaskUpdate`/`TaskList`.
- **`>>` user command protocol**: lines starting with `>>` in any `.agents/*.md` file are user-directed; agents check for them before each work cycle. Variants: `>>plan:`, `>>gen:`, `>>eval:`, `>>ui:`.
- **`.agents/` directory**: shared communication between orchestrator and sub-agents (`status.md`, `plan.md`, `sprint-contract.md`, `feedback.md`, `acceptance.md`, `story.md`, `ui.md`, `env.md`, `experiment-log.md`, etc. — depending on which specs are loaded).
- **PASS + FLAGs verdict shape**: Project Acceptance can return PASS with a polish list; the planner mirrors FLAGs into `status.md` before declaring ship-ready. See `specs/pge-orchestration/CLAUDE.md`.

## Adding a New Spec

When you have a concern that's reusable across projects and orthogonal to existing specs:

1. `specs/<name>/CLAUDE.md` — the rules
2. `specs/<name>/prompts/*.md` — spawn templates if the spec mandates sub-agents
3. Add a row to the Trigger Rules table in `specs/route.md` and to Composition Sanity-Check if there's a non-obvious combination

If a rule is project-specific, it belongs in your project's `## Project-Specific Overrides`, not in `specs/`.

## License

MIT — see [LICENSE](LICENSE).
