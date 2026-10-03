# Hindsight logging schema (lean)

## Goal

Store enough to evaluate the orchestrator later without flooding memory.

## Retain payload

Call Hindsight `retain` with a single short string:

```text
orchestrator_route task_type=<tier> model=<display> reason=<why> mode=<mode> project_type=<type>
```

| Field | Required | Notes |
| --- | --- | --- |
| `task_type` | yes | Tier id (`science_stats`, …) |
| `model` | yes | Display name recommended |
| `reason` | yes | ≤120 characters |
| `mode` | yes | `eco` \| `balance` \| `max` |
| `project_type` | yes | `ds` \| `paper` \| `web` \| … |

Optional metadata:

- `document_id`: `cursor-model-orchestrator-route-log-YYYY-MM` (UTC month)
- Tags (if supported): `orchestrator`, `route`

## Anti-spam rules

1. **Dedup in-session:** skip retain when `(task_type, model, mode, project_type)` equals the last logged tuple in the current chat.
2. **Never log:** full user prompts, source code, file contents, token/cost estimates every turn, stack traces, secrets, PII.
3. **No outcome spam in v0:** do not log success/failure of the downstream task (optional later if curated).

## Budget updates

If the user updates remaining budget in chat, you may retain once:

```text
orchestrator_budget remaining_usd=<n> hard_other_override=<true|false>
```

with `document_id` `cursor-model-orchestrator-budget`.

## Recall usage

Before unusual routing, agents may `recall` query:
`orchestrator_route science_stats` or `orchestrator budget`
— but must not dump long histories into the user-facing reply.
