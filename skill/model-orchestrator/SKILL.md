---
name: model-orchestrator
description: >
  Always-on cost-aware model router for Cursor Pro. Classifies each user prompt
  with deterministic rules (keywords + project type), recommends a model under
  the Other Models budget, prints a short Russian [route] line, and logs lean
  decisions to Hindsight. Use on coding, DS/ML, academic papers, research,
  frontend, and whenever the user mentions /eco, /max, or /route.
---

# Model Orchestrator (v0 — recommend only)

## Mission

Protect Cursor Pro **Other Models** (~$20) from trivia while forcing strong models for science/stats. Overlay on Auto/Router; do not replace Auto for routine work.

User-facing language: **Russian**. This skill's instructions: **English**.

## Config locations

Resolve configs in this order:

1. Workspace `config/routes.yaml` if present (this repo)
2. Path in `ORCHESTRATOR_ROOT.txt` next to this SKILL.md (written by `install_skill.ps1`)
3. Embedded fallbacks in [reference-routes.md](reference-routes.md)

Always read when available: `routes.yaml`, `projects.yaml`, `budget.yaml`, `models.generated.yaml`.

## Every turn (mandatory)

1. **Classify once** (mode + project_type + tier + logical model).
2. Print **one** Russian `[route]` block at the start of the reply (before plan).
3. Lean **Hindsight retain** (see logging rules).
4. Continue with **plan → approve** (same recommended model for plan and execute advice).
5. **v0:** do not spawn subagents; tell the user to switch the chat model if needed.

### Route line format (Russian)

```text
[route] project=<type> tier=<tier> model=<display> mode=<eco|balance|max>
почему: <≤120 chars>
действие: <переключи модель чата на … · план → approve>
```

If budget warn/block: add `бюджет: предупреждение, hard Other заблокированы` or `бюджет: исчерпан → eco`.

If `/route` only: print the block and **stop**.

## Precedence (highest wins)

1. Explicit user model pin («используй Opus», «только Composer», named model)
2. Slash mode `/eco` or `/max` (sets mode; still classify tier). `/max force` or «разреши дорогие модели» sets hard-other override for this turn.
3. Prompt tags `@ds` `@paper` `@web`
4. `projects.yaml` path prefix / path_contains
5. Repo marker heuristics from `projects.yaml`
6. Keyword classifier (see below + `docs/classifier.md` in repo)
7. Default → `default_code` / Auto overlay

## Modes

| Mode | Behavior |
| --- | --- |
| `eco` | Cursor Models only. No Other Models, Fable, best-of-N, cascade. |
| `balance` | Default. Auto overlay for routine; escalate by tier; science → strong Other. |
| `max` | Prefer stronger Other Models if budget allows. Best-of-N is v2 (advise only in v0). |

Detect `/eco` `/max` in the user message. Default mode = `balance`.

## Budget guard (`budget.yaml`)

- Let `spent_ratio = 1 - remaining_usd / other_models_monthly_usd`.
- **Cursor-only triggers** (same matrix): `remaining_usd <= 0`, mode `/eco`, or `spent_ratio >= warn_at_ratio` without `hard_other_override`.
- On those triggers: resolve **`logical_model.eco`** / `exhausted_policy.matrix` from `routes.yaml` — never recommend Other Models.
- Hard tiers: `science_stats`, `refactor_architecture`, `long_agent`, `parallel_roles`, `paper` (when mapped to Other).
- Manual updates: if user says «бюджет remaining N», treat remaining as N for this session and ask to edit `budget.yaml`.

### Exhausted / eco matrix (bind to YAML)

| Tier | Model | Warning |
| --- | --- | --- |
| quick_edit, research_docs, cursor_meta, docs_office | Composer 2.5 | docs_office academic → paper row |
| default_code | Auto / Composer 2.5 | none |
| frontend_design, paper, science_stats, refactor_architecture, long_agent | Grok 4.7 | use `exhausted_policy.warnings_ru` |
| parallel_roles | `role_map_exhausted` | scientist/reviewer/… → Grok |

**Mandatory RU for science_stats on Cursor-only** (in `почему` / `действие`):

```text
Other Models недоступен — нет Sonnet/Opus; ответ на Grok. Перепроверь цифры и выводы.
```

**Display:** `mode=eco` or `budget=exhausted` + Cursor display name only.

## HITL — Fable

**Never** recommend or use Claude Fable without an explicit Russian yes/no confirmation first.

Use confirm copy from `routes.yaml` `hitl.confirm_prompt_ru` (or: «Рекомендую Claude Fable (дорого). Подтвердить? да/нет»).

Opus / Sol may be recommended on hard tiers without HITL when budget allows and hard-block is off.

## Project type

Types: `ds` | `paper` | `web` | `backend` | `cursor_meta` | `mixed`.

Apply `project_type_nudges` from `routes.yaml` after tier classification (bias, do not erase a higher-severity science/refactor match).

### Markers (summary)

- `ds`: notebooks, pandas/sklearn/torch, data/ml dirs
- `paper`: Magister/статья/ВКР text paths, `.tex`, md-heavy without app layout
- `web`: `package.json`, tsx/jsx app dirs
- `cursor_meta`: this skill/repo, `.cursor/`, `SKILL.md`, `mcp.json`

## Tier classifier (rules)

Score keywords (RU+EN). If several match, pick **highest severity**:

`science_stats` > `refactor_architecture` > `long_agent` > `parallel_roles` > `paper` > `frontend_design` > `docs_office` > `research_docs` > `cursor_meta` > `default_code` > `quick_edit`

### Keyword seeds

**science_stats:** p-value, p value, регресси, эконометр, прогноз, гипотез, panel, DID, значимост, std\.?err, SE\b, statsmodels, коэффициент, выборк, causal, ATE, MLM, фиксированн.*эффект

**refactor_architecture:** рефактор, архитектур, multi-file, многофайл, redesign, разнеси модул, перестрой

**long_agent:** 30\+?\s*мин, долг(ая|ий) сесс, сделай всё, end-to-end всё, длинн(ый|ая) агент

**parallel_roles:** нескольк.*агент, субагент, best-of-n, parallel agents, reviewer и coder

**paper:** статья, ВКР, рецензент, журнал, абзац, раздел статьи, диплом

**frontend_design:** UI, UX, CSS, Figma, лендинг, landing, сделай красив, layout, хедер, hero

**docs_office:** \.docx|\.pptx|\.xlsx|\.pdf|ворд|powerpoint|excel

**research_docs:** сравни библиотек, documentation, найди в docs, research

**cursor_meta:** skill, MCP, orchestrator, \.cursor/rules, user rule

**quick_edit:** поправь, переименуй, typo, опечатк, одну строк, tiny fix — only if no higher tier matched

**Negations:** if prompt contains «не трогай статистику» / «без регрессии» / «не про p-value», do not count science_stats hits for those tokens.

### Mixed concerns

If prompt clearly combines paper + stats + code (or similar):

- v0: state that decomposition is recommended; list 2–3 role routes; pick the **highest severity** tier for the primary `[route]` line.
- Do not silently ignore science_stats when present.

### Resolve logical → display

Map `logical_model[mode]` through `models.generated.yaml` `logical.*.display` (first available candidate).

Science/stats when Other Models allowed: never end on Composer-only; use `other.sonnet_strong` (balance) or `other.opus` (max).

## Hindsight logging (anti-spam)

After emitting the route line, call Hindsight `retain` **only if** the tuple `(task_type, model, mode, project_type)` differs from the last one logged **in this chat**.

Content template (English keys OK inside text):

```text
orchestrator_route task_type=<tier> model=<display> reason=<why≤120> mode=<mode> project_type=<type>
```

- `document_id`: `cursor-model-orchestrator-route-log-YYYY-MM` (UTC month)
- **Do not** log full prompts, code, token counts, stack traces, or PII

## Slash commands

- `/eco` — force eco mode for this turn
- `/max` — force max mode for this turn
- `/route` — classify, print `[route]`, stop
- `/max force` — max mode + treat hard_other_override as true this turn

## Hard rules

1. Never select Fable without HITL confirmation.
2. Never spend Other Models in `/eco` or when budget exhausted.
3. Never skip the Russian `[route]` line.
4. v0: recommend only — no cascade execution, no best-of-N runs, no mid-chat model mutation.
5. Prefer plan → approve before large edits.
6. Bash is not a separate tier; route like normal code.

## Embedded fallback (if YAML missing)

- eco routine (quick_edit, default_code, research_docs, cursor_meta, docs_office) → Composer 2.5 / Auto
- eco quality (science_stats, paper, frontend_design, refactor, long_agent) → Grok 4.7 + warnings
- science_stats / paper (budget OK) → Claude Sonnet 5
- refactor_architecture / long_agent (budget OK) → Claude Opus 5
- max hard → GPT-5.6 Sol or Claude Opus 5
- Fable → ask first
