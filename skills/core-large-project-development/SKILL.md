---
name: core-large-project-development
description: >
  Use for substantial software engineering work in a repository: multi-file feature implementation,
  large refactor, architecture change, migration, complex bug fix, test strategy, release readiness,
  or any task that needs planning, isolated implementation, independent review, bounded retries, or
  project acceptance. Trigger on user phrases such as "大项目", "复杂改造", "重构", "迁移", "架构",
  "多文件", "端到端验证", "做完整一点", "review then fix", "plan then implement", or when the
  request is too broad for a single direct edit.
---

# Core Large Project Development

Use this skill to run `spec-workflow` as an engineering workflow, not as a file lookup helper.

## Load

Read these files in order:

1. `AGENTS.md`
2. `CLAUDE.md`
3. `specs/codex-adapter/CLAUDE.md` when running in Codex
4. `specs/phased-workflow/CLAUDE.md` if the work has clear phases or checkpoints
5. `specs/pge-orchestration/CLAUDE.md` when implementation needs independent evaluation

## Apply

- Start with a concise implementation plan when the task has multiple steps.
- Use `.agents/status.md` only for durable project state, not routine narration.
- Use `.agents/plan.md`, `.agents/sprint-contract.md`, `.agents/feedback.md`, and `.agents/acceptance.md` when the PGE protocol is active.
- Preserve generator/evaluator/reviewer boundaries even if the current Codex session lacks a separate subagent tool.
- Verify before declaring completion.

## Do Not Use

- Do not use for single-file mechanical edits or simple factual questions.
- Do not force PGE overhead onto small tasks.
