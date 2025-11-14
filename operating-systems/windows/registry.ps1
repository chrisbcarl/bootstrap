# jump list / pinned taskbar item count
New-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name "JumpListItems_Maximum" -Value 24 -PropertyType Dword -Force

# long path limit, need both
New-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Control\FileSystem" -Name "LongPathsEnabled" -Value 1 -PropertyType DWORD -Force
New-ItemProperty -Path "HKLM:\SYSTEM\ControlSet001\Control\FileSystem" -Name "LongPathsEnabled" -Value 1 -PropertyType DWORD -Force

# Turn On or Off "Recent Items" and "Frequent Places" for Current User using a REG file
# https://www.tenforums.com/tutorials/3469-turn-off-recent-items-frequent-places-windows-10-a.html
# start %APPDATA%\Microsoft\Windows\Recent Items
# Recent files are ALWAYS tracked... this is just in the display...
# disabling with 0 results in jump list recents going away, Quick Access going away, Recent Items going away, so to be hidden with file access you n
New-ItemProperty -Path "HKLM:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name "Start_TrackDocs" -Value 1 -PropertyType DWORD -Force
New-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name "Start_TrackDocs" -Value 1 -PropertyType DWORD -Force


# Disable fast startup
# https://www.tenforums.com/tutorials/4189-turn-off-fast-startup-windows-10-a.html
New-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Control\Session Manager\Power" -Name "HiberbootEnabled" -Value 0 -PropertyType DWORD -Force

& $PSScriptRoot/admin-self-elevate.ps1

& $PSScriptRoot/tweaks/widgets.ps1
