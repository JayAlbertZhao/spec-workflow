# Spec: Codex Adapter

Purpose: make Claude-oriented `spec-workflow` protocols executable in Codex without rewriting every spec.

Use this spec whenever Codex is operating inside a project bootstrapped from `spec-workflow`, or when a spec references Claude Code primitives that are not available in the current Codex session.

## Concept Mapping

| Claude-facing concept | Codex-facing behavior |
|---|---|
| `TaskCreate` / `TaskUpdate` / `TaskList` | Use Codex `update_plan` for current-session progress. Mirror durable decisions and checkpoints into `.agents/status.md` when the workflow requires cross-session continuity. |
| Sub-agent spawn templates | Use available Codex multi-agent tooling when present. If unavailable, execute the role in-session while preserving the role boundary in files and status notes. |
| `.agents/status.md` | Durable human-facing project status. Keep user-facing notes in Chinese unless a project override says otherwise. |
| `.agents/feedback.md` | Open findings inbox. Read after every generator/evaluator/reviewer role returns, then clear, queue, or resolve entries. |
| `.agents/acceptance.md` | Acceptance-tester-owned verdict log. Do not edit verdicts; mirror follow-up work into `status.md`. |
| Slash commands | Treat as legacy triggers. Prefer specs and skills as the authoritative protocol surface. |
| Claude `CLAUDE.md` | Canonical framework instructions. Codex reads `AGENTS.md` as the bridge and then follows `CLAUDE.md`. |

## Operating Rules

- Read `AGENTS.md` first when present, then `CLAUDE.md`, then declared specs.
- If a spec calls for `TaskList`, check the current Codex plan state and `.agents/status.md` instead of fabricating a task board API.
- If the current Codex environment has no sub-agent tool, do not pretend one ran. Log that the role was executed in-session.
- Preserve write boundaries even when executing in-session. For example, an evaluator role may write feedback but should not directly fix generator code in the same role pass.
- Use `apply_patch` for manual edits in this repository.

## Project Startup

When starting work in a bootstrapped project:

1. Read `AGENTS.md` if present.
2. Read `CLAUDE.md`.
3. Read every path under `## Specs in Use` if the section is non-empty.
4. If `## Specs in Use` is empty, run the routing workflow from `specs/route.md`.
5. Check `.agents/status.md` if present.
6. Proceed with the user's task.

## Composition

This spec composes with every other spec. It does not change project semantics; it maps protocol mechanics to Codex.

If a project explicitly uses Claude Code and not Codex, this spec is unnecessary.

## Verification

- A Codex user can follow the same project workflow without Claude-only tools.
- Durable status is still visible in `.agents/status.md`.
- No role claims to have been performed by a separate agent unless a separate agent actually ran.

## NEVER

- Invent unavailable Claude APIs.
- Mark a separate evaluator, reviewer, or acceptance-tester as run if the work happened in-session.
- Rewrite canonical spec behavior just to fit Codex; adapt the mechanics instead.

## ALWAYS

- Keep the distinction between framework rules, selected specs, and project-specific overrides.
- Make tool substitutions explicit in `.agents/status.md` when they affect workflow evidence.
