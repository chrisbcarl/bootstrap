function Get-IsAdmin {
    return ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
}
function Invoke-AsAdmin {
    <#
    https://ss64.com/ps/syntax-elevate.html
    #>
    if (-not (Get-IsAdmin)) {
        # Relaunch as an elevated process:
        Start-Process powershell.exe "-noprofile", "-executionpolicy", "bypass", "-File", ('"{0}"' -f $MyInvocation.MyCommand.Path) -Verb RunAs
        exit
    }
}