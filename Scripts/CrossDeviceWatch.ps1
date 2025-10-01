<#
CraigOS Module: CrossDeviceWatch
Author: CraigOS Sovereign
Date: 2025-10-01
Purpose: Monitor cross-device probes and flag unauthorized sync attempts
#>	                                                                           
 
$logPath = "C:\CraigOS\Logs\CrossDeviceWatch.log"
$process = Get-Process -Name "CrossDeviceService" -ErrorAction SilentlyContinue
if ($process) {
    "$((Get-Date).ToString()) - CrossDeviceService active: $($process.Id)" | Out-File $logPath -Append
}
$process = Get-Process -Name "ShellExperienceHost" -ErrorAction SilentlyContinue
if ($process) {
    "$((Get-Date).ToString()) - ShellExperienceHost active: $($process.Id) | Threads: $($process.Threads.Count)" | Out-File "C:\CraigOS\Logs\ShellHostWatch.log" -Append
}
