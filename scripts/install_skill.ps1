# Install model-orchestrator skill into the user Cursor skills directory.
param(
    [ValidateSet("core", "stack")]
    [Alias("Profile")]
    [string]$InstallProfile = "core"
)

$ErrorActionPreference = "Stop"

$RepoRoot = Split-Path -Parent $PSScriptRoot
$Src = Join-Path $RepoRoot "skill\model-orchestrator"
$Dst = Join-Path $env:USERPROFILE ".cursor\skills\model-orchestrator"
$ConfigDir = Join-Path $RepoRoot "config"
$IntegrationsActive = Join-Path $ConfigDir "integrations.yaml"
$CoreTemplate = Join-Path $ConfigDir "integrations.core.yaml"
$StackTemplate = Join-Path $ConfigDir "integrations.stack.yaml"
$ProjectsExample = Join-Path $ConfigDir "projects.example.yaml"
$ProjectsLocal = Join-Path $ConfigDir "projects.yaml"

if (-not (Test-Path $Src)) {
    Write-Error "Source skill not found: $Src"
}

$template = if ($InstallProfile -eq "stack") { $StackTemplate } else { $CoreTemplate }
if (-not (Test-Path $template)) {
    Write-Error "Missing profile template: $template"
}
Copy-Item -Force $template $IntegrationsActive

if (-not (Test-Path $ProjectsLocal)) {
    if (Test-Path $ProjectsExample) {
        Copy-Item -Force $ProjectsExample $ProjectsLocal
        Write-Host "Created config/projects.yaml from projects.example.yaml (edit local paths)."
    }
}

New-Item -ItemType Directory -Force -Path (Split-Path $Dst) | Out-Null
if (Test-Path $Dst) {
    Remove-Item -Recurse -Force $Dst
}
Copy-Item -Recurse -Force $Src $Dst

$pointer = Join-Path $Dst "ORCHESTRATOR_ROOT.txt"
Set-Content -Path $pointer -Value $RepoRoot -Encoding UTF8

$IntegrationsSkill = Join-Path $Dst "integrations.yaml"
Copy-Item -Force $IntegrationsActive $IntegrationsSkill

Write-Host "Installed skill to: $Dst"
Write-Host "InstallProfile: $InstallProfile"
Write-Host "ORCHESTRATOR_ROOT -> $RepoRoot"

$syncScript = Join-Path $RepoRoot "scripts\sync_budget.py"
Write-Host "Budget: run  python scripts/sync_budget.py  (Other Models % → config/budget.local.yaml)"
$py = Get-Command python -ErrorAction SilentlyContinue
if ($py -and (Test-Path $syncScript)) {
    try {
        & python $syncScript 2>&1 | ForEach-Object { Write-Host $_ }
    } catch {
        Write-Host "Budget sync skipped (non-fatal): $($_.Exception.Message)"
    }
}

if ($InstallProfile -eq "stack") {
    Write-Host "Next: install Hindsight ondemand - https://github.com/dapetun/cursor-hindsight-ondemand"
    Write-Host "Optional: GitNexus MCP + analyze (see docs/integrations/stack.md)"
}
Write-Host "Restart Cursor or start a new agent chat to load the skill."
