# Create log directory
$logPath = "C:\CraigOS_Logs"
if (!(Test-Path $logPath)) { New-Item -Path $logPath -ItemType Directory }

$timestamp = Get-Date -Format "yyyy-MM-dd_HH-mm-ss"
$logFile = "$logPath\CraigOS_ArtifactSweep_$timestamp.txt"

# SYSTEM-Level Scheduled Tasks
$systemTasks = Get-ScheduledTask | Where-Object { $_.TaskPath -like "\Microsoft\*" } |
Select-Object TaskName, TaskPath, State

# COM Handlers
$comHandlers = Get-ItemProperty -Path "HKLM:\SOFTWARE\Classes\CLSID\*" |
Where-Object { $_.InprocServer32 -or $_.LocalServer32 } |
Select-Object PSChildName, InprocServer32, LocalServer32

# Telemetry Services
$telemetryServices = Get-Service | Where-Object {
    $_.Name -match "DiagTrack|dmwappushservice|WMPNetworkSvc|MapsBroker|RetailDemo"
} | Select-Object Name, Status, StartType

# Write to log
"=== CraigOS Artifact Sweep ===" | Out-File $logFile
"Timestamp: $timestamp" | Out-File $logFile -Append
"`n--- SYSTEM-Level Scheduled Tasks ---" | Out-File $logFile -Append
$systemTasks | Out-File $logFile -Append
"`n--- COM Handlers ---" | Out-File $logFile -Append
$comHandlers | Out-File $logFile -Append
"`n--- Telemetry Services ---" | Out-File $logFile -Append
$telemetryServices | Out-File $logFile -Append

Write-Output "CraigOS Artifact Sweep saved to $logFile"

