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

- Generator: `./specs/pge-orchestration/prompts/generator.md`
- Evaluator: `./specs/pge-orchestration/prompts/evaluator.md`

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
4. **Read `feedback.md` end-to-end** — including any entries written by the Generator itself (boundary-violation reports, see "Cross-Boundary Findings" below)
5. If pass and no unresolved findings: commit, advance to next sprint
6. If fail or unresolved findings and rounds < 3: Generator runs again with `feedback.md` in context
7. If fail and rounds == 3: stop, write blocker to `status.md`, ask user

## Cross-Boundary Findings

Sub-agents have hard write boundaries (Generator can only touch its sprint scope; Evaluator can only write `feedback.md`; sub-agents in other specs may have similar restrictions). When a sub-agent discovers a defect outside its boundary — e.g. the Backend agent finds the wrong default in code it isn't allowed to touch — it appends to `feedback.md` instead of silently skipping or reaching outside its scope.

This means **`feedback.md` is the inbox for both Evaluator verdicts and any out-of-scope finding any sub-agent surfaces.** The Planner is responsible for clearing it.

### Planner's obligation (ALWAYS)

After every sub-agent return — Generator, Evaluator, acceptance-tester, or any sub-agent from a composed spec — read **both `.agents/feedback.md` and any new section of `.agents/acceptance.md`** in full. The two files have different write owners but the same downstream handling: for each new entry (a `feedback.md` line or an `acceptance.md` FLAG / Issue bullet):

- **Resolve in place** if it's a small fix the Planner can make directly (single-line config, default value, typo)
- **Convert to a sprint** if it requires non-trivial code change — add to the sprint list, do not start the next planned sprint until this one is on the queue
- **Defer with explicit note** if the user has signaled it's out of scope — write the deferral reason to `status.md` so the entry doesn't silently disappear

A finding that is neither resolved, queued, nor explicitly deferred is a **blocker**. The Planner does not advance to the next sprint, nor mark the project shippable, while one is open.

After resolution, the Planner removes the entry from `feedback.md` (or strikes it through with a one-line resolution note) so the file always reflects the current open set. For `acceptance.md` FLAGs, the Planner does NOT edit `acceptance.md` (it is the acceptance-tester's file) — instead, the Planner mirrors each FLAG into `status.md` as a tracked TODO with its disposition (resolved / queued / deferred), so a fresh reader of `status.md` alone sees the true open state.

## Project Acceptance vs Sprint Evaluation

These are two different things and should not be conflated:

- **Sprint Evaluation** (this spec's Evaluator role): runs after every sprint Generator pass, checks the `sprint-contract.md` acceptance bullets in isolation, decides pass / fail-with-list. Lives entirely inside the sprint loop.
- **Project Acceptance** (this section): runs **once** after all planned sprints converge, exercises the system end-to-end against the original user goal, decides whether the project is shippable.

Project Acceptance must be run by an **independent acceptance-tester sub-agent**. The Planner does NOT run it directly — having authored the plan, written the sprint contracts, and orchestrated every Generator round, the Planner is the worst-positioned actor to spot what was missed. Anything the Planner skipped, mis-specified, or rationalized into the sprint contracts is invisible from inside the same session.

The acceptance-tester is spawned with:
- The **whole project as scope** (not one sprint)
- Acceptance criteria pulled from `plan.md` and the original user brief, NOT from any sprint contract
- Permission to run the system end-to-end (start the app, exercise representative inputs, inspect outputs, run scripts/tests/commands)
- Read access to the codebase; **the only file it may write is `.agents/acceptance.md`**

Cap: **3 rounds** (acceptance-tester → fix → re-test), same shape as sprint loop. After 3 rounds without convergence, surface to the user.

Project Acceptance is not optional. A project where every sprint passed but no independent end-to-end check ran is **not** done.

### Verdict shapes

The acceptance-tester's verdict is not just pass / fail. It is one of:

- **PASS, clean** — ship-ready as-is
- **PASS + FLAGs** — core goal met, but the tester surfaces specific polish / risk items (false-positive in a demo, sub-optimal classification, silent-fallback hazard). The project is not automatically shippable — the Planner must process each FLAG via the **Planner's obligation** rules above (resolve / queue / defer), mirror them into `status.md`, then re-decide whether to ship without another acceptance round. A FLAG that is "deferred with reason" counts as processed.
- **FAIL with list** — core goal not met; next round required (subject to the 3-round cap)

PASS + FLAGs is the most common real-world shape and the easiest to mishandle: a downstream reader who sees only the PASS line in `status.md` will assume done, while the FLAG list sits unread in `acceptance.md`. The Planner's mirroring obligation exists to prevent exactly this.

## Post-Acceptance Distribution

When the deliverable is not source code but an artifact the user runs — a single binary, an installer, a container image, a desktop app bundle, a firmware image — **packaging is its own phase that runs after Project Acceptance passes and before release**. It does not belong to any sprint Generator (sprints build the source) and is out of scope for the acceptance-tester (which exercises the running app, not the packaged artifact).

This phase is owned by the Planner-orchestrator and may be done in-session or via a dedicated packaging sub-agent if the build is non-trivial. Its rules:

- **Do not start until Project Acceptance returns PASS** (clean or PASS+FLAGs whose FLAGs are processed). Packaging a build that fails acceptance is wasted work.
- **Verify with a smoke-run, not a full acceptance re-run.** Boot the packaged artifact, hit a couple of representative inputs, confirm it doesn't crash and respects user-data paths. The acceptance-tester already proved the running app is correct; the smoke-run only proves the packaging didn't break anything.
- **Cross-platform packaging is host-bounded** — a Linux session cannot produce a Windows installer; document the target-host build steps in a sibling `PACKAGING.md` rather than blocking the phase.
- **Update `status.md`** when the artifact is produced (or when target-host build is documented and handed off).

Packaging surfacing a code-side defect (e.g. a hard-coded path that only fails when frozen) is the same shape as a Cross-Boundary Finding — write to `feedback.md`, Planner clears via the normal rules.

## Independence Principle

Any role whose job is to **judge** work — Sprint Evaluator, UI Reviewer, acceptance-tester, security reviewer, accessibility auditor — must run as a separate sub-agent that did not produce the work it judges. The Planner-orchestrator is never a judge: it plans, spawns, and integrates, but does not score its own output. Self-evaluation produces predictable blind spots — the work the Planner most needs to catch is the work the Planner was least likely to question while authoring it.

This applies recursively: an acceptance-tester from round 1 should ideally not be the same sub-agent re-spawned in round 2 if round 2 is checking work the round-1 agent itself recommended. When this matters (rare), spawn a fresh agent each round.

## Compact Hints (when context approaches limit)

Preserve in order:
1. Architecture decisions — never summarize
2. Sprint-contract criteria + each sprint's pass/fail
3. Modified files + key changes per sprint
4. Outstanding `feedback.md` entries — never drop
5. Outstanding blockers, TODOs, rollback notes
6. Tool outputs — pass/fail bit only

## NEVER

- Generator and Evaluator are the same session
- Planner authors implementation in `plan.md`
- Evaluator suggests fixes
- Skip the spawn-prompt one-sentence context
- Advance to the next sprint while `feedback.md` has unresolved entries
- Mark the project done without an independent Project Acceptance pass
- Treat a "PASS + FLAGs" verdict as shippable without processing every FLAG via resolve / queue / defer
- Run any judging role (Evaluator, Reviewer, acceptance-tester) from the Planner session — always spawn a fresh sub-agent

## ALWAYS

- After every sub-agent return, read `.agents/feedback.md` AND any new section of `.agents/acceptance.md` in full and clear / queue / defer each new entry before advancing
- When a sub-agent surfaces a finding outside its write boundary, the Planner owns the resolution — never carry it silently
- Spawn a fresh, independent acceptance-tester for Project Acceptance — log the spawn (not the choice) in `status.md`
- Mirror every acceptance FLAG into `status.md` with its disposition, so the project's true open state is visible from `status.md` alone
