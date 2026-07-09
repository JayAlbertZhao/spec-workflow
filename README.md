# Codex Personal Skills

This repository contains a compact Codex skill set plus the author's global
`AGENTS.md` routing preferences.

## Skills

- `discussion`: collaborative discussion, standard-setting, direction evaluation,
  review of plans/prompts/specs/reports/implementations, architecture, research,
  writing, product design, and workflow exploration.
- `reporting`: user-facing reports, research notes, technical analyses, reviews,
  audits, summaries, delivery documents, and evidence-backed Markdown analysis.
- `case-study`: explicit case-study requests, bad-case reviews, project
  investigations, root-cause or first-principles analysis, product/workflow/
  research evaluation, and user-provided concrete examples.
- `agent-team-dev`: substantial repository work, multi-file implementation,
  refactors, migrations, architecture changes, review loops, and acceptance.
- `story-telling`: RFCs, design docs, proposals, research narratives,
  technical memos, multi-section writing, and structured revisions.
- `experiment`: experiment design and execution, baselines, benchmarks,
  datasets, ablations, model evaluation, large compute, and reproducibility.

## Install On Windows

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

Restart Codex after installing so the skill metadata and global instructions
are loaded into a fresh session.

## Repository Shape

```text
skills/
  discussion/SKILL.md
  reporting/SKILL.md
  case-study/SKILL.md
  agent-team-dev/SKILL.md
  story-telling/SKILL.md
  experiment/SKILL.md
AGENTS.md
README.md
LICENSE
```

The skills are intentionally self-contained. There is no separate plugin layer
or `specs/` routing system.
