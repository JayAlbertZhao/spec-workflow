---
name: domain-ui-ogma-workflow
description: >
  Use for UI/product design and frontend workflows: user-facing screens, page flows, navigation
  graphs, state transitions, screen inventories, API contracts for frontend/backend, interactive
  prototypes, design review, Ogma review loops, pinned UI feedback, or building a web/desktop app
  with visible screens. Trigger on "UI", "界面", "前端", "页面", "screen", "prototype",
  "原型", "Ogma", "design review", "产品设计", "交互", "导航", "状态", "frontend",
  "React", "Vue", "Vite", "app shell", or "可视化评审".
---

# Domain UI Ogma Workflow

Use this skill for UI work where screen structure and reviewability matter.

## Load

Read these files:

1. `AGENTS.md`
2. `CLAUDE.md`
3. `specs/codex-adapter/CLAUDE.md` when running in Codex
4. `specs/ui-design/CLAUDE.md`
5. `specs/pge-orchestration/CLAUDE.md` when implementation/evaluation is needed

## Apply

- Use `.agents/ui.md` for screen inventory, navigation, per-screen acceptance, state, and API contract.
- Keep frontend and backend boundaries explicit.
- Use `tool-ogma` when the user asks for a reviewable prototype, visual design pass, product review, or pinned feedback loop.
- After Ogma feedback, preserve stable feedback ids such as `OG-001` and track resolution.
- Verify UI behavior with a real browser or equivalent UI runtime before completion.

## Do Not Use

- Do not use for backend-only tasks with no user-facing screen.
