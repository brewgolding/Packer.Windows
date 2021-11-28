<#
.SYNOPSIS
Basic Chocolatey Config
#>
$config = "ChocolateyCore"
Configuration $config {
    Import-DscResource -ModuleName PSDesiredStateConfiguration
    Import-DscResource -ModuleName cChoco
    $OSVersion = Get-CimInstance -ClassName win32_operatingsystem

    node $env:COMPUTERNAME {
        cChocoInstaller installChocolatey
        {
            InstallDir = "C:\ProgramData\chocolatey\"
        }
        cChocoFeature chocolateyFeaturesRememberArgs {
            Ensure = "Present"
            FeatureName = "useRememberedArgumentsForUpgrades"
            DependsOn = "[cChocoInstaller]installChocolatey"
        }
    }
}

ChocolateyCore -OutputPath "$PSScriptRoot/$([Config]::MofOutputPath)/$config" | Out-Null
