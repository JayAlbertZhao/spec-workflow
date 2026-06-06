# Spec: Experiment

**Load when**: project runs heavy experiments — GPU/TPU compute, large model checkpoints, datasets that don't fit casually on disk, training or evaluation runs whose state must be reproducible.

This spec governs the **resource and reproducibility discipline** that's common to deep-learning research, model evaluation, ML systems work, and similar heavyweight experimental workflows. It composes with `pge-orchestration` (each experiment iteration as a sprint), `phased-workflow` (experiments live inside an autonomous phase), and `story-telling` (results feed sections of a research narrative).

## Environment Detect (always first)

Before any sprint that consumes compute or storage, run an environment detect and write the result to `.agents/env.md`. The orchestrator spawns an **env-detector** sub-agent for this; spawn template at `./specs/experiment/prompts/env-detector.md`.

`.agents/env.md` records (at minimum):
- GPU model, count, free / total VRAM (`nvidia-smi`)
- CUDA driver and toolkit versions
- Disk free on the working filesystem and on any data drive (`df -h`)
- RAM total and free (`free -h`)
- Python version, key library versions (`torch`, `transformers`, etc., per project relevance)
- A timestamp

Re-run env-detect when entering a new phase, or when a sprint fails with a suspected resource cause. Do not modify `.agents/env.md` other than via the env-detector.

## Reference Library Curation

Many experiments depend on cloned external repositories — baselines, frameworks, datasets-as-code. Spawn a **ref curator** sub-agent to act on these rules; spawn template at `./specs/experiment/prompts/ref-curator.md`.

### Budget

Default cap: **≤ 5 repos** per project, declared in the project's CLAUDE.md if different.

### Selection Criteria (in priority order)

1. Official implementation of a top baseline named in the project's deliverable
2. Implementation that includes loaders for the project's target datasets
3. Framework or toolkit broadly used in the area
4. Reference implementation of the closest existing method to the proposed direction

### Cloning Convention

```bash
cd ref/
git clone --depth 1 <url> <short-name>
```

- Always `--depth 1` (disk discipline; this is reference, not history)
- Short, descriptive directory name; no `owner-name-fork-v2` ceremony
- **Never modify a `ref/` repo in place** — they are read-only references. Apply patches via a project-local script, not by editing.

### Replacement

If a chosen repo turns out to be unusable (broken setup, missing weights, license incompatible), the curator may replace it within the budget. Replacement uses the revision protocol from `story-telling` if the repo list is part of the story; otherwise just update the project's tracking section.

## Large Artifact Gate

Any of these requires explicit user confirmation **before** the action:

- Cloning a repo > 1 GB
- Downloading a dataset > 1 GB
- Downloading a model checkpoint > 1 GB
- Allocating > 50% of free disk on the working filesystem in a single step
- Running a process projected to take > 30 minutes of GPU time

The orchestrator surfaces the action, the size estimate, and the resource impact (vs. `.agents/env.md`) and waits for a yes. This is a hard rule — do not pre-emptively download "to save the user time."

## Reproducibility Discipline

Every experiment run is a **sealed unit** with a fixed config and recoverable outputs.

### Run directory layout

```
experiments/<run-id>/
├── config.yaml      # exact hyperparameters, seeds, dataset paths, model paths
├── env.md           # snapshot of .agents/env.md at run start (immutable)
├── log/             # stdout, stderr, training logs
├── checkpoints/     # model weights, optimizer state (if produced)
└── result.md        # final metrics, plots, conclusion (one page)
```

`<run-id>` convention: `<YYYYMMDD>-<short-tag>-<seed>`, e.g. `20260524-baseline-42`.

### Required at run start

- Set seeds deterministically (`torch.manual_seed`, `numpy.random.seed`, `random.seed`, plus framework-specific equivalents)
- Pin library versions in `requirements.txt` (or pyproject equivalent); refuse to start a run if `pip freeze` diverges from the lockfile beyond a documented set of dev tools
- Record the git SHA of the project repo in `config.yaml`
- Snapshot `.agents/env.md` into the run directory

### Required at run end

- Write `result.md` with a one-page summary: setup, headline metrics, what to compare against, link to log
- Update the project's experiment log (`.agents/experiment-log.md`) with one row: `<run-id> | <intent> | <verdict> | <key metric>`

## Failure Recovery

When a sprint fails (PGE evaluator says FAIL, or the run crashed):

- Do **not** delete the failed `experiments/<run-id>/` — the next round needs it for diff
- Do not silently reuse cached datasets / checkpoints from the failed run; if the failure root-caused to a corrupted artifact, name the artifact in `feedback.md` and rebuild it
- If a checkpoint produced by a failed run is being kept for later analysis, note this in `result.md` with a `STATUS: failed-but-retained` line

## Communication Files

```
.agents/
├── env.md                # env-detector output; immutable except via env-detector
└── experiment-log.md     # append-only run log: <run-id> | <intent> | <verdict> | <key metric>
```

## Composition Notes

- **With `phased-workflow`**: experiments live inside autonomous phases. Resource implications surfaced at checkpoints come from this spec's env detect + large-artifact gate accounting.
- **With `pge-orchestration`**: each experiment iteration is a sprint. The Generator runs the training/eval; the Evaluator reads `result.md` and checks acceptance against the sprint contract. The "do not delete failed runs" rule supersedes any sprint cleanup.
- **With `story-telling`**: experiment results feed numbered sections (typically results/evaluation). Cite specific `<run-id>`s in the story so the artifact is traceable.

## NEVER

- Skip env-detect at phase entry or after suspected-resource failures
- Cross the large-artifact gate without explicit user confirmation
- Modify a `ref/` repo in place
- Delete a failed `experiments/<run-id>/` directory
- Run an experiment without a fixed seed and pinned library versions
- Hand-edit `.agents/env.md` (always re-run the detector)

## ALWAYS

- Run env-detect on entering an experiment phase; re-run on suspected resource failures
- Snapshot env into each run directory at run start
- Use `--depth 1` for `ref/` clones
- Append one row to `.agents/experiment-log.md` at run end (success or failure)
- Surface resource costs at every `phased-workflow` checkpoint when this spec is loaded
