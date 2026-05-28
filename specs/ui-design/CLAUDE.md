# Spec: UI Design

**Load when**: deliverable includes user-facing screens or pages where navigation between them, per-screen responsibility, and state transitions matter.

This spec covers **how to design and document the UI surface** before (or alongside) implementation. It composes with `pge-orchestration` (the build) and any deliverable spec (`story-telling` for research with a frontend component).

## Core Artifact: `.agents/ui.md`

A single markdown file that fully describes the UI surface. Implementation reads from it; revisions write back to it. It is the source of truth for screen identity, navigation, and per-screen responsibility.

### Required sections

```
1. Inventory       — list of every screen/page with id, name, purpose
2. Navigation      — directed graph: edges = how the user moves between screens
3. Per-Screen      — one subsection per screen (rubric below)
4. State           — global state pieces and which screens read/write each
5. Open Questions  — flagged ambiguities the user must resolve
```

### Per-Screen Subsection Rubric

For each screen:

- **Purpose** — one sentence; what the user accomplishes here
- **Entry points** — which screens / events lead here
- **Exits** — where the user can go from here (and the trigger for each)
- **Local state** — what this screen owns
- **Reads** — global state pieces it consumes
- **Writes** — global state pieces it mutates
- **Components** — the major UI building blocks (not pixel detail; structural)
- **Empty / loading / error** — what's shown in each non-happy state
- **Acceptance** — checkable conditions that say "this screen is done"

The acceptance bullets feed directly into a sprint contract (when composing with pge-orchestration).

## Navigation Graph Convention

Use a simple text adjacency in `ui.md`, not images:

```
home → search           (header search box submit)
home → profile          (avatar click)
search → result-detail  (row click)
result-detail → search  (back button)
result-detail → editor  (edit button, requires auth)
* → login               (any screen, when auth expires)
```

`*` denotes "any screen". Make conditional edges (auth, permissions, feature flags) explicit on the edge.

## State Section Convention

For each global state piece:

- **Name**
- **Shape** — minimal type sketch
- **Owned by** — which screen / store / context creates and updates it
- **Read by** — which screens consume it
- **Persistence** — memory / session / localStorage / server

This makes state ownership unambiguous and surfaces accidental cross-screen coupling.

## Authoring Flow

1. Orchestrator drafts §1 Inventory and §2 Navigation from the user's brief
2. Spawn one **ui-designer** sub-agent to fill §3 Per-Screen for all screens (or one per screen if the surface is large)
3. Spawn **ui-reviewer** sub-agent: reads `ui.md`, looks for orphan screens (no entry), dead ends (no exit, not terminal), state owned-by-no-one, missing empty/error states. Writes findings to §5 Open Questions
4. If §5 has open questions: present at next checkpoint OR resolve via PGE if composed with that spec
5. Implementation reads `ui.md` and treats per-screen acceptance bullets as sprint contract input

## Spawn Templates

- ui-designer (fills §3 Per-Screen): `~/prompt/specs/ui-design/prompts/designer.md`
- ui-reviewer (audits structural integrity into §5): `~/prompt/specs/ui-design/prompts/reviewer.md`

Fill in `<...>` placeholders before sending. Templates are the single source of truth for spawn protocol.

## Composing With Other Specs

- **With `pge-orchestration`**: each screen's acceptance bullets become a sprint contract. The Generator implements; the Evaluator runs the app and checks each bullet (see the `verify` skill or equivalent).
- **With `story-telling`**: a research project that ships a demo UI gets `ui.md` as a sibling deliverable to `story.md`. Add UI authorship as a section in the story or treat it as an independent track.
- **With `research-workflow`**: UI design is a phase, with its own checkpoint after `ui.md` is drafted but before implementation begins.

## Communication Files

```
.agents/
├── ui.md              # the UI source of truth
└── ui-feedback.md     # ui-reviewer → ui-designer (when revising)
```

## NEVER

- Implement screens not in `ui.md`
- Add navigation edges in code that aren't in §2
- Let a single agent both author and review the same screen
- Hide design decisions in code comments — they belong in `ui.md`

## ALWAYS

- Update `ui.md` first when the design changes; code follows
- Specify empty/loading/error for every screen, not just the happy path
- Make conditional navigation edges (auth, flags) explicit on the edge
- Verify in a real browser before claiming a UI sprint passes (when implementing)
