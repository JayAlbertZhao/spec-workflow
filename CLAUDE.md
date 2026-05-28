# CLAUDE.md — Base Conventions

Project-agnostic rules that apply across every workspace under `~/prompt/`. Specific projects compose by declaring which `specs/*.md` apply.

## Language

- Code, agent files, commits, sub-agent prompts: **English**
- User communication, status notes for the user: **中文**

## Specs as Composable Concerns

Specs in `~/prompt/specs/` are **orthogonal** — a project loads any combination based on what it produces and how it works. Each spec lives in its own folder:

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
    └── prompts/{designer,reviewer}.md
```

To choose specs for a new project, read `~/prompt/specs/route.md`. It contains the trigger table and composition examples — that's the single source of truth, not this file.

A project's `CLAUDE.md` declares the specs it uses; agents read those specs at session start and follow them in addition to this file. Sub-agent prompt templates are read on demand when spawning that agent.

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
