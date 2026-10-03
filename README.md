# Cursor Model Orchestrator

**What it is:** A recommend-only Cursor skill that classifies each prompt with deterministic rules (keywords + project type) and recommends a cost-aware model under the Cursor Pro **Other Models** (~$20) budget. It overlays Auto/Router for routine work; it does not replace Auto and does not force the model picker.

**Last updated:** 2026-10-03 · **License:** [MIT](LICENSE) · **Release:** [v0.1.0](https://github.com/dapetun/cursor-model-orchestrator/releases/tag/v0.1.0)

**Stack partner (optional):** [cursor-hindsight-ondemand](https://github.com/dapetun/cursor-hindsight-ondemand) — local Hindsight daemon lifecycle on Windows. This repo is the **model router**; that repo is **memory lifecycle**. GitNexus is separate upstream.

## Core vs stack

| Profile | Hindsight | GitNexus | When to use |
| --- | --- | --- | --- |
| **core** (default) | Not required; retain skipped | Not required | Standalone routing skill |
| **stack** | Soft retain if MCP `hindsight` is up | Optional impact hints | You already use / will install ondemand + optional GitNexus |

Install stack order: (1) this repo `-Profile stack` → (2) [cursor-hindsight-ondemand](https://github.com/dapetun/cursor-hindsight-ondemand) `install.ps1` → (3) GitNexus optional. Details: [docs/integrations/stack.md](docs/integrations/stack.md).

## Goals

- Protect the **Other Models** pool (~$20/mo) from trivia
- Force strong models for science/stats (no cheap-first)
- Short Russian explanation of every routing decision (`[route]`)
- Long-horizon research: v0 recommend-only → v1 subagents → v2 cascade/best-of-N → v3 usage ops

## Install

### Core (standalone)

```powershell
git clone https://github.com/dapetun/cursor-model-orchestrator.git
cd cursor-model-orchestrator
Copy-Item config\projects.example.yaml config\projects.yaml
# Edit config/projects.yaml — your path_prefixes
pwsh -File .\scripts\install_skill.ps1 -Profile core
```

Details: [docs/integrations/core.md](docs/integrations/core.md).

### Stack (Hindsight + optional GitNexus)

```powershell
pwsh -File .\scripts\install_skill.ps1 -Profile stack
```

Then install **[cursor-hindsight-ondemand](https://github.com/dapetun/cursor-hindsight-ondemand)** (`install.ps1` + hooks/MCP), and optionally GitNexus MCP + `analyze` on coding repos.

Details: [docs/integrations/stack.md](docs/integrations/stack.md).

Copies `skill/model-orchestrator/` to `%USERPROFILE%\.cursor\skills\model-orchestrator\` and writes `ORCHESTRATOR_ROOT` + `integrations.yaml`.

## Slash commands

| Command | Effect |
| --- | --- |
| `/eco` | Cursor Models only (Composer/Grok) |
| `/max` | Prefer strong Other Models when budget allows |
| `/route` | Print routing decision and stop (debug) |

Tags: `@ds` `@paper` `@web` override project-type detection.

## Config

- [`config/integrations.yaml`](config/integrations.yaml) — `core` / `stack` (templates: `integrations.core.yaml`, `integrations.stack.yaml`)
- [`config/routes.yaml`](config/routes.yaml) — tiers, modes, HITL, role maps, plan_shapes
- [`config/projects.example.yaml`](config/projects.example.yaml) — copy to gitignored `projects.yaml`
- [`config/budget.yaml`](config/budget.yaml) — Other Models remaining budget (manual in v0)
- [`config/models.generated.yaml`](config/models.generated.yaml) — synced catalog (do not hand-edit)

Refresh model catalog:

```powershell
python .\scripts\sync_models.py
```

## FAQ

### Do I need Hindsight?

No. **Core** works without Hindsight or GitNexus. Use **stack** only if you want lean route logging via local Hindsight MCP (server name `hindsight`).

### Does this start the Hindsight daemon?

No. Daemon lifecycle is [cursor-hindsight-ondemand](https://github.com/dapetun/cursor-hindsight-ondemand). This skill only calls `retain` when stack is enabled and MCP is available.

### Does this replace Cursor Auto / Router?

No. It recommends a model and prints a Russian `[route]` line; you switch the chat model if needed. Auto remains the daily driver for routine work.

### Is GitNexus required?

No. With stack, the skill may hint impact / `detect_changes` when GitNexus is available. Missing GitNexus does not break routing.

## Docs

- [Core install](docs/integrations/core.md) · [Stack install](docs/integrations/stack.md)
- [Routing policy](docs/routing-policy.md)
- [Classifier](docs/classifier.md)
- [Hindsight schema](docs/hindsight-schema.md) (stack + Hindsight)
- [Acceptance](docs/acceptance-v0.md)
- [Roadmap (phases 0–5)](docs/roadmap.md)
- [Research folder](docs/research/README.md)
- [llms.txt](llms.txt) — short summary for AI tools

## License

MIT — see [LICENSE](LICENSE). Hindsight and GitNexus are separate projects.
