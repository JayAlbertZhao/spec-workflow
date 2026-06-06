# CLAUDE.md — Base Conventions

Project-agnostic rules for any project built on spec-workflow. The spec-workflow repo itself is the project root (cloned via `scripts/bootstrap.sh`); this file is loaded at session start and applies regardless of which specs the project declares.

## Language

- Code, agent files, commits, sub-agent prompts: **English**
- User communication, status notes for the user: **中文**

## Specs as Composable Concerns

Specs in `./specs/` are **orthogonal** — a project loads any combination based on what it produces and how it works. Each spec lives in its own folder:

```
specs/
├── route.md                            # decision table: signals → which specs to load
├── phased-workflow/
│   └── CLAUDE.md                       # autonomous phases + user checkpoints
├── pge-orchestration/
│   ├── CLAUDE.md
│   └── prompts/{generator,evaluator}.md
├── story-telling/
│   ├── CLAUDE.md
│   └── prompts/{section-author,section-evaluator}.md
├── experiment/
│   ├── CLAUDE.md                       # heavy experiments: ref/, env, large artifacts, reproducibility
│   └── prompts/{ref-curator,env-detector}.md
└── ui-design/
    ├── CLAUDE.md
    └── prompts/{planner,frontend-gen,backend,reviewer}.md
```

A project's `CLAUDE.md` (appended below the base section by `scripts/bootstrap.sh`) declares the specs it uses under a `## Specs in Use` heading. Agents read those specs at session start and follow them in addition to this file. Sub-agent prompt templates are read on demand when spawning that agent.

### Auto-routing on first run

If `## Specs in Use` is empty or missing when you start a session:

1. Read `## Brief` (project description) from the project CLAUDE.md.
2. **List `./brief/` and read every file in it** (skip `brief/README.md` — that's the drop-zone instructions, not project material). This directory is a drop-zone the user fills with chat transcripts, requirement docs, slides, spreadsheets, screenshots, PDFs, etc. Treat its contents as authoritative project input alongside `## Brief`. If a file is binary or you can't read it directly, note that in your routing rationale rather than skipping silently.
3. Read `./specs/route.md` — its rules are agent-facing and tell you how to map the brief + brief/ inputs to a spec set.
4. Apply the rules and pick a spec set.
5. **Write the result back** to `## Specs in Use` in the project CLAUDE.md as a bullet list of spec paths (e.g. `- ./specs/pge-orchestration/CLAUDE.md`).
6. Write a one-sentence "why these specs" note to `.agents/status.md`, mentioning which `brief/` files influenced the decision.
7. Then proceed with the user's task.

`./brief/` remains available throughout the project, not just on first run — re-read it whenever you need to confirm a project constraint or load context for a sub-agent. The user is free to add, remove, or modify `brief/` files at any time.

The user is also free to edit `## Specs in Use` afterward — adding, removing, or replacing entries. Once non-empty, subsequent sessions skip routing and just load the declared specs.

## TaskList as Work Board

Use `TaskCreate`/`TaskUpdate`/`TaskList` as the cross-session work board.

- Run `TaskList` at session start to resume from prior state
- Mark `in_progress` before work, `completed` immediately after — don't batch
- Use `addBlockedBy` to encode the dependency graph; downstream tasks become available as upstream finishes
- A spec may prescribe a specific task graph at startup — the spec wins on shape; this file only mandates that the board exists

## User Command Protocol

Lines beginning with `>>` anywhere in any file are **user-directed instructions**.

| Format | Target |
|--------|--------|
| `>> ...` | Default agent (usually orchestrator) |
| `>>planner: ...` / `>>plan: ...` | Planner |
| `>>gen: ...` / `>>generator: ...` | Generator |
| `>>eval: ...` / `>>evaluator: ...` | Evaluator |
| `>>ui: ...` | UI-design agent (when ui-design spec is loaded) |

Agents check for their `>>` lines before starting each work cycle. Agents must not write `>>` themselves — that prefix is reserved for the user.

## Communication Files

Project state lives under `.agents/` in each project root. Specs prescribe specific files; the always-true subset:

```
.agents/
├── status.md     # Orchestrator ↔ user (中文); progress, blockers, decisions
└── preference.md # User-local env/tooling prefs; gitignored
```

## NEVER

- Push to remote without explicit user request
- Skip a checkpoint a spec mandates
- Let one agent both produce and evaluate the same artifact
- Fabricate file paths, function names, or APIs — verify by reading

## ALWAYS

- Resume from `TaskList` at session start
- Read every spec the project's CLAUDE.md declares before acting
- Inject one-sentence task context when spawning sub-agents (the spec is in the file; the situation is in the prompt)
- Update `.agents/status.md` after meaningful state changes
