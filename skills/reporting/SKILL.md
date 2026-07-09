---
name: reporting
description: Use when the user asks to 汇报 or report, or when producing a user-facing report, research note, technical analysis, review, audit, summary, delivery document, or evidence-backed Markdown analysis.
---

# Reporting

Use this skill when the output must help a human reader understand conclusions, evidence, uncertainty, implications, and next actions.

## Report Contract

- Produce Markdown unless the user requests another format.
- Write in Chinese by default. For important terms, use `English（中文）` on first appearance, then use English.
- If the user gives no special constraints, default to a detailed, source-backed report.
- Start with a sharp, compressed Overview that states the central answer, argument structure, and most decision-relevant findings.
- Put conclusions, mechanisms, and decision-relevant analysis in the main body. Put commands, file paths, raw logs, tool output, and pipeline details in appendices unless central to the argument.
- Use `case-study` for explicit case-study requests, bad-case reviews, project investigations, root-cause or first-principles analysis, and reports that benefit from case-style investigation.
- If the user specifically asks to investigate a case or example, run `case-study` first, produce a standalone case investigation section or report, and preserve those findings before writing broader synthesis.

## Evidence Discipline

- Ground non-trivial claims in reliable sources, inspected files, measured outputs, or clearly identified evidence.
- Mark major claims as verified fact, engineering inference, interpretation, or open gap when stakes are high.
- Avoid unsupported recommendation, probability, or necessity wording; tie "should", "likely", and "possible" to evidence or label them as interpretation.
- Clean noisy evidence before citing it. Do not quote low-quality ASR, OCR, scraping output, or search snippets as authoritative text.
- Preserve conflicting evidence and source disagreement instead of smoothing it into one convenient narrative.
- Browse or inspect primary sources when current facts, external references, or precise attribution matter.
- For high-stakes reports, reduce bias with relevant skills, independent review, or subagents when available; avoid seeding reviewers with the desired conclusion.

## Analysis Discipline

- Use first-principles reasoning to identify the focused question, core constraints, assumptions, and success criteria before analyzing evidence.
- Synthesize across sources and cases; do not mirror one source's framing, sequence, terminology, or emphasis unless that is itself the subject.
- Include adversarial review for important conclusions: counterexamples, hidden assumptions, weak evidence, alternative explanations, failure modes, and confidence limits.
- Do not treat passing tests, generated files, or successful scripts as proof that the report is good; verify against the reader goal.

## Media And Reproducibility

- When high-value media sources are relevant, convert them into inspectable evidence with ASR, OCR, subtitles, frame extraction, or other appropriate tools.
- Persist extracted media evidence when it may be needed for review, citation, reproduction, or later skill creation.
- When useful for quantitative explanation, use appropriate scientific plotting tools to produce statistical charts.
- When useful for conceptual explanation and no concrete source image is available, use `imagegen` to generate explanatory diagrams or illustrations.
- Distinguish extracted source evidence from generated explanatory media.
- Include a concise reproducibility trace for reports, audits, research notes, and reusable analysis: sources, search/query strategy, key commands or tools, data-processing steps, output paths, and known gaps.

## Default Structure

1. Overview.
2. Context and focused question.
3. Evidence and case study.
4. Mechanism or analysis.
5. Implications and recommendations.
6. Adversarial review: limits, counterexamples, uncertainty.
7. Reproducibility trace or source notes.
