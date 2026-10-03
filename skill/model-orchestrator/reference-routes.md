# Reference routes (cheat sheet)

Use when YAML configs are unavailable. Prefer `config/routes.yaml` when present.

## Modes

- `eco` → Cursor pool only (Composer 2.5 / Grok 4.7 per tier)
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

## eco / exhausted / hard-block (shared Cursor-only matrix)

Triggers: `/eco`, `remaining_usd<=0`, hard-block@80% without override.

| Tier | Model |
| --- | --- |
| quick_edit | Composer 2.5 |
| default_code | Auto / Composer 2.5 |
| research_docs | Composer 2.5 |
| cursor_meta | Composer 2.5 |
| docs_office | Composer 2.5 (academic → paper) |
| frontend_design | Grok 4.7 |
| paper | Grok 4.7 (+ warning) |
| science_stats | Grok 4.7 (+ **mandatory** science warning) |
| refactor_architecture | Grok 4.7 |
| long_agent | Grok 4.7 |
| parallel_roles | role_map_exhausted |

### role_map_exhausted

| Role | Model |
| --- | --- |
| planner | Composer 2.5 |
| coder | Auto / Composer 2.5 |
| reviewer | Grok 4.7 |
| researcher | Grok 4.7 |
| verifier | Grok 4.7 |
| scientist | Grok 4.7 |

Never show Other model names while Cursor-only.

## Fable

Never without Russian HITL confirm.

## Severity

science_stats > refactor_architecture > long_agent > parallel_roles > paper > frontend_design > docs_office > research_docs > cursor_meta > default_code > quick_edit
