<#
.SYNOPSIS
Installs all modules required by the DSC recourses in this directory
#>
$modules = @(
    @{
        Name = "cChoco"
    }
)
[string] $PSModulePath = ($env:PSModulePath -split ";")[0]
$allModules = Get-Module -All
for ([int] $i = 0; $i -lt $modules.Count; $i++) {
    $activity = @{
        Activity = "Checking Modules"
        Status = "$(($i / $modules.Count)*100)% Complete. Module $i of $($modules.Count)"
        PercentComplete = (($i / $modules.Count)*100)
    }
    Write-Progress @activity
    $moduleInstalled = $allModules | Where-Object {($_.Name -match $modules[$i].Name)}
    if ($moduleInstalled -eq $null) {
        Write-Host "Module $($modules[$i].Name) is not installed. Attempting install..." -ForegroundColor Magenta
        Install-Package -Name $modules[$i].Name -Force -ForceBootstrap
    }
    else {
        Write-Host "Module $($modules[$i].Name) is already installed. Skipping install..." -ForegroundColor Magenta
    }
}
