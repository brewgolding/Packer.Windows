$ErrorActionPreference = 'Stop'

Set-Location -LiteralPath $PSScriptRoot

$env:DOTNET_SKIP_FIRST_TIME_EXPERIENCE = '1'
$env:DOTNET_CLI_TELEMETRY_OPTOUT = '1'
$env:DOTNET_NOLOGO = '1'

$paket = ".paket/paket.exe"
$cake = "tools/cake/cake.exe"

& $paket install
if ($LASTEXITCODE -ne 0) { exit $LASTEXITCODE }

& $cake @args
if ($LASTEXITCODE -ne 0) { exit $LASTEXITCODE }
