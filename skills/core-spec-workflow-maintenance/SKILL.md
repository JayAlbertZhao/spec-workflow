---
name: core-spec-workflow-maintenance
description: >
  Use when maintaining the spec-workflow framework itself: adding or revising specs, changing
  specs/route.md, creating skill wrappers, changing .codex-plugin/plugin.json, updating AGENTS.md
  or CLAUDE.md conventions, packaging the framework as a Codex plugin, installing or reinstalling
  the local plugin, cleaning deprecated workflow skills, or deciding whether something belongs in
  core, domain, or tool. Trigger on "spec-workflow", "workflow framework", "new spec",
  "skill wrapper", "plugin packaging", "core/domain/tool", "route.md", "bootstrap",
  "Codex adapter", or "Claude to Codex".
---

# Core Spec Workflow Maintenance

Use this skill for work on this repository as a workflow framework.

## Load

Read these files before changing framework behavior:

1. `AGENTS.md`
2. `CLAUDE.md`
3. `docs/design/workflow-packaging.md`
4. `docs/design/skill-taxonomy.md`
5. `specs/spec-authoring/CLAUDE.md`
6. `specs/codex-adapter/CLAUDE.md` when Codex behavior is involved

## Apply

- Keep reusable protocol in `specs/`.
- Keep scenario trigger behavior in `skills/`.
- Keep concrete tools in external or `tool-*` skills.
- When a spec protocol changes, update referenced prompt templates.
- When plugin metadata or skills change, validate and reinstall the local plugin.

## Validate

- Run skill validation for changed skills.
- Run plugin validation for `.codex-plugin/plugin.json`.
- Check that deprecated skill wrappers are removed from both source and installed cache after reinstall.
