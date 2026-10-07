# Refresh the YAML snapshot that `npx skills add` copies with the skill directory.
# Does not touch scripts/sync_budget.py (that snapshot stays aligned with the committed repo script).
param()

$ErrorActionPreference = "Stop"

$RepoRoot = Split-Path -Parent $PSScriptRoot
$Src = Join-Path $RepoRoot "config"
$Dest = Join-Path $RepoRoot "skill\model-orchestrator\config"

New-Item -ItemType Directory -Force -Path $Dest | Out-Null

foreach ($name in @(
        "routes.yaml",
        "budget.yaml",
        "budget.local.example.yaml",
        "models.generated.yaml",
        "projects.example.yaml"
    )) {
    Copy-Item -Force (Join-Path $Src $name) (Join-Path $Dest $name)
}

Copy-Item -Force (Join-Path $Src "integrations.core.yaml") (Join-Path $Dest "integrations.yaml")

Write-Host "Bundled config into $Dest"
Write-Host "Default integrations.yaml is the core profile."
