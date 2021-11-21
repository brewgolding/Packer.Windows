$networkConnectionProfile = Get-NetConnectionProfile

foreach ($netProfile in $networkConnectionProfile) {
    if ($networkConnectionProfile.NetworkCategory -match "Public") {
        Set-NetConnectionProfile -InterfaceIndex $netProfile.InterfaceIndex -NetworkCategory Private
    }
}
$service = Get-Service winrm
if ($service.Status -notmatch "running") {
    Start-Service $service
}
$service | Set-Service -StartupType Automatic
netsh advfirewall firewall add rule name="WinRM-HTTP" dir=in localport=5985 protocol=TCP action=allow
winrm set winrm/config/service/auth '@{Basic="true"}'
winrm set winrm/config/service '@{AllowUnencrypted="true"}'
