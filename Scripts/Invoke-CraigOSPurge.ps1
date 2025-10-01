$logPath = "C:\CraigOS_Logs"
if (!(Test-Path $logPath)) { New-Item -Path $logPath -ItemType Directory }

$timestamp = Get-Date -Format "yyyy-MM-dd_HH-mm-ss"
$logFile = "$logPath\CraigOS_Purge_$timestamp.txt"

# Disable telemetry services
$telemetry = @("DiagTrack", "dmwappushservice", "MapsBroker", "RetailDemo", "WMPNetworkSvc")
foreach ($svc in $telemetry) {
    try {
        Stop-Service -Name $svc -Force -ErrorAction SilentlyContinue
        Set-Service -Name $svc -StartupType Disabled
        "Disabled telemetry service: $svc" | Out-File $logFile -Append
    } catch {
        "Failed to disable service: $svc" | Out-File $logFile -Append
    }
}

# Purge SYSTEM tasks
$tasks = @(
    "\Microsoft\Windows\Diagnosis\Scheduled",
    "\Microsoft\Windows\Shell\FamilySafetyMonitor",
    "\Microsoft\Windows\WindowsUpdate\AutomaticAppUpdate"
)
foreach ($task in $tasks) {
    try {
        Unregister-ScheduledTask -TaskName ($task.Split('\')[-1]) -TaskPath ($task.Substring(0, $task.LastIndexOf('\') + 1)) -Confirm:$false
        "Purged SYSTEM task: $task" | Out-File $logFile -Append
    } catch {
        "Failed to purge task: $task" | Out-File $logFile -Append
    }
}

"=== CraigOS Purge Execution Complete ===" | Out-File $logFile -Append
Write-Output "CraigOS Purge Log saved to $logFile"

