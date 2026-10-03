# Reference routes (cheat sheet)

Use when YAML configs are unavailable. Prefer `config/routes.yaml` when present.

## Modes

- `eco` → Cursor pool only (Composer 2.5 / Grok)
- `balance` → Auto overlay; escalate hard/science to Other Models
- `max` → stronger Other Models if budget allows

## Tier → model (balance / budget OK)

| Tier | Model |
| --- | --- |
| quick_edit | Auto / Composer 2.5 |
| default_code | Auto / Composer 2.5 |
| research_docs | Auto / Composer 2.5 |
| cursor_meta | Composer 2.5 |
| docs_office | Auto / Composer 2.5 (or Sonnet if academic) |
| frontend_design | Claude Sonnet 5 |
| paper | Claude Sonnet 5 |
| science_stats | Claude Sonnet 5 (never Composer-only) |
| refactor_architecture | Claude Opus 5 |
| long_agent | Claude Opus 5 |
| parallel_roles | advise role map (v0) |

## max mode upgrades

- science_stats / paper → Claude Opus 5
- refactor / long_agent → GPT-5.6 Sol or Claude Opus 5

## eco / budget exhausted / hard-block fallbacks

- All tiers → Composer 2.5 or Grok 4.7
- Still print quality warning for science_stats

## Fable

Never without Russian HITL confirm.

## Severity

science_stats > refactor_architecture > long_agent > parallel_roles > paper > frontend_design > docs_office > research_docs > cursor_meta > default_code > quick_edit
