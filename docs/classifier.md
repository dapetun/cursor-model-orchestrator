# Classifier specification (v0)

Deterministic rules only — no LLM classifier.

## Precedence

1. Explicit user model pin
2. Slash mode (`/eco`, `/max`) — sets mode, not tier
3. Tags `@ds` `@paper` `@web`
4. `projects.yaml` path_prefixes / path_contains
5. Filesystem markers
6. Keyword tier scores
7. Default `default_code`

## Severity order

When multiple tiers match, choose the first in this list:

1. `science_stats`
2. `refactor_architecture`
3. `long_agent`
4. `parallel_roles`
5. `paper`
6. `frontend_design`
7. `docs_office`
8. `research_docs`
9. `cursor_meta`
10. `default_code`
11. `quick_edit`

`quick_edit` applies only when no higher tier matched.

## Keyword tables

Matching is case-insensitive. Treat listed tokens as substrings / light regex.

### science_stats

| RU | EN |
| --- | --- |
| регресси | regression |
| эконометр | econometric |
| прогноз | forecast |
| гипотез | hypothesis |
| значимост | significance |
| коэффициент | coefficient |
| выборк | sample |
| панел | panel |
| фиксированн эффект | fixed effect |
| p-value / p value | p-value |
| std err / стандартн ошиб | standard error |
| DID / разность разностей | DID, difference-in-differences |
| ATE / каузальн | causal, ATE |
| statsmodels | statsmodels |

### refactor_architecture

| RU | EN |
| --- | --- |
| рефактор | refactor |
| архитектур | architecture |
| многофайл | multi-file |
| разнеси модул | split modules |
| перестрой | redesign |

### long_agent

| RU | EN |
| --- | --- |
| долгая сесс / долгий агент | long-running |
| 30 мин | 30+ min |
| сделай всё | do everything end-to-end |

### parallel_roles

| RU | EN |
| --- | --- |
| несколько агентов | parallel agents |
| субагент | subagent |
| best-of-n | best-of-N |
| ревьюер и кодер | reviewer and coder |

### paper

| RU | EN |
| --- | --- |
| статья | article / paper |
| ВКР | thesis |
| рецензент | reviewer (academic) |
| журнал | journal |
| абзац / раздел статьи | section / paragraph |
| диплом | diploma |

### frontend_design

| RU | EN |
| --- | --- |
| сделай красив | make it look good |
| лендинг | landing |
| вёрстка / layout | layout |
| UI / UX / CSS | UI, UX, CSS |
| Figma | Figma |
| hero / хедер | hero, header |

### docs_office

Extensions/tokens: `.docx`, `.pptx`, `.xlsx`, `.pdf`, `ворд`, `excel`, `powerpoint`.

### research_docs

| RU | EN |
| --- | --- |
| сравни библиотек | compare libraries |
| найди в docs | find in docs |
| research | research |
| documentation | documentation |

### cursor_meta

Tokens: `skill`, `MCP`, `orchestrator`, `.cursor/rules`, `user rule`, `mcp.json`.

### quick_edit

| RU | EN |
| --- | --- |
| поправь | fix quickly |
| переименуй | rename |
| опечатк / typo | typo |
| одну строк | one-line |

## Negations

If the prompt contains patterns like:

- `не трогай статистику`
- `без регрессии`
- `не про p-value`
- `no stats`

…do not count the negated science tokens toward `science_stats`.

## Mixed concerns

If ≥2 high-level domains appear (e.g. paper + science_stats + default_code):

1. Mention decomposition in the `почему` / `действие` lines.
2. Still emit a single primary `[route]` using highest severity.
3. Optionally list role→model advice (from `routes.yaml` `parallel_roles.role_map`).

## Phase / роль (after tier pick)

Resolve `роль` from `phases` in `routes.yaml` (plan / execute / analyze). This **does** change which logical model goes into `[route] model=`:

- `план` / `анализ` → `logical_model[mode]`
- `код` → `executor_logical[mode]` (Composer / Grok)

Never pick Other for `роль=код`.

## Plan shapes (after tier pick)

Map primary tier → `shape` via `plan_shapes.by_tier` in `routes.yaml` (default `none`). This does **not** change severity. If `splitter_hint` is true and `shape != none`, name roles in `действие` only — never spawn.

## Project nudges

After tier pick, if `project_type` is set, soft-bias (only when tier is `default_code` or ambiguous between two adjacent severities):

- `ds` → prefer `science_stats` when any weak science signal exists
- `paper` → prefer `paper`
- `web` → prefer `frontend_design` for UI wording
- `cursor_meta` → prefer `cursor_meta`
