---
name: case-study
description: Use when the user explicitly asks for case-study, study, 案例, or 案例分析, or when reviewing bad cases, investigating projects, doing root-cause or first-principles analysis, evaluating product/workflow/research decisions, or working from user-provided concrete examples.
---

# Case Study

Use this skill for case-style investigation. Trigger actively in investigative work; keep the method evidence-oriented and label data gaps clearly.

## Trigger Conditions

Trigger when either condition holds:

- The user explicitly asks for case-study, study, 案例, 案例分析, or investigation of a named case/example.
- The work is investigative and benefits from case-level evidence: bad-case review, project investigation, root-cause or first-principles analysis, product/workflow/research evaluation, report/audit preparation, or user-provided concrete examples.

## Data-Driven Method

Treat case study as data-driven method rather than a passive trigger. Actively look for inspectable evidence: production data, logs, traces, metrics, support tickets, incident records, datasets, benchmark outputs, experiment results, failed outputs, screenshots, transcripts, repository artifacts, issue threads, external sources, or user-provided examples.

When evidence is missing, continue only at the appropriate confidence level: state the data gap, separate evidence-backed findings from hypotheses or scenario reasoning, and ask for data only when the missing evidence blocks the requested analysis.

## Case Contract

- Prefer real, inspectable evidence over synthetic examples.
- Clearly mark synthetic or hypothetical material as scenario reasoning.
- If the user provides a case or example, investigate that case first and preserve its context before writing broader synthesis.
- If the user explicitly asks to investigate a case or example, produce a standalone case investigation before any overall report or synthesis.
- When current facts, source verification, or concrete external examples matter, consult reliable web or local sources.
- Separate data, observed facts, source-specific observations, interpretations, transferable principles, non-transferable details, and open gaps.

## Coverage Pattern

When the subject allows it, include:

- Typical Case: the normal data slice or observed case that reveals the main mechanism.
- Corner Case: a boundary, failure, adversarial, or unusual data slice that tests the mechanism.
- Trivial Case: the minimal baseline or null slice that exposes hidden assumptions or clarifies what changes when complexity is added.

Skip a case type only when it would be artificial or unhelpful, and say what evidence is missing if the gap matters.

## Output Shape

Use the smallest structure that preserves the case:

1. Case frame: context, actor, goal, environment, and why this case is relevant.
2. Data and evidence: source, sample, filters, measurement method, and known quality limits.
3. Observed facts: what is directly supported by sources or inspected material.
4. Mechanism: what produced the outcome or behavior.
5. Constraints and corner cases: where the mechanism breaks, weakens, or changes.
6. Transferable lessons: principles that plausibly generalize.
7. Non-transferable details: context that should not be copied blindly.
8. Open gaps: missing evidence, unresolved contradictions, and confidence limits.

## Guardrails

- Do not let one case dictate the whole answer when the question needs broader synthesis.
- Do not imitate surface form; extract mechanisms and constraints.
- Do not erase inconvenient case details to make the lesson cleaner.
- Do not present a case as proof of a universal rule.
- Do not present a hypothetical example or pure reasoning exercise as data-backed.
