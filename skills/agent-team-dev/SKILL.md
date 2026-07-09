---
name: agent-team-dev
description: Use when doing substantial software engineering in a repository: multi-file features, complex bug fixes, refactors, migrations, architecture changes, test strategy, review-then-fix work, implementation plans, acceptance checks, or tasks phrased as 大项目, 复杂改造, 重构, 迁移, 架构, 多文件, 端到端验证, 做完整一点, plan then implement, or review then fix.
---

# Agent Team Dev

Use this skill to run repository work as a small engineering team with explicit
scope, implementation, review, and acceptance boundaries.

## Operating Model

Scale the workflow to risk:

- Small single-file mechanical edit: do not use team overhead.
- Multi-step repo change: plan, implement task-by-task, verify after each task.
- High-risk or user-facing change: preserve separate implementer and reviewer
  roles; use subagents when available, otherwise execute role passes in-session.

## Workflow

1. Inspect the repository before proposing edits: current files, tests, package
   manager, conventions, and git status.
2. State the objective, constraints, assumptions, and failure modes.
3. Create a short task plan with independently verifiable deliverables.
4. For behavior changes, use test-first discipline when practical: write or
   identify the failing check, implement the smallest fix, then rerun.
5. Keep diffs scoped to the requested behavior. Do not refactor unrelated code.
6. Run the strongest affordable verification: targeted tests first, broader
   tests when shared behavior or user-facing flows are touched.
7. Review the diff as a separate pass before calling work complete.

## Role Boundaries

- Lead: scopes the work, chooses the plan, owns communication, and protects
  user constraints.
- Implementer: changes files according to one task at a time.
- Reviewer: checks requirements, regressions, missing tests, security/privacy
  risk, and whether the diff stays inside scope.
- Acceptance: confirms the user's requested outcome with fresh evidence.

If separate agents are unavailable, keep the boundaries explicit in the order
of work: plan, implement, review, verify.

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

- Do not claim a separate reviewer or agent ran unless it actually ran.
- Do not push, publish, or deploy without explicit user request.
- Do not fabricate APIs, file paths, or test results.
- Do not let planning become a substitute for making the requested change.
