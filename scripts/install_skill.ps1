# Install model-orchestrator skill into the user Cursor skills directory.
$ErrorActionPreference = "Stop"

$RepoRoot = Split-Path -Parent $PSScriptRoot
$Src = Join-Path $RepoRoot "skill\model-orchestrator"
$Dst = Join-Path $env:USERPROFILE ".cursor\skills\model-orchestrator"

if (-not (Test-Path $Src)) {
    Write-Error "Source skill not found: $Src"
}

New-Item -ItemType Directory -Force -Path (Split-Path $Dst) | Out-Null
if (Test-Path $Dst) {
    Remove-Item -Recurse -Force $Dst
}
Copy-Item -Recurse -Force $Src $Dst

# Pointer so the skill can find config when workspace is not this repo
$pointer = Join-Path $Dst "ORCHESTRATOR_ROOT.txt"
Set-Content -Path $pointer -Value $RepoRoot -Encoding UTF8

Write-Host "Installed skill to: $Dst"
Write-Host "ORCHESTRATOR_ROOT -> $RepoRoot"
Write-Host "Restart Cursor or start a new agent chat to load the skill."
