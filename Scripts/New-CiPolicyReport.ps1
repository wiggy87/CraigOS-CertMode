param (
    [string]$PolicyPath = "$env:SystemDrive\CraigOS\BootAudit\CiPolicies",
    [string]$LogPath = "$env:SystemDrive\CraigOS\BootAudit\Logs",
    [switch]$Verbose
)

function Get-CiPolicyEntries {
    param ([string]$FilePath)
    if (!(Test-Path $FilePath)) {
        Write-Warning "Policy file not found: $FilePath"
        return $null
    }
    try {
        $entries = Get-Content $FilePath | Where-Object { $_ -match '\.cip' }
        return $entries
    } catch {
        Write-Error "Failed to parse entries: $_"
        return $null
    }
}

function Write-AuditLog {
    param (
        [string]$LogFile,
        [string[]]$Entries
    )
    $timestamp = Get-Date -Format "yyyy-MM-dd_HH-mm-ss"
    Add-Content -Path $LogFile -Value "=== Audit Run: $timestamp ==="
    foreach ($entry in $Entries) {
        Add-Content -Path $LogFile -Value $entry
    }
}

# Main Execution
$policyFiles = Get-ChildItem -Path $PolicyPath -Filter "*.cip" -Recurse
foreach ($file in $policyFiles) {
    $entries = Get-CiPolicyEntries -FilePath $file.FullName
    if ($entries) {
        $logFile = Join-Path $LogPath "Audit_$($file.BaseName)_$(Get-Date -Format 'yyyyMMdd_HHmmss').log"
        Write-AuditLog -LogFile $logFile -Entries $entries
        if ($Verbose) { Write-Host "Logged $($entries.Count) entries from $($file.Name)" }
    }
}

$KnownAnchors = @(
    "Microsoft UEFI CA Root",
    "CraigOS Secure Boot Anchor",
    "AMD Platform Key",
    "NVIDIA Boot Trust",
    "Realtek Secure Loader"
)

foreach ($entry in $PolicyEntries) {
    if ($KnownAnchors -notcontains $entry) {
        Write-Warning "⚠️ Unknown Trust Anchor Detected: $entry"
        Add-Content -Path "$LogPath\SuspiciousAnchors.log" -Value "$timestamp - $entry"
    }
}

