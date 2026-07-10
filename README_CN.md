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

## Repair Instructions for Codex

### 为什么需要这个修复

`model_instructions_file` 会替换模型内置指令。旧模型复制出来的 prompt 即使在 model selector 切换到 Sol 后仍可能继续覆盖原生 prompt，导致新的 skill contract 等行为无法进入运行时。这一替换语义可在 [Codex 官方配置参考](https://developers.openai.com/codex/config-reference/#configtoml) 中确认。

这个方案面向明确希望移除 Sol 原生 `## Intermediate commentary` section 的用户。它从当前 bundled `gpt-5.6-sol` prompt 生成新的 override，只删除 `## Intermediate commentary` 到 `## Final answer` 之间的内容，不复用参考文章中的旧 GPT-5.5 prompt。

### Codex 操作指南

当用户要求应用这个修复时，Codex 应当：

1. 检查当前 Codex 安装、全局 `config.toml`、可用时的 task metadata，以及 Desktop-managed model catalog。不能默认 `PATH` 中第一个 `codex` 就是 Codex App 使用的 runtime。
2. 读取当前 bundled `gpt-5.6-sol` 的 `base_instructions`。`models_cache.json` 只作为诊断状态使用，不得修改。
3. 确认 source 中恰好存在一个 `## Intermediate commentary` section，且其后存在 `## Final answer`。marker 缺失、重复或顺序异常时停止，不写文件。
4. 生成 minimal-difference prompt，只删除从 `## Intermediate commentary` 开始到 `## Final answer` 之前的内容，保留 `## Final answer` 及其后续内容。
5. 把生成文件写入用户自己的 Codex home，优先使用 `~/.codex/prompts/gpt-5.6-sol-base-without-commentary.md`；如果用户已经指定其他 private path，则沿用用户路径。
6. 在用户全局 `config.toml` 中把 `model_instructions_file` 更新为生成文件的绝对路径。保留其他无关配置；除非用户明确要求，否则不要改变 model 和 reasoning preference。
7. 验证 source/generated hash，确认 commentary 已移除且 `## Final answer` 仍存在，运行 `codex doctor`，并向用户报告实际使用的路径和证据。
8. 告知用户新建 task。现有或恢复的旧 task 可能继续保留创建时序列化的 prompt。

不得执行从本仓库下载的脚本，不得复用旧模型的完整 prompt，不得硬编码其他用户的 private path，不得修改 model cache，也不得把 config parse 成功当作模型质量已经改善的证明。

### 验收与回滚

验收要求包括：prompt 来源是当前已安装的 Sol catalog、只删除一个目标 section、全局 config 有效，并完成 fresh-task check。Codex Candy 可以作为 smoke signal；质量结论需要在固定 client、provider、model、reasoning 和 task settings 的条件下进行配对 before/after runs。

需要回滚时，从全局 `config.toml` 删除 `model_instructions_file` 并新建 task，Codex 应恢复使用模型未修改的内置指令。

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
