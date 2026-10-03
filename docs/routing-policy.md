# Routing policy

## Product stance

- **Plan:** Cursor Pro ($20) — Cursor Models pool + Other Models ~$20
- **Daily driver:** Auto/Router when available; this policy overlays escalation rules
- **Conflict resolution:** quality under a hard Other Models budget
- **User language:** Russian explanations; configs/docs English

## Decision pipeline

1. Detect slash mode (`eco` / `max` / default `balance`)
2. Detect project type (tags → paths → markers)
3. Classify task tier (keywords + severity)
4. Apply budget guard → `budget` (`ok` / `warn` / `exhausted`) and resolved `pool`
5. Map tier+mode → logical model → display name
6. Resolve `shape` from `plan_shapes.by_tier` (hint only; no spawn in v0.1)
7. Fable HITL if needed
8. Emit Russian `[route]` with machine fields + lean Hindsight log
9. Continue plan → approve

### [route] machine fields (v0.1)

```text
[route] project=… tier=… model=… mode=… pool=… budget=… shape=…
почему: …
действие: …
```

Required every turn: `tier`, `model`, `mode`, `pool`, `budget`, `shape`.

## Tier matrix (balance, budget OK)

| Tier | Pool | Model | Cheap-first? |
| --- | --- | --- | --- |
| quick_edit | cursor | Auto / Composer 2.5 | n/a |
| default_code | cursor | Auto / Composer 2.5 | n/a |
| research_docs | cursor | Auto / Composer 2.5 | n/a |
| cursor_meta | cursor | Composer 2.5 | n/a |
| docs_office | cursor/other | Auto / Composer (Sonnet if academic) | no special dump |
| frontend_design | other | Claude Sonnet 5 | no |
| paper | other | Claude Sonnet 5 | no |
| science_stats | other | Claude Sonnet 5 | **never** |
| refactor_architecture | other | Claude Opus 5 | no |
| long_agent | other | Claude Opus 5 | no |
| parallel_roles | mixed | role map (advise in v0) | n/a |

### max upgrades

- science_stats / paper → Claude Opus 5
- refactor / long_agent → GPT-5.6 Sol or Claude Opus 5

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
| planner | Composer 2.5 |
| coder | Auto / Composer 2.5 |
| reviewer | Grok 4.7 |
| researcher | Grok 4.7 |
| verifier | Grok 4.7 |
| scientist | Grok 4.7 (+ science warning) |

**Display rule:** `[route]` shows `mode=eco` or `budget=exhausted` and a **Cursor** display name — never a phantom Other model.

## HITL

Only **Claude Fable** requires confirmation. Opus/Sol may auto on hard tiers when allowed.

## Budget

See `config/budget.yaml`:

- warn + block hard Other at 80% spent → Cursor-only matrix above
- force eco at $0 remaining → same matrix
- override: `/max force` or «разреши дорогие модели»

Manual remaining updates in v0; usage scrape is v3. When Other is empty and science is critical, Phase 3 documents BYOK / wait-for-reset as an explicit user choice after warning — never silent Other routing without budget/BYOK.

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
| planner | Composer 2.5 |
| coder | Auto / Composer 2.5 |
| reviewer | Claude Sonnet 5 |
| researcher | GPT-5.6 Terra |
| verifier | Claude Sonnet 5 |
| scientist | Claude Opus 5 |

## Plan shapes (v0.1 — recommend hints only)

Canonical source: `plan_shapes` in [`config/routes.yaml`](../config/routes.yaml).

| Tier | shape | Notes |
| --- | --- | --- |
| `parallel_roles` | `specialist` | Splitter lists role_map roles; **do not spawn** |
| `refactor_architecture` | `pipeline` | Hint: coder→reviewer→verifier |
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
