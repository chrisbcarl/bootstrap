if (-NOT ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {    
    Write-Warning "Not admin!"
    exit 1
}


# base choco install
if (Get-Command choco -ErrorAction SilentlyContinue) {
    Write-Warning "chocolatey already installed!"
} else {
    Set-ExecutionPolicy Bypass -Scope Process -Force; [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; iex ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))
    Write-Host -ForegroundColor Green "Done!"
}
