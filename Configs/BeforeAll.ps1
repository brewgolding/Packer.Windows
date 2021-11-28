<#
.SYNOPSIS
Complies and exacutes DSC configurations within the script's directory.

.DESCRIPTION

#>
[CmdletBinding()]
param (
    [Parameter()]
    [validateset("Start","Test")]
    [string]
    $DscConfig = "Start"
)
Get-ChildItem -Path "$PSScriptRoot/*class.ps1" | Import-Module -Force -Verbose
Remove-Item "$($PSScriptRoot)/$([Config]::MofOutputPath)" -Recurse -ErrorAction SilentlyContinue
# Run all powershell files with the following regex filter
[regex] $scriptRegex = "\.P\d{1,}\.ps1$"
Get-ChildItem -Path $PSScriptRoot | Where-Object {$_.name -match $scriptRegex} | % {& $_.FullName}
# Compile Mof files
Get-ChildItem -Path "$($PSScriptRoot)/$([Config]::DscScriptPath)" | % {& $_.FullName}

$jobs = @()
$mofs = Get-ChildItem -Path "$($PSScriptRoot)/$([Config]::MofOutputPath)" -Recurse | Where-Object {$_.name -match "\.mof$"}
for ([int]$i = 0; $i -lt $mofs.count; $i++) {
    $dscSplat = @{
        Path = ($mofs[$i].DirectoryName)
    }

    switch ($DscConfig) {
        "Start" {
            # Run compiled mofs
            $dscSplat.(@{
                Force = $true
                AsJob = $true
            })
            $jobs += Start-DscConfiguration @DscSplat
            $jobs[$i].Name
        }
        "Test" {
            Test-DscConfiguration @DscSplat
        }
        Default {}
    }

}
$jobs | Wait-Job -Verbose | Receive-Job
