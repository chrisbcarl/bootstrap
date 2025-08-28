if (-NOT ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {    
    Write-Warning "Not admin!"
    exit 1
}


Set-ExecutionPolicy -ExecutionPolicy Unrestricted -Force
Write-Host -ForegroundColor Green "Done!"
