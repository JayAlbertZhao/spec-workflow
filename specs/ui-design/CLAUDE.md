# Spec: UI Design

**Load when**: deliverable includes user-facing screens or pages, especially when frontend and backend are separate concerns connected by an API contract.

This spec covers **the full GUI track**: page planning, frontend implementation, backend implementation, and the API contract that connects them. It composes with `pge-orchestration` (each role's work runs as one or more sprints) and any deliverable spec.

## Core Artifact: `.agents/ui.md`

A single markdown file that fully describes the UI surface and the frontend ↔ backend interface. Frontend-gen and backend both read it as the **single source of truth** for what to build and how the two halves talk to each other.

### Required Sections

```
1. Inventory       — every screen / page (id, name, purpose)
2. Navigation      — directed graph of how the user moves between screens
3. Per-Screen      — for each screen: components, local state, empty/loading/error, acceptance
4. State           — global state pieces and which screens read/write each
5. API Contract    — every endpoint: method, path, request shape, response shape, error codes
6. Open Questions  — reviewer findings (only filled if reviewer has run)
```

### §3 Per-Screen Rubric

For every screen:

- **Purpose** — one sentence
- **Entry / Exit** — which screens lead here, where the user can go (with trigger)
- **Components** — major structural blocks (NOT pixel detail)
- **Local state** — what this screen owns
- **Reads / Writes** — which §4 global state pieces this screen consumes / mutates
- **Calls** — which §5 API endpoints this screen invokes (by id)
- **Empty / loading / error** — what's shown in each non-happy state
- **Acceptance** — checkable conditions that say "this screen is done"

### §5 API Contract Format

For every endpoint:

```
### <endpoint-id>
- Method: GET / POST / PUT / DELETE
- Path: /api/...
- Request:
  - <field>: <type> — <constraint / description>
- Response (200):
  - <field>: <type>
- Errors:
  - 400 <when>
  - 404 <when>
  - 500 <when>
- Called by: <screen ids from §1>
- Implemented by: backend
```

The contract is the **only** place endpoint shapes are defined. Frontend code must not invent fields; backend code must not return fields not declared here. If the shape changes, planner edits §5 first, then frontend-gen and backend re-run.

## Roles

| Role | Reads | Writes |
|------|-------|--------|
| **planner** | user brief + project CLAUDE.md | `ui.md` §1-5 |
| **frontend-gen** | `ui.md` (esp. §3 + §5) | frontend source files; never edits ui.md |
| **backend** | `ui.md` (esp. §5) | backend source files; never edits ui.md |
| **reviewer** (optional but recommended) | `ui.md` §1-5 in full | `ui.md` §6 only |

### Spawn Templates

- planner: `./specs/ui-design/prompts/planner.md`
- frontend-gen: `./specs/ui-design/prompts/frontend-gen.md`
- backend: `./specs/ui-design/prompts/backend.md`
- reviewer: `./specs/ui-design/prompts/reviewer.md`

Fill `<...>` placeholders before sending. Templates are the single source of truth for spawn protocol.

## Authoring Flow

1. Orchestrator drafts user brief; spawns **planner** → `ui.md` §1-5 produced in one shot
2. Spawn **reviewer** → audits §1-5, writes §6 Open Questions if any defects (orphan screens, broken contract, vague acceptance, page ↔ endpoint mismatch)
3. If §6 has findings: planner revises affected sections, re-run reviewer (cap **3 rounds**)
4. Once §6 is empty (or reviewer is skipped): spawn **frontend-gen** and **backend** in parallel — they share §5 as contract, work independently otherwise
5. Each acceptance bullet in §3 + each endpoint in §5 becomes a sprint contract entry when composing with `pge-orchestration`

## Fixtures vs Configuration Alignment

Demo fixtures (sample inputs, seed data, example documents) and runtime configuration (rule files, threshold YAMLs, keyword dictionaries) are produced by different roles but must stay consistent — a keyword the config expects to find must actually appear in the fixture, or every demo run shows a false-positive.

Rule:

- **Whoever produces the artifact owns its alignment with everything else.** If backend authored `rules/required_fields.yaml` and the dictionary doesn't match the fixture's actual wording, backend is responsible for adjusting (extending keywords, or surfacing the gap to the Planner).
- **When two producers conflict** — e.g. the fixture author and the config author disagree on what the canonical field name is — **the Planner decides**, and the decision is recorded in `ui.md` (a short note under §3 acceptance or §4 state, whichever the disagreement touches).
- **Detected by Project Acceptance.** The acceptance-tester is the natural place this surfaces; when it does, it flags via the verdict, the Planner mirrors per `pge-orchestration` rules. Do not push this to acceptance by default — the producing role should self-check before declaring its sprint done.

This applies equally when `ui-design` runs standalone or composed with `pge-orchestration`.

## Cross-Boundary Findings

frontend-gen and backend have hard write boundaries — they never edit `ui.md`, and neither agent can edit the other's source files. When either agent discovers something it cannot fix from inside its boundary (a §5 gap, a contract field type that doesn't match what the screen actually needs, a default value in code that's clearly wrong but lives in someone else's territory), it appends a finding to `.agents/feedback.md` and proceeds with the most reasonable workaround inside its own scope.

`feedback.md` here serves the same purpose as in `pge-orchestration`: an inbox that the orchestrator must clear. After every sub-agent return (planner, reviewer, frontend-gen, backend), the orchestrator reads `feedback.md` end-to-end. For each new entry:

- **Resolve in place** if it's a small fix (config value, default, comment, single-line correction)
- **Convert to a sprint or revision** if it requires non-trivial work — for §5 gaps, that means re-spawning the planner; for code-side gaps, the next PGE round
- **Defer with explicit note in `status.md`** if out of scope

The orchestrator does not advance to the next stage of the authoring flow while `feedback.md` has unresolved entries. After resolution, strike or remove the entry so the file reflects only the open set.

When `pge-orchestration` is also loaded, its identical rule applies; this section exists so the same discipline holds when `ui-design` is used standalone.

## Project Acceptance

ui.md §6 reviewer convergence and sprint-level evaluation cover **structural** integrity (contract closure, acceptance phrasing) and **per-sprint** correctness. Neither covers the question "does the running app actually do what the user asked for?"

That question is answered by **Project Acceptance**, which runs once after all UI implementation work converges. It is run by an **independent acceptance-tester sub-agent** — never the orchestrator-Planner directly. The Planner authored ui.md, spawned every implementation agent, and integrated their work; it is the worst-positioned actor to spot what the user requested but didn't get. Spawn a fresh agent that didn't participate in any sprint to launch the app, exercise §3 acceptance bullets in a real browser, verify §5 endpoints respond as declared, and check the deliverable against the original brief. Verdict to `.agents/acceptance.md`.

When composing with `pge-orchestration`, that spec's "Project Acceptance vs Sprint Evaluation" section is authoritative — this section just makes the rule explicit when `ui-design` is used standalone. Either way: independent agent, not the Planner.

## Composing With Other Specs

- **With `pge-orchestration`**: each role (planner / frontend-gen / backend) runs inside a Generator sprint. The PGE Evaluator runs the actual app and checks each §3 acceptance bullet + each §5 endpoint contract end-to-end. PGE's `feedback.md` discipline and Project Acceptance section govern.
- **With `phased-workflow`**: ui.md authoring (planner + reviewer) is its own phase, with a checkpoint before implementation begins. User confirms `ui.md` reads right before frontend-gen and backend get spawned.
- **With `story-telling`**: a research project shipping a demo UI gets `ui.md` as a sibling deliverable to `story.md`. The story may reference §5 endpoints when describing system architecture.

## NEVER

- Implement screens not in §1, navigation edges not in §2, endpoints not in §5
- Let frontend-gen and backend invent fields not declared in §5
- Have one agent both produce and review the same artifact
- Hide design decisions in code comments — they belong in `ui.md`
- Skip §5 because "it's just a small demo" — even a one-endpoint app benefits from a written contract
- Advance the authoring flow while `.agents/feedback.md` has unresolved entries
- Mark UI work done without a Project Acceptance pass

## ALWAYS

- Update `ui.md` first when design changes; code follows
- Specify empty / loading / error for every screen, not just the happy path
- Mark conditional navigation (auth, flags, permissions) explicit on the §2 edge
- Verify in a real browser / running app before claiming a sprint passes (when implementing)
- Keep §5 minimal — fewer endpoints with clean shapes beat many endpoints with overlapping responsibilities
