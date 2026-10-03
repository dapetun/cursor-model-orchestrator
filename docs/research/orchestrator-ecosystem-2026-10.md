# Orchestrator & Model-Router Ecosystem Research

**Search boundary date:** 2026-10-03  
**Focus:** Primary sources (GitHub READMEs, official docs, skills.sh).  
**Audience:** Personal Cursor Pro **recommend-only** skill (YAML tiers, exhausted Cursor-only matrix, Hindsight lean logs, `/eco` `/max`).

---

## Located evidence

### 1. GustavoWinter/cursor-agent-orchestrator-mcp

| Field | Value |
| --- | --- |
| URL | https://github.com/GustavoWinter/cursor-agent-orchestrator-mcp |
| README | https://raw.githubusercontent.com/GustavoWinter/cursor-agent-orchestrator-mcp/main/README.md |
| npm | https://www.npmjs.com/package/cursor-agent-orchestrator-mcp |
| Stars (GitHub API, 2026-10-03) | **1** |
| Cursor-specific? | **Yes** (`@cursor/sdk`, `.cursor/mcp.json`, Cursor Cloud) |

**What it does (README):** MCP server that runs many `@cursor/sdk` agents in parallel from one Cursor chat — locally or on Cursor Cloud — with a **propose → confirm → execute** flow and one merged event stream. Top-level orchestrator: independent subagents, mixed runtimes/models, lifecycle control outside a single agent loop.

**Mechanism:** Propose/confirm/execute. Planner produces JSON plan + Mermaid (shapes: mapper / specialist / pipeline / hybrid). `confirm_plan` is a hard server-side gate before `execute_plan`. Parallel subagents; `stream_plan` merges labeled events. Env: `CURSOR_ORCH_PROPOSE_PLAN_MODE`, `CURSOR_ORCH_SKIP_CONFIRMATION`, concurrency caps, planner/parent model overrides.

**[Idea]** Explicit propose→confirm before spend is a strong pattern for a recommend-only skill (show tier + reason; wait for user “yes” / `/max` before any optional execute path). Plan shapes (mapper/specialist/pipeline) map cleanly to YAML task classes.

---

### 2. qmediat/cursor-mcp (`@qmediat.io/cursor-mcp`)

| Field | Value |
| --- | --- |
| URL | https://github.com/qmediat/cursor-mcp |
| README | https://raw.githubusercontent.com/qmediat/cursor-mcp/main/README.md |
| npm | https://www.npmjs.com/package/@qmediat.io/cursor-mcp |
| Stars (GitHub API, 2026-10-03) | **1** |
| Cursor-specific? | **Yes** (wraps Cursor CLI `cursor-agent` / `agent`) |

**What it does (README):** MCP server for the Cursor CLI: run Cursor’s agent with any model id the plan offers (Composer, Claude, GPT, Gemini, Grok families) through MCP. Five tools: `cursor_agent`, `cursor_reply`, `cursor_models`, `cursor_sessions`, `cursor_health`. Parallel runs via semaphore (`CURSOR_MAX_CONCURRENCY`, default 3).

**Mechanism:** Gateway/wrapper over CLI — not propose/confirm planning; caller picks `model` (or `auto`). Modes: `agent` / `plan` / `ask`. Optional Claude Code skill **cursor-code**: Claude supervises, Cursor codes, iterate with `cursor_reply` (max 3 rounds). Security: auto-approve only via `CURSOR_ALLOW_YOLO` env (never LLM-controllable).

**[Idea]** `cursor_models` as live catalog discovery; parallel same-prompt multi-model compare; supervisor/coder loop with hard round cap — useful for `/max` “second opinion” without auto-apply.

---

### 3. timgrossinger/tgs-router-dev (TGs-router)

| Field | Value |
| --- | --- |
| URL (historical / search) | https://github.com/timgrossinger/tgs-router-dev |
| Stars (web index snapshot in session) | **0** |
| Cursor-specific? | **Partial** — registers `~/.cursor/mcp.json` + `~/.cursor/rules/tgs-router.mdc`; also Copilot, Claude Code, Gemini, Codex, Junie, etc. |

**Availability note (2026-10-03):** Direct `github.com` and GitHub API fetches returned **404** during this research pass. Evidence below is from an earlier-in-session crawl of the same URL (README content + metadata: Apache-2.0, topics `ai-routing`, `cli-orchestration`, `mcp`, `model-routing`, created 2026-04-15). Treat as **stale / possibly unpublished** until re-verified.

**What it does (README crawl):** CLI-native AI task router and MCP orchestrator. Routes coding work across Copilot, Claude Code, Gemini CLI, OpenCode, Codex, Cursor, Junie, Aider, Amazon Q/Kiro, etc. Decomposes multi-file tasks into parallel waves; keeps low-tier work on cheap/free models; approval-gated self-learning loop for reusable agents. Uses existing CLI subscriptions (no API keys for core path). Status claimed: public beta `v1.0.0-beta.1`.

**Mechanism:** Cost-aware tier routing (low/medium/high) + task decomposition into dependency waves + MCP tools (`route_task`, `decompose_task`, `execute_subtask`, swarm/budget options). Cross-routing excludes the calling CLI to avoid recursion. YAML: `cost_overrides`, `preferred_routing`, `preferred_routing_by_caller`. Token circuit breaker / `unlimited_budget` on swarm (from commit message evidence).

**[Idea]** YAML tiers + cost_rank + caller-scoped preferences are closest to a personal Cursor Pro matrix. “Most work is boilerplate → low tier” heuristic; prefer subscription/free before metered. Approval-gated learning of recurring patterns → Hindsight lean logs (outcome + recommended tier, not full transcripts).

---

### 4. m4stanuj/mast-llm-router

| Field | Value |
| --- | --- |
| URL (historical / search) | https://github.com/m4stanuj/mast-llm-router |
| Stars (web index snapshot) | **3** |
| Cursor-specific? | **Claimed yes** (MCP config for Cursor/Windsurf among others) |

**Availability note (2026-10-03):** GitHub HTML/API/raw README returned **404** during this pass. Evidence from search-indexed README / `src/server.py` / `AGENTS.md` blobs.

**What it does (README snippets):** Task-aware LLM fallback router — 13 provider routes, 10 task chains, 6 fallbacks, positioned as **$0/month** free-tier. Detects task from prompt keywords; routes to chain; auto-failover on 429/503/empty; semantic cache (0.82 fuzzy, 500 LRU). MCP tools: `llm_chat`, `llm_detect_task`, `llm_batch`, `llm_stream`, etc. Clients listed: Claude Code, Cursor, Windsurf, Continue.dev, Codex CLI.

**Mechanism:** Cascade / best-first chain per task (`speed`, `reason`, `code`, `vision`, `research`, `write`, `agent`, `pentest`, `hinglish`, `vision_reason`) then full-provider fallback. Not Cursor-native execution — OpenAI-compatible / provider APIs behind MCP.

**[Idea]** `llm_detect_task` preview before spend maps to recommend-only “show chain, don’t call.” Task→chain tables are a template for YAML roles. Free-tier-first is orthogonal to Cursor Pro–only matrix but the *preview tool* pattern is transferable.

---

### 5. AdnanSattar/cursor-openrouter-proxy (+ LiteLLM OpenRouter gateway pattern)

| Field | Value |
| --- | --- |
| URL | https://github.com/AdnanSattar/cursor-openrouter-proxy |
| README | https://raw.githubusercontent.com/AdnanSattar/cursor-openrouter-proxy/main/README.md |
| Stars (GitHub API, 2026-10-03) | **1** |
| Cursor-specific? | **Yes** (Cursor Models → OpenAI-compatible Base URL) |
| Related upstream | https://github.com/BerriAI/litellm (~**60,079** stars, API 2026-10-03) |

**What it does (README):** Dockerized LiteLLM gateway for Cursor. Exposes OpenAI-compatible `/v1` with logical models `chat` / `coder` / `vision`; routes to OpenRouter with latency-based routing, Redis cache, Postgres, Cloudflare Tunnel. Framed as workaround because “Cursor + OpenRouter is broken.”

**Mechanism:** Gateway + cascading failover chains in `config.yaml` + cache + public tunnel (Cursor SSRF / localhost constraints). Cursor sees stable names; LiteLLM owns retries/cooldowns/routing.

**Forum / secondary primary:** https://forum.cursor.com/t/workaround-to-get-openrouter-models-working-in-cursor/123235 (minimal LiteLLM on VPS).

**[Idea]** Logical aliases (`eco`/`max` as Cursor model picker names) vs real model ids; failover chains belong in YAML; for recommend-only skill, *do not* replace Cursor Pro — document gateway as optional escape hatch only.

---

### 6. lm-sys/RouteLLM (brief)

| Field | Value |
| --- | --- |
| URL | https://github.com/lm-sys/RouteLLM |
| README | https://raw.githubusercontent.com/lm-sys/RouteLLM/main/README.md |
| Blog | http://lmsys.org/blog/2024-07-01-routellm/ |
| Paper | https://arxiv.org/abs/2406.18665 |
| Stars (GitHub API, 2026-10-03) | **5,569** |
| Cursor-specific? | **No** (OpenAI-compatible server / Python client) |

**What it does (README):** Framework for serving and evaluating LLM routers. Drop-in OpenAI client/server; route simpler queries to cheaper models. Claims up to **85% cost reduction** while maintaining **~95% GPT-4** performance on MT Bench (trained routers). Strong/weak pair + cost threshold (`router-mf-<threshold>`). Routers: `mf` (recommended), `sw_ranking`, `bert`, `causal_llm`, `random`.

**Mechanism:** Learned binary routing (strong vs weak) with calibratable threshold — not agent orchestration.

**[Idea]** Calibrate `/eco` vs `/max` as thresholds on a personal history (Hindsight outcomes), not a fixed model name. Prefer lightweight heuristics over training unless you have labeled preference data.

---

### 7. Other notable open projects (>500★ or clear Cursor integration + routing claims)

#### diegosouzapw/OmniRoute

| Field | Value |
| --- | --- |
| URL | https://github.com/diegosouzapw/OmniRoute |
| Docs (auto-combo) | https://omniroute.hagicode.com/en-US/routing/auto-combo/ |
| Stars (GitHub API, 2026-10-03) | **72,555** |
| Cursor-specific? | **Yes listed** in description/topics (`cursor` among Claude Code, Codex, Copilot, etc.) |

**What it does (repo description + docs):** MIT AI gateway — one endpoint, hundreds of providers/models; quota-aware auto-fallback; MCP/A2A; strategies include `cost-optimized`, `auto`, `fusion` (parallel panel + judge), `pipeline` (sequential handoff), reset/headroom-aware quota routing, budget headers (`X-OmniRoute-Budget`).

**Mechanism:** Gateway / combo engine (not Cursor SDK propose/confirm).

**[Idea]** Budget headers + `cost-optimized` combo; fusion for hard decisions under `/max`; keep recommend-only skill as *advisor* that can suggest OmniRoute combo names without hosting a gateway.

#### BerriAI/litellm

| Field | Value |
| --- | --- |
| URL | https://github.com/BerriAI/litellm |
| Docs | https://docs.litellm.ai/docs/ |
| Stars | **~60,079** |
| Cursor-specific? | **No** (used *by* Cursor gateway setups) |

**Mechanism:** AI gateway — load balancing, fallback, cost tracking, OpenAI-compatible proxy. Underpins many Cursor OpenRouter workarounds.

#### OpenHands/OpenHands

| Field | Value |
| --- | --- |
| URL | https://github.com/OpenHands/OpenHands |
| Routing docs | https://docs.openhands.dev/sdk/guides/llm-routing |
| Stars (GitHub API, 2026-10-03) | **89,873** |
| Cursor-specific? | **No** |

**What official docs claim:** Built-in `MultimodalRouter` — text-only → secondary LLM; multimodal → primary; accumulate cost metrics. Feature “under active development.” Custom routers via extending `Router`.

**[Idea]** Rule-based multimodal/cost split is a simple YAML rule class (“vision → primary”). Cost report after run → lean log field.

#### CrewAI / AutoGen / LangGraph (routing claims filter)

| Project | Include for model/cost routing? | Notes |
| --- | --- | --- |
| CrewAI | **Weak / no primary README claim found this pass** | Role agents; per-agent `llm` config is common, but not a documented cost router. Skipped as primary routing evidence. |
| AutoGen | **Weak / no primary README claim found this pass** | Conversational multi-agent; `llm_config` per agent. Not cost routing. |
| LangGraph | **Control-flow routing, not cost routing** | Conditional edges route *graph nodes*; cost savings require user-chosen models per node or an external gateway. Not treated as a model router product. |

Secondary blogs discuss latency/cost of frameworks; those are **not** primary README claims and are omitted from “Located evidence.”

---

### 8. skills.sh / `npx skills` — relevant skills

Install counts are those **visible on skills.sh pages** as of 2026-10-03 (labeled “Installs” or large numeric badge). Where not shown in fetch text, marked **n/a**.

| Skill | skills.sh URL | Installs (visible) | Mechanism | Cursor? |
| --- | --- | --- | --- | --- |
| **workflow-orchestration-patterns** | https://www.skills.sh/wshobson/agents/workflow-orchestration-patterns | **~11.6K** | Skill-only; Temporal/distributed workflow patterns (not LLM cost routing) | No |
| **cost-aware-llm-pipeline** | https://www.skills.sh/affaan-m/ecc/cost-aware-llm-pipeline | **~9.5K** (find 2026-10-03) | Skill-only patterns: complexity routing, budgets, retries, prompt caching | No |
| **agentic-engineering** | https://www.skills.sh/affaan-m/ecc/agentic-engineering | **~9.7K** (find 2026-10-03) | Skill-only: completion criteria, agent-sized units, **route model tiers by complexity**, eval-first loop | No |
| **plan-orchestrate** | https://www.skills.sh/affaan-m/ecc/plan-orchestrate | **~5.7K** | Plan then orchestrate execution units | No |
| **orch-pipeline** | https://www.skills.sh/affaan-m/ecc/orch-pipeline | **~3.9K** | Pipeline orchestration skill | No |
| **subagent-driven-development** (obra) | https://www.skills.sh/obra/superpowers/subagent-driven-development | **~220.7K** | Fresh implementer subagent per task + reviews | Host-agnostic |
| **executing-plans** (obra) | https://www.skills.sh/obra/superpowers/executing-plans | **~227.9K** | Execute approved plans with checkpoints | Host-agnostic |
| **council** (warp) | https://www.skills.sh/warpdotdev/common-skills/council | **~26.4K** | Multi-perspective deliberation | No |
| **cross-critique** (warp) | https://www.skills.sh/warpdotdev/common-skills/cross-critique | **~20.5K** | Critique pass across drafts | No |
| **context-engineering** (addyosmani) | https://www.skills.sh/addyosmani/agent-skills/context-engineering | **~44.9K** | Context packing / handoff hygiene | No |
| **deep-agents-orchestration** | https://www.skills.sh/langchain-ai/langchain-skills/deep-agents-orchestration | **~14.9K** | LangChain deep-agent orchestration patterns | No |
| **omniroute-chat** | https://www.skills.sh/diegosouzapw/omniroute/omniroute-chat | n/a on page | Skill → OmniRoute HTTP (`auto`, `cost-optimized`, `subscription` combos) | Via gateway |
| **omniroute cli-routing** | https://www.skills.sh/diegosouzapw/omniroute/cli-routing | **~684** | CLI manage/test combos & fallback chains | Via gateway |
| **omniroute cli-setup** | https://www.skills.sh/diegosouzapw/omniroute/cli-setup | **~748** | Install/configure OmniRoute CLI | Via gateway |
| **thinking-model-combination** | https://www.skills.sh/tjboudreaux/cc-thinking-skills/thinking-model-combination | **~453** (catalog badge on https://www.skills.sh/tjboudreaux/cc-thinking-skills) | Skill-only: combine ≤3 mental models with roles + conflict rule (not LLM vendor routing) | No |
| **cursor-sdk** | https://www.skills.sh/cursor/plugins/cursor-sdk | n/a | Skill for `@cursor/sdk` local/cloud agents | **Yes** |
| **orchestrate** | https://www.skills.sh/cursor/plugins/orchestrate | n/a | `/orchestrate` fan-out to Cursor cloud agents; `plan.json` + CLI spawn/wait/handoff; requires cursor-sdk skill | **Yes** |
| **cursor-models** | https://www.skills.sh/hktitan/cursor-sdk/cursor-models | n/a | SDK model catalog / params / per-run override | **Yes** (SDK) |
| **subagent-driven-development** | https://www.skills.sh/openai/plugins/subagent-driven-development | n/a | Fresh implementer subagent per task + task review + whole-branch review | Host-agnostic |

Install command examples (from pages):

```bash
npx skills add https://github.com/affaan-m/ecc --skill cost-aware-llm-pipeline
npx skills add https://github.com/affaan-m/ecc --skill agentic-engineering
npx skills add https://github.com/affaan-m/ecc --skill plan-orchestrate
npx skills add https://github.com/diegosouzapw/omniroute --skill omniroute-chat
npx skills add https://github.com/wshobson/agents --skill workflow-orchestration-patterns
npx skills add tjboudreaux/cc-thinking-skills --skill thinking-model-combination
npx skills add obra/superpowers@subagent-driven-development
npx skills add obra/superpowers@executing-plans
npx skills add warpdotdev/common-skills@council
npx skills add warpdotdev/common-skills@cross-critique
npx skills add addyosmani/agent-skills@context-engineering
```

**Quality note (find-skills):** Prefer obra (~220K) and affaan-m/ecc (~9K+) over low-star Cursor MCP wrappers (~1★). Do not install OmniRoute/gateway skills as daily defaults if they bypass Cursor Pro Other Models accounting.

**Related skill (not in original list, high relevance):** https://www.skills.sh/v1truv1us/ai-eng-system/dynamic-router — conductor/subagent system routing by complexity across Anthropic/Cursor/OpenCode/Codex (“cheapest model that can do the job”).

---

## Assumptions

1. skills.sh numeric badges are **install counts** (pages label some as “Installs”; others show a bare number next to the repo slug).
2. GitHub `stargazers_count` from the public API on 2026-10-03 is the star figure used above.
3. Where repos 404’d mid-session (tgs-router-dev, mast-llm-router), earlier crawl/search text still reflects the published README at crawl time — **not** revalidated live.
4. User intent is a **recommend-only** Cursor Pro skill: no requirement to replicate gateways that spend external API keys.
5. “Cursor-specific” means first-class Cursor IDE/CLI/SDK/MCP config in primary docs — not “works with any MCP client that happens to include Cursor.”

---

## Gaps

1. **tgs-router-dev** and **mast-llm-router** not fetchable via GitHub API/HTML on 2026-10-03 (404) — may be private, renamed, or removed; re-check before citing in product docs.
2. Exact skills.sh install counts missing for `cursor-sdk`, `orchestrate`, `subagent-driven-development`, `omniroute-chat`, `thinking-model-combination` skill page body (catalog list had 453 for combination).
3. No deep dive of CrewAI/AutoGen official READMEs for cost routers this pass — filtered out after failing the “README claims model/cost routing” bar; could re-scan if needed.
4. npm weekly downloads for small Cursor MCP packages are low/noisy (search snippets: orchestrator ~4/wk, qmediat ~11–20/wk) — not treated as primary success metrics.
5. RouteLLM last push appears old (2024-08 per API) vs high stars — maintenance status not investigated.
6. Hindsight MCP integration patterns were **not** researched in third-party repos (out of scope unless they document it).

---

## Transferable ideas → personal Cursor Pro recommend-only skill

Labeled **[Idea]** (not evidence). Target: YAML tiers, exhausted Cursor-only matrix, Hindsight lean logs, `/eco` `/max`.

1. **[Idea] Propose → confirm UX** (from GustavoWinter): Always emit recommendation card (tier, model id, reason, estimated relative cost) and require explicit user confirm or slash mode before any future execute hook.
2. **[Idea] Plan shapes in YAML** (mapper / specialist / pipeline / hybrid): Encode as task templates, not as auto-spawning agents.
3. **[Idea] Tier matrix + cost_rank** (from TGs-router): `low|medium|high` with Cursor-only model ids; `preferred_routing` for ties; `/eco` = force low/medium preference, `/max` = allow high + optional fusion/second model.
4. **[Idea] Exhausted matrix:** When all Cursor-tier options are rate-limited/unavailable, recommend wait / downgrade / user-gated external gateway — never silently leave Cursor Pro path (contrast OpenRouter proxy repos).
5. **[Idea] Preview routing** (mast `llm_detect_task`): Pure function `classify(prompt) → {tier, model, reasons[]}` with no side effects.
6. **[Idea] Supervisor round cap** (qmediat cursor-code): If skill ever suggests a second model opinion under `/max`, hard-cap iterations (e.g. 1–3).
7. **[Idea] Logical aliases** (LiteLLM proxy): Expose `/eco` and `/max` as skill modes mapped to YAML, not as fake OpenAI model names that break Cursor Pro.
8. **[Idea] Threshold calibration** (RouteLLM): Maintain rolling “strong model %” from Hindsight outcomes; adjust recommend bias without ML training initially.
9. **[Idea] Lean logs** (inspired by TGs learning loop + OpenHands cost metrics): Store `{ts, task_class, recommended, chosen, outcome_ok, notes}` — no full prompts/PII.
10. **[Idea] Skill composition:** Reuse patterns from `cost-aware-llm-pipeline` + `agentic-engineering` (complexity → tier) and Cursor `orchestrate`/`cursor-sdk` only if fan-out is explicitly requested — keep default path recommend-only.
11. **[Idea] Thinking-model-combination:** For ambiguous routing decisions, run ≤3 *decision lenses* (cost / risk / deadline) with a named conflict rule — meta-reasoning, not multi-LLM spend.
12. **[Idea] OmniRoute as optional backend:** Document “if user runs OmniRoute, suggest `auto/cheap` vs coding combo” without making it a dependency of the Cursor Pro skill.
13. **[Idea] Companion Superpowers** (`obra/superpowers` subagent-driven-development + executing-plans, ~220K+ installs): use for *how* to run Task subagents; our skill remains sole cost/tier authority (D20).
14. **[Idea] Council / cross-critique skills** (warp ~20–26K installs): map to capped `/max` review paths (D15, D21) — never uncapped multi-model spend.
15. **[Idea] Context-engineering skill** (~45K): informal checklist for compact handoffs (D17) before inventing a custom protocol.
16. **[Idea] ecc plan-orchestrate / orch-pipeline** (~4–6K): plan shapes as skill text, not a second router competing with YAML.

---

## Quick comparison matrix

| Project | Mechanism | Cursor-native | Stars / installs | Best steal for recommend-only |
| --- | --- | --- | --- | --- |
| cursor-agent-orchestrator-mcp | Propose/confirm/execute | Yes | 1★ | Confirm gate, plan shapes |
| qmediat/cursor-mcp | CLI multi-model tools | Yes | 1★ | Live model list, round-capped second opinion |
| tgs-router-dev | CLI cost tiers + waves | Partial | 0★ (crawl); **404 now** | YAML tiers, preferred_routing |
| mast-llm-router | Task cascade + cache | MCP client | 3★ (crawl); **404 now** | detect_task preview |
| cursor-openrouter-proxy | LiteLLM gateway | Yes (custom Base URL) | 1★ | Logical aliases + failover YAML |
| RouteLLM | Learned strong/weak | No | 5.6k★ | Threshold /eco vs /max |
| OmniRoute | Gateway combos | Listed | 72k★ | Budget + cost-optimized combos |
| LiteLLM | Gateway | No | 60k★ | Fallback/load-balance primitives |
| OpenHands MultimodalRouter | Rule router | No | 90k★ | Simple rule classes + cost field |
| cost-aware-llm-pipeline | Skill patterns | No | ~9.5K installs | Complexity → model |
| agentic-engineering | Skill patterns | No | ~9.7K installs | Eval-first + tier by complexity |
| obra subagent-driven-development | Subagent workflow | Host-agnostic | ~221K installs | Companion how-to (D20) |
| warp council / cross-critique | Multi-perspective | No | ~20–26K | Capped `/max` review (D15/D21) |
| orchestrate (cursor/plugins) | Cloud agent fan-out | Yes | n/a | Explicit `/orchestrate` only |

---

## Source index (URLs touched)

- https://github.com/GustavoWinter/cursor-agent-orchestrator-mcp  
- https://github.com/qmediat/cursor-mcp  
- https://github.com/timgrossinger/tgs-router-dev *(404 on 2026-10-03 re-fetch)*  
- https://github.com/m4stanuj/mast-llm-router *(404 on 2026-10-03 re-fetch)*  
- https://github.com/AdnanSattar/cursor-openrouter-proxy  
- https://github.com/lm-sys/RouteLLM  
- https://github.com/diegosouzapw/OmniRoute  
- https://github.com/BerriAI/litellm  
- https://github.com/OpenHands/OpenHands  
- https://docs.openhands.dev/sdk/guides/llm-routing  
- https://omniroute.hagicode.com/en-US/routing/auto-combo/  
- https://www.skills.sh/affaan-m/ecc/cost-aware-llm-pipeline  
- https://www.skills.sh/affaan-m/ecc/agentic-engineering  
- https://www.skills.sh/wshobson/agents/workflow-orchestration-patterns  
- https://www.skills.sh/diegosouzapw/omniroute/omniroute-chat  
- https://www.skills.sh/diegosouzapw/omniroute/cli-routing  
- https://www.skills.sh/tjboudreaux/cc-thinking-skills/thinking-model-combination  
- https://www.skills.sh/cursor/plugins/cursor-sdk  
- https://www.skills.sh/cursor/plugins/orchestrate  
- https://www.skills.sh/openai/plugins/subagent-driven-development  
- https://www.skills.sh/obra/superpowers/subagent-driven-development  
- https://www.skills.sh/obra/superpowers/executing-plans  
- https://www.skills.sh/warpdotdev/common-skills/council  
- https://www.skills.sh/warpdotdev/common-skills/cross-critique  
- https://www.skills.sh/addyosmani/agent-skills/context-engineering  
- https://www.skills.sh/affaan-m/ecc/plan-orchestrate  
- https://www.skills.sh/hktitan/cursor-sdk/cursor-models  
- https://forum.cursor.com/t/workaround-to-get-openrouter-models-working-in-cursor/123235  

---

*End of research note. No other repo files were modified for this write-up.*
