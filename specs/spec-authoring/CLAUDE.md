# Spec: Spec Authoring

Purpose: define how reusable workflow specs are created, revised, and packaged in `spec-workflow`.

Use this spec when adding a new `specs/<name>/` protocol, revising an existing spec protocol, or creating a skill wrapper around a spec.

## Spec Layout

Each reusable spec lives under:

```text
specs/<name>/
  CLAUDE.md
  prompts/        # optional
  examples/       # optional
  checks.md       # optional
```

`CLAUDE.md` is required. Prompt templates are required only when the spec mandates specialized roles.

## Recommended Sections

Use these sections unless the spec has a clear reason to differ:

```md
# Spec: <Name>

Purpose:

## When To Use
## Artifacts
## Roles
## Workflow
## Composition
## Verification
## NEVER
## ALWAYS
```

## Authoring Rules

- Keep reusable workflow rules in `specs/<name>/`.
- Keep one-off project rules in the bootstrapped project's `CLAUDE.md`.
- If changing a spec protocol, update both the spec `CLAUDE.md` and any prompt templates it references.
- Add or update `specs/route.md` when the spec should be auto-selected from a project brief.
- Add examples only when they clarify behavior that the protocol itself cannot express concisely.
- Do not generate lines beginning with `>>`; that prefix is reserved for the user.

## Skill Wrappers

When wrapping a spec as a Codex skill:

- Use the taxonomy in `docs/design/skill-taxonomy.md`.
- Keep `SKILL.md` short.
- Point to the framework files that must be read.
- Do not duplicate the entire spec body unless the skill must work outside this repository.

## Verification

Before finishing a spec change:

1. Read the changed spec and every prompt template it references.
2. Check `specs/route.md` if auto-routing should change.
3. Confirm the spec does not contradict `CLAUDE.md` or `AGENTS.md`.
4. Run a lightweight file-level validation: required files exist, prompt paths are real, and examples do not contain generated `>>` instructions.

## NEVER

- Add project-specific behavior to a reusable spec.
- Change a role protocol without changing its spawn template.
- Let a skill wrapper become the only source of truth for a spec.

## ALWAYS

- Preserve the framework/spec/project override boundary.
- Prefer small composable specs over one global workflow.
- Keep packaging separate from protocol semantics.
