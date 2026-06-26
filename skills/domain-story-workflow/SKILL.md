---
name: domain-story-workflow
description: >
  Use for long-form structured writing: RFCs, design docs, research narratives, proposals,
  reports, technical memos, multi-section markdown documents, documents where later sections depend
  on earlier sections, or writing tasks that need author/reviewer passes and revision flags.
  Trigger on "story", "story telling", "写文档", "RFC", "设计文档", "proposal", "report",
  "章节", "section", "narrative", "大纲", "草稿", "评审文稿", or "long-form doc".
---

# Domain Story Workflow

Use this skill when the deliverable is a structured document.

## Load

Read these files:

1. `AGENTS.md`
2. `CLAUDE.md`
3. `specs/codex-adapter/CLAUDE.md` when running in Codex
4. `specs/story-telling/CLAUDE.md`
5. `specs/phased-workflow/CLAUDE.md` if the writing work has checkpointed phases

## Apply

- Use `.agents/story.md` as the durable story artifact unless the project overrides it.
- Keep section ownership and dependency order explicit.
- Verify each section against its rubric before advancing.
- Use `[FLAG]` markers and `.agents/revision-proposal.md` for revision cascades.

## Do Not Use

- Do not use for short answers, one-off README edits, or simple copy edits.
