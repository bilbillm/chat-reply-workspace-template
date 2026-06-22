[CmdletBinding()]
param(
    [Parameter(Mandatory = $true)][string]$Alias,
    [string]$Workspace = "",
    [switch]$Force
)

$ErrorActionPreference = "Stop"

function Get-WorkspaceRoot {
    param([string]$ExplicitWorkspace)

    if ($ExplicitWorkspace.Trim().Length -gt 0) {
        return $ExecutionContext.SessionState.Path.GetUnresolvedProviderPathFromPSPath($ExplicitWorkspace)
    }

    $scriptRoot = $PSScriptRoot
    $candidate = Resolve-Path (Join-Path $scriptRoot "..")
    if (Test-Path -LiteralPath (Join-Path $candidate "AGENTS.md")) {
        return $candidate.Path
    }

    $current = (Get-Location).Path
    if (Test-Path -LiteralPath (Join-Path $current "AGENTS.md")) {
        return $current
    }

    throw "Cannot find TalkTrace workspace root. Pass -Workspace <path>."
}

$workspaceRoot = Get-WorkspaceRoot -ExplicitWorkspace $Workspace

$invalidChars = [System.IO.Path]::GetInvalidFileNameChars()
if ($Alias.IndexOfAny($invalidChars) -ge 0) {
    throw "Alias contains characters that cannot be used in a folder name: $Alias"
}
if ($Alias -eq "_template") {
    throw "Alias cannot be _template."
}

$template = Join-Path $workspaceRoot "people\_template"
$target = Join-Path $workspaceRoot ("people\" + $Alias)

if (-not (Test-Path -LiteralPath $template)) {
    throw "Missing person template: $template"
}

if (Test-Path -LiteralPath $target) {
    if (-not $Force) {
        throw "Person already exists: $target. Use -Force only if you want to overwrite template files."
    }
} else {
    New-Item -ItemType Directory -Path $target | Out-Null
}

Copy-Item -Path (Join-Path $template "*") -Destination $target -Recurse -Force:$Force

Get-ChildItem -LiteralPath $target -Filter "*.md" -File | ForEach-Object {
    $content = Get-Content -LiteralPath $_.FullName -Raw
    $content = $content.Replace("<alias>", $Alias)
    Set-Content -LiteralPath $_.FullName -Value $content -Encoding UTF8
}

Write-Host "Initialized TalkTrace person:"
Write-Host "  $target"
Write-Host ""
Write-Host "Next: tell your agent the alias is '$Alias' and paste the chat context plus your reply goal."
