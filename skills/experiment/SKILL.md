---
name: experiment
description: 'Use for experiment design, execution, or analysis: baseline reproduction, datasets, benchmarks, ablations, model evaluation, metrics, GPU or large-compute runs, training, reproducibility, run logs, artifact hygiene, ref/ repository curation, or tasks phrased as 实验, baseline, reproduction, 复现, benchmark, dataset, ablation, evaluation, GPU, 训练, 指标, run, or experiment plan.'
---

# Experiment

Use this skill when the work needs reproducible empirical evidence rather than
only code changes or prose.

## Experiment Contract

Define before running:

- Research or engineering question.
- Hypothesis and baseline.
- Dataset, inputs, filters, and exclusions.
- Metrics, denominators, success criteria, and guardrails.
- Compute budget, environment, and expected artifacts.
- Known threats to validity.

If the question is not clear enough to choose metrics or data, clarify before
starting expensive work.

## Artifact Layout

Prefer a run directory shaped like:

```text
experiments/YYYYMMDD-short-slug/
  README.md              # question, hypothesis, commands, status
  configs/               # exact configs used
  data/                  # small derived inputs or pointers to large data
  runs/<run-id>/          # logs, metrics, outputs, checkpoints or pointers
  analysis/              # notebooks, scripts, figures, summaries
```

Do not commit large datasets, checkpoints, secrets, or credentials. Store
pointers and reproduction instructions instead.

## Workflow

1. Inspect prior runs, existing scripts, environment files, and data contracts.
2. Snapshot the environment before changing it: OS, GPU if relevant, Python or
   runtime version, package manager, key dependency versions, and git commit.
3. Use isolated environments. For Python package changes, prefer Conda and do
   not install packages into base Python with `pip`.
4. Run the smallest dry run that can expose configuration, data, or dependency
   failures.
5. Execute controlled runs with stable run ids. Capture commands, stdout/stderr,
   metrics, and artifact paths.
6. Analyze results against the original metric contract. Separate measured
   results from interpretation.
7. Report reproducibility: exact commands, inputs, environment, output paths,
   known gaps, and rerun cost.

## Ref And Data Hygiene

- Treat external repositories under `ref/` as read-only unless the user asks to
  patch them.
- Record source URL, commit/tag, license constraints when curating references.
- Do not silently reuse caches after data or checkpoint corruption. Name the
  suspect artifact and rebuild or quarantine it.
- For long runs, prefer resumable checkpoints and periodic metric snapshots.

## Analysis Checklist

- Are metrics computed at the right grain?
- Are denominators and exclusions explicit?
- Is the comparison against a fair baseline?
- Did random seeds, sampling, or caching affect the result?
- Is the conclusion supported by the measured evidence?

## Do Not

- Do not start expensive compute without a clear metric contract.
- Do not treat a successful script run as proof that the result is meaningful.
- Do not hide failed runs; record them when they affect interpretation.
- Do not overgeneralize beyond the data, benchmark, or environment tested.
