# Turn On or Off "Recent Items" and "Frequent Places" for Current User using a REG file
# https://www.tenforums.com/tutorials/3469-turn-off-recent-items-frequent-places-windows-10-a.html
# start %APPDATA%\Microsoft\Windows\Recent Items
# Recent files are ALWAYS tracked... this is just in the display...
# disabling with 0 results in jump list recents going away, Quick Access going away, Recent Items going away, so to be hidden with file access you n
New-ItemProperty -Path "HKLM:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name "Start_TrackDocs" -Value 1 -PropertyType DWORD -Force
