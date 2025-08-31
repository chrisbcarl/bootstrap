# https://superuser.com/a/1805830

function isadmin {
    # https://ss64.com/ps/syntax-elevate.html
    return ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
}
If (-NOT (isadmin)) {
    # Relaunch as an elevated process:
    Start-Process powershell.exe "-noprofile", "-executionpolicy", "bypass", "-File", ('"{0}"' -f $MyInvocation.MyCommand.Path) -Verb RunAs
    exit
}


& "C:\ProgramData\chocolatey\bin\DiskInfo64.exe" /CopyExit
$s=Get-Content "C:\ProgramData\chocolatey\lib\crystaldiskinfo.portable\tools\DiskInfo.txt"
$models=($s | select-string "           Model : ") -replace "           Model : ",""
$firmwares=($s | select-string "        Firmware : ") -replace "        Firmware : ",""
$healths=($s | Select-String "   Health Status : ") -replace "   Health Status : ",""
$dletters=($s | Select-String "    Drive Letter : ") -replace "    Drive Letter : ",""
$temps=($s | Select-String "     Temperature : ") -replace "     Temperature : ",""
$feats=($s | Select-String "        Features : ") -replace "        Features : ",""
$Drives=`
for ($i=0;$i -lt $models.count;$i++) {
    [PSCustomObject]@{"Model"=$models[$i];"Firmware"=$firmwares[$i];"Health"=$healths[$i];"Letter"=$dletters[$i];"Temp"=$temps[$i];"Features"=$feats[$i]}
}
$Drives


Read-Host "press enter to continue"  # in case of auto-elevate, it will dismiss too quickly
