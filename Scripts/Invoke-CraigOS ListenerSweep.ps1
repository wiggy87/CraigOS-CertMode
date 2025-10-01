# CraigOS Listener & Execution Trace Audit
Write-Host "🔍 Starting CraigOS Listener & Execution Trace Audit..." -ForegroundColor Cyan

# Hidden PowerShell sessions
Get-WmiObject Win32_Process | Where-Object {
    $_.Name -match "powershell" -and $_.CommandLine -match "hidden|EncodedCommand"
} | Select-Object ProcessId, CommandLine

# WMI Event Consumers
Get-WmiObject -Namespace "root\subscription" -Class __EventConsumer

# Startup Commands
Get-CimInstance Win32_StartupCommand | Select-Object Name, Command, Location

# Scheduled Tasks
schtasks /query /fo LIST /v | Out-String | Select-String "TaskName|Task To Run|Scheduled Task State"

# Active TCP Connections
Get-NetTCPConnection | Where-Object { $_.State -eq "Established" } | Select-Object LocalAddress, RemoteAddress, RemotePort

# Mic/Webcam Device Audit
Get-PnpDevice -Class Camera
Get-CimInstance Win32_SoundDevice

