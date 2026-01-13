if (-Not ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] 'Administrator')) {
    if ([int](Get-CimInstance -Class Win32_OperatingSystem | Select-Object -ExpandProperty BuildNumber) -ge 6000) {
        Write-Warning "run as admin"
        exit 1
    }
}


# https://www.reddit.com/r/Surface/comments/nm85p8/sb2_battery_drain_when_shut_off_rant/


# https://www.elevenforum.com/t/enable-or-disable-wake-on-lan-wol-in-windows-11.11872/
Write-Host -ForegroundColor Cyan "Before"
powercfg -devicequery wake_armed
# powercfg -devicequery wake_programmable

Get-NetAdapter | ForEach-Object {
    Write-Host $_.InterfaceDescription
    # disable
    powercfg -devicedisablewake $_.InterfaceDescription
    # enable
    # powercfg -deviceenablewake $_.InterfaceDescription
}

Write-Host -ForegroundColor Cyan "After"
powercfg -devicequery wake_armed


Write-Host -ForegroundColor Cyan "Disable fast startup"
# Disable fast startup
# https://www.tenforums.com/tutorials/4189-turn-off-fast-startup-windows-10-a.html
New-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Control\Session Manager\Power" -Name "HiberbootEnabled" -Value 0 -PropertyType DWORD -Force


Write-Host -ForegroundColor Cyan "Find out how often it's waking up"
Powercfg /batteryreport
$output_html = [IO.Path]::GetFullPath("$((Get-Location).Path)/battery-report.html")
Copy-Item -Path $output_html -Destination "C:\temp"
chrome.exe "C:\temp\battery-report.html"


# https://www.tenforums.com/tutorials/63064-view-wake-timers-windows-10-a.html
Write-Host -ForegroundColor Cyan "Find out how often it's waking up"
Get-ScheduledTask | ? {$_.Settings.WakeToRun} | Out-GridView




# removes the right click start > sleep possibility...
# # https://www.elevenforum.com/t/disable-modern-standby-in-windows-10-and-windows-11.3929/
# Write-Host -ForegroundColor Cyan "Disabling 'Standby (S0 Low Power Idle) Network Connected'"
# New-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Control\Power" -Name "PlatformAoAcOverride" -Value 0 -PropertyType DWORD -Force


# https://www.elevenforum.com/t/enable-or-disable-network-connectivity-in-modern-standby-in-windows-11.3286/
Write-Host -ForegroundColor Cyan "GPO > Computer Configuration > Administrative Templates > System > Power Management > Sleep Settings​ > Allow network connectivity during connected-standby (plugged in)"
# Computer Configuration > Administrative Templates > System > Power Management > Sleep Settings​ > Allow network connectivity during connected-standby (plugged in)
# run gpo (group policy editor)
powercfg /a




# https://www.tenforums.com/tutorials/63070-enable-disable-wake-timers-windows-10-a.html
# TODO: NUCLEAR


# SURFACE BOOK 2 Related
# Allow Connectivity During connected-standby (on battery / pugged in ) disable
# https://www.tenforums.com/tutorials/146593-enable-disable-network-connectivity-modern-standby-windows-10-a.html
# GPO > Computer Configuration > Administrative Templates > System > Power Management > Sleep Settings
powercfg /batteryreport
# Battery life report saved to file path C:\WINDOWS\system32\battery-report.html.

# C:\WINDOWS\system32>powercfg /sleepstudy
# Sleep Study report saved to file path C:\WINDOWS\system32\sleepstudy-report.html.