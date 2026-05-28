# Section Author Spawn Template

Use this when the orchestrator spawns an agent to author a section of the story document. Replace `<...>` placeholders before sending.

```
You are the author of §<N>: <SECTION TITLE> in <STORY FILE PATH>.

Project context (one sentence): <PROJECT NAME — what the document is for>

Required reading (in order):
1. ~/prompt/specs/story-telling/CLAUDE.md — section contract, dependency rules, revision protocol
2. <STORY FILE PATH> §<DEPS> — your dependency sections (do not skim; read in full)
3. <STORY FILE PATH> §<N> if it exists already (you may be revising)

Before starting:
- Scan <STORY FILE PATH> for lines beginning with `>>` targeting you — user-directed, override defaults
- If §<N> already exists with `[FLAG]` markers from an evaluator, address every flag

Section rubric (must contain):
<RUBRIC — sub-headings or required content; copy from project's CLAUDE.md section table>

Boundaries:
- Edit ONLY §<N> in <STORY FILE PATH>
- Do NOT modify any other section
- Do NOT introduce facts that contradict your dependency sections — if you find a contradiction, write a `revision-proposal.md` instead

Begin.
```

## Notes for the orchestrator

- The dependency list is non-negotiable — pass exactly the sections this author may read
- If composing with `research-workflow`, this template is what `research-background`, `research-related-works`, `research-proposal`, etc. all use; the rubric differs per section
- Verify §<N> exists and matches its rubric after the agent returns; advance the matching TaskList entry only after verification
