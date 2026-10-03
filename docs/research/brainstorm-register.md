# Brainstorm register — orchestrator research directions

**Session focus:** How should the personal Cursor Pro orchestrator evolve over 12–24 months so Other Models stay near ~$20/mo while science/stats silent-error risk falls and daily UX stays friction-light?

**Decision owner:** Даниил  
**Stage:** `discussion`  
**Origin of this register:** `AI-assisted` (scientific-brainstorming workflow; not a finding)  
**Date:** 2026-10-03  

All rows below are **ideas / proposals**. They are not validated results.

## Constraints (recorded)

| Kind | Item |
| --- | --- |
| Real | Other Models ~$20/mo hard preference; skill cannot force model picker; RU user-facing route line; plan→approve; Fable HITL; science never cheap-first final; Auto overlay preferred |
| Assumed | Hindsight lean logs will be usable later for learning; acceptance scenarios approximate real mix |
| Negotiable | Exact BoN monthly cap; whether GitNexus is required on every code route |
| Unknown | When Cursor Router Balance/Intelligence fully lands for individual Pro |

## Predeclared criteria (before ranking)

| Criterion | Direction | Notes |
| --- | --- | --- |
| cost_fit | higher | Stay inside Other Models ~$20 |
| science_safety | higher | Fewer silent stats/science errors |
| cursor_feasibility | higher | Skill/SDK without picker APIs |
| ux_friction | higher | Less friction (plan→approve + short RU route) |
| reversibility | higher | Easy disable/rollback |

**Hard gates (non-compensatory):** no Fable without HITL; no science cheap-first final; must not require leaving Cursor for daily use.

## Candidate directions

| ID | Statement | Stage | Origin | Status |
| --- | --- | --- | --- | --- |
| D1 | Keep rule router + harden science gate; measure spend vs error journal | discussion | AI-assisted | advance (Phase 0) |
| D2 | Role-specialized SDK/Task subagents (scientist/reviewer/coder) | discussion | AI-assisted | advance (Phase 1) |
| D3 | Code cascade: lint/tests then escalate (FrugalGPT-style for verifiable tasks) | discussion | AI-assisted + literature-inspired | advance (Phase 2) |
| D4 | Prose/docs heuristic verifier before Other Models spend | discussion | AI-assisted | advance (Phase 2) |
| D5 | AutoMix-like self-verify — disabled as final path for `science_stats` | discussion | literature-inspired | restricted use only |
| D6 | `/max` best-of-N with hard monthly BoN budget cap | discussion | AI-assisted | advance (Phase 2) |
| D7 | Learn binary strong/weak router from Hindsight logs + thumbs (RouteLLM-inspired) | discussion | literature-inspired | Phase 4 if H1 plateaus |
| D8 | Soft spend controller (warn@80%, remaining-$ policy) | discussion | AI-assisted | advance (Phase 0/3) |
| D9 | GitNexus-conditioned routing for coding repos only | discussion | AI-assisted | Phase 1 optional |
| D10 | Team packaging of skill+YAML after personal metrics stabilize | discussion | AI-assisted | Phase 5 |
| D11 | Local/offline models | discussion | AI-assisted | parked |
| D12 | External LiteLLM/OpenRouter as primary gateway | discussion | literature-inspired | parked |

## Working prioritization (decision aid, not truth)

Advance: **D1 → D2 → D3/D8 → D6 → D7 → D10**.  
Park: **D11, D12**.  
Restrict: **D5** (never as science final path).

## Adversarial notes

- Keyword false-positives can overspend Other Models (`idea`).
- Uncapped BoN can exhaust the $20 pool (`idea`).
- Arena-trained learned routers may not transfer to RU academic/econometrics prompts (`assumption`; see landscape note OOD evidence for RouteLLM).
- Cascades add latency against long agent sessions (`idea`).
- Hindsight spam can hurt recall more than routing helps (`rival` to logging-heavy designs).

## Literature cross-check

Primary-source summary: [llm-routing-landscape-2026-10.md](llm-routing-landscape-2026-10.md).  
After evidence check, no direction was auto-selected as “winner”; phases encode the working order above.
