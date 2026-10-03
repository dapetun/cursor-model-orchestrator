# Cursor Model Orchestrator

Personal policy layer for **Cursor Pro ($20)** that classifies each prompt with deterministic rules and recommends a cost-aware model. Overlay on Auto/Router — does not replace it for routine work.

**Works without Hindsight or GitNexus** (core profile). Optional **stack** profile adds soft logging via [cursor-hindsight-ondemand](https://github.com/dapetun/cursor-hindsight-ondemand) and optional GitNexus hints.

License: [MIT](LICENSE). Hindsight and GitNexus are separate projects.

## Goals

- Protect the **Other Models** pool (~$20/mo) from trivia
- Force strong models for science/stats (no cheap-first)
- Short Russian explanation of every routing decision
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

## Docs

- [Core install](docs/integrations/core.md) · [Stack install](docs/integrations/stack.md)
- [Routing policy](docs/routing-policy.md)
- [Classifier](docs/classifier.md)
- [Hindsight schema](docs/hindsight-schema.md) (stack + Hindsight)
- [Acceptance](docs/acceptance-v0.md)
- [Roadmap (phases 0–5)](docs/roadmap.md)
- [Research folder](docs/research/README.md)

## License

MIT — see [LICENSE](LICENSE).
