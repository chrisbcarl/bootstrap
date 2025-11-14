# Disable fast startup
# https://www.tenforums.com/tutorials/4189-turn-off-fast-startup-windows-10-a.html
New-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Control\Session Manager\Power" -Name "HiberbootEnabled" -Value 0 -PropertyType DWORD -Force

