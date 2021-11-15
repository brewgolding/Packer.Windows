$updates = Start-WUScan -Verbose
Install-WUUpdates -Updates -Verbose
if ((Get-WUIsPendingReboot)) {
    Restart-Computer -Force
}