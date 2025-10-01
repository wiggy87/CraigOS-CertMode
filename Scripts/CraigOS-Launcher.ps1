$modules = @(
    "SyncTrace\CraigOS-SyncMeshTrace.ps1",
    "InputSweep\CraigOS-InputHookLogger.ps1",
    "IMPrediction\CraigOS-IMPredictionSealer.ps1",
    "CLSIDPurge\CraigOS-CLSIDPurge.ps1"
)

$logPath = "C:\CraigOS\Logs\CraigOS-Launcher_$(Get-Date -Format 'yyyy-MM-dd HHmmss').log"
"CraigOS Launcher – $(Get-Date -Format 'yyyy-MM-dd-HHmmss')" | Out-File -FilePath $logPath

foreach ($module in $modules) {
    $fullPath = "C:\CraigOS\Modules\$module"
    $start = Get-Date
    " Running: $module @ $start" | Out-File -Append -FilePath $logPath

    try {
        powershell -ExecutionPolicy Bypass -File $fullPath
        $end = Get-Date
        " Completed: $module @ $end" | Out-File -Append -FilePath $logPath
    } catch {
        " Error in: $module → $_" | Out-File -Append -FilePath $logPath
    }
}

