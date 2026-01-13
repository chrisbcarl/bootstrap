<#
Author:      Chris Carl
Date:        2024-11-23
Email:       chrisbcarl@outlook.com

Description:
    analyzes the `PATH` variable and cleans it up:
        remove python dirs from the PATH variable
        creates a _PATH variable in user mode, fills it with python dirs
        adds _PATH to the user PATH for expansion later.
    _PATH is used because C comes before P, and expansion variables are loaded alphabetically and have a race condition where they must be defined first before expanded.
        - https://superuser.com/a/1034020

Updated:
    2026-01-04 - install-python-path - put it on system path instead, no need for user, re-orged for module use
    2026-01-04 - install-python-path - confirmed that for win11, any expandables alphabeta after PATH in PATH cause ALL expandables to fail
    2025-12-24 - install-python-path - refine
    2024-11-23 - install-python-path - install-path initial commit
#>

[CmdletBinding()]
param (
    [Parameter()][Switch]$Dry
)

function isadmin {
    # https://ss64.com/ps/syntax-elevate.html
    return ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
}
If (-NOT (isadmin)) {
    # Relaunch as an elevated process:
    Start-Process powershell.exe "-noprofile", "-executionpolicy", "bypass", "-File", ('"{0}"' -f $MyInvocation.MyCommand.Path) -Verb RunAs
    exit
}

$env_var_module = [IO.Path]::GetFullPath("$PSScriptRoot/../powershell/modules/env-var.psm1")
Import-Module -Name $env_var_module


$SystemRegKey = "HKLM:\SYSTEM\CurrentControlSet\Control\Session Manager\Environment"
# $UserRegKey = "HKCU:\Environment"
$MetaEnvKey = 'CPATH'

# make a list of everything that SHOULDNT appear in SYSTEM PATH
$RemoveList = @("%$MetaEnvKey%")  # these are elements of the path that are to be extracted away from the env variable
$where_pythons = (where.exe python)
python -c "import sys; sys.exit(sys.prefix != sys.base_prefix)"  # if 1, we're in a virtual env, so chop off the top
$pythons = @()
for ($i = $LASTEXITCODE; $i -lt $where_pythons.Count; $i++) {
    $pythons += $where_pythons[$i]
}
$python_directories = ($pythons | ForEach-Object {[IO.Path]::GetDirectoryName($_)})

# add all real python dirs to a list, add that list to what SHOULDNT appear in SYSTEM PATH
$pythons_variable_tokens = @()
$python_directories | ForEach-Object {
    $RemoveList += $_
    $RemoveList += "$_\"
    $RemoveList += "$_\Scripts"
    $RemoveList += "$_\Scripts\"
    $pythons_variable_tokens += $_
    $pythons_variable_tokens += "$_\Scripts"
}

$meta_path_variable_text = $pythons_variable_tokens -join ';'
if (-Not $Dry) {
    # New-ItemProperty -Path $UserRegKey -Name $MetaEnvKey -Value "$_path_variable_text" -PropertyType ExpandString -Force
    New-ItemProperty -Path $SystemRegKey -Name $MetaEnvKey -Value "$meta_path_variable_text" -PropertyType ExpandString -Force
}
Write-Host -ForegroundColor Cyan        "$MetaEnvKey     - $_path_variable_text"

$system_path_text_raw = (Get-Item -Path $SystemRegKey).GetValue('Path', '', 'DoNotExpandEnvironmentNames')
$system_path_text_clean = Get-CleanPath -Content $system_path_text_raw -RemoveList $RemoveList
$system_path_text_clean = "%$($MetaEnvKey)%;$system_path_text_clean"
if (-Not $Dry) {
    New-ItemProperty -Path $SystemRegKey -Name "Path" -Value "$system_path_text_clean" -PropertyType ExpandString -Force
}
Write-Host -ForegroundColor DarkRed     "SYSTEM PATH Before - $system_path_text_raw"
Write-Host -ForegroundColor Red         "SYSTEM PATH After  - $system_path_text_clean"

# $user_path_text_raw = (Get-Item -Path $UserRegKey).GetValue('Path', '', 'DoNotExpandEnvironmentNames')
# $user_path_text_clean = Get-CleanPath -Content $user_path_text_raw -RemoveList $RemoveList
# $user_path_text_clean = "%$($MetaEnvKey)%;$user_path_text_clean"
# if (-Not $Dry) {
#     New-ItemProperty -Path $UserRegKey -Name "Path" -Value "$user_path_text_clean" -PropertyType ExpandString -Force
# }
# Write-Host -ForegroundColor DarkBlue    "USER PATH Before - $user_path_text_raw"
# Write-Host -ForegroundColor Blue        "USER PATH After  - $user_path_text_clean"

Write-Host -ForegroundColor Green "Success installing paths for $($pythons.Count) python interpreters!"

pause
