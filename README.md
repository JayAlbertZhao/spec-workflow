# Codex Personal Skills

This repository contains a small, direct Codex skill set plus the author's
global `AGENTS.md` preferences.

## Skills

- `agent-team-dev`: substantial repository work, multi-file implementation,
  refactors, migrations, architecture changes, review loops, and acceptance.
- `story-telling`: long-form reports, RFCs, design docs, proposals, research
  narratives, technical memos, and multi-section writing.
- `experiment`: experiment design and execution, baselines, benchmarks,
  datasets, ablations, model evaluation, large compute, and reproducibility.

## Install On Windows

From the repository root:

```powershell
$dest = Join-Path $env:USERPROFILE ".codex\skills"
New-Item -ItemType Directory -Force -Path $dest | Out-Null
Copy-Item -Recurse -Force .\skills\agent-team-dev (Join-Path $dest "agent-team-dev")
Copy-Item -Recurse -Force .\skills\story-telling (Join-Path $dest "story-telling")
Copy-Item -Recurse -Force .\skills\experiment (Join-Path $dest "experiment")
Copy-Item -Force .\AGENTS.md (Join-Path $env:USERPROFILE ".codex\AGENTS.md")
```

Restart Codex after installing so the skill metadata and global instructions
are loaded into a fresh session.

## Repository Shape

```text
skills/
  agent-team-dev/SKILL.md
  story-telling/SKILL.md
  experiment/SKILL.md
AGENTS.md
README.md
LICENSE
```

The skills are intentionally self-contained. There is no separate plugin layer
or `specs/` routing system.
