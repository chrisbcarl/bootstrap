[CmdletBinding()]
param (
    [Parameter()][string]$Filepath = "$PSScriptRoot/Mars4_5.jar"
)

if (-Not (Get-Command "java.exe" -ErrorAction SilentlyContinue)) {
    if (-not (Get-IsAdmin)) {
        # Relaunch as an elevated process:
        Start-Process powershell.exe "-noprofile", "-executionpolicy", "bypass", "-File", ('"{0}"' -f $MyInvocation.MyCommand.Path) -Verb RunAs
        exit
    }
    choco install openjdk -y
}

$uri = "https://github.com/dpetersanderson/MARS/releases/download/v.4.5.1/Mars4_5.jar"
Invoke-WebRequest -Uri $uri -OutFile $filepath

Start-Process java -ArgumentList @("-jar", $filepath) -NoNewWindow
