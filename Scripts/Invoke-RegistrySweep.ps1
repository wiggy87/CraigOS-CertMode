function Invoke-RegistrySweep {
    Write-Host "🧹 Sweeping volatile and orphaned registry keys..."

    $runKeys = @(
        "HKCU:\Software\Microsoft\Windows\CurrentVersion\Run",
        "HKLM:\Software\Microsoft\Windows\CurrentVersion\Run"
    )
    foreach ($key in $runKeys) {
        Get-ItemProperty -Path $key | Remove-ItemProperty -Name * -Force -ErrorAction SilentlyContinue
    }

    Get-ChildItem "HKLM:\SYSTEM\CurrentControlSet\Services" |
        Where-Object { $_.Name -like "*OneDrive*" -or $_.Name -like "*DiagTrack*" } |
        Remove-Item -Recurse -Force -ErrorAction SilentlyContinue

    Write-Host "✅ RegistrySweep complete."
}

