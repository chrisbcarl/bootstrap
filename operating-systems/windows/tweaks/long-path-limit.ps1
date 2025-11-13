# long path limit, need both
New-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Control\FileSystem" -Name "LongPathsEnabled" -Value 1 -PropertyType DWORD -Force
New-ItemProperty -Path "HKLM:\SYSTEM\ControlSet001\Control\FileSystem" -Name "LongPathsEnabled" -Value 1 -PropertyType DWORD -Force

