# CraigOS-ManifestBreak.ps1
# Purpose: Break manifest trust for XboxGamingOverlay and related DLLs
# Author: CraigOS Sovereign
# Timestamp: $(Get-Date -Format "yyyy-MM-dd HH:mm:ss")

$targets = @(
    "xboxgamingoverlay",
    "windows.gaming.xboxlive.storage",
    "xboxgipsvc",
    "proxystub"
)

$manifestPaths = @(
    "$env:windir\WinSxS\Manifests",
    "$env:windir\WinSxS\Backup"
)

$logPath = "C:\CraigOS\Logs\ManifestBreak.log"
New-Item -Path $logPath -ItemType File -Force | Out-Null

foreach ($target in $targets) {
    foreach ($path in $manifestPaths) {
        Get-ChildItem -Path $path -Filter "*$target*.manifest" -ErrorAction SilentlyContinue |
        ForEach-Object {
            "$($_.FullName) - DELETED @ $(Get-Date)" | Out-File -FilePath $logPath -Append
            Remove-Item -Path $_.FullName -Force -ErrorAction SilentlyContinue
        }

        Get-ChildItem -Path $path -Filter "*$target*.cdf-ms" -ErrorAction SilentlyContinue |
        ForEach-Object {
            "$($_.FullName) - DELETED @ $(Get-Date)" | Out-File -FilePath $logPath -Append
            Remove-Item -Path $_.FullName -Force -ErrorAction SilentlyContinue
        }
    }
}

Write-Host "Manifest trust broken. Log saved to $logPath"

