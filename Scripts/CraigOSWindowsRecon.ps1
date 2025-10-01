# === CraigOS Windows Recon Sweep ===
$timestamp = Get-Date -Format "yyyy-MM-dd_HH-mm-ss"
$logfile = "CraigOS_WindowsRecon_$timestamp.txt"

# === Listener Scan ===
"CraigOS Windows Recon – $timestamp" | Out-File $logfile
"`n🔍 Active TCP Listeners:`n" | Out-File $logfile -Append
Get-NetTCPConnection | Where-Object {$_.State -eq "Listen"} | Format-Table -AutoSize | Out-String | Out-File $logfile -Append

# === ARP Table Dump ===
"`n🔍 ARP Table:`n" | Out-File $logfile -Append
arp -a | Out-File $logfile -Append

# === DNS Cache Dump ===
"`n🔍 DNS Cache:`n" | Out-File $logfile -Append
ipconfig /displaydns | Out-File $logfile -Append

# === Completion Notice ===
"`n✅ CraigOS Windows Recon Complete – Results saved to $logfile`n" | Out-File $logfile -Append
Write-Host "Recon complete. Log saved to $logfile"

