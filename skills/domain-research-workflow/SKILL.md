---
name: domain-research-workflow
description: >
  Use for research and academic workflows: paper planning, proposal writing, related work,
  experiment design, baseline reproduction, model evaluation, datasets, GPU or large compute runs,
  ablations, metrics, reproducibility, ref/ repository curation, literature-to-experiment
  pipelines, or research artifacts that combine narrative and empirical evidence. Trigger on
  "科研", "论文", "proposal", "related work", "baseline", "实验", "ablation", "dataset",
  "benchmark", "复现", "GPU", "训练", "evaluation plan", "research project", or "academic".
---

# Domain Research Workflow

Use this skill when the project is research-shaped rather than ordinary product engineering.

## Load

Read these specs as needed:

1. `AGENTS.md`
2. `CLAUDE.md`
3. `specs/codex-adapter/CLAUDE.md` when running in Codex
4. `specs/phased-workflow/CLAUDE.md`
5. `specs/story-telling/CLAUDE.md` for papers, proposals, and reports
6. `specs/experiment/CLAUDE.md` for compute, datasets, baselines, refs, and reproducibility
7. `specs/pge-orchestration/CLAUDE.md` for implementation/evaluation loops

## Apply

- Treat `brief/` and project notes as source material.
- Use story sections for claims, motivation, related works, method, evaluation plan, and feasibility.
- Use experiment discipline before compute-heavy work: env snapshot, artifact gate, run directory, and experiment log.
- Cite concrete run ids or reference entries when research conclusions depend on experiments.

## Do Not Use

- Do not use for ordinary coding tasks with no research artifact or experiment discipline.
