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
| D13 | Plan shapes: mapper / specialist / pipeline / hybrid (from cursor-agent-orchestrator-mcp) | discussion | literature-inspired | advance (Phase 1) |
| D14 | Optional MCP propose→confirm→execute for Phase 1 (same gates as skill) | discussion | literature-inspired | optional Phase 1 |
| D15 | Specialist DAG + critique merge for `/max` reviews (dispatch-mcp pattern) under tier matrix | discussion | literature-inspired | advance (Phase 2) |
| D16 | Splitter step before spawn (which roles fire) — agent-squared pattern | discussion | literature-inspired | advance (Phase 1) |
| D17 | Compact handoff JSON between subagent hops (TOMAPE-style) | discussion | literature-inspired | advance (Phase 1–2) |
| D18 | Lean token/pool impact report beside `[route]` / Hindsight | discussion | literature-inspired | advance (Phase 0 measure) |
| D19 | Machine route fields `{tier, model, score?, reason}` (tgs-router-shaped) for learning | discussion | literature-inspired | advance (Phase 0–4) |
| D20 | Companion install of obra parallel-agent skills; our skill stays cost authority | discussion | mixed | Phase 1 optional |
| D21 | `/max` council (2–3 perspectives) only under BoN monthly cap | discussion | literature-inspired | Phase 2 under cap |

## Working prioritization (decision aid, not truth)

Advance: **D1 → D18/D19 → D2/D13/D16/D17 → D3/D8 → D15/D6/D21 → D7 → D10**.  
Optional: **D14, D20**.  
Park: **D11, D12**, multi-CLI daily routing.  
Restrict: **D5** (never as science final path); **D21** only with hard BoN cap.

Ecosystem scan: [orchestrator-ecosystem-2026-10.md](orchestrator-ecosystem-2026-10.md).

## Adversarial notes

- Keyword false-positives can overspend Other Models (`idea`).
- Uncapped BoN can exhaust the $20 pool (`idea`).
- Arena-trained learned routers may not transfer to RU academic/econometrics prompts (`assumption`; see landscape note OOD evidence for RouteLLM).
- Cascades add latency against long agent sessions (`idea`).
- Hindsight spam can hurt recall more than routing helps (`rival` to logging-heavy designs).
- Companion skills (obra/warp) can override cost policy if installed without our skill as authority (`idea`).
- External gateways “save” Cursor Other Models while billing a second wallet (`rival` to D12 / OmniRoute-as-default).

## Literature cross-check

Primary-source summaries: [llm-routing-landscape-2026-10.md](llm-routing-landscape-2026-10.md), [orchestrator-ecosystem-2026-10.md](orchestrator-ecosystem-2026-10.md) (GitHub + skills.sh, 2026-10-03).  
Post-check reopen: D13–D21 added from ecosystem scan; prioritization reordered to put measure fields (D18/D19) early.  
No direction auto-selected as “winner”; phases encode the working order above.
