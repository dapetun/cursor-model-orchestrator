# Hindsight logging schema (lean)

Used when **stack** profile has `hindsight.enabled: true` and Hindsight MCP is available (see [integrations/stack.md](integrations/stack.md)). Core profile skips retain.

## Goal

Store enough to evaluate the orchestrator later without flooding memory.

## Retain payload (v0.2)

Call Hindsight `retain` with a single short string:

```text
orchestrator_route task_type=<tier> tier=<tier> model=<display> logical=<key>
reason=<why> mode=<eco|balance|max> project_type=<type> pool=<cursor|other|mixed>
budget=<ok|warn|exhausted> shape=<none|mapper|specialist|pipeline|hybrid>
role=<plan|execute|analyze>
```

| Field | Required | Notes |
| --- | --- | --- |
| `task_type` | yes | Tier id (`science_stats`, …); same as `tier` |
| `tier` | yes | Explicit tier id for machine parsing |
| `model` | yes | Display name recommended |
| `logical` | yes | Logical key from `routes.yaml` / `models.generated.yaml` (e.g. `other.sonnet_strong`) |
| `reason` | yes | ≤120 characters |
| `mode` | yes | `eco` \| `balance` \| `max` |
| `project_type` | yes | `ds` \| `paper` \| `web` \| … |
| `pool` | yes | `cursor` \| `other` \| `mixed` — resolved pool after budget/eco |
| `budget` | yes | `ok` \| `warn` \| `exhausted` (see below) |
| `shape` | yes | From `plan_shapes.by_tier` (default `none`) |
| `role` | yes | `plan` \| `execute` \| `analyze` (maps from `[route] роль=`) |

### `budget` resolution

| Value | When |
| --- | --- |
| `ok` | `remaining_usd > 0` and `spent_ratio < warn_at_ratio` |
| `warn` | `spent_ratio >= warn_at_ratio` without hard-other override (Cursor-only matrix) |
| `exhausted` | `remaining_usd <= 0` |

`/eco` sets `mode=eco` and `pool=cursor` but does **not** force `budget=exhausted` if remaining > 0.

Optional metadata:

- `document_id`: `cursor-model-orchestrator-route-log-YYYY-MM` (UTC month)
- Tags (if supported): `orchestrator`, `route`

## Anti-spam rules

1. **Dedup in-session:** skip retain when `(task_type, model, mode, project_type, pool, budget, shape, role)` equals the last logged tuple in the current chat.
2. **Never log:** full user prompts, source code, file contents, token/cost estimates every turn, stack traces, secrets, PII.
3. **No outcome spam in v0.1:** do not log success/failure of the downstream task (optional later if curated).

## Privacy invariant (mandatory)

Lean retain is for **routing evaluation**, not identity profiling.

| Allowed in retain text | Forbidden |
| --- | --- |
| tier / model / logical / mode / pool / budget / shape | Full user prompt or paraphrase that quotes private content |
| Short non-identifying `reason` (≤120 chars) | Emails, phones, names, addresses, account IDs |
| Document id by UTC month | Source code, file paths with secrets, API keys, stack traces |

If a field would require pasting user content to be useful, **omit retain for that turn** rather than violating this table.

See also: [legal/privacy.md](legal/privacy.md).

## Budget updates

If the user updates remaining budget in chat, or after a successful sync, you may retain once:

```text
orchestrator_budget remaining_usd=<n> api_percent_used=<n> spent_ratio=<n> source=<synced|stale|manual> hard_other_override=<true|false>
```

with `document_id` `cursor-model-orchestrator-budget`.

**Never** retain session tokens, cookies, JWTs, or email from auth probes.

## Recall usage

Before unusual routing, agents may `recall` query:
`orchestrator_route science_stats` or `orchestrator budget`
— but must not dump long histories into the user-facing reply.
