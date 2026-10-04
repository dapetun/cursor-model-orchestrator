---
name: model-orchestrator
description: >
  Always-on cost-aware model router for Cursor Pro. Classifies each user prompt
  with deterministic rules (keywords + project type), recommends a model under
  the Other Models budget, and prints a short Russian [route] line. Doctrine:
  Other Models plan in detail; Composer/Grok execute code and file ops. Works
  standalone (core profile). With stack profile, lean-logs to Hindsight when
  MCP is available and may hint GitNexus on coding tasks. Use on coding, DS/ML,
  academic papers, research, frontend, and whenever the user mentions /eco,
  /max, or /route.
---

# Model Orchestrator (v0.2 — recommend only)

## Mission

Protect Cursor Pro **Other Models** (~$20) from trivia **and** from writing code.
Strong Other models **plan** (detailed briefs a weaker agent can follow).
**Composer 2.5 / Grok 4.7** **execute** (read files, write/edit code, routine tools).

Overlay on Auto/Router; do not replace Auto for routine work.

User-facing language: **Russian**. This skill's instructions: **English**.

## Doctrine: planner → executor

Canonical source: `doctrine` + `phases` in `routes.yaml`.

| Role (`роль=`) | Who | Does |
| --- | --- | --- |
| `план` | Other (Sonnet/Opus/Sol) or Grok if exhausted | Detailed plan, specs, architecture, science Q&A prose |
| `код` | Composer 2.5 (default) or Grok 4.7 | File reads/writes, patches, routine agent work |
| `анализ` | Other (science/paper Q&A) | Interpret results / write prose — **not** code edits |

**Hard rule:** Never recommend Other Models for writing code, applying patches, or bulk file edits — even on hard tiers. If the user asks to implement now, set `роль=код` and recommend Composer (or Grok for UI / Cursor-only quality).

### Phase detection (after tier)

1. Explicit pin («используй Opus», «только Composer») wins.
2. `force_execute_if` keywords → `роль=код` → use `executor_logical[mode]`.
3. `force_plan_if` keywords → `роль=план` → use `logical_model[mode]`.
4. Else if tier in `always_execute_tiers` → `роль=код`.
5. Else if tier in `default_plan_tiers` and no approved plan in thread → `роль=план`.
6. Else if tier in `analyze_tiers` and prompt is Q&A (no «напиши код» / «реализуй») → `роль=анализ`.
7. Else if user said «реализуй» / approved a prior plan → `роль=код`.

### Planner output contract (when `роль=план`)

Plan must be **Composer-ready** in Russian (or bilingual if user asks EN):

- Goal + non-goals
- Files to touch (paths)
- Ordered steps (small enough for one Composer turn each if long)
- Acceptance / done criteria
- Risks / what not to change
- End with handoff from `doctrine.handoff_ru`

Do **not** apply file edits while recommending Other as the chat model.

### Executor handoff (`роль=код`)

In `действие`: «переключи на Composer 2.5 (или Grok) и выполни план».
If no plan exists yet on a hard tier, first recommend `роль=план` unless user forced execute.

## Config locations

Resolve configs in this order:

1. Workspace `config/` if present (this repo): `routes.yaml`, `integrations.yaml`, `projects.yaml`, `budget.yaml`, `models.generated.yaml`
2. Path in `ORCHESTRATOR_ROOT.txt` next to this SKILL.md (written by `install_skill.ps1`)
3. Skill-local `integrations.yaml` (copied at install)
4. Embedded fallbacks in [reference-routes.md](reference-routes.md)

If `projects.yaml` is missing, use `projects.example.yaml` markers only (path_prefixes may be placeholders).

### Integrations profile (`integrations.yaml`)

| `profile` | Behavior |
| --- | --- |
| `core` (default) | Router only. Skip Hindsight retain and GitNexus hints. |
| `stack` | Soft deps: retain if Hindsight MCP available; optional GitNexus hint on coding tiers. |

Read `hindsight.enabled` / `gitnexus.enabled` from that file. Missing file → treat as **core**.

## Every turn (mandatory)

1. **Classify once** (mode + project_type + tier + **phase/role** + logical model + pool + budget + shape).
2. Print **one** Russian `[route]` block at the start of the reply (before plan). Machine fields `tier`, `model`, `mode`, `pool`, `budget`, `shape`, `роль` are required every turn.
3. **Integrations (soft):** Hindsight retain and GitNexus hints — see below. Never fail the turn if tools are absent.
4. Continue per role: planner elaborates; executor implements after approve / model switch.
5. **v0.2:** do not spawn subagents; tell the user to switch the chat model if needed. Plan-shape / splitter text is a hint only.

### Route line format (Russian)

```text
[route] project=<type> tier=<tier> model=<display> mode=<eco|balance|max> pool=<cursor|other|mixed> budget=<ok|warn|exhausted> shape=<none|mapper|specialist|pipeline|hybrid> роль=<план|код|анализ>
почему: <≤120 chars>
действие: <переключи модель чата на … · план → approve · handoff на Composer · optional shape/roles hint>
```

- `pool`: `cursor` on eco/exhausted/hard-block; else tier pool (`other` / `cursor` / `mixed`).
- `budget`: `ok` if remaining OK and under warn ratio; `warn` at hard-block@warn_ratio; `exhausted` if `remaining_usd<=0`. `/eco` alone does not force `exhausted`.
- `shape`: from `plan_shapes.by_tier` in `routes.yaml` (default `none`). If `shape != none` and `splitter_hint: true`, add one RU hint in `действие` naming roles that *would* fire — **never spawn**.
- `роль`: `план` | `код` | `анализ` (see doctrine).
- `model`: for `план`/`анализ` use `logical_model[mode]`; for `код` use `executor_logical[mode]` when present, else Cursor default (Composer).

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
| `eco` | Cursor Models only. No Other Models, Fable, best-of-N, cascade. Planner→Grok; executor→Composer/Grok per matrix. |
| `balance` | Default. Auto/Composer for routine execute; Other for plan/analyze on hard tiers. |
| `max` | Stronger Other planners if budget allows. Execution still Composer/Grok. |

Detect `/eco` `/max` in the user message. Default mode = `balance`.

## Budget guard (`budget.yaml`)

- Let `spent_ratio = 1 - remaining_usd / other_models_monthly_usd`.
- **Cursor-only triggers** (same matrix): `remaining_usd <= 0`, mode `/eco`, or `spent_ratio >= warn_at_ratio` without `hard_other_override`.
- On those triggers: resolve **`logical_model.eco`** / `exhausted_policy.matrix` — never recommend Other Models.
- Hard tiers: `science_stats`, `refactor_architecture`, `long_agent`, `parallel_roles`, `paper` (when mapped to Other for plan/analyze).
- Manual updates: if user says «бюджет remaining N», treat remaining as N for this session and ask to edit `budget.yaml`.

### Exhausted / eco matrix (bind to YAML)

| Tier | Model | Warning |
| --- | --- | --- |
| quick_edit, research_docs, cursor_meta, docs_office | Composer 2.5 | docs_office academic → paper row |
| default_code | Auto / Composer 2.5 | none |
| frontend_design, paper, science_stats, refactor_architecture, long_agent | Grok 4.7 | use `exhausted_policy.warnings_ru` |
| parallel_roles | `role_map_exhausted` | planner/reviewer/… → Grok; coder → Composer |

**Mandatory RU for science_stats on Cursor-only** (in `почему` / `действие`):

```text
Other Models недоступен — нет Sonnet/Opus; ответ на Grok. Перепроверь цифры и выводы.
```

**Display:** `mode=eco` and/or `budget=warn|exhausted` + `pool=cursor` + Cursor display name only.

## Plan shapes (hints only)

Read `plan_shapes` from `routes.yaml`. Defaults if missing: `shape=none`, no spawn.

| Tier (examples) | shape | Splitter hint (RU, do not spawn) |
| --- | --- | --- |
| parallel_roles | specialist | роли: planner/coder/reviewer/… — не спавню |
| refactor_architecture | pipeline | роли: planner→coder→reviewer→verifier — не спавню |
| long_agent | hybrid | роли: planner→coder→reviewer — не спавню |
| science_stats, quick_edit, … | none | (omit roles line) |

## HITL — Fable

**Never** recommend or use Claude Fable without an explicit Russian yes/no confirmation first.

Use confirm copy from `routes.yaml` `hitl.confirm_prompt_ru` (or: «Рекомендую Claude Fable (дорого). Подтвердить? да/нет»).

Opus / Sol may be recommended as **planners** on hard tiers without HITL when budget allows and hard-block is off — still not for writing code.

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

- State that decomposition is recommended; list 2–3 role routes; pick the **highest severity** tier for the primary `[route]` line.
- Plan/analyze on Other; code path always Composer.

### Resolve logical → display

Map through `models.generated.yaml` `logical.*.display` (first available candidate):

- `роль=план|анализ` → `logical_model[mode]`
- `роль=код` → `executor_logical[mode]` if present, else Composer / Auto

Science/stats **analyze** when Other allowed: never Composer-only for the answer. Science/stats **code**: plan on Sonnet/Opus, execute on Composer.

## Hindsight logging (anti-spam, stack only)

**Gate:** `integrations.yaml` has `hindsight.enabled: true` **and** Hindsight MCP/tools are available (typically via [cursor-hindsight-ondemand](https://github.com/dapetun/cursor-hindsight-ondemand), MCP server name `hindsight` unless overridden).

- If gate fails (core profile, or MCP down): **skip retain** — do not error, do not claim logging in `[route]`.
- If gate passes: call `retain` **only if** the tuple `(task_type, model, mode, project_type, pool, budget, shape, роль)` differs from the last one logged **in this chat**.

Content template (English keys OK inside text):

```text
orchestrator_route task_type=<tier> tier=<tier> model=<display> logical=<key> reason=<why≤120> mode=<mode> project_type=<type> pool=<cursor|other|mixed> budget=<ok|warn|exhausted> shape=<none|mapper|specialist|pipeline|hybrid> role=<plan|execute|analyze>
```

- `document_id`: `cursor-model-orchestrator-route-log-YYYY-MM` (UTC month)
- **Do not** log full prompts, code, token counts, stack traces, or PII
- Schema details: repo `docs/hindsight-schema.md` (used when stack + Hindsight)

## GitNexus hint (soft, stack only)

**Gate:** `gitnexus.enabled: true` and GitNexus MCP/CLI available.

On coding-related tiers (`default_code`, `refactor_architecture`, `long_agent`, `cursor_meta` when editing code): one short hint that impact / `detect_changes` is available — **do not** block classify/route if GitNexus is missing. Never require GitNexus in core.

## Slash commands

- `/eco` — force eco mode for this turn
- `/max` — force max mode for this turn
- `/route` — classify, print `[route]`, stop
- `/max force` — max mode + treat hard_other_override as true this turn

## Hard rules

1. Never select Fable without HITL confirmation.
2. Never spend Other Models in `/eco` or when budget exhausted.
3. Never skip the Russian `[route]` line (include `роль=`).
4. Never recommend Other Models for writing/editing code or applying patches.
5. Recommend only — no cascade execution, no best-of-N runs, no mid-chat model mutation, no subagent spawn (shape/splitter are hints).
6. Prefer plan → approve → Composer execute before large edits.
7. Bash is not a separate tier; route like normal code (executor = Composer).

## Embedded fallback (if YAML missing)

- eco/execute routine → Composer 2.5 / Auto
- eco plan/quality → Grok 4.7 + warnings
- science_stats / paper analyze (budget OK) → Claude Sonnet 5
- refactor / long_agent **plan** (budget OK) → Claude Opus 5; **execute** → Composer 2.5
- frontend **plan** → Sonnet; **execute** → Grok 4.7
- max hard planner → GPT-5.6 Sol or Claude Opus 5
- Fable → ask first
