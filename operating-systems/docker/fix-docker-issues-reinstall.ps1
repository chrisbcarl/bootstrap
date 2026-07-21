# https://github.com/docker/for-win/issues/14934

if (-Not ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
    Write-Warning "run as admin"
    exit 1
}

Write-Warning "killing docker-desktop"
taskkill /IM "com.docker.build.exe" /F
taskkill /IM "com.docker.backend.exe" /F
taskkill /IM "Docker Desktop.exe" /F
taskkill /IM "com.docker.backend.exe" /F
taskkill /IM "com.docker.build.exe" /F
taskkill /IM "Docker Desktop.exe" /F

Write-Warning "suspending wsl"
wsl --shutdown

Write-Warning "uninstalling docker-desktop"
choco uninstall docker-desktop -y

Write-Warning "removing all docker-desktop appdata"
Remove-Item -Path "$env:USERPROFILE\AppData\Local\Docker" -Recurse -Force

Write-Warning "restarting wsl"
wsl --shutdown
wsl echo wsl restarted "&&" exit

Write-Warning "reinstalling docker-desktop"
choco install docker-desktop -y

Write-Warning "launching docker-desktop"
& 'c:\Program Files\Docker\Docker\Docker Desktop.exe'
