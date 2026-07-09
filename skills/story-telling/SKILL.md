---
name: story-telling
description: 'Use for long-form structured writing and narrative synthesis: RFCs, design docs, proposals, technical memos, multi-section Markdown, writing plans, section-by-section drafting, document review, revision cascades, or tasks phrased as 写文档, 叙事, 章节, 大纲, 草稿, 评审文稿, story, narrative, long-form doc, or storytelling.'
---

# Story Telling

Use this skill when the deliverable is a structured document whose sections
depend on shared context, evidence, argument, or reader goals.

## Reader Contract

Before drafting, identify:

- Reader and decision context.
- Question the document must answer.
- Evidence available and evidence still missing.
- Required tone, language, format, and depth.
- Failure modes: vague thesis, unsupported claims, biased examples, hidden
  assumptions, or sections that do not connect.

## Workflow

1. Gather source material. Read provided files or links before relying on
   memory. Browse when current facts or external cases matter.
2. Build the document spine: central answer, argument sequence, section list,
   and what each section must prove.
3. Draft from the spine, not from source order. Preserve source context while
   synthesizing across sources.
4. Mark claims by evidence strength when stakes are high: verified fact,
   engineering inference, interpretation, or open gap.
5. Include case studies when they improve understanding. Prefer real cases;
   use synthetic examples only when abstraction is requested or no real case is
   available.
6. Run adversarial review before treating the document as ready: counterexamples,
   weak evidence, alternative explanations, and likely reader objections.
7. Finish with a concise reproducibility or source trace when the document is a
   report, audit, research note, or reusable analysis.

## Default Structure For Long-Form Documents

Use Chinese by default when writing for this user unless requested otherwise.

1. Purpose and reader context.
2. Central thesis or design intent.
3. Section sequence and what each section must prove.
4. Evidence, examples, or decisions needed by each section.
5. Risks, alternatives, and unresolved questions.
6. Revision checklist.

Use `reporting` for reports, research notes, audits, summaries, or evidence-backed delivery documents. Use `case-study` when concrete cases or examples should ground the document.

## Revision Discipline

- Preserve the user's intended scope; do not take over the decision.
- Separate facts, interpretations, preferences, decisions, and open questions.
- Prefer explicit constraints, schemas, validation rules, and counter-rules over
  few-shot examples.
- Use XML for complex prompt structures and JSON for machine-readable data.

## Do Not

- Do not restate sources mechanically.
- Do not smooth conflicting evidence into a convenient single story.
- Do not quote noisy ASR, OCR, scraping output, or search snippets as authority.
- Do not bury the main answer after process narration.
