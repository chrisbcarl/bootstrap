# https://www.windows-commandline.com/find-windows-os-version-from-command/
# https://www.delftstack.com/howto/powershell/run-cmd-commands-in-powershell/#google_vignette

cmd /c ver
# Microsoft Windows [Version 10.0.19045.5965]

systeminfo | findstr /B /C:"OS Name" /C:"OS Version"
# OS Name:                   Microsoft Windows 10 Pro
# OS Version:                10.0.19045 N/A Build 19045
