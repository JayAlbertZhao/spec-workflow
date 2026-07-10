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

### Local Finding

The Codex App model catalog currently exposes `gpt-5.6-sol` as a model-specific
agent runtime with its own built-in instructions, reasoning presets, tool mode,
context policy, and multi-agent behavior. On the machine inspected for this
update, the app cache reported a 372k context window, a 95% effective context
window, `low` default reasoning, reasoning levels through `ultra`, low default
verbosity, code-mode tools, and a catalog-selected multi-agent version. These
are internal, rollout-sensitive fields: inspect the current cache instead of
treating the values in this note as a stable public contract.

The active global configuration still contained two stale settings:

- `model = "gpt-5.5"`;
- `model_instructions_file` pointing to the GPT-5.5 instruction copy published
  in the downgrade article.

The override was not the current 5.6 Sol prompt. It differed in both content and
structure and omitted current native sections such as the model's skill-usage
contract. Because `model_instructions_file` replaces the model's built-in
instructions, retaining that file pins future models to an old prompt even when
the model selector changes. This replacement behavior is documented in the
[official Codex configuration reference](https://developers.openai.com/codex/config-reference/#configtoml).

The local preference is to remove the native `## Intermediate commentary`
section. This is an intentional prompt experiment inspired by the article, not
proof that commentary necessarily truncates hidden reasoning. The important
maintenance rule is that the experiment must start from the current Sol prompt,
not the older GPT-5.5 copy.

### Repair Applied

The global configuration now uses:

```toml
model_instructions_file = 'C:\Users\JAZ03\Documents\Codex\private\gpt-5.6-sol-base-without-commentary.md'

model = "gpt-5.6-sol"
model_reasoning_effort = "xhigh"
```

The replacement file is generated from the current bundled `gpt-5.6-sol`
`base_instructions`, with only the text from `## Intermediate commentary` up to
`## Final answer` removed. At the inspected version, the native base contained
16,299 characters and the generated prompt contained 14,955; the generated file
SHA-256 was `891867fd3815eecf80dbedd5072b3c72917bae9e0c9c64ab6495e4391314c059`.
The old GPT-5.5 file remains only as historical material. `xhigh` is the selected
local reasoning preference, not part of the prompt transformation.

Regenerate the file after Codex or Sol updates instead of editing a copied
prompt by hand:

```powershell
.\scripts\update-sol-prompt.ps1 `
  -OutputPath "$env:USERPROFILE\Documents\Codex\private\gpt-5.6-sol-base-without-commentary.md"
```

The script discovers the newest Desktop-managed CLI when possible, reads
`debug models --bundled`, refuses to continue if the expected section boundaries
changed, and reports source/generated hashes for review.

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

Check executable provenance before comparing prompts. This machine had an npm
CLI, the Desktop-packaged CLI, and a Desktop-managed CLI at different versions;
the `codex` found first on `PATH` did not expose the same bundled model catalog
as the active Desktop runtime. Use `codex doctor --json`, `Get-Command codex
-All`, and the app cache together rather than assuming every local `codex.exe`
represents the running task.

This source repository also contains the same `AGENTS.md` that it installs
globally. When the global copy and repository copy are identical, Codex may load
both while working inside this repository. That duplication is specific to
maintaining the source package; normal projects load the global file plus their
own project guidance.

When upgrading again, first check for a stale `model_instructions_file`, then
regenerate the override from the current model entry and run paired before/after
evals. Codex Candy is a useful smoke signal, not sufficient acceptance by
itself: keep client, provider, model, reasoning, and task settings fixed; use
repeated runs and more than one task; and compare correctness, latency, output
tokens, and reasoning tokens separately. Keep the source hash, generated hash,
removed section, rollback path, and before/after measurements with each prompt
experiment.

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
