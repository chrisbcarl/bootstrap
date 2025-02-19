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


# https://www.tenforums.com/tutorials/63064-view-wake-timers-windows-10-a.html
Write-Host -ForegroundColor Cyan "Find out how often it's waking up"
Get-ScheduledTask | ? {$_.Settings.WakeToRun} | Out-GridView


# https://www.tenforums.com/tutorials/63070-enable-disable-wake-timers-windows-10-a.html
# TODO: NUCLEAR