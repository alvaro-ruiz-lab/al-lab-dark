# Compila el proyecto de Unity en modo batch
param(
    [string]$Target = "StandaloneWindows64",
    [switch]$Clean
)

$ErrorActionPreference = 'Stop'
$unity = "C:\Program Files\Unity\Hub\Editor\6000.0.23f1\Editor\Unity.exe"
$log = Join-Path $PSScriptRoot "build.log"

function Invoke-UnityBuild {
    param([string]$Path)
    if ($Clean -and (Test-Path "$Path\Library")) {
        Remove-Item -Recurse -Force "$Path\Library"
    }
    & $unity -batchmode -quit -projectPath $Path -buildTarget $Target -logFile $log
    return $LASTEXITCODE -eq 0
}

$ok = Invoke-UnityBuild -Path (Get-Location)
Get-ChildItem .\Build -Filter *.exe | ForEach-Object { Write-Host "Build: $($_.Name)" -ForegroundColor Green }
if (-not $ok) { exit 1 }
