# Routing policy

## Product stance

- **Plan:** Cursor Pro ($20) — Cursor Models pool + Other Models ~$20
- **Daily driver:** Auto/Router when available; this policy overlays escalation rules
- **Doctrine:** Other Models **plan/analyze**; Composer / Grok **execute** code and file ops
- **Conflict resolution:** quality under a hard Other Models budget — spend Other on thinking, not on typing code
- **User language:** Russian explanations; configs/docs English
- **Privacy:** stack Hindsight retain is lean route metadata only — never prompts/PII ([hindsight-schema.md](hindsight-schema.md), [legal/privacy.md](legal/privacy.md))
- **Scope:** recommend-only overlay; not a hosted AI product by itself ([legal/ai-act-disclosure.md](legal/ai-act-disclosure.md))

## Decision pipeline

1. Detect slash mode (`eco` / `max` / default `balance`)
2. Detect project type (tags → paths → markers)
3. Classify task tier (keywords + severity)
4. Detect **phase** (`роль=план|код|анализ`) from `phases` in `routes.yaml`
5. Refresh budget snapshot if stale (`sync_budget.py`) → `budget` (`ok` / `warn` / `exhausted`) and resolved `pool`
6. Map: plan/analyze → `logical_model[mode]`; execute → `executor_logical[mode]` → display name
7. Resolve `shape` from `plan_shapes.by_tier` (hint only; no spawn)
8. Fable HITL if needed
9. Emit Russian `[route]` with machine fields + lean Hindsight log
10. Continue: planner elaborates → approve → switch to Composer/Grok to execute

### [route] machine fields (v0.2)

```text
[route] project=… tier=… model=… mode=… pool=… budget=… shape=… роль=<план|код|анализ>
почему: …
действие: …
```

Required every turn: `tier`, `model`, `mode`, `pool`, `budget`, `shape`, `роль`.

## Doctrine summary

| Never Other for | Prefer Other for |
| --- | --- |
| write_code, apply_patches, file_edits | detailed plans, architecture, science Q&A, design briefs |
| routine reads in execute phase | reviewing plans / specs |

Handoff (RU): after approve, switch chat to Composer 2.5 and run the plan step by step.

## Tier matrix (balance, budget OK)

| Tier | Pool | Plan / analyze | Execute (код) |
| --- | --- | --- | --- |
| quick_edit | cursor | — | Auto / Composer 2.5 |
| default_code | cursor | — | Auto / Composer 2.5 |
| research_docs | cursor | Composer (or Sonnet if deep) | Composer 2.5 |
| cursor_meta | cursor | — | Composer 2.5 |
| docs_office | cursor/other | Sonnet if academic prose | Composer 2.5 |
| frontend_design | mixed | Claude Sonnet 5 | Grok 4.7 |
| paper | other | Claude Sonnet 5 | Composer if code tooling |
| science_stats | mixed | Claude Sonnet 5 | Composer 2.5 |
| refactor_architecture | mixed | Claude Opus 5 | Composer 2.5 |
| long_agent | mixed | Claude Opus 5 | Composer 2.5 |
| parallel_roles | mixed | role map (advise) | coder = Composer |

### max upgrades (planners only)

- science_stats / paper → Claude Opus 5
- refactor / long_agent → GPT-5.6 Sol or Claude Opus 5
- execute path unchanged

### eco / exhausted / hard-block (one shared Cursor-only matrix)

**Triggers (same resolver):** `/eco`, `remaining_usd <= 0`, hard-block at 80% spent without override.

Canonical source: `exhausted_policy` + `logical_model.eco` in [`config/routes.yaml`](../config/routes.yaml).

| Tier | Cursor-only model | RU warning |
| --- | --- | --- |
| `quick_edit` | Composer 2.5 | none |
| `default_code` | Auto / Composer 2.5 | none |
| `research_docs` | Composer 2.5 | none |
| `cursor_meta` | Composer 2.5 | none |
| `docs_office` | Composer 2.5 | if academic → use `paper` row |
| `frontend_design` | Grok 4.7 | Other исчерпан — UI на Grok |
| `paper` | Grok 4.7 | quality risk vs Sonnet |
| `science_stats` | Grok 4.7 | **mandatory:** нет Sonnet/Opus; перепроверь цифры |
| `refactor_architecture` | Grok 4.7 | quality risk |
| `long_agent` | Grok 4.7 | quality + plan→approve |
| `parallel_roles` | `role_map_exhausted` | list role→Cursor model |

**Exhausted role remap** (`parallel_roles.role_map_exhausted`):

| Role | Model |
| --- | --- |
| planner | Grok 4.7 |
| coder | Composer 2.5 |
| reviewer | Grok 4.7 |
| researcher | Grok 4.7 |
| verifier | Grok 4.7 |
| scientist | Grok 4.7 (+ science warning) |

**Display rule:** `[route]` shows `mode=eco` or `budget=exhausted` and a **Cursor** display name — never a phantom Other model.

## HITL

Only **Claude Fable** requires confirmation. Opus/Sol may auto as planners on hard tiers when allowed.

## Budget

**Policy:** [`config/budget.yaml`](../config/budget.yaml) — thresholds (`warn_at_ratio`, override).

**Live spend:** `python scripts/sync_budget.py` → gitignored [`config/budget.local.yaml`](../config/budget.local.example.yaml) from Cursor dashboard `apiPercentUsed` (Other Models). Auth: local Cursor `state.vscdb` or `CURSOR_SESSION_TOKEN`. Skill refreshes when older than `sync_ttl_minutes` (60) or on «синхронизируй бюджет» / `/budget sync`.

- `spent_ratio = api_percent_used / 100` when local snapshot exists
- warn + block hard Other at `warn_at_ratio` (default 0.8) → Cursor-only matrix above
- force eco when `spent_ratio >= 1` / remaining ≤ 0 → same matrix
- override: `/max force` or «разреши дорогие модели»
- Fail-soft: sync error → last local + `budget_source=stale`; never synced → manual `remaining_usd` in `budget.yaml`

When Other is empty and science is critical: after the Cursor-only (Grok) warning, offer wait-for-reset or BYOK — **never** silently route to Other without budget/BYOK.

## Cascade matrix (v2 — not executed in v0)

| Domain | Strategy |
| --- | --- |
| code | run lint/tests; escalate if fail |
| science_stats | strong-first already; no cheap pass |
| prose/docs | heuristic checklist; escalate if fail |
| ambiguous non-science | cheap verifier model then escalate |

## Best-of-N (v2)

- Allowed only in `/max`
- Forbidden in `/eco`
- 2–3 models → pick/merge instruction
- v0: may *mention* BoN as future action, must not run it

## Role map (v1 spawn / v0 advise)

| Role | Model |
| --- | --- |
| planner | Claude Opus 5 |
| coder | Composer 2.5 |
| reviewer | Claude Sonnet 5 |
| researcher | GPT-5.6 Terra |
| verifier | Grok 4.7 |
| scientist | Claude Opus 5 |

## Plan shapes (recommend hints only)

Canonical source: `plan_shapes` in [`config/routes.yaml`](../config/routes.yaml).

| Tier | shape | Notes |
| --- | --- | --- |
| `parallel_roles` | `specialist` | Splitter lists role_map roles; **do not spawn** |
| `refactor_architecture` | `pipeline` | Hint: planner→coder→reviewer→verifier |
| `long_agent` | `hybrid` | Hint: planner→coder→reviewer |
| `science_stats` | `none` | Single strong path |
| other tiers | `none` | — |

`splitter_hint: true` means one RU line in `действие` naming roles that would fire. Execution remains recommend-only until Phase 1.

## Profiles

- **core** — routing only ([integrations/core.md](integrations/core.md))
- **stack** — soft Hindsight via [cursor-hindsight-ondemand](https://github.com/dapetun/cursor-hindsight-ondemand) + optional GitNexus ([integrations/stack.md](integrations/stack.md))

## Related docs

- [classifier.md](classifier.md)
- [hindsight-schema.md](hindsight-schema.md)
- [roadmap.md](roadmap.md)
- [acceptance-v0.md](acceptance-v0.md)
