# Create log directory
$logPath = "C:\CraigOS_Logs"
if (!(Test-Path $logPath)) { New-Item -Path $logPath -ItemType Directory }

$timestamp = Get-Date -Format "yyyy-MM-dd_HH-mm-ss"
$logFile = "$logPath\CraigOS_IntegritySweep_$timestamp.txt"

# Re-check telemetry services
$telemetry = @("DiagTrack", "dmwappushservice", "MapsBroker", "RetailDemo", "WMPNetworkSvc")
foreach ($svc in $telemetry) {
    $status = Get-Service -Name $svc -ErrorAction SilentlyContinue
    if ($status) {
        "Service '$svc' is present. Status: $($status.Status), StartType: $($status.StartType)" | Out-File $logFile -Append
    } else {
        "Service '$svc' not found. ✅ Purged." | Out-File $logFile -Append
    }
}

# Re-check SYSTEM tasks
$tasks = @(
    "\Microsoft\Windows\Diagnosis\Scheduled",
    "\Microsoft\Windows\Shell\FamilySafetyMonitor",
    "\Microsoft\Windows\WindowsUpdate\AutomaticAppUpdate"
)
foreach ($task in $tasks) {
    try {
        $taskObj = Get-ScheduledTask -TaskName ($task.Split('\')[-1]) -TaskPath ($task.Substring(0, $task.LastIndexOf('\') + 1))
        "Task '$task' still exists. ⚠️" | Out-File $logFile -Append
    } catch {
        "Task '$task' not found. ✅ Purged." | Out-File $logFile -Append
    }
}

"=== CraigOS Integrity Sweep Complete ===" | Out-File $logFile -Append
Write-Output "CraigOS Integrity Sweep saved to $logFile"

