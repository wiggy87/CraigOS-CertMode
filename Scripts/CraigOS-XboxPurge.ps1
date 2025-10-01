# CraigOS-XboxPurge.ps1 — Module 2: Purge DLLs and Drivers
$Timestamp = Get-Date -Format "yyyy-MM-dd_HH-mm-ss"
$LogPath = "C:\CraigOS\Logs\XboxPurge_$Timestamp.txt"

$Targets = @(
    "C:\Windows\System32\xboxgip.sys",
    "C:\Windows\System32\xboxgipsvc.dll",
    "C:\Windows\System32\xboxgipsynthetic.dll",
    "C:\Windows\System32\Windows.Gaming.XboxLive.Storage.dll",
    "C:\Windows\System32\Windows.Networking.XboxLive.ProxyStub.dll",
    "C:\Windows\SysWOW64\Windows.Gaming.XboxLive.Storage.dll",
    "C:\Windows\SysWOW64\Windows.Networking.XboxLive.ProxyStub.dll"
)

foreach ($file in $Targets) {
    if (Test-Path $file) {
        try {
            Remove-Item $file -Force
            Add-Content $LogPath "$Timestamp - Purged: $file"
        } catch {
            Add-Content $LogPath "$Timestamp - Failed to purge: $file - $_"
        }
    } else {
        Add-Content $LogPath "$Timestamp - Not found: $file"
    }
}

