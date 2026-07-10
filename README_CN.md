# Codex Personal Skills

语言：[中文](README_CN.md) | [English](README.md)

这个仓库是我的 Codex 全局指令和个人 skills 的人类可读版本。

它的设计目标很简单：让始终加载的 `AGENTS.md` 保持轻量，把较重的工作流放进独立 skill，只有任务需要时再让 Codex 加载。

## 这个仓库有什么

这个 repo 是一套小型 Codex instruction system，不是完整框架：

- `README.md`: 英文的人类可读说明和维护指南。
- `README_CN.md`: 中文的人类可读说明和维护指南。
- `AGENTS.md`: Codex 全局指令入口。它只保留路由、个人偏好和常驻授权，避免每个会话都从巨大 prompt 开始。
- `skills/discussion/`: discussion mode，用于标准制定、方案评估、架构讨论、prompt、产品决策和 workflow critique。
- `skills/reporting/`: reporting mode，用于 research note、技术分析、audit、review、summary 和 evidence-backed deliverable。
- `skills/case-study/`: case-style investigation，用于具体案例、项目证据、bad-case review、root-cause analysis 和产品 / workflow 评估。
- `skills/agent-team-dev/`: 较大的仓库或项目工程工作流，包括 planner 主导协调、side-agent 分发、review loop 和 acceptance check。
- `skills/story-telling/`: long-form structured writing 和 narrative synthesis，用于 RFC、设计文档、proposal、research narrative 和 revision workflow。
- `skills/experiment/`: experiment design、execution、analysis、reproducibility、benchmark、dataset、ablation、model evaluation 和 run artifact。
- `scripts/update-sol-prompt.ps1`: 从 Desktop-managed bundled catalog 重新生成当前 Sol prompt override，并且只移除 commentary section。

## 文件结构

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

## 系统如何工作

`AGENTS.md` 是 routing layer。它应该包含：

- 全局沟通风格；
- 简洁但完整的 skill trigger preferences；
- 常驻授权规则；
- 个人工程偏好。

详细触发阈值、workflow steps 和质量规则属于每个 skill 自己的 `SKILL.md`。这样全局 prompt 可读、可维护，也更容易 debug。

## Skills

- `discussion`: 用于 discussion-mode analysis，覆盖标准、计划、架构、prompt、写作、产品决策和 workflow 问题。
- `reporting`: 用于 report-mode deliverables，例如 research notes、technical analyses、reviews、audits、summaries 和 evidence-backed Markdown reports。
- `case-study`: 用于 case-style investigation，例如明确的 case-study 请求、bad-case review、project investigation、root-cause 或 first-principles analysis、product/workflow/research evaluation 和 concrete examples。
- `agent-team-dev`: 用于较大的仓库或项目工程工作。它自己的 `SKILL.md` 定义 from-scratch projects、large existing projects、decomposition requests、multi-file work，以及何时缩小流程。
- `story-telling`: 用于 long-form structured writing，例如 RFC、design docs、proposals、technical memos、multi-section Markdown 和 revision workflows。
- `experiment`: 用于 experiment design、execution 和 analysis，包括 baselines、benchmarks、datasets、ablations、model evaluation、large compute 和 reproducibility。

## Windows 安装或更新

在仓库根目录运行：

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

安装后重启 Codex，让全局指令和 skill metadata 在新会话中重新加载。

## 推荐的外部安装

这个 repo 只保存我的个人全局指令和小型 personal skills。更完整的工作环境建议单独安装以下 upstream tools 或 skills，并从它们自己的 repo 更新。

| 项目 | 用途 | 安装或入口 | Upstream link |
|---|---|---|---|
| Superpowers | 更完整的 skill 和 workflow collection，用于 disciplined agentic development、verification、planning 和 tool use。 | Codex App 中使用 Plugins sidebar 安装 `Superpowers`；Codex CLI 中运行 `/plugins`，搜索 `superpowers` 后安装。 | [obra/superpowers](https://github.com/obra/superpowers) |
| Product Design | OpenAI 的 design/prototyping plugin，用于 product brief、UX audit、visual exploration、prototype 和 image-to-code workflow。 | 从 Codex plugin marketplace 安装，然后用 `@Product Design Help me get started` 开始。 | [openai/role-specific-plugins: product-design](https://github.com/openai/role-specific-plugins/tree/main/plugins/product-design) |
| PPT Master | source-to-SVG-to-PPTX deck generation workflow，用于结构化生成幻灯片、视觉设计、live preview 和 PPTX export。 | 优先使用 upstream install path，例如 `npx skills add hugohe3/ppt-master`；需要完整工具链时 clone repo。安装 Python dependencies 前先使用隔离环境。 | [hugohe3/ppt-master](https://github.com/hugohe3/ppt-master) |
| YouTube Render PDF | video-to-LaTeX/PDF note workflow，用于把 YouTube 技术讲座转成包含关键截图的中文教学笔记。 | Clone repo，并把 `skills/youtube-render-pdf` 复制到 Codex skills directory。它需要 `yt-dlp`、`ffmpeg`、ImageMagick 和 XeLaTeX 等视频、抽帧、LaTeX 工具。 | [wdkns/wdkns-skills](https://github.com/wdkns/wdkns-skills) |
| Codex Candy Counting Benchmark | 轻量本地 benchmark，用于检查 Codex CLI 行为、candy-counting accuracy、reasoning token use 和 output speed。 | 本地 skill 名是 `codex-candy-eval`。常见 upstream script 入口是 `python codex_candy_eval.py -m <model> -r high -n 5`。 | [haowang02/codex-candy-eval](https://github.com/haowang02/codex-candy-eval) |

Product Design 的更广义背景可以参考 OpenAI 的 role-specific plugin template repo：[openai/role-specific-plugins](https://github.com/openai/role-specific-plugins)。

## Reference Material

- [Claude Code Best Practice](https://github.com/shanraisshan/claude-code-best-practice): 一个不错的 agentic engineering reference book。它整理了 planning、context management、subagents、commands、skills、hooks、verification、Git/PR workflow、debugging、utilities 和日常使用经验。适合作为 pattern catalogue 和 checklist source；具体规则仍需要确认适配 Codex 和本 repo 的偏好。
- [Everything Claude Code / ECC](https://github.com/affaan-m/ECC): 另一套 agent-harness workflow paradigm。它适合研究更完整的系统设计，包括 skills、agents、hooks、rules、memory、verification loops、security posture、research-first development、parallelization 和 cross-harness packaging。主要 tradeoff 是完整范式 token-intensive 且 operationally heavy。更适合作为 comparison system 和 mechanisms source，而不是本 repo 默认 operating policy。
- [OpenAI Codex AI 降智解决方案、原因解析与系统提示词修改指南](https://dpit.lib00.com/zh/content/1242/uncovering-the-reason-behind-openai-codex-ai-downgrade-system-prompt-configuration-guide): Codex system-prompt configuration、Codex Candy evaluation 及相关讨论的有用上下文。其中复制的 GPT-5.5 prompt 现在属于历史案例，不应继续作为当前模板。文章里的配置修改应先当作 hypothesis，本地验证后再采用。

## GPT-5.6 Sol 更新（2026-07-10）

### 本机发现

Codex App 当前的模型目录把 `gpt-5.6-sol` 作为一套带有专属内置指令、reasoning presets、tool mode、context policy 和 multi-agent 行为的模型运行时。本次检查时，本机 app cache 显示其 context window 为 372k、effective context window 为 95%、默认 reasoning 为 `low`、支持到 `ultra`、默认 verbosity 为 low、使用 code-mode tools，并由 catalog 选择 multi-agent version。这些属于内部且受 rollout 影响的字段，应现场检查当前 cache，不应把本节数值当成稳定的公开契约。

检查发现全局配置仍残留两项旧设置：

- `model = "gpt-5.5"`；
- `model_instructions_file` 指向“降智”文章中发布的 GPT-5.5 instruction 副本。

这个 override 并不是当前 5.6 Sol prompt。它在内容和结构上都已有差异，并缺少当前原生 prompt 中的 skill-usage contract 等部分。`model_instructions_file` 会替换模型内置指令，因此即使切换了模型，保留旧文件仍会把后续模型锁在旧 prompt 上；这一替换语义可在 [Codex 官方配置参考](https://developers.openai.com/codex/config-reference/#configtoml) 中确认。

本机偏好是移除原生 prompt 中的 `## Intermediate commentary` section。这是参考文章后采用的 prompt experiment，不代表已经证明 commentary 必然截断隐藏推理。维护上的关键要求是每次实验都从当前 Sol prompt 出发，不能继续沿用旧 GPT-5.5 副本。

### 已应用的修复

全局配置现使用：

```toml
model_instructions_file = 'C:\Users\JAZ03\Documents\Codex\private\gpt-5.6-sol-base-without-commentary.md'

model = "gpt-5.6-sol"
model_reasoning_effort = "xhigh"
```

替换文件由当前 bundled `gpt-5.6-sol` 的 `base_instructions` 生成，只删除 `## Intermediate commentary` 到 `## Final answer` 之前的内容。本次检查时，原生 base 为 16,299 characters，生成后为 14,955；生成文件 SHA-256 为 `891867fd3815eecf80dbedd5072b3c72917bae9e0c9c64ab6495e4391314c059`。旧 GPT-5.5 文件只作为历史材料保留。`xhigh` 是本机 reasoning preference，不属于 prompt transformation。

Codex 或 Sol 更新后，应重新生成文件，不要手工维护整份复制 prompt：

```powershell
.\scripts\update-sol-prompt.ps1 `
  -OutputPath "$env:USERPROFILE\Documents\Codex\private\gpt-5.6-sol-base-without-commentary.md"
```

脚本会优先发现最新的 Desktop-managed CLI，读取 `debug models --bundled`，在 section boundaries 发生变化时拒绝生成，并输出 source/generated hash 供 review。

### 检查与验证

优先使用 Codex 自身提供的诊断入口：

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

`models_cache.json` 是内部缓存，只适合诊断，不应作为仓库中的固定源文件。`codex debug prompt-input` 用于查看生成后的 developer/user prompt layers，包括权限、环境上下文和已加载的 `AGENTS.md`；模型目录则提供 model-specific base instructions。全局配置变更后需要新建 task，让新的 prompt layers 重新构造。

比较 prompt 前先确认 executable provenance。本机同时存在 npm CLI、Desktop package CLI 和 Desktop-managed CLI，版本并不一致；`PATH` 中优先命中的 `codex` 与当前 Desktop runtime 的 bundled model catalog 也不完全相同。应结合 `codex doctor --json`、`Get-Command codex -All` 和 app cache 判断，不能默认每个本地 `codex.exe` 都代表正在运行的 task。

这个 source repo 本身包含将被安装到全局的同一份 `AGENTS.md`。当全局副本和仓库副本一致时，在本仓库内维护它可能同时加载两份；这是 source package 的局部重复。普通项目仍会加载全局文件和该项目自己的 guidance。

后续模型升级时，先检查 `model_instructions_file`，再从当前模型条目重新生成 override，并执行配对的 before/after eval。Codex Candy 适合作为 smoke signal，但不能单独承担 acceptance：固定 client、provider、model、reasoning 和任务设置，重复运行多个任务，并分别比较 correctness、latency、output tokens 与 reasoning tokens。每次 prompt experiment 都应保留 source hash、generated hash、removed section、rollback path 和前后测量结果。

## 维护说明

- 保持 `AGENTS.md` 简洁，并维持结构一致。
- 把详细触发条件放在对应 skill，不要塞回 `AGENTS.md`。
- 编辑 skill 后运行校验：

```powershell
$env:PYTHONUTF8 = "1"
python "$env:USERPROFILE\.codex\skills\.system\skill-creator\scripts\quick_validate.py" .\skills\discussion
python "$env:USERPROFILE\.codex\skills\.system\skill-creator\scripts\quick_validate.py" .\skills\reporting
python "$env:USERPROFILE\.codex\skills\.system\skill-creator\scripts\quick_validate.py" .\skills\case-study
python "$env:USERPROFILE\.codex\skills\.system\skill-creator\scripts\quick_validate.py" .\skills\agent-team-dev
python "$env:USERPROFILE\.codex\skills\.system\skill-creator\scripts\quick_validate.py" .\skills\story-telling
python "$env:USERPROFILE\.codex\skills\.system\skill-creator\scripts\quick_validate.py" .\skills\experiment
```

这个仓库刻意不包含单独 plugin layer 或 `specs/` routing system。它就是 plain files，这正是它的用途。
