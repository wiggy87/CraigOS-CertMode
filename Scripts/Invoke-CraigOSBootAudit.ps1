# Create log directory
$logPath = "C:\CraigOS_Logs"
if (!(Test-Path $logPath)) { New-Item -Path $logPath -ItemType Directory }

$timestamp = Get-Date -Format "yyyy-MM-dd_HH-mm-ss"
$logFile = "$logPath\CraigOS_BootAudit_$timestamp.txt"

# Boot Delay Events
$bootEvents = Get-WinEvent -LogName "Microsoft-Windows-Diagnostics-Performance/Operational" |
Where-Object { $_.Id -eq 100 } |
Select-Object TimeCreated, Message

# Secure Boot Errors
$secureBootErrors = Get-WinEvent -LogName "System" |
Where-Object { $_.Id -eq 1796 } |
Select-Object TimeCreated, Message

# Shutdown Events
$shutdownEvents = Get-WinEvent -LogName "System" |
Where-Object { $_.Id -eq 1074 } |
Select-Object TimeCreated, Message

# Write to log
"=== CraigOS Boot & Security Audit ===" | Out-File $logFile
"Timestamp: $timestamp" | Out-File $logFile -Append
"`n--- Boot Delays ---" | Out-File $logFile -Append
$bootEvents | Out-File $logFile -Append
"`n--- Secure Boot Errors ---" | Out-File $logFile -Append
$secureBootErrors | Out-File $logFile -Append
"`n--- Shutdown Events ---" | Out-File $logFile -Append
$shutdownEvents | Out-File $logFile -Append

Write-Output "CraigOS Boot & Security Audit saved to $logFile"

