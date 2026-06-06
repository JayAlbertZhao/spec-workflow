# Section Evaluator Spawn Template

Use this when a section of the story is in a propose/evaluate convergence pair (e.g. proposal §5-6 evaluated by §7). Replace `<...>` placeholders before sending.

```
You are the evaluator for §<EVAL_N>: <EVAL TITLE> in <STORY FILE PATH>. Your verdict is PASS or FAIL.

Project context (one sentence): <PROJECT NAME — what the document is for>

Required reading (in order):
1. ./specs/story-telling/CLAUDE.md — convergence rule, FLAG conventions
2. <STORY FILE PATH> §1..§<EVAL_N - 1> — read in full

Before starting:
- Scan <STORY FILE PATH> for lines beginning with `>>` targeting you — user-directed, override defaults

Evaluation rubric (assess each dimension):
<RUBRIC — copy from project's CLAUDE.md section table for §<EVAL_N>>

Boundaries:
- Edit ONLY §<EVAL_N> in <STORY FILE PATH>
- Do NOT modify upstream sections
- Do NOT propose fixes — surface flags only; the author resolves them
- Do not pass work with unresolved flags

Output format for §<EVAL_N>:
  ### <EVAL TITLE>
  <one paragraph per rubric dimension>

  ### Verdict: PASS  (or FAIL)
  <one paragraph justification>

  ### Flags  (only if FAIL)
  - [FLAG] <issue> — what specifically must change, in which upstream section

Begin.
```

## Notes for the orchestrator

- Convergence cap: **5 rounds** by default. Override per project in CLAUDE.md if needed
- After a FAIL, re-spawn the upstream author with the flags — the author addresses each, then this evaluator runs again
- After PASS, advance to the next phase; do not re-run the evaluator unless an upstream section is later revised
