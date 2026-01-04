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


$SystemRegKey = "HKLM:\SYSTEM\CurrentControlSet\Control\Session Manager\Environment"
$UserRegKey = "HKCU:\Environment"
$MetaEnvKey = 'CPATH'

function Get-PathClean {
    [CmdletBinding()]
    param (
        [Parameter()][string]$Content,
        [Parameter()][string[]]$SkipList
    )
    $visited = @{}
    $clean_path = @()
    $Content -split ';' | ForEach-Object {
        if (-Not $SkipList.Contains($_)){
            $token = "$_\" -replace "\\{2,}","\"
            $token = $token.replace('\;', ';')
            $token = $token -replace "(.+)\\$",'$1'

            # go ahead and replace %SYSTEMROOT% and other stuff in PATH
            # in Win11, having ANY expandable vars in PATH alphabetically after PATH is bad...
            # https://superuser.com/questions/1034004/certain-variables-wont-expand-in-windows-system-environment-variables-path#comment2911979_1034020
            if ($token -match '%(.+?)%(.*)') {
                $env_value = (Get-Item -Path "env:$($Matches.1)").Value
                $token = "$($env_value)$($Matches.2)"
            }
            $token = [IO.Path]::GetFullPath($token)
            if ($visited.ContainsKey($token.ToLower())) {
                continue
            }

            $clean_path += $token
            $visited[$token] = $true
        }
    }
    $variable_text = $clean_path -join ';'
    return $variable_text
}

# make a list of everything that SHOULDNT appear in SYSTEM PATH
$BlockList = @("%$MetaEnvKey%")  # these are elements of the path that are to be extracted away from the env variable
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
    $BlockList += $_
    $BlockList += "$_\"
    $BlockList += "$_\Scripts"
    $BlockList += "$_\Scripts\"
    $pythons_variable_tokens += $_
    $pythons_variable_tokens += "$_\Scripts"
}

$system_path_text_raw = (Get-Item -Path $SystemRegKey).GetValue('Path', '', 'DoNotExpandEnvironmentNames')
$system_path_text_clean = Get-PathClean -Content $system_path_text_raw -SkipList $BlockList
if (-Not $Dry) {
    New-ItemProperty -Path $SystemRegKey -Name "Path" -Value "$system_path_text_clean" -PropertyType ExpandString -Force
}

$_path_variable_text = $pythons_variable_tokens -join ';'
if (-Not $Dry) {
    New-ItemProperty -Path $UserRegKey -Name $MetaEnvKey -Value "$_path_variable_text" -PropertyType ExpandString -Force
}

$user_path_text_raw = (Get-Item -Path $UserRegKey).GetValue('Path', '', 'DoNotExpandEnvironmentNames')
$user_path_text_clean = Get-PathClean -Content $user_path_text_raw -SkipList $BlockList
$user_path_text_clean = "%$($MetaEnvKey)%;$user_path_text_clean"
if (-Not $Dry) {
    New-ItemProperty -Path $UserRegKey -Name "Path" -Value "$user_path_text_clean" -PropertyType ExpandString -Force
}

Write-Host -ForegroundColor DarkRed "SYSTEM PATH Before - $system_path_text_raw"
Write-Host -ForegroundColor Magenta "SYSTEM PATH After  - $system_path_text_clean"
Write-Host -ForegroundColor DarkGreen "$MetaEnvKey     - $_path_variable_text"
Write-Host -ForegroundColor DarkRed "USER PATH Before - $user_path_text_raw"
Write-Host -ForegroundColor Magenta "USER PATH After  - $user_path_text_clean"

Write-Host -ForegroundColor Green "Success installing paths for $($pythons.Count) python interpreters!"

pause
