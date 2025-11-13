# jump list / pinned taskbar item count
New-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name "JumpListItems_Maximum" -Value 24 -PropertyType Dword -Force
