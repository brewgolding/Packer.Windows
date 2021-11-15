#packer init .
$order = @(
  "Base-Install.*",
  "Compress.*"
)
cat $PSScriptRoot\variables.yaml | ConvertFrom-Yaml -AsHashtable | ConvertTo-Json | Out-File "variables.json"
$order | % {packer build -only="$($_)" -var-file "variables.json" .}
