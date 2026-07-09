---
name: agent-team-dev
description: 'Use when doing larger software engineering in a repository: from-scratch projects, changes to large existing projects, multi-file features, complex bug fixes, refactors, migrations, architecture changes, explicit 拆分 / split / decompose requests, test strategy, review-then-fix work, implementation plans, acceptance checks, or tasks phrased as 大项目, 复杂改造, 重构, 迁移, 架构, 多文件, 端到端验证, 做完整一点, plan then implement, or review then fix.'
---

# Agent Team Dev

Use this skill to run repository work as a small engineering team with explicit
scope, implementation, review, and acceptance boundaries.

## Trigger Threshold

Use this skill when at least one condition holds:

- The task starts a from-scratch project or app.
- The change touches a large existing project or multiple ownership boundaries.
- The work needs a plan with independently verifiable tasks.
- The change affects behavior, contracts, data, security, deployment, migration,
  architecture, or test strategy.
- The task benefits from separate planner, dev, evaluator, and acceptance roles.
- The user explicitly asks for 拆分, split, decompose, 大项目, 复杂改造, 重构,
  迁移, 架构, 多文件, 端到端验证, 做完整一点, plan then implement, or review then fix.

Do not auto-trigger for:

- Small AGENTS.md, README, prompt, skill, or documentation edits.
- Single-file mechanical patches.
- Formatting, wording, metadata, or install-instruction fixes.
- Local changes the main agent can understand, patch, and verify in one pass.

Scale-down rule: if the main agent can safely inspect, edit, and verify the
change in one local loop, use ordinary local workflow instead of team workflow.

## Operating Model

Scale the workflow to risk:

- Small single-file mechanical edit: do not use team overhead.
- Multi-step repo change: plan, implement task-by-task, verify after each task.
- High-risk or user-facing change: preserve separate planner, dev, evaluator,
  and acceptance roles.
- Planner stays in the main agent flow. The main agent owns scope, sequencing,
  integration, user communication, and final acceptance.
- Under the user's standing authorization, dev and evaluator/reviewer work may
  run in side agents when available. Treat them as non-blocking side branches:
  dispatch bounded tasks, continue useful local work, and wait only when their
  result blocks the next local step.

## Workflow

1. Inspect the repository before proposing edits: current files, tests, package
   manager, conventions, and git status.
2. State the objective, constraints, assumptions, and failure modes.
3. Create a short task plan with independently verifiable deliverables.
4. For independent dev or evaluator slices, dispatch side agents with explicit
   ownership and "do not revert others' work" instructions.
5. For behavior changes, use test-first discipline when practical: write or
   identify the failing check, implement the smallest fix, then rerun.
6. Keep diffs scoped to the requested behavior. Do not refactor unrelated code.
7. Run the strongest affordable verification: targeted tests first, broader
   tests when shared behavior or user-facing flows are touched.
8. Review the diff as a separate evaluator pass before calling work complete.

## Role Boundaries

- Planner/Main agent: scopes the work, chooses the plan, owns communication,
  sequences tasks, integrates side-agent output, and protects user constraints.
- Dev side agent: changes files only within an assigned ownership boundary.
- Evaluator side agent: checks requirements, regressions, missing tests,
  security/privacy risk, and whether the diff stays inside scope.
- Acceptance: confirms the user's requested outcome with fresh evidence.

If side agents are unavailable, keep the boundaries explicit in-session:
plan, implement, evaluate, verify.

## Artifacts

Use only artifacts that help the current task:

- Current-session plan for ordinary work.
- A saved plan or design note for large changes that need review or reuse.
- Test output, build output, screenshots, or logs as evidence.
- Durable status files only when the repository already uses them or the user
  asks for cross-session tracking.

## Review Checklist

- Does the diff implement the requested behavior and no unrelated behavior?
- Are modified paths the right ownership boundary?
- Are tests or checks strong enough for the risk?
- Are errors, rollback, and partial-failure paths covered where relevant?
- Did the final answer distinguish verified facts from unverified limits?

## Do Not

- Do not hand off the immediate blocking step when the main agent can progress
  faster locally.
- Do not claim a separate reviewer or agent ran unless it actually ran.
- Do not push, publish, or deploy without explicit user request.
- Do not fabricate APIs, file paths, or test results.
- Do not let planning become a substitute for making the requested change.
