function Invoke-LeakPurge {
    Write-Host "🔒 Purging telemetry and remote sniffers..."

    $services = @("DiagTrack", "dmwappushservice", "RemoteRegistry", "OneSyncSvc", "PushToInstall")
    foreach ($svc in $services) {
        Stop-Service -Name $svc -Force -ErrorAction SilentlyContinue
        Set-Service -Name $svc -StartupType Disabled
    }

    $tasks = @(
        "\Microsoft\Windows\Customer Experience Improvement Program\Consolidator",
        "\Microsoft\Windows\Application Experience\ProgramDataUpdater"
    )
    foreach ($task in $tasks) {
        schtasks /Change /TN $task /Disable
    }

    Remove-Item -Path "C:\ProgramData\Microsoft\Diagnosis" -Recurse -Force -ErrorAction SilentlyContinue
    Write-Host "✅ LeakPurge complete."
}

