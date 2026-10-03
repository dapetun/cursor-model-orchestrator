# Acceptance scenarios (v0 / v0.1)

Manual checks in a **new Agent chat** after `scripts/install_skill.ps1`.

For each case, verify the Russian `[route]` line fields. **v0.1:** every `[route]` must include `tier`, `model`, `mode`, `pool`, `budget`, `shape`.

## 1. Tiny rename

**Prompt:** «Переименуй переменную `x` в `count` в этом файле»

**Expect:** `tier=quick_edit`, model Auto/Composer, mode balance, Cursor pool.

## 2. Science / stats

**Prompt:** «Оцени значимость коэффициента в панельной регрессии»

**Expect:** `tier=science_stats`, model Claude Sonnet 5 (or Opus in `/max`), **not** Composer-only when budget OK. `почему` mentions no cheap first-pass.

## 3. VKR / paper

**Prompt:** «Перепиши абзац статьи ВКР про ограничения выборки»

**Expect:** `tier=paper` (or science_stats if heavily statistical), strong Other Model when budget OK.

## 4. Large refactor

**Prompt:** «Полный рефакторинг модулей X, Y и Z — разнеси архитектуру»

**Expect:** `tier=refactor_architecture`, Claude Opus 5 (balance) or Sol/Opus (`/max`).

## 5. Frontend design

**Prompt:** «@web Сделай красивый hero для лендинга»

**Expect:** `project=web`, `tier=frontend_design`, not trivia Composer-only when Other Models allowed.

## 6. Eco + science

**Prompt:** `/eco Оцени значимость коэффициента в панели`

**Expect:** `tier=science_stats`, model **Grok 4.7** (not silent Composer-only), `mode=eco`, mandatory quality warning (нет Sonnet/Opus; перепроверь цифры).

## 7. Fable HITL

**Prompt:** «Используй Fable для разбора статьи»

**Expect:** Confirmation question in Russian **before** any Fable use. No silent Fable.

## 8. Tag overrides path

**Setup:** workspace under a `ds` path.  
**Prompt:** `@web поправь layout шапки`

**Expect:** `project=web` wins over ds path; frontend-oriented tier.

## 9. Mixed concerns

**Prompt:** «Допиши статью и поправь регрессию в коде»

**Expect:** Advises decomposition; primary tier is `science_stats` or `paper` (highest severity present); lists separate routes.

## 10. Budget hard-block

**Setup:** set `config/budget.yaml` `remaining_usd: 3` (≤20% of 20).  
**Prompt:** «Сделай полный рефакторинг архитектуры сервиса»

**Expect:** warn in route line; hard Other blocked unless override; model **Grok 4.7** (`fallback_if_blocked` / eco matrix).

## 11. Other Models exhausted + science

**Setup:** set `config/budget.yaml` `remaining_usd: 0`.  
**Prompt:** «Оцени значимость коэффициента в панельной регрессии»

**Expect:** Cursor-only; `model=Grok 4.7`; `budget=exhausted` or `mode=eco`; **mandatory** science warning; never recommend Sonnet/Opus/Composer as if Other were available.

## 12. Exhausted + parallel roles advice

**Setup:** `remaining_usd: 0`.  
**Prompt:** «Несколько агентов: reviewer, coder и scientist для рефакторинга и проверки регрессии»

**Expect:** advises `role_map_exhausted` (reviewer/researcher/verifier/scientist → Grok 4.7; planner/coder → Composer/Auto); no Other model names in the route advice.

## Budget override

**Prompt:** «разреши дорогие модели» then repeat scenario 10.

**Expect:** hard Other allowed again for that turn / after `hard_other_override: true`.

## `/route` debug

**Prompt:** `/route переименуй файл`

**Expect:** prints `[route]` and stops without editing files.

## 13. Machine fields — balance science (v0.1)

**Setup:** budget OK (`remaining_usd` well above warn).  
**Prompt:** «Оцени значимость коэффициента в панельной регрессии»

**Expect:** `tier=science_stats`, `pool=other`, `budget=ok`, `shape=none`, `mode=balance`; model Claude Sonnet 5 (not Composer-only). Machine fields all present.

## 14. Machine fields — eco / exhausted (v0.1)

**Setup A:** `/eco` with budget OK.  
**Prompt:** `/eco Оцени значимость коэффициента в панели`

**Expect:** `pool=cursor`, `mode=eco`, model Grok 4.7, science warning; `budget=ok` (eco alone ≠ exhausted).

**Setup B:** `remaining_usd: 0`.  
**Prompt:** «Оцени значимость коэффициента в панельной регрессии»

**Expect:** `pool=cursor`, `budget=exhausted`, Grok 4.7 + mandatory science warning.

## 15. Plan shape pipeline hint — no spawn (v0.1)

**Setup:** budget OK.  
**Prompt:** «Полный рефакторинг модулей X, Y и Z — разнеси архитектуру»

**Expect:** `tier=refactor_architecture`, `shape=pipeline`, `pool=other`; `действие` mentions coder→reviewer→verifier (or equivalent) and explicitly **does not** claim to spawn subagents.
