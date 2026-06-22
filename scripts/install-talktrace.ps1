[CmdletBinding()]
param(
    [string]$Destination = (Join-Path ([Environment]::GetFolderPath("MyDocuments")) "TalkTrace-workspace"),
    [string]$Alias = "",
    [switch]$Force
)

$ErrorActionPreference = "Stop"

function Resolve-FullPath {
    param([Parameter(Mandatory = $true)][string]$Path)
    $ExecutionContext.SessionState.Path.GetUnresolvedProviderPathFromPSPath($Path)
}

function Copy-WorkspaceItem {
    param(
        [Parameter(Mandatory = $true)][string]$Name,
        [Parameter(Mandatory = $true)][string]$SourceRoot,
        [Parameter(Mandatory = $true)][string]$TargetRoot
    )

    $source = Join-Path $SourceRoot $Name
    $target = Join-Path $TargetRoot $Name
    if (-not (Test-Path -LiteralPath $source)) {
        throw "Missing required template item: $Name"
    }

    Copy-Item -LiteralPath $source -Destination $target -Recurse -Force:$Force
}

function New-TalkTracePerson {
    param(
        [Parameter(Mandatory = $true)][string]$WorkspaceRoot,
        [Parameter(Mandatory = $true)][string]$PersonAlias,
        [switch]$ForceCreate
    )

    $invalidChars = [System.IO.Path]::GetInvalidFileNameChars()
    if ($PersonAlias.IndexOfAny($invalidChars) -ge 0) {
        throw "Alias contains characters that cannot be used in a folder name: $PersonAlias"
    }
    if ($PersonAlias -eq "_template") {
        throw "Alias cannot be _template."
    }

    $template = Join-Path $WorkspaceRoot "people\_template"
    $target = Join-Path $WorkspaceRoot ("people\" + $PersonAlias)

    if (-not (Test-Path -LiteralPath $template)) {
        throw "Missing person template: $template"
    }

    if (Test-Path -LiteralPath $target) {
        if (-not $ForceCreate) {
            Write-Host "Person already exists: $target"
            return
        }
    } else {
        New-Item -ItemType Directory -Path $target | Out-Null
    }

    Copy-Item -Path (Join-Path $template "*") -Destination $target -Recurse -Force:$ForceCreate

    Get-ChildItem -LiteralPath $target -Filter "*.md" -File | ForEach-Object {
        $content = Get-Content -LiteralPath $_.FullName -Raw
        $content = $content.Replace("<alias>", $PersonAlias)
        Set-Content -LiteralPath $_.FullName -Value $content -Encoding UTF8
    }
}

$scriptRoot = Split-Path -Parent $MyInvocation.MyCommand.Path
$sourceRoot = Resolve-Path (Join-Path $scriptRoot "..")
$destinationRoot = Resolve-FullPath $Destination

if (Test-Path -LiteralPath $destinationRoot) {
    $existing = Get-ChildItem -LiteralPath $destinationRoot -Force -ErrorAction SilentlyContinue
    if ($existing -and -not $Force) {
        throw "Destination exists and is not empty: $destinationRoot. Choose a new -Destination or rerun with -Force."
    }
} else {
    New-Item -ItemType Directory -Path $destinationRoot | Out-Null
}

$items = @(
    "AGENTS.md",
    "README.md",
    "README.en.md",
    "LICENSE",
    ".gitignore",
    "assets",
    "me",
    "people",
    "scripts"
)

foreach ($item in $items) {
    Copy-WorkspaceItem -Name $item -SourceRoot $sourceRoot -TargetRoot $destinationRoot
}

@("logs", "raw", "screenshots", "exports", "tmp", ".tmp_crops") | ForEach-Object {
    $dir = Join-Path $destinationRoot $_
    if (-not (Test-Path -LiteralPath $dir)) {
        New-Item -ItemType Directory -Path $dir | Out-Null
    }
}

if ($Alias.Trim().Length -gt 0) {
    New-TalkTracePerson -WorkspaceRoot $destinationRoot -PersonAlias $Alias -ForceCreate:$Force
}

$startHere = @'
# TalkTrace Start Here

Give this to your local agent:

I am using this directory as my TalkTrace workspace. Read AGENTS.md first. Then read me/profile.md, me/style.md, and me/unconscious.md. If I give you a chat object alias, read people/<alias>/profile.md, persona.md, unconscious.md, and style.md before drafting replies. If the alias does not exist, create it from people/_template/.

For a new chat object, run:

```powershell
powershell -ExecutionPolicy Bypass -File scripts\new-person.ps1 -Alias <alias>
```
'@

Set-Content -LiteralPath (Join-Path $destinationRoot "START_HERE.md") -Value $startHere -Encoding UTF8

Write-Host ""
Write-Host "TalkTrace workspace installed:"
Write-Host "  $destinationRoot"
if ($Alias.Trim().Length -gt 0) {
    Write-Host "Initialized person alias:"
    Write-Host "  $Alias"
}
Write-Host ""
Write-Host "Next command:"
Write-Host "  cd `"$destinationRoot`""
Write-Host ""
Write-Host "Then tell your local agent:"
Write-Host "  Read START_HERE.md and AGENTS.md, then help me initialize TalkTrace."
