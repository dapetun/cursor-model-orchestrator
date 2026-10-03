# LLM Routing / Orchestration Landscape (Cursor Pro personal orchestrator)

**Search boundary:** 2026-10-03 (primary sources only: papers, official docs, project READMEs).  
**Scope:** RouteLLM, FrugalGPT, AutoMix, Cursor Router/Auto, and practical Cursor-side orchestrators/gateways.  
**Labeling:** `[Evidence]` = claim tied to a cited primary source; `[Idea]` = synthesis/implication not stated by that source; `[Assumption]` = working hypothesis for a personal Pro orchestrator.

---

## 1. RouteLLM (LMSYS / UC Berkeley / Anyscale)

### Located evidence

| Claim | Source |
| --- | --- |
| RouteLLM is a framework for **serving and evaluating** LLM routers; drop-in OpenAI client / OpenAI-compatible server. | [GitHub README](https://github.com/lm-sys/RouteLLM) · [raw README](https://raw.githubusercontent.com/lm-sys/RouteLLM/main/README.md) |
| Paper: *RouteLLM: Learning to Route LLMs with Preference Data* (Ong et al., 2024). | [arXiv:2406.18665](https://arxiv.org/abs/2406.18665) |
| Official LMSYS blog summarizes claims and open-sources code/datasets. | [LMSYS blog 2024-07-01](https://www.lmsys.org/blog/2024-07-01-routellm/) |
| **Method (binary single-route):** learn \(P(\mathrm{win}_s \mid q)\) from preference data; threshold \(\alpha\) sends query to strong vs weak model — **one LLM call per query** (not cascade). | [arXiv:2406.18665](https://arxiv.org/abs/2406.18665) §3.1 |
| Preference data from Chatbot Arena; models tiered into strong/weak classes; responses excluded from training (winner labels only). | [arXiv:2406.18665](https://arxiv.org/abs/2406.18665) §4.1 |
| Four routers: similarity-weighted (SW) ranking, matrix factorization (MF), BERT classifier, causal LLM classifier (+ random baseline). | [README](https://raw.githubusercontent.com/lm-sys/RouteLLM/main/README.md) · paper §4.2 |
| **Blog claim:** cost reductions **>85% on MT Bench, 45% on MMLU, 35% on GSM8K** vs GPT-4-only while still achieving **~95% of GPT-4 performance** (under their eval setup). | [LMSYS blog](https://www.lmsys.org/blog/2024-07-01-routellm/) |
| **Paper claim:** can reduce costs by **over 2×** without substantially compromising quality; routers generalize across model pairs without retraining. | [arXiv abstract / §1](https://arxiv.org/abs/2406.18665) |
| MF on Arena+LLM-judge data: CPT(50%) ≈ **13.4%** strong calls on MT Bench (vs ~49% random). | [arXiv Table 1](https://arxiv.org/abs/2406.18665) |
| Arena-only routers are **near-random on MMLU/GSM8K** (OOD); small golden/judge augmentation restores gains. | [arXiv Tables 2–3, §5.1–5.3](https://arxiv.org/abs/2406.18665) |
| Compared to FrugalGPT / AutoMix / LLM-Blender: those use **multi-LLM** querying (cascade / verify / ensemble); RouteLLM targets **single-LLM routing** for latency. | [arXiv §2 Related Work](https://arxiv.org/abs/2406.18665) |
| Serving: `router-[name]-[threshold]`; calibrate threshold for target strong-model %; recommends `mf`; uses LiteLLM for providers. | [README](https://raw.githubusercontent.com/lm-sys/RouteLLM/main/README.md) |
| Router overhead small vs generation (e.g. MF ~$3.32 / million requests in their VM estimate). | [arXiv Table 7](https://arxiv.org/abs/2406.18665) |

### Assumptions

- `[Assumption]` Preference-trained “query hardness” routers transfer to coding-agent prompts only if the user’s prompt distribution is similar enough to Arena/augmented chat (paper’s own similarity analysis implies otherwise for OOD).
- `[Assumption]` For Cursor Pro, “strong/weak” is more naturally **Cursor Models pool vs Other Models pool** than GPT-4 vs Mixtral.

### Gaps

- No Cursor-specific or coding-agent benchmark in primary sources.
- Binary strong/weak focus; N-way routing left as future foundation ([paper §3.1](https://arxiv.org/abs/2406.18665)).
- Live calibration on **your** query mix is required; Arena-calibrated thresholds won’t match agent tool-use traffic ([README calibration section](https://raw.githubusercontent.com/lm-sys/RouteLLM/main/README.md)).

### Ideas vs evidence

- `[Evidence]` Pre-call, single-model routing from preferences + threshold.
- `[Idea]` A recommend-only skill can mimic RouteLLM’s **thresholded win-rate** as a *policy recommendation* without deploying MF/BERT.

---

## 2. FrugalGPT (Stanford) — cascade vs single-route

### Located evidence

| Claim | Source |
| --- | --- |
| Paper: *FrugalGPT: How to Use Large Language Models While Reducing Cost and Improving Performance* (Chen, Zaharia, Zou). | [arXiv:2305.05176](https://arxiv.org/abs/2305.05176) · [HTML](https://arxiv.org/html/2305.05176v1) · [TMLR PDF](https://lingjiaochen.com/papers/2024_FrugalGPT_TMLR.pdf) |
| Official implementation / notebook. | [stanford-futuredata/FrugalGPT](https://github.com/stanford-futuredata/FrugalGPT) |
| Three strategy families: **(1) prompt adaptation**, **(2) LLM approximation**, **(3) LLM cascade**. | [arXiv §3](https://arxiv.org/html/2305.05176v1) |
| **Cascade:** query LLMs **sequentially**; accept when a generation scoring function \(g(q,a)\) exceeds threshold; else escalate. Learns list \(L\) and thresholds \(\tau\) under a budget. | [arXiv §3 Strategy 3](https://arxiv.org/html/2305.05176v1) |
| Scoring function can be a small regression model (e.g. DistilBERT) on (query, answer) → reliability — **post-generation** quality estimate. | [arXiv §3–4](https://arxiv.org/html/2305.05176v1) |
| Empirically: match best individual LLM with **up to ~98% cost reduction**, or **~+4% accuracy** at same cost (task-dependent). | [arXiv abstract](https://arxiv.org/abs/2305.05176) |
| HEADLINES case: cascade GPT-J → J1-L → GPT-4; ~**80% cost cut** and **+1.5% accuracy** vs GPT-4 alone at their budget. | [arXiv §4 Case Study](https://arxiv.org/html/2305.05176v1) |
| Cheap LLMs are complementary: MPI shows cases where GPT-4 errs but cheaper models are correct (~6% on HEADLINES in their figure discussion). | [arXiv §4 LLM diversity](https://arxiv.org/html/2305.05176v1) |
| Notebook exposes **LLMforAll** (unified interface) and **LLMCascade** (budget-constrained optimization). | [intro.ipynb](https://github.com/stanford-futuredata/FrugalGPT/blob/main/intro.ipynb) |

### Cascade vs single-route (explicit)

| Dimension | Single-route (RouteLLM-style) | Cascade (FrugalGPT-style) |
| --- | --- | --- |
| Calls per query | Exactly **1** LLM | **1…m** until accept |
| Decision time | **Before** generation (query-only) | **After** each generation (query+answer score) |
| Latency | Lower | Higher when escalating |
| Can beat best single model | Rarely (picks one) | Yes, via complementarity ([FrugalGPT MPI](https://arxiv.org/html/2305.05176v1)) |
| Needs labels / training | Preference or win labels | Correctness / scoring data for \(g\) and thresholds |

### Assumptions

- `[Assumption]` Agent tasks with tool loops amplify cascade cost (each escalate may re-run tools), so FrugalGPT’s “API QA” cascade ≠ Cursor Agent cascade without redesign.
- `[Assumption]` DistilBERT-style scorers won’t transfer cleanly to open-ended code diffs; need task-specific verifiers.

### Gaps

- Primary experiments are classification / reading-comprehension style tasks with short answers — not long-horizon coding agents.
- Cascade optimization is mixed-integer / specialized; not a drop-in Cursor skill.

### Ideas vs evidence

- `[Evidence]` Cascade pays extra calls for a chance to **match or beat** the top model cheaper.
- `[Idea]` Escalation should be gated by a cheap verifier, not by “always try Opus next.”

---

## 3. AutoMix (and self-verify → escalate)

### Located evidence

| Claim | Source |
| --- | --- |
| Paper: *AutoMix: Automatically Mixing Language Models* (Aggarwal et al.; NeurIPS 2024). | [arXiv:2310.12963](https://arxiv.org/abs/2310.12963) · [NeurIPS PDF](https://proceedings.neurips.cc/paper_files/paper/2024/file/ecda225cb187b40ea8edc1f46b03ffda-Paper-Conference.pdf) |
| Code: `github.com/automix-llm/automix`. | Linked from [arXiv abstract](https://arxiv.org/abs/2310.12963) |
| **Pipeline:** (1) small LM generates; (2) **few-shot self-verification** (entailment vs context); (3) router decides accept vs escalate to larger LM. | [arXiv §4 / Fig 1](https://arxiv.org/abs/2310.12963) |
| Verification: sample \(k\) high-temperature judgments; \(p(\mathrm{correct})=\frac{1}{k}\sum \mathbf{1}\{\mathrm{correct}\}\); same 4-shot prompt across tasks; **no trained verifier**. | [arXiv §4.1](https://arxiv.org/abs/2310.12963) |
| Router options: simple **threshold** on \(v\); or **POMDP** meta-verifier treating verification as noisy observation of difficulty; can avoid escalating **unsolvable** queries. | [arXiv §4.2](https://arxiv.org/abs/2310.12963) |
| Reward \(R = P - \lambda C\); learns from as few as **~50** examples. | [arXiv §1, §4.2](https://arxiv.org/abs/2310.12963) |
| Claimed: consistently beats strong baselines; **>50% compute cost reduction** for comparable performance (five LMs, five datasets). | [arXiv abstract](https://arxiv.org/abs/2310.12963) |
| Assumes **context-grounded** tasks (context available for entailment checks). | [arXiv §3](https://arxiv.org/abs/2310.12963) |
| Explicitly positions against FrugalGPT-style trained verifiers: AutoMix uses few-shot SLM verification + black-box APIs. | [arXiv §2](https://arxiv.org/abs/2310.12963) |

### Assumptions

- `[Assumption]` Coding agents often lack a single “context paragraph” that entails the answer; AutoMix’s entailment verifier needs a redesigned check (tests, typecheck, lint, patch apply).
- `[Assumption]` \(k\)-sample self-verify multiplies weak-model tokens — material under a tight Other Models budget.

### Gaps

- Primary evals are dialogue / context-grounded reasoning — not IDE agent loops.
- POMDP setup complexity may exceed a personal skill’s maintainability.

### Ideas vs evidence

- `[Evidence]` Self-verify-then-escalate is a distinct pattern from pre-call routing and from FrugalGPT’s trained DistilBERT scorer.
- `[Idea]` Map AutoMix’s \(v\) to cheap **deterministic** checks (pytest / tsc / eslint) before escalating to frontier models.

---

## 4. Cursor Router / Auto — individuals vs Teams

### Located evidence

| Claim | Source |
| --- | --- |
| **Cursor Router** is the routing system behind **Auto**; classifies agent requests by task type/complexity; picks cost-effective model. | [cursor.com/docs/cursor-router](https://cursor.com/docs/cursor-router) |
| **“Cursor Router is currently only available on Teams and Enterprise plans.”** | [cursor.com/docs/cursor-router](https://cursor.com/docs/cursor-router) |
| Help: Router **launches for Teams and Enterprise**; Individual plans (Hobby, Pro, Pro+, Ultra) “will receive this update a few months after launch.” Enterprise starts **off** (admin opt-in). | [cursor.com/help/.../pricing](https://cursor.com/help/account-and-billing/pricing) |
| Staff on forum (2026-09-07): Router on Teams/Enterprise now; Individual expansion under evaluation; **Individual Auto still picks a model per request** but **without Intelligence / Balance / Cost** Router settings. | [forum.cursor.com/.../169498](https://forum.cursor.com/t/bring-cursor-router-to-individual-plans-pro-pro-ultra/169498) (@deanrie) |
| Optimize For modes: **Cost** (previous Auto logic), **Balance**, **Intelligence**. Balance/Intelligence use limits faster than Cost. | [cursor.com/docs/cursor-router](https://cursor.com/docs/cursor-router) |
| All Auto modes bill at **list price of the routed model**; third-party also incur **Cursor Token Rate** (Teams/Enterprise: **$0.25 / M tokens**). | [cursor-router](https://cursor.com/docs/cursor-router) · [models-and-pricing](https://cursor.com/docs/models-and-pricing) |
| Router model pool (docs): GPT-5.5, Claude Opus 5, Grok 4.6, Claude Fable 5; **Grok 4.6 required**; blocking GPT-5.5 and Opus 5 together disables router. | [available-models help](https://cursor.com/help/models-and-usage/available-models) |
| Two usage pools: **Cursor Models** (Grok 4.7/4.6/4.5, Composer 2.5) and **Other Models** (third-party at API price). Pro includes both pools. | [models-and-pricing](https://cursor.com/docs/models-and-pricing) · [usage-limits](https://cursor.com/help/models-and-usage/usage-limits) |
| Pro plan price: **$20/mo**. | [pricing help](https://cursor.com/help/account-and-billing/pricing) |
| Auto / Router can draw from **both** pools depending on routed model; subagents on named third-party models also hit Other Models. | [usage-limits](https://cursor.com/help/models-and-usage/usage-limits) |
| **Individual BYOK:** model cost billed by provider; **does not** draw Cursor pools. Teams/Enterprise BYOK still pays Cursor Token Rate into Other Models. | [usage-limits](https://cursor.com/help/models-and-usage/usage-limits) |
| SDK: Router as `auto-smart` + `optimize_for` (`cost` / `balanced` / `intelligence`); confirm via `Cursor.models.list()`. | [cursor-router](https://cursor.com/docs/cursor-router) |
| Built-in subagents pick models automatically; custom subagents default to `inherit`. | [available-models help](https://cursor.com/help/models-and-usage/available-models) |
| On Teams/Enterprise, Router docs/admin settings cover enablement, mode allowlists, show/hide underlying model, Impose Auto soft/hard. | [cursor-router](https://cursor.com/docs/cursor-router) |

### Assumptions

- `[Assumption]` User’s “hard **$20 Other Models** budget” refers to Pro’s included Other Models allowance historically described as **$20** in help tables / staff posts; **live docs as of this search often omit the dollar figure**. Confirm in dashboard Spending tab.
- `[Assumption]` Preferential use of **Composer / Grok (Cursor Models pool)** for default work is the main way a Pro user avoids burning Other Models.

### Gaps

- Exact published dollar size of Pro Other Models allowance is **unstable across primary sources**: indexed help once showed Pro → $20 Other Models; current models-and-pricing page says “Included” without a number; a staff reply on Ultra metering said they **no longer publish specific dollar amounts** ([forum thread](https://forum.cursor.com/t/bug-help-other-models-hits-100-while-usage-export-at-published-api-rates-only-reconstructs-65-how-to-reconcile-the-meter/172012)).
- Public docs do not expose Router classifier features / training data.
- Individual “basic Auto” pricing mechanics (“fixed price” in forum staff wording vs “list price of routed model” in docs) need dashboard verification — wording differs between sources.

### Ideas vs evidence

- `[Evidence]` Full Cursor Router (Cost/Balance/Intelligence) is **Teams/Enterprise**, not Pro, as of 2026-10-03 docs + staff post.
- `[Idea]` A personal recommend-only / MCP orchestrator is a rational Pro substitute for missing Router controls.

---

## 5. Practical Cursor-side orchestrators & gateways (README / official docs only)

### 5.1 GustavoWinter/cursor-agent-orchestrator-mcp

**Source:** [README](https://raw.githubusercontent.com/GustavoWinter/cursor-agent-orchestrator-mcp/main/README.md) · [repo](https://github.com/GustavoWinter/cursor-agent-orchestrator-mcp)

| Capability (README) | Notes |
| --- | --- |
| MCP server over **`@cursor/sdk`** | Parallel agents from one Cursor chat |
| Flow: **propose → confirm → execute** | `confirm_plan` gates `execute_plan` server-side |
| Tools | `propose_plan`, `confirm_plan`, `execute_plan`, `stream_plan`, status/result/cancel, `prompt_one_shot`, list/prune/attach/resume |
| Plan shapes | mapper / specialist / **pipeline** / hybrid |
| Runtimes | `local`, `cloud`, or `auto`; concurrency caps |
| Models | `CURSOR_PARENT_MODEL` (default `composer-2`); planner override; subagents default `inherit` |
| Status | v0.1.x public beta |

**Not claimed in README:** learned cost routing, FrugalGPT cascade, AutoMix verification, or Other Models budget accounting.

### 5.2 mast-llm-router (m4stanuj)

**Source:** [GitHub repo / README excerpts](https://github.com/m4stanuj/mast-llm-router) (raw README fetch returned 404 from this environment; claims below are from the project README content surfaced via GitHub/search primary page text and companion `AGENTS.md` / `PRESENTATION.md` on the same repo).

| Capability (project README) | Notes |
| --- | --- |
| Task-aware **fallback router** as MCP | Clients listed: Claude Code, Cursor, Windsurf, Continue.dev, Codex CLI, … |
| Keyword/task detection → chain | Chains: speed, reason, code, vision, research, write, agent, pentest, hinglish, vision_reason |
| **13 provider routes**, **6 fallbacks** per chain | Failover on 429/503/empty |
| Semantic cache | Fuzzy match ~0.82 threshold, 500-entry LRU |
| SMART_KEY auto-detect | Prefix-based provider detection |
| Cost positioning | Claims **$0/month** via free-tier APIs |
| Transports | stdio + HTTP |

**Not claimed:** preference-trained quality routing (RouteLLM), DistilBERT quality scoring (FrugalGPT), or POMDP self-verify (AutoMix). This is **reliability / free-tier failover**, not quality-cost CPT routing.

### 5.3 LiteLLM gateway patterns

**Sources:** [BerriAI/litellm README](https://github.com/BerriAI/litellm) · [docs.litellm.ai](https://docs.litellm.ai/) · [Fallbacks docs](https://docs.litellm.ai/docs/proxy/reliability) · [OpenRouter provider page](https://docs.litellm.ai/docs/providers/openrouter)

| Capability | Source claim |
| --- | --- |
| Unified OpenAI-format SDK + **Proxy / AI Gateway** for 100+ providers | README |
| Router: retry/fallback across deployments; load balancing; spend tracking / virtual keys / budgets (proxy) | README · getting started |
| Fallbacks: `fallbacks`, `context_window_fallbacks`, `content_policy_fallbacks`; ordered model groups | [proxy/reliability](https://docs.litellm.ai/docs/proxy/reliability) |
| OpenRouter as provider: `model=openrouter/<model>`; env `OPENROUTER_API_KEY` | [OpenRouter docs page](https://docs.litellm.ai/docs/providers/openrouter) |
| RouteLLM itself uses LiteLLM for multi-provider completions | [RouteLLM README](https://raw.githubusercontent.com/lm-sys/RouteLLM/main/README.md) |

### 5.4 OpenRouter gateway patterns

**Sources:** [OpenRouter Quickstart](https://openrouter.ai/docs) · [Model Fallbacks](https://openrouter.ai/docs/guides/routing/model-fallbacks) · [Provider selection](https://openrouter.ai/docs/guides/routing/provider-selection) · [Failover blog](https://openrouter.ai/blog/insights/reliability-failover/)

| Capability | Source claim |
| --- | --- |
| Single API to many models; OpenAI-compatible base URL | Quickstart |
| **Provider-layer failover** default (`allow_fallbacks: true`) — same model, other providers | Provider selection · Failover blog |
| **Model-layer fallbacks** opt-in via `models` array (priority order); triggers on downtime, rate limits, context-length, moderation | Model Fallbacks |
| Pricing charged for the **model ultimately used** | Model Fallbacks |
| Provider prefs: `order`, `only`, `ignore`, latency/throughput preferences | Provider selection |

**Not claimed:** preference-trained quality routing or self-verify escalation — these are **availability / provider** routers.

---

## Cross-cutting: Located evidence / Assumptions / Gaps

### Located evidence (patterns that recur)

1. **Pre-call single-route** (RouteLLM): decide strong vs weak from the query; one generation.
2. **Post-call cascade** (FrugalGPT): generate → score → maybe escalate; can beat the best single model.
3. **Self-verify escalate** (AutoMix): generate with small → few-shot entailment → threshold/POMDP → large.
4. **Reliability failover** (LiteLLM / OpenRouter / mast): escalate on **errors/limits**, not on quality scores.
5. **Agent fan-out** (cursor-agent-orchestrator-mcp): parallel SDK agents with human confirm — orthogonal to model-tier routing.
6. **Cursor product split:** full Router modes on Teams/Enterprise; Pro keeps Auto without those controls; usage split Cursor Models vs Other Models.

### Assumptions (for a Cursor Pro personal orchestrator)

1. Hard budget ≈ Pro **Other Models** included pool (historically ~$20; verify live).
2. Default daily work should prefer **Composer / Grok** (Cursor Models) so orchestration rarely touches Other Models.
3. When Other Models are used, **single-route recommendation** beats naive cascade/best-of-N under a hard dollar cap.
4. Deterministic verifiers (tests) beat LLM self-verify for code when available.

### Gaps

1. No primary source measures these methods on Cursor Agent tool-use trajectories.
2. Pro Router feature parity and exact Other Models dollar allowance are **product-moving**; re-check docs/dashboard each release.
3. mast-llm-router raw README was not fetchable from this environment (404); capabilities taken from GitHub-rendered README text — re-fetch before relying on version numbers.
4. Best-of-N / speculative decoding papers were out of scope unless tied to the listed topics.

---

## Implications for a recommend-only skill → subagents → cascade → best-of-N  
*(under hard ~$20 Other Models budget on Cursor Pro)*

Labels: `[Evidence]` from above; `[Idea]` product design guidance.

### Stage A — Recommend-only skill (now)

- `[Idea]` Emit a **route recommendation**: `{tier, model_or_pool, reason, escalate_if}` without spawning agents.
- `[Evidence→Idea]` Borrow RouteLLM’s **threshold / CPT mindset**: default weak (Composer/Grok); escalate only when predicted “needs strong.”
- `[Evidence]` Prefer Cursor Models pool for defaults ([models-and-pricing](https://cursor.com/docs/models-and-pricing)).
- `[Idea]` Log recommendations vs outcomes offline to build a tiny preference dataset (Arena-style), instead of shipping MF weights day one.

### Stage B — Subagents

- `[Evidence]` Parallel SDK orchestration exists ([cursor-agent-orchestrator-mcp README](https://raw.githubusercontent.com/GustavoWinter/cursor-agent-orchestrator-mcp/main/README.md)); custom subagents can override `model` ([Cursor available-models](https://cursor.com/help/models-and-usage/available-models)).
- `[Idea]` Assign **roles to pools**: explore/draft → Composer; hard reasoning / final review → sparse Other Models.
- `[Evidence]` Subagent third-party calls still burn Other Models even if parent shows Auto ([usage-limits](https://cursor.com/help/models-and-usage/usage-limits)) — fan-out is a budget risk.
- `[Idea]` Keep human confirm (orchestrator MCP pattern) before any multi-agent spend.

### Stage C — Cascade

- `[Evidence]` FrugalGPT/AutoMix show cascade can save money **or** improve quality — but **multiply tokens** on escalate path.
- `[Idea]` Cascade only with **cheap acceptance tests**: lint/typecheck/unit test / structured checklist — not \(k\)-sample LLM self-verify by default.
- `[Idea]` Cap cascade depth (e.g. max 2 models) and hard-stop when Other Models spend in-session exceeds a fraction of monthly pool.
- `[Evidence]` RouteLLM warns multi-LLM approaches hurt latency ([paper §2](https://arxiv.org/abs/2406.18665)) — cascade last for interactive chat.

### Stage D — Best-of-N

- `[Idea]` Best-of-N is the **most expensive** stage under a hard Other Models cap; treat as rare (architecture decisions, security reviews).
- `[Evidence]` FrugalGPT’s MPI shows diversity value — but their wins came from **selective** use of cheap models, not N frontier samples.
- `[Idea]` If best-of-N is needed: N on **Composer/Grok**, judge once with a single mid-tier Other Models call — invert the usual “N× Opus” pattern.
- `[Evidence]` Reliability fallbacks (LiteLLM/OpenRouter `models` array) are **not** quality best-of-N; don’t confuse them ([OpenRouter Model Fallbacks](https://openrouter.ai/docs/guides/routing/model-fallbacks)).

### Budget heuristic (idea, not vendor policy)

| Spend class | Suggested default | Escalation trigger |
| --- | --- | --- |
| Routine edit / nav | Cursor Models (Composer) | — |
| Multi-file implement | Composer → optional Sonnet-class if tests fail | Deterministic fail |
| Hard debug / design | Single strong Other Models call | Recommend-only first |
| Parallel subagents | Cap concurrency; inherit cheap parent | User confirm |
| Best-of-N | Avoid on Other Models | Explicit user opt-in |

---

## Source index (primary)

1. RouteLLM paper — https://arxiv.org/abs/2406.18665  
2. RouteLLM README — https://github.com/lm-sys/RouteLLM  
3. LMSYS RouteLLM blog — https://www.lmsys.org/blog/2024-07-01-routellm/  
4. FrugalGPT paper — https://arxiv.org/abs/2305.05176  
5. FrugalGPT repo — https://github.com/stanford-futuredata/FrugalGPT  
6. AutoMix paper — https://arxiv.org/abs/2310.12963  
7. AutoMix NeurIPS PDF — https://proceedings.neurips.cc/paper_files/paper/2024/file/ecda225cb187b40ea8edc1f46b03ffda-Paper-Conference.pdf  
8. Cursor Router docs — https://cursor.com/docs/cursor-router  
9. Cursor Models & Pricing — https://cursor.com/docs/models-and-pricing  
10. Cursor pricing help — https://cursor.com/help/account-and-billing/pricing  
11. Cursor usage limits — https://cursor.com/help/models-and-usage/usage-limits  
12. Cursor available models — https://cursor.com/help/models-and-usage/available-models  
13. Cursor forum (Router on Individuals) — https://forum.cursor.com/t/bring-cursor-router-to-individual-plans-pro-pro-ultra/169498  
14. cursor-agent-orchestrator-mcp README — https://github.com/GustavoWinter/cursor-agent-orchestrator-mcp  
15. mast-llm-router — https://github.com/m4stanuj/mast-llm-router  
16. LiteLLM README — https://github.com/BerriAI/litellm  
17. LiteLLM fallbacks — https://docs.litellm.ai/docs/proxy/reliability  
18. OpenRouter docs / fallbacks — https://openrouter.ai/docs · https://openrouter.ai/docs/guides/routing/model-fallbacks · https://openrouter.ai/docs/guides/routing/provider-selection  

---

*End of note. No commits made. Search boundary: 2026-10-03.*
