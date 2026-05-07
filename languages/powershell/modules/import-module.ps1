$ModulePath = [IO.Path]::GetFullPath("$PSScriptRoot/env-var.psm1")
$ModuleName = [IO.Path]::GetFileNameWithoutExtension((Get-Item -Path $ModulePath).Name)
Import-Module -Name $ModulePath -Force
Write-Host -ForegroundColor Cyan "$ModuleName.psm1"
Get-Command -Module $ModuleName | ForEach-Object {
    Write-Host "    * $($_.Name)"  # Invoke-Prompt, whatever
}
