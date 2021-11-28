class Config {
    <#
    .SYNOPSIS
    Specifies the path of complied MOF's and powershell DSC scripts.
    #>

    # The relative output path of compiled MOF files.
    static [string] $MofOutputPath = "CompiledMofs/"

    # The relative path of DSC configs.
    static [string] $DscScriptPath = "*dsc.ps1"
}
