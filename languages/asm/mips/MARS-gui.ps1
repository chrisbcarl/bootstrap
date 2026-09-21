$cwd = Get-Location
Set-Location $PSScriptRoot

# MARS Simulator opens files from current directory launched
Start-Process "java" -ArgumentList @("-jar", "$PSScriptRoot\Mars4_5.jar") -NoNewWindow


Set-Location $cwd
