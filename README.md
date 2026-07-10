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
- `scripts/update-sol-prompt.ps1`: regenerates the current Sol prompt override
  from the Desktop-managed bundled catalog and removes only the commentary
  section.

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
scripts/
  update-sol-prompt.ps1
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

## GPT-5.6 Sol Update (2026-07-10)

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

### Repair Procedure

1. Close active Codex tasks or plan to start a new task after the change.
2. From this repository, generate the override:

```powershell
.\scripts\update-sol-prompt.ps1
```

By default, the script writes:

```text
%USERPROFILE%\.codex\prompts\gpt-5.6-sol-base-without-commentary.md
```

The script discovers the newest Desktop-managed CLI when possible, reads
`debug models --bundled`, and refuses to generate a file if the expected section
boundaries have changed. Its JSON output records the source prompt hash,
generated prompt hash, executable path, model, and character counts.

3. Add the generated file's absolute path to `%USERPROFILE%\.codex\config.toml`:

```toml
model_instructions_file = 'C:\Users\<username>\.codex\prompts\gpt-5.6-sol-base-without-commentary.md'

model = "gpt-5.6-sol"
model_reasoning_effort = "xhigh"
```

Replace `<username>` with the Windows account name. `xhigh` is an optional local
reasoning preference and is not part of the prompt transformation.

4. Start a new Codex task. Existing and resumed tasks may retain the prompt
serialized when they were created.

If automatic CLI discovery selects the wrong installation, pass the executable
explicitly:

```powershell
.\scripts\update-sol-prompt.ps1 -CodexExe "C:\path\to\codex.exe"
```

### Inspect And Verify

Use the client itself as the primary diagnostic surface:

```powershell
codex --version
Get-Command codex -All
codex doctor --json
codex debug prompt-input -c 'model="gpt-5.6-sol"' "prompt audit"

$catalog = Get-Content -Raw "$env:USERPROFILE\.codex\models_cache.json" | ConvertFrom-Json
$sol = $catalog.models | Where-Object slug -eq "gpt-5.6-sol"
$sol | Select-Object slug, display_name, default_reasoning_level, context_window, effective_context_window_percent, default_verbosity, multi_agent_version
$sol.base_instructions
```

`models_cache.json` is an internal cache, so use it for diagnosis rather than as
a committed source file. `codex debug prompt-input` shows the generated
developer/user prompt layers, including permissions, environment context, and
loaded `AGENTS.md`; the model catalog exposes the model-specific base
instructions. After changing global configuration, start a new task so it is
constructed from the updated layers.

Check executable provenance before comparing prompts. npm, Desktop-packaged,
and Desktop-managed Codex installations can coexist at different versions. Use
the generator's `codex_exe` result, `codex doctor --json`, `Get-Command codex
-All`, and the app cache together rather than assuming the first `codex` on
`PATH` represents the active Desktop runtime.

When upgrading again, first check for a stale `model_instructions_file`, then
regenerate the override from the current model entry and run paired before/after
evals. Codex Candy is a useful smoke signal, not sufficient acceptance by
itself: keep client, provider, model, reasoning, and task settings fixed; use
repeated runs and more than one task; and compare correctness, latency, output
tokens, and reasoning tokens separately. Keep the source hash, generated hash,
removed section, rollback path, and before/after measurements with each prompt
experiment.

To roll back, remove `model_instructions_file` from `config.toml` and start a new
task. Codex will return to the model's unmodified built-in instructions.

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
