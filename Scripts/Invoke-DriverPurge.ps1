param (
    [switch]$Purge,
    [switch]$LogOnly,
    [switch]$DryRun
)

$timestamp = Get-Date -Format "yyyyMMdd_HHmmss"
$logPath = "$env:USERPROFILE\Desktop\DriverPurge_$timestamp.log"

$safeVendors = @("Advanced Micro Devices", "Realtek", "MediaTek", "NVIDIA")
$drivers = Get-WmiObject Win32_PnPSignedDriver |
    Where-Object { $safeVendors -notcontains $_.Signer }

foreach ($driver in $drivers) {
    $entry = "$($driver.DeviceName) | $($driver.InfName) | $($driver.DriverVersion)"
    Add-Content -Path $logPath -Value $entry

    if ($Purge -and -not $LogOnly) {
        if ($DryRun) {
            Write-Host "DryRun: Would remove $($driver.InfName)" -ForegroundColor Yellow
        } else {
            Write-Host "Removing: $($driver.InfName)" -ForegroundColor Red
            pnputil /delete-driver $driver.InfName /uninstall /force
        }
    }
}

Write-Host "Driver purge complete. Log saved to $logPath"

