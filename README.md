# Codex Personal Skills

Language: [English](README.md) | [中文](README_CN.md)

This repository is the human-readable source of truth for my Codex global
instructions and personal skills.

It keeps the always-loaded `AGENTS.md` small, and moves heavier workflows into
individual skills that Codex can load only when the task calls for them.

## Repository Contents

This repo contains a small Codex instruction system, not a full framework:

- `README.md`: English human-facing overview and maintenance guide.
- `README_CN.md`: Chinese human-facing overview and maintenance guide.
- `AGENTS.md`: the global Codex instruction entry point. It keeps routing,
  personal preferences, and standing authorization concise so every session does
  not start with a giant prompt.
- `skills/discussion/`: discussion-mode behavior for standards, plans,
  architecture, prompts, product decisions, and workflow critique.
- `skills/reporting/`: report-mode behavior for research notes, technical
  analysis, audits, reviews, summaries, and evidence-backed deliverables.
- `skills/case-study/`: case-style investigation for concrete examples,
  project evidence, bad-case reviews, root-cause analysis, and product/workflow
  evaluation.
- `skills/agent-team-dev/`: larger repository or project engineering workflow,
  including planner-led coordination, side-agent dispatch, review loops, and
  acceptance checks.
- `skills/story-telling/`: long-form structured writing and narrative synthesis,
  including RFCs, design docs, proposals, research narratives, and revision
  workflows.
- `skills/experiment/`: experiment design, execution, analysis, reproducibility,
  benchmarks, datasets, ablations, model evaluation, and run artifacts.

## What Lives Here

```text
AGENTS.md
README.md
README_CN.md
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

| Item | What it is for | Install or entry point | Upstream link |
|---|---|---|---|
| Superpowers | A broader skill and workflow collection for disciplined agentic development, verification, planning, and tool use. | In Codex App, use the Plugins sidebar and install `Superpowers`; in Codex CLI, run `/plugins`, search `superpowers`, then install. | [obra/superpowers](https://github.com/obra/superpowers) |
| Product Design | OpenAI's design/prototyping plugin for product briefs, UX audits, visual exploration, prototypes, and image-to-code workflows. | Install from the Codex plugin marketplace, then start with `@Product Design Help me get started`. | [openai/role-specific-plugins: product-design](https://github.com/openai/role-specific-plugins/tree/main/plugins/product-design) |
| PPT Master | A source-to-SVG-to-PPTX deck generation workflow for structured slide creation, visual design, live preview, and PPTX export. | Prefer the upstream install path, such as `npx skills add hugohe3/ppt-master`, or clone the repo when you need the full toolchain. Use an isolated Python environment before installing its Python dependencies. | [hugohe3/ppt-master](https://github.com/hugohe3/ppt-master) |
| YouTube Render PDF | A video-to-LaTeX/PDF note workflow for turning YouTube technical lectures into figure-rich Chinese teaching notes. | Clone the repo and copy `skills/youtube-render-pdf` into the Codex skills directory. It needs video, frame, and LaTeX tooling such as `yt-dlp`, `ffmpeg`, ImageMagick, and XeLaTeX. | [wdkns/wdkns-skills](https://github.com/wdkns/wdkns-skills) |
| Codex Candy Counting Benchmark | A lightweight local benchmark for checking Codex CLI behavior, candy-counting accuracy, reasoning token use, and output speed. | Local skill name: `codex-candy-eval`. Upstream script entry is usually `python codex_candy_eval.py -m <model> -r high -n 5`. | [haowang02/codex-candy-eval](https://github.com/haowang02/codex-candy-eval) |

For Product Design, OpenAI's broader role-specific plugin template repository is
also useful background: [openai/role-specific-plugins](https://github.com/openai/role-specific-plugins).

## Reference Material

- [Claude Code Best Practice](https://github.com/shanraisshan/claude-code-best-practice):
  a useful reference book for agentic engineering practice. It collects practical
  guidance around planning, context management, subagents, commands, skills,
  hooks, verification, Git/PR workflow, debugging, utilities, and daily usage.
  Use it as a pattern catalogue and checklist source; adopt patterns only after
  checking that they fit Codex and this repo's preferences.
- [Everything Claude Code / ECC](https://github.com/affaan-m/ECC):
  another workflow paradigm for agent-harness operation. It is useful for studying
  broader system design: skills, agents, hooks, rules, memory, verification loops,
  security posture, research-first development, parallelization, and cross-harness
  packaging. Its main tradeoff is that the full paradigm is token-intensive and
  operationally heavy. Treat it as a comparison system and source of mechanisms,
  not as the default operating policy for this repo.
- [OpenAI Codex AI 降智解决方案、原因解析与系统提示词修改指南](https://dpit.lib00.com/zh/content/1242/uncovering-the-reason-behind-openai-codex-ai-downgrade-system-prompt-configuration-guide):
  useful context for Codex system-prompt configuration, Codex Candy evaluation,
  and the surrounding discussion. Its copied GPT-5.5 prompt is now a historical
  case, not a current template. Treat configuration changes from articles as
  hypotheses to verify locally before adopting.

## Repair Instructions for Codex

### Why This Repair Exists

`model_instructions_file` replaces the model's built-in instructions. A prompt
copied from an older model can therefore keep overriding Sol after the model
selector changes, leaving new native behavior such as updated skill contracts
behind. This replacement behavior is documented in the
[official Codex configuration reference](https://developers.openai.com/codex/config-reference/#configtoml).

This repair is for users who intentionally want to remove Sol's native
`## Intermediate commentary` section. It generates a new override from the
current bundled `gpt-5.6-sol` prompt and removes only the text between
`## Intermediate commentary` and `## Final answer`. It does not reuse the older
GPT-5.5 prompt from the referenced article.

### Codex Operator Guide

When asked to apply this repair, Codex should:

1. Inspect the active Codex installation, current global `config.toml`, current
   task metadata when available, and the Desktop-managed model catalog. Do not
   assume the first `codex` on `PATH` is the runtime used by the Codex App.
2. Read the current bundled `gpt-5.6-sol` `base_instructions`. Treat
   `models_cache.json` as diagnostic state only; never edit it.
3. Verify that the source contains exactly one `## Intermediate commentary`
   section followed by `## Final answer`. Stop without writing if either marker
   is missing, duplicated, or reordered.
4. Generate a minimal-difference prompt by removing only the text from
   `## Intermediate commentary` up to, but not including, `## Final answer`.
5. Write the generated prompt under the user's Codex home, preferably
   `~/.codex/prompts/gpt-5.6-sol-base-without-commentary.md`, unless the user has
   already chosen another private path.
6. Update `model_instructions_file` in the user's global `config.toml` to the
   generated file's absolute path. Preserve unrelated settings. Keep the model
   and reasoning preference unchanged unless the user asks to change them.
7. Verify the source and generated hashes, confirm that commentary is absent and
   `## Final answer` remains, run `codex doctor`, and report the exact paths and
   evidence used.
8. Tell the user to start a new task. Existing and resumed tasks may retain the
   prompt serialized when they were created.

Do not execute scripts downloaded from this repository, reuse an older model's
full prompt, hard-code another user's private path, modify the model cache, or
claim that a config parse alone proves model-quality improvement.

### Acceptance And Rollback

Acceptance requires a prompt derived from the currently installed Sol catalog,
an exact one-section removal, a valid global config, and a fresh-task check.
Codex Candy may be used as a smoke signal, but quality claims require paired
before/after runs with fixed client, provider, model, reasoning, and task
settings.

To roll back, remove `model_instructions_file` from global `config.toml` and
start a new task. Codex should then return to the model's unmodified built-in
instructions.

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
