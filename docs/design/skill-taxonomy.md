# Skill Taxonomy

This project uses three skill categories. The prefix is part of the skill name when a skill is installed or packaged.

## Categories

### core-*

Use for general agent behavior, workflow control, planning, verification, routing, orchestration, and cross-harness adaptation.

Core skills change how the agent works across projects. They should not depend on a specific product, API, or narrow domain.

Examples:

- `core-large-project-development`
- `core-spec-workflow-maintenance`
- Superpowers-style planning, debugging, review, and verification skills

### domain-*

Use for domain protocols, domain rubrics, and field-specific definitions of done.

Domain skills may contain workflow, but only because the domain needs it. They are loaded only when a project brief or spec selection asks for that domain.

Examples:

- `domain-research-workflow`
- `domain-story-workflow`
- `domain-ui-ogma-workflow`
- `domain-academic-writing`
- `domain-ml-evaluation`

### tool-*

Use for concrete tools, CLIs, libraries, services, and artifact pipelines.

Tool skills teach the agent how to drive a specific capability. They do not own the project lifecycle.

Examples:

- `tool-ogma`
- `tool-ppt-master`
- `tool-youtube-render-pdf`
- `tool-bilibili-render-pdf`

## Boundary Rules

- If it changes the agent's project-level behavior, use `core-*`.
- If it defines what good work looks like in a field, use `domain-*`.
- If it drives a named tool or artifact pipeline, use `tool-*`.
- If a skill looks like both core and domain, prefer `domain-*` when it only applies to projects with that domain.
- If a tool also includes a small workflow, keep it `tool-*` and connect it from a spec.
- Prefer scenario-specific skill names over spec-file names. A skill should trigger from what the user asks for, not from internal implementation terms.

## Naming

- Use lowercase kebab-case.
- Keep names stable after installation.
- Prefer source prefixes only when needed to avoid collisions, for example `core-superpowers-writing-plans`.
- Do not rename third-party skills blindly if they have internal cross-references. Wrap or alias them when that is safer.
