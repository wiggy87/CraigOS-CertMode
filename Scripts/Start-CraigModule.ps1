function Start-CraigModule {
    param (
        [ValidateSet("DriverPurge", "PrivacySweep", "BootAudit")]
        [string]$Module,
        [switch]$Purge,
        [switch]$LogOnly,
        [switch]$DryRun
    )

    $basePath = "C:\CraigOS\Modules"
    $scriptMap = @{
        "DriverPurge" = "Invoke-DriverPurge.ps1"
        "PrivacySweep" = "Invoke-PrivacySweep.ps1"
        "BootAudit" = "New-CiPolicyReport.ps1"
    }

    $script = Join-Path $basePath $scriptMap[$Module]
    if (Test-Path $script) {
        & $script @PSBoundParameters
    } else {
        Write-Host "Module not found: $Module" -ForegroundColor Red
    }
}

