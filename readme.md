# Packer Windows Templates

Currently this repo with the use of packer outputs the following images;

| Name | Output Directory | Remarks |
| --- | --- | --- |
| Windows11Pro | ./build/NonProduction/Windows11Pro | Windows 11 Base Install (KMS activated) with Chocolatey provisioned via DSC |
| ServerDataCenterCore | ./build/NonProduction/ServerDataCenterCore | Windows Server 2022 Base Install (KMS activated) with Chocolatey provisioned via DSC |
| Base.Windows11Pro | ./build/NonProduction/Base.Windows11Pro | Windows 11 Base Install (KMS activated) |
| Base.ServerDataCenterCore | ./build/NonProduction/Base.ServerDataCenterCore | Windows Server 2022 Base Install (KMS activated). |

## Build Instructions 

#### Requirments
 * git
 * powershell
 * packer

1) Clone this repo with `git clone`

    Before anything make sure that the URI's and checksums in [variables.yaml](variables.yaml) are correct. Specificly the following;

    ```yaml
    server_2022:
        iso_checksum: "FFBCD49D7BD6A1C1A49E830384272BEC"
        iso_url: "ISO/Windows Server 2022.iso"
    windows_11_pro:
        iso_checksum: "1F7840814B672457482AE77A70ACE03F"
        iso_url: "ISO/Windows 11.iso"
    ```

    In the future these will be replaced with URI's to <strike>reduce</strike> stop user interaction.

### Option 1: Cake Build

2) Run [build.ps1](build.ps1) with powershell/pwsh.
   The build script will 
    * bootstrap paket, which handles dependencies for cake.build
    * run cake build. Paket will download this to [tools/cake](tools/cake).
      * cake will build the above mentioned images by running packer

### Option 2: Powershell
2) Run [buildPacker.ps1](buildPacker.ps1) in powershell/pwsh. The script will;
    * Run packer.
### Option 3: Custom Build Script

2) Edit [buildPacker.ps1](buildPacker.ps1) to your liking and run it.