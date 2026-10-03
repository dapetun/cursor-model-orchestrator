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
4. Apply budget guard
5. Map tier+mode → logical model → display name
6. Fable HITL if needed
7. Emit Russian `[route]` line + lean Hindsight log
8. Continue plan → approve

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

### eco / exhausted / hard-block

All → Composer 2.5 or Grok 4.7, with quality warning on science_stats.

## HITL

Only **Claude Fable** requires confirmation. Opus/Sol may auto on hard tiers when allowed.

## Budget

See `config/budget.yaml`:

- warn + block hard Other at 80% spent
- force eco at $0 remaining
- override: `/max force` or «разреши дорогие модели»

Manual remaining updates in v0; usage scrape is v3.

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

## Related docs

- [classifier.md](classifier.md)
- [hindsight-schema.md](hindsight-schema.md)
- [roadmap.md](roadmap.md)
- [acceptance-v0.md](acceptance-v0.md)
