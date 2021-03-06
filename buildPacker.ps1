[CmdletBinding()]
param (
    [Parameter(Mandatory = $false)]
    [ValidateNotNullOrEmpty()]
    [ValidateSet('build','validate','inspect')]
    [string]
    $BuildType = "build",
    [switch]
    $Force
)
# Paket handles dependencies
$paket = ".paket/paket.exe"

& $paket install
if ($LASTEXITCODE -ne 0) { exit $LASTEXITCODE }

Import-Module -Name "$PSScriptRoot/tools/powershellmodules/psyml" -Force -Verbose

$order = @(
  "Base-Install.*",
  "DSCProvision.*"
)
# Start CONFIG SETUP
$variables = @{}
if ($Force) {
    $_force = "-force"
}
# Converters yaml to a nested variables hashtable. This is so packer can autoload it as a json.
$variables.variables = cat $PSScriptRoot\variables.yaml | ConvertFrom-Yaml -AsHashtable
$build = $variables.variables.build
#Outputs packer variable .pkr.json
$variables | ConvertTo-Json -Depth 10 | Out-File $build.json_output
packer init .
$order | % {packer $BuildType -only="$($_)" $_force .}
