if (-Not ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
    Write-Warning "must run as admin"
    exit 1
}

# also removes hiberfil.sys, could be a large file...
powercfg /hibernate off
