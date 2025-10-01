# CraigOS Hygiene Sweep – Save as .ps1 file
Set-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Control\SystemInformation" -Name "SystemProductName" -Value "CraigOS Ryzen 7 7700"

New-Item -Path "HKLM:\Software\Policies\Microsoft\Windows\DeviceInstall\Restrictions" -Force
Set-ItemProperty -Path "HKLM:\Software\Policies\Microsoft\Windows\DeviceInstall\Restrictions" -Name "DenyDeviceIDs" -Value 1

Get-PnpDevice | Where-Object {
    $_.InstanceId -match "SWD\\DRIVERENUM\\{C3A63ED"
} | Disable-PnpDevice -Confirm:$false

Get-NetAdapter | Where-Object { $_.Status -eq "Up" } | Select Name, InterfaceDescription, LinkSpeed

