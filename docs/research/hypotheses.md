# Candidate hypotheses (not findings)

**Frozen observation (2026-10-03):** v0 recommend-only skill + YAML policy exists; no calibrated personal prompt corpus in-repo; success metrics are Other Models spend, escalation share, and a subjective science-error journal.

**Stance:** N-of-1 personal quasi-experiments. Label exploratory vs confirmatory. Do not treat rejection of one null as proof of a mechanism.

## H1 — Rule router saves money without harming science journal

| Field | Content |
| --- | --- |
| Statement | Rule router + science strong-gate cuts Other Models $ vs “always Sonnet/Opus” without raising science-error journal rate |
| Claim type | Causal (assumption-heavy, N-of-1) |
| Status | `candidate` |
| Linked directions | D1, D8 |
| Prediction | Over ~4 weeks alternating policy intensity, Other Models $ is lower under orchestrator balance/eco than under always-strong, and science journal is not worse |
| Rivals | Auto alone matches policy; keyword over-triggers erase savings; journal under-reports errors |
| Falsify if | Spend not lower **or** science journal worsens under orchestrator weeks |

## H2 — Role subagents help refactors at similar cost

| Field | Content |
| --- | --- |
| Statement | Role subagents beat a single strong model on multi-file refactor at similar Other Models $ |
| Claim type | Comparative / associational |
| Status | `candidate` |
| Linked directions | D2, D9 |
| Prediction | Same class of refactor tasks: fewer reopen-fix loops at ≤ same Other $ |
| Rivals | Gains are from better prompting/plan→approve, not from multi-model roles |
| Falsify if | Reopen-fix loops do not fall, or Other $ rises materially |

## H3 — Test-gated code cascade beats always-Opus

| Field | Content |
| --- | --- |
| Statement | Test-gated code cascade reduces silent code failures more than always-Opus on hard code |
| Claim type | Comparative |
| Status | `candidate` |
| Linked directions | D3 |
| Prediction | Failures caught by lint/tests before escalate; Opus/Sol call count down vs always-hard |
| Rivals | Tests are weak oracles; cascade latency dominates UX cost |
| Falsify if | Silent failures do not fall, or hard-model calls do not fall without quality loss |

## H4 — Learned binary router beats rules after enough labels

| Field | Content |
| --- | --- |
| Statement | After ≥200 logged routes with explicit feedback, a learned binary strong/weak router beats rules on cost at iso-quality |
| Claim type | Predictive |
| Status | `candidate` (Phase 4 only if H1 plateaus) |
| Linked directions | D7 |
| Prediction | Holdout month: lower strong-model call rate; science journal not worse |
| Rivals | OOD vs Arena training (RouteLLM evidence of OOD collapse without augmentation); feedback too sparse/noisy |
| Falsify if | Holdout cost or journal worse than rules; **science hard-gate must remain even if router disagrees** |

## H5 — Capped BoN helps science; uncapped blows budget

| Field | Content |
| --- | --- |
| Statement | `/max` best-of-N reduces science journal errors but only if capped (e.g. ≤N BoN/month) |
| Claim type | Comparative |
| Status | `candidate` |
| Linked directions | D6 |
| Prediction | Uncapped BoN exhausts Other pool mid-cycle; capped BoN improves journal on tagged science tasks vs single strong call |
| Rivals | BoN gains are placebo (attention); single Opus already saturates quality |
| Falsify if | Capped BoN does not improve journal, or cap still exhausts budget |

## Visible nulls / rivals (global)

- Quality gains from BoN are placebo (attention effect).
- Built-in Auto/Router alone matches custom policy for your mix.
- Hindsight spam harms recall more than routing helps.

## Preregistration sketch (exploratory)

Before a measurement week, note in `docs/research/metrics-log.md` (create when first used):

- week dates, mode (`eco`/`balance`/`max`), whether BoN allowed
- planned tasks domain mix (ds / paper / code)
- which hypothesis is under informal test

Do not rewrite outcomes as a priori predictions after the week ends.
