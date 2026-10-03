# Cursor Model Orchestrator

Personal policy layer for **Cursor Pro ($20)** that classifies each prompt with deterministic rules and recommends a cost-aware model. Overlay on Auto/Router — does not replace it for routine work.

## Goals

- Protect the **Other Models** pool (~$20/mo) from trivia
- Force strong models for science/stats (no cheap-first)
- Short Russian explanation of every routing decision
- Long-horizon research: v0 recommend-only → v1 subagents → v2 cascade/best-of-N → v3 usage ops

## Install

```powershell
pwsh -File .\scripts\install_skill.ps1
```

Copies `skill/model-orchestrator/` to `%USERPROFILE%\.cursor\skills\model-orchestrator\`.

Also keep this repo available so the skill can read `config/*.yaml` when the workspace is this project, or when you set `ORCHESTRATOR_ROOT` (see skill).

## Slash commands

| Command | Effect |
| --- | --- |
| `/eco` | Cursor Models only (Composer/Grok) |
| `/max` | Prefer strong Other Models when budget allows |
| `/route` | Print routing decision and stop (debug) |

Tags: `@ds` `@paper` `@web` override project-type detection.

## Config

- [`config/routes.yaml`](config/routes.yaml) — tiers, modes, HITL, role maps
- [`config/projects.yaml`](config/projects.yaml) — path/marker → project type
- [`config/budget.yaml`](config/budget.yaml) — Other Models remaining budget (manual in v0)
- [`config/models.generated.yaml`](config/models.generated.yaml) — synced catalog (do not hand-edit)

Refresh model catalog:

```powershell
python .\scripts\sync_models.py
```

## Docs

- [Routing policy](docs/routing-policy.md)
- [Classifier](docs/classifier.md)
- [Hindsight schema](docs/hindsight-schema.md)
- [Acceptance v0](docs/acceptance-v0.md)
- [Roadmap (phases 0–5)](docs/roadmap.md)
- [Research folder](docs/research/README.md) — landscape note, brainstorm register, hypotheses, weekly metrics

## License

Personal research project. No license file — private use unless you add one later.
