# Codex Personal Skills

This repository is the human-readable source of truth for my Codex global
instructions and personal skills.

It keeps the always-loaded `AGENTS.md` small, and moves heavier workflows into
individual skills that Codex can load only when the task calls for them.

## What Lives Here

```text
AGENTS.md
skills/
  discussion/
  reporting/
  case-study/
  agent-team-dev/
  story-telling/
  experiment/
```

## How The System Is Intended To Work

`AGENTS.md` is the routing layer. It should contain:

- global communication style;
- concise skill trigger preferences;
- standing authorization rules;
- personal engineering preferences.

Detailed trigger thresholds, workflow steps, and quality rules belong inside
each skill's own `SKILL.md`. This keeps the global prompt readable and avoids
turning it into a giant policy dump. A small prompt is a quiet prompt. Quiet
prompts are easier to debug.

## Skills

- `discussion`: discussion-mode analysis for standards, plans, architecture,
  prompts, writing, product decisions, and workflow questions.
- `reporting`: report-mode deliverables such as research notes, technical
  analyses, reviews, audits, summaries, and evidence-backed Markdown reports.
- `case-study`: case-style investigation for explicit case-study requests,
  bad-case reviews, project investigations, root-cause or first-principles
  analysis, product/workflow/research evaluation, and concrete examples.
- `agent-team-dev`: larger repository or project engineering work. Its own
  `SKILL.md` defines the threshold for from-scratch projects, large existing
  projects, decomposition requests, multi-file work, and when to scale down.
- `story-telling`: long-form structured writing such as RFCs, design docs,
  proposals, technical memos, multi-section Markdown, and revision workflows.
- `experiment`: experiment design, execution, and analysis, including baselines,
  benchmarks, datasets, ablations, model evaluation, large compute, and
  reproducibility.

## Install Or Update On Windows

From the repository root:

```powershell
$dest = Join-Path $env:USERPROFILE ".codex\skills"
New-Item -ItemType Directory -Force -Path $dest | Out-Null

$skills = "discussion", "reporting", "case-study", "agent-team-dev", "story-telling", "experiment"
foreach ($skill in $skills) {
  $target = Join-Path $dest $skill
  if (Test-Path $target) {
    Remove-Item -Recurse -Force -LiteralPath $target
  }
  Copy-Item -Recurse -Force ".\skills\$skill" $target
}

Copy-Item -Force .\AGENTS.md (Join-Path $env:USERPROFILE ".codex\AGENTS.md")
```

Restart Codex after installing so the global instructions and skill metadata
are loaded into a fresh session.

## Maintenance Notes

- Keep `AGENTS.md` concise and structurally consistent.
- Put detailed trigger conditions in the relevant skill, not in `AGENTS.md`.
- Validate skills after editing:

```powershell
$env:PYTHONUTF8 = "1"
python "$env:USERPROFILE\.codex\skills\.system\skill-creator\scripts\quick_validate.py" .\skills\discussion
python "$env:USERPROFILE\.codex\skills\.system\skill-creator\scripts\quick_validate.py" .\skills\reporting
python "$env:USERPROFILE\.codex\skills\.system\skill-creator\scripts\quick_validate.py" .\skills\case-study
python "$env:USERPROFILE\.codex\skills\.system\skill-creator\scripts\quick_validate.py" .\skills\agent-team-dev
python "$env:USERPROFILE\.codex\skills\.system\skill-creator\scripts\quick_validate.py" .\skills\story-telling
python "$env:USERPROFILE\.codex\skills\.system\skill-creator\scripts\quick_validate.py" .\skills\experiment
```

The repository intentionally has no separate plugin layer or `specs/` routing
system. It is plain files, which is exactly the point.
