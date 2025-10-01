function Invoke-EndpointDiff {
    Write-Host "🔍 Capturing audio/video endpoint properties..."

    $audioKey = "HKLM:\SYSTEM\CurrentControlSet\Control\Class\{4d36e96c-e325-11ce-bfc1-08002be10318}"
    $props = Get-ItemProperty -Path $audioKey -ErrorAction SilentlyContinue
    $props | Out-File "$env:USERPROFILE\CraigOS\Logs\EndpointDiff_$(Get-Date -Format 'yyyy-MM-dd_HH-mm-ss').txt"

    Write-Host "✅ EndpointDiff logged."
}

