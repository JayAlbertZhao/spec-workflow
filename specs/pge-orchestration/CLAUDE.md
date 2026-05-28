# Spec: PGE Orchestration

**Load when**: implementation needs a separate generator + an independent evaluator, with bounded retries.

A paradigm, not a mode. Composes with any deliverable spec (story-telling, ui-design, etc.). The thing being built is defined by the deliverable spec; PGE only governs **how** the build cycle runs.

## Roles

### Planner (the orchestrator session — you)

- Clarify user goal; write the high-level plan to `.agents/plan.md` (product context, scope, intent — no implementation steps)
- Break the plan into ordered **sprints** with testable acceptance criteria
- For each sprint: write `.agents/sprint-contract.md`, spawn Generator, spawn Evaluator, decide whether to advance
- Cap each sprint at **3 generator-evaluator rounds**; if still failing, stop and ask the user
- Update `.agents/status.md` after each sprint, evaluation, or blocker

### Generator (sub-agent)

**Capabilities**: read/write code, run scripts/tests/commands, commit when a sprint passes.

**Boundaries**:
- Implements only what `sprint-contract.md` requires
- Cannot evaluate its own work
- Cannot edit `plan.md` or `sprint-contract.md`
- Reads `.agents/feedback.md` if present and addresses listed issues

### Evaluator (sub-agent)

**Capabilities**: read everything, run scripts/tests/commands, write `.agents/feedback.md`.

**Boundaries**:
- Read-only except `feedback.md`
- Reports problems, never proposes fixes
- Cannot pass work that fails any acceptance criterion
- Decision is binary: pass / fail-with-list

## Spawn Templates

- Generator: `~/prompt/specs/pge-orchestration/prompts/generator.md`
- Evaluator: `~/prompt/specs/pge-orchestration/prompts/evaluator.md`

The Planner reads the template, fills in `<...>` placeholders (project context, sprint goal), and sends the result as the sub-agent prompt. Templates are the single source of truth for spawn protocol — when the protocol changes, edit the template.

## Communication Files

```
.agents/
├── plan.md              # Planner → product spec (no impl detail)
├── sprint-contract.md   # Planner → current sprint's acceptance criteria
├── progress.md          # Generator → append-only build log
└── feedback.md          # Evaluator → review verdict + issue list
```

## Sprint Loop

1. Planner writes/updates `sprint-contract.md`
2. Spawn Generator → implementation + `progress.md` entry
3. Spawn Evaluator → `feedback.md`
4. If pass: commit, advance to next sprint
5. If fail and rounds < 3: Generator runs again with `feedback.md` in context
6. If fail and rounds == 3: stop, write blocker to `status.md`, ask user

## Compact Hints (when context approaches limit)

Preserve in order:
1. Architecture decisions — never summarize
2. Sprint-contract criteria + each sprint's pass/fail
3. Modified files + key changes per sprint
4. Outstanding blockers, TODOs, rollback notes
5. Tool outputs — pass/fail bit only

## NEVER

- Generator and Evaluator are the same session
- Planner authors implementation in `plan.md`
- Evaluator suggests fixes
- Skip the spawn-prompt one-sentence context
