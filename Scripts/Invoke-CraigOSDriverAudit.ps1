$logPath = "C:\CraigOS_Logs"
if (!(Test-Path $logPath)) { New-Item -Path $logPath -ItemType Directory }

$timestamp = Get-Date -Format "yyyy-MM-dd_HH-mm-ss"
$logFile = "$logPath\CraigOS_DriverAudit_$timestamp.txt"

# Driver Inventory
$drivers = Get-WmiObject Win32_PnPSignedDriver | Select DeviceName, DriverVersion, Manufacturer, DriverDate

# Recent Updates
$updates = Get-HotFix | Select InstalledOn, Description, HotFixID

# Write to log
"=== CraigOS Driver & Update Audit ===" | Out-File $logFile
"Timestamp: $timestamp" | Out-File $logFile -Append
"`n--- Driver Inventory ---" | Out-File $logFile -Append
$drivers | Out-File $logFile -Append
"`n--- Recent Updates ---" | Out-File $logFile -Append
$updates | Out-File $logFile -Append

Write-Output "CraigOS Driver & Update Audit saved to $logFile"

