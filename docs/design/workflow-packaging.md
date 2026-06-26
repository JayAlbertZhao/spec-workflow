# Workflow Packaging

`spec-workflow` is a framework repository, not a single skill.

The source of truth stays in the repository:

```text
CLAUDE.md
AGENTS.md
BASE_README.md
specs/
scripts/bootstrap.sh
docs/design/
```

Codex skills and plugins are packaging layers. They expose the framework to Codex without duplicating the whole protocol into one large `SKILL.md`.

## Layers

### Framework

The framework owns reusable workflow protocols, routing rules, bootstrap behavior, and project-layer conventions.

Framework files:

- `CLAUDE.md` for Claude-facing base conventions
- `AGENTS.md` for Codex-facing bridge instructions
- `specs/` for reusable protocols
- `specs/route.md` for brief-to-spec routing
- `scripts/bootstrap.sh` for new project creation

### Specs

Specs are composable protocols under `specs/<name>/`.

Each spec should be usable from the framework directly and should also be easy to wrap as a skill.

Recommended sections:

- Purpose
- When To Use
- Artifacts
- Roles
- Workflow
- Composition
- Verification
- NEVER
- ALWAYS

### Skills

Skills are thin trigger wrappers around specs. A skill should tell Codex when to use the spec and which repository files to read.

Skills should not copy the entire spec unless the skill must work standalone outside this repository.

### Plugin

The Codex plugin wrapper exposes scenario-specific skill wrappers from `skills/`.

The plugin should remain light:

- `.codex-plugin/plugin.json`
- `skills/core-large-project-development`
- `skills/core-spec-workflow-maintenance`
- `skills/domain-research-workflow`
- `skills/domain-story-workflow`
- `skills/domain-ui-ogma-workflow`
- optional future assets or scripts

## Runtime Flow

1. A project is bootstrapped from this repository.
2. The agent reads `AGENTS.md` or `CLAUDE.md`.
3. If `## Specs in Use` is empty, the agent uses the routing workflow.
4. The chosen specs are loaded from `specs/`.
5. Tool skills such as Ogma or PPT generation are invoked only when the selected workflow needs them.

## Packaging Rule

Keep protocols in `specs/`. Keep scenario triggers in `skills/`. Keep concrete tool instructions in `tool-*` skills.

Skill trigger descriptions should be written for real user language: "large refactor", "research project", "write an RFC", "UI prototype", "Ogma review". Do not rely on internal file names such as `pge-orchestration` as the main trigger.
