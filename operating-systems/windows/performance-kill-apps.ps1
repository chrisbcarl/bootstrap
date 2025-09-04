function isadmin {
    # https://ss64.com/ps/syntax-elevate.html
    return ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
}
If (-NOT (isadmin)) {
    # Relaunch as an elevated process:
    Start-Process powershell.exe "-noprofile", "-executionpolicy", "bypass", "-File", ('"{0}"' -f $MyInvocation.MyCommand.Path) -Verb RunAs
    exit
}

taskkill /f /t /im discord.exe


taskkill /f /t /im python.exe

# taskkill /f /t /im code.exe

taskkill /f /t /im zoom.exe
taskkill /f /t /im "Creative Cloud.exe"
taskkill /f /t /im GoogleDriveFS.exe

taskkill /f /t /im AdobeCollabSync.exe
taskkill /f /t /im AdobeUpdateService.exe
taskkill /f /t /im "Adobe Crash Processor.exe"
taskkill /f /t /im AdobeNotificationClient.exe
taskkill /f /t /im CCXProcess.exe

taskkill /f /t /im OneDrive.exe
taskkill /f /t /im OfficeClickToRun.exe  # PHANTOM keeps respawning

taskkill /f /t /im NordVPN.exe
taskkill /f /t /im nordsec-threatprotection-service.exe
taskkill /f /t /im NordUpdateService.exe

taskkill /f /t /im node.exe

taskkill /f /t /im ONENOTE.exe
taskkill /f /t /im ONENOTEM.exe


pause


