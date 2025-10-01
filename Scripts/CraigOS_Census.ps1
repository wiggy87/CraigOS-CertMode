# CraigOS System Census – Full Sweep
# Save as CraigOS_Census.ps1

$timestamp = Get-Date -Format "yyyy-MM-dd_HH-mm"
$logRoot = "C:\CraigOS\Logs\SystemCensus_$timestamp"
New-Item -ItemType Directory -Path $logRoot -Force | Out-Null

# 🧠 Hardware Summary
Get-ComputerInfo | Out-File "$logRoot\Hardware_Summary.txt"
Get-WmiObject Win32_Processor | Out-File "$logRoot\CPU_Info.txt"
Get-WmiObject Win32_PhysicalMemory | Out-File "$logRoot\RAM_Info.txt"
Get-WmiObject Win32_DiskDrive | Out-File "$logRoot\Disk_Info.txt"
Get-WmiObject Win32_NetworkAdapterConfiguration | Out-File "$logRoot\Network_Adapters.txt"

# 🧱 Driver Store Census
pnputil /enum-drivers > "$logRoot\Driver_Store.txt"

# 🧩 Services & Scheduled Tasks
Get-Service | Sort-Object Status | Out-File "$logRoot\Services.txt"
Get-ScheduledTask | Out-File "$logRoot\Scheduled_Tasks.txt"

# 🧼 Startup Programs
Get-CimInstance Win32_StartupCommand | Out-File "$logRoot\Startup_Programs.txt"

# 🧾 Installed Programs
Get-ItemProperty HKLM:\Software\Microsoft\Windows\CurrentVersion\Uninstall\* |
Select-Object DisplayName, DisplayVersion, Publisher, InstallDate |
Out-File "$logRoot\Installed_Programs.txt"

# 🧠 BIOS & UEFI
Get-WmiObject Win32_BIOS | Out-File "$logRoot\BIOS_Info.txt"

# 🧠 TPM & Secure Boot
Get-WmiObject -Namespace "Root\CIMv2\Security\MicrosoftTpm" -Class Win32_Tpm | Out-File "$logRoot\TPM_Info.txt"
Confirm-SecureBootUEFI | Out-File "$logRoot\SecureBoot_Status.txt"

# 🧠 RAM Tuning Snapshot
Get-CimInstance Win32_PhysicalMemory | Select-Object Manufacturer, Speed, Capacity, PartNumber | Out-File "$logRoot\RAM_Tuning.txt"

# 🧠 NVMe Controller Exposure
Get-PnpDevice | Where-Object { $_.DeviceID -like "*1602*" } | Out-File "$logRoot\NVMe_Controller.txt"

# ✅ Completion Message
Write-Host "CraigOS System Census complete. Logs saved to $logRoot"

