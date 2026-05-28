# Spec: Story Telling

**Load when**: deliverable is a multi-section authored document where later sections cite earlier ones — research narrative, design doc, RFC, technical proposal.

A "story" is a single markdown file (default `.agents/story.md`) divided into numbered sections. Each section has a single owner agent. Later sections read earlier ones; earlier sections never read later ones. Cross-section integrity is the orchestrator's responsibility.

## Core Idea

The story file **is** the work product. Agents don't write reports about their work — they write the section that *is* their work. Coordination happens through file structure (which section, what it must reference), not through messages between agents.

## Section Contract

Define the section list up front in this spec or in the project's CLAUDE.md. Each entry fixes:
- Section number and title
- Owning agent type
- Which prior sections it must read (dependency)
- What sub-headings or rubric the section must contain

Example for a research narrative (the cc_academic case):

| § | Title | Owner | Reads | Must Contain |
|---|-------|-------|-------|--------------|
| 1 | Motivation | orchestrator | — | problem origin, stakes |
| 2 | Background | research-background | §1 | 2.1 problem framing, 2.2 weaknesses of current art |
| 3 | Related Works | research-related-works | §1-2 | 3.1 closest methods, 3.2 baselines, 3.3 datasets, 3.4 resource norms |
| 4 | Reference Projects | research-ref-curator | §3 | curated repo table |
| 5 | Proposed Method | research-proposal | §1-4 | 5.1-5.4 problem/insight/approach/contribution |
| 6 | Evaluation Plan | research-proposal | §1-5 | 6.1-6.3 metrics/experiments/ablations |
| 7 | Feasibility Assessment | research-evaluator | §1-6 | 7.1-7.4 dimensions + verdict |

Different documents will have different tables. The shape — owner + dependency + rubric — is universal.

## Sequential Expansion

Spawn agents in dependency order. Use the spawn templates:

- Section author: `~/prompt/specs/story-telling/prompts/section-author.md`
- Section evaluator (for propose/evaluate pairs): `~/prompt/specs/story-telling/prompts/section-evaluator.md`

Fill in `<...>` placeholders (section number, dependencies, rubric) before sending. The rubric for each section comes from the project's CLAUDE.md section table.

After each agent returns, the orchestrator does **not** rewrite the section — it verifies the section exists, conforms to its rubric, and advances the corresponding TaskList entry.

## Propose-Evaluate Convergence

Some section pairs are propose / evaluate (e.g. §5-6 proposed by author, §7 evaluator's verdict). The convergence rule:

1. Author writes proposal section(s)
2. Evaluator reads §1..proposal, writes verdict section
3. If verdict is FAIL: author re-runs, reads evaluator flags, revises in place
4. Cap at **5 rounds** (configurable per project)
5. If still FAIL at cap: stop, surface unresolved flags to user, do not advance

The evaluator's flags use a fixed marker (`[FLAG]`) so the author can find and address each one. The author either fixes the issue or provides a justification — never silently drops a flag.

## Revision Protocol

After the story converges and downstream work begins, downstream may discover the story is wrong. Revisions follow this flow:

1. Downstream writes `.agents/revision-proposal.md` describing what's wrong and which section is implicated
2. Orchestrator decides scope: which section(s) need revision, what cascades
3. Orchestrator re-spawns the section's owner with the section-author template, adding to the prompt: `You are revising. First read .agents/revision-proposal.md, then revise §N preserving all other sections.`
4. If a revised section is upstream of others, cascade: spawn each downstream owner in order, with the same revision prompt
5. If §propose or §eval were revised, re-run a single eval round (not the full convergence loop)
6. Update `.agents/status.md` with the revision note

Define the cascade table per project:

| Revised § | Cascades To |
|-----------|-------------|
| §2 | §5-6 → §7 |
| §3 | §5-6 → §7 |
| §5-6 | §7 |
| §4 | (no cascade) |

## Communication Files

```
.agents/
├── story.md               # the deliverable
└── revision-proposal.md   # downstream → orchestrator: request to revise §N
```

## NEVER

- Have one agent write into another agent's section
- Skip a section's dependencies (later before earlier)
- Let the convergence loop run uncapped
- Apply a revision to §N without spawning §N's owner
- Cascade only partially (if §3 changes, §5-6 and §7 must both re-run)

## ALWAYS

- Define the section table before spawning anyone
- Pass the dependency list explicitly in each agent's prompt
- Verify the section exists and matches its rubric after each agent returns
- Advance the matching TaskList entry only after verification
