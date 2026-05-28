# prompt_workflow

A composable Claude Code prompt system organized as **orthogonal specs**. Drop it next to your projects and each project loads only the specs it needs — no monolithic CLAUDE.md, no copy-paste between projects.

## Idea

Most multi-agent prompt setups are written as one big workflow. That breaks the moment a project's shape doesn't match — a research project that also has a frontend, a frontend project that also runs experiments, an RFC that needs a propose-evaluate loop.

This repo treats workflow concerns as **independent dimensions**:

- **`phased-workflow`** — autonomous phases punctuated by user checkpoints
- **`pge-orchestration`** — Planner / Generator / Evaluator paradigm with bounded retries
- **`story-telling`** — multi-section authored documents with cross-section dependencies
- **`experiment`** — heavy ML/DL discipline: ref/ curation, env detection, large-artifact gate, reproducibility
- **`ui-design`** — screen inventory + navigation graph + per-screen contracts

A project loads any subset. Read [`specs/route.md`](specs/route.md) for the trigger table and composition examples.

## Layout

```
~/prompt/                              # this repo
├── CLAUDE.md                          # base conventions, loaded by every session here
├── specs/
│   ├── route.md                       # which specs to load when
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
│       └── prompts/{designer,reviewer}.md
└── <your-project>/                    # gitignored; lives alongside this repo
    └── CLAUDE.md                      # declares which specs apply, plus project overrides
```

Each spec folder has:

- **`CLAUDE.md`** — the rules. Loaded at session start when the project declares the spec.
- **`prompts/*.md`** — sub-agent spawn templates with `<...>` placeholders. Read on demand when spawning.

## Usage

1. Clone this repo as `~/prompt/` (or anywhere; the paths in CLAUDE.md files use `~/prompt/` so adjust if you put it elsewhere)
2. Put your project in a subdirectory: `~/prompt/your-project/`
3. In `your-project/CLAUDE.md`, declare which specs you need:

   ```markdown
   ## Specs in Use
   - ~/prompt/specs/phased-workflow/CLAUDE.md
   - ~/prompt/specs/story-telling/CLAUDE.md
   - ~/prompt/specs/pge-orchestration/CLAUDE.md
   ```

4. Add project-specific overrides below (phase list, section table, sprint conventions, etc.)
5. Open Claude Code in that project directory — Claude walks the cwd up and loads both `your-project/CLAUDE.md` and `~/prompt/CLAUDE.md`

## Composition Examples

| Project Type | Specs |
|--------------|-------|
| Academic / heavy-experiment research with a paper deliverable | `phased-workflow` + `story-telling` + `experiment` + `pge-orchestration` |
| Theoretical research narrative (no GPU) | `phased-workflow` + `story-telling` |
| Pure baseline reproduction (no paper) | `experiment` + `pge-orchestration` |
| Engineering project with phase gates | `phased-workflow` + `pge-orchestration` |
| Multi-file feature build | `pge-orchestration` |
| Frontend feature build | `pge-orchestration` + `ui-design` |
| Design RFC | `story-telling` |
| Quick fix / question | none — defaults are enough |

## Conventions This Repo Bakes In

- **Language split**: code, agents, commits in English; user-facing status in 中文. Override in your project's CLAUDE.md if needed.
- **TaskList as work board**: cross-session work tracked via Claude Code's TaskCreate/TaskUpdate/TaskList.
- **`>>` user command protocol**: lines starting with `>>` in any `.agents/*.md` file are user-directed; agents check for them before each work cycle. Variants: `>>plan:`, `>>gen:`, `>>eval:`, `>>ui:`.
- **`.agents/` directory**: shared communication files between orchestrator and sub-agents (`status.md`, `plan.md`, `sprint-contract.md`, `feedback.md`, `story.md`, `ui.md`, `env.md`, `experiment-log.md`, etc., depending on which specs are loaded).

## Adding a New Spec

When you have a concern that's reusable across projects and orthogonal to existing specs:

1. `specs/<name>/CLAUDE.md` — the rules
2. `specs/<name>/prompts/*.md` — spawn templates if the spec mandates sub-agents
3. Add a row to `specs/route.md`'s trigger table and composition examples

If a rule is project-specific, it lives in the project's own `CLAUDE.md`, not in `specs/`.

## License

MIT — see [LICENSE](LICENSE).
