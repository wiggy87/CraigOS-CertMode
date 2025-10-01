param (
    [string]$LogPath = "$env:SystemDrive\CraigOS\LeakAudit\Logs",
    [switch]$Verbose
)

$timestamp = Get-Date -Format "yyyy-MM-dd_HH-mm-ss"
$leakTargets = @("OneDrive", "DiagTrack", "RemoteRegistry", "vmhgfs", "VBoxService", "vm3dgl", "vmusb", "Hyper-V")

if (!(Test-Path $LogPath)) {
    New-Item -Path $LogPath -ItemType Directory -Force
}

$logFile = Join-Path $LogPath "LeakAudit_$timestamp.log"

foreach ($target in $leakTargets) {
    $service = Get-Service -Name $target -ErrorAction SilentlyContinue
    if ($service) {
        $entry = "$timestamp - 🚨 Leak Risk Detected: $target service is present"
        Add-Content -Path $logFile -Value $entry
        if ($Verbose) { Write-Warning $entry }
    }
}

Write-Host "Leak audit complete. Log saved to $logFile"

