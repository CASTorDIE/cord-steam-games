param(
  [Parameter(Mandatory=$true)]
  [string]$MainJson,

  [Parameter(Mandatory=$true)]
  [string]$HorrorJson
)

$ErrorActionPreference = 'Stop'
$Root = Split-Path -Parent $PSScriptRoot

Copy-Item -LiteralPath $MainJson -Destination (Join-Path $Root 'data\steam\worker-feed\latest.json') -Force
Copy-Item -LiteralPath $HorrorJson -Destination (Join-Path $Root 'data\steam\horror-upcoming\worker-feed\latest.json') -Force

Push-Location $Root
try {
  git add data/steam/worker-feed/latest.json data/steam/horror-upcoming/worker-feed/latest.json
  $status = git status --porcelain
  if (-not $status) {
    Write-Host 'No Steam JSON changes to publish.'
    exit 0
  }

  git commit -m "Update Steam game data"
  git push
}
finally {
  Pop-Location
}
