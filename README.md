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

## Recommended External Installs

This repo only stores my personal global instructions and small personal skills.
For a fuller working environment, install the following upstream tools or skills
separately and keep them updated from their own repositories.

| Item | Install or entry point | Upstream link |
|---|---|---|
| Superpowers | In Codex App, use the Plugins sidebar and install `Superpowers`; in Codex CLI, run `/plugins`, search `superpowers`, then install. | [obra/superpowers](https://github.com/obra/superpowers) |
| Product Design | Install from the Codex plugin marketplace, then start with `@Product Design Help me get started`. | [openai/role-specific-plugins: product-design](https://github.com/openai/role-specific-plugins/tree/main/plugins/product-design) |
| PPT Master | Prefer the upstream install path, such as `npx skills add hugohe3/ppt-master`, or clone the repo when you need the full toolchain. Use an isolated Python environment before installing its Python dependencies. | [hugohe3/ppt-master](https://github.com/hugohe3/ppt-master) |
| YouTube Render PDF | Clone the repo and copy `skills/youtube-render-pdf` into the Codex skills directory. It needs video, frame, and LaTeX tooling such as `yt-dlp`, `ffmpeg`, ImageMagick, and XeLaTeX. | [wdkns/wdkns-skills](https://github.com/wdkns/wdkns-skills) |
| Codex Candy Counting Benchmark | Local skill name: `codex-candy-eval`. Upstream script entry is usually `python codex_candy_eval.py -m <model> -r high -n 5`. | [haowang02/codex-candy-eval](https://github.com/haowang02/codex-candy-eval) |

For Product Design, OpenAI's broader role-specific plugin template repository is
also useful background: [openai/role-specific-plugins](https://github.com/openai/role-specific-plugins).

## Reference Material

- [OpenAI Codex AI 降智解决方案、原因解析与系统提示词修改指南](https://dpit.lib00.com/zh/content/1242/uncovering-the-reason-behind-openai-codex-ai-downgrade-system-prompt-configuration-guide):
  useful context for Codex system-prompt configuration, Codex Candy evaluation,
  and the surrounding discussion. Treat configuration changes from articles as
  hypotheses to verify locally before adopting.
- [How Claude Code works](https://code.claude.com/docs/en/how-claude-code-works):
  useful for capability vocabulary and command-line-agent framing.
- [Best practices for Claude Code](https://code.claude.com/docs/en/best-practices):
  useful as a comparison reference for context management, verification loops,
  planning, subagents, and long-running workflows.

The Claude Code references are included as comparison material, not as operating
policy for this repository. Read them selectively, extract mechanisms that test
well in Codex, and avoid copying workflow rules wholesale.

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
