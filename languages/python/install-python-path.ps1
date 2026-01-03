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
    2025-12-24 - install-python-path - refine
    2024-11-23 - install-python-path - install-path initial commit
#>


$ScriptBlock = {
    $SystemRegKey = "HKLM:\SYSTEM\CurrentControlSet\Control\Session Manager\Environment"
    $UserRegKey = "HKCU:\Environment"
    $MetaEnvKey = 'CPATH'

    function Get-PathClean {
        [CmdletBinding()]
        param (
            [Parameter()][string]$Content,
            [Parameter()][string[]]$SkipList
        )
        $clean_path = @()
        $Content -split ';' | ForEach-Object {
            if (-Not $SkipList.Contains($_)){
                $token = "$_\" -replace "\\{2,}","\"
                $token = $token.replace('\;', ';')
                $token = $token -replace "(.+)\\$",'$1'
                $clean_path += $token
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
    New-ItemProperty -Path $SystemRegKey -Name "Path" -Value "$system_path_text_clean" -PropertyType ExpandString -Force

    $_path_variable_text = $pythons_variable_tokens -join ';'
    New-ItemProperty -Path $UserRegKey -Name $MetaEnvKey -Value "$_path_variable_text" -PropertyType ExpandString -Force

    $user_path_text_raw = (Get-Item -Path $UserRegKey).GetValue('Path', '', 'DoNotExpandEnvironmentNames')
    $user_path_text_clean = Get-PathClean -Content $user_path_text_raw -SkipList $BlockList
    $user_path_text_clean = "%$($MetaEnvKey)%;$user_path_text_clean"
    New-ItemProperty -Path $UserRegKey -Name "Path" -Value "$user_path_text_clean" -PropertyType ExpandString -Force

    Write-Host -ForegroundColor DarkRed "SYSTEM PATH Before - $system_path_text_raw"
    Write-Host -ForegroundColor Magenta "SYSTEM PATH After  - $system_path_text_clean"
    Write-Host -ForegroundColor DarkGreen "$MetaEnvKey     - $_path_variable_text"
    Write-Host -ForegroundColor DarkRed "USER PATH Before - $user_path_text_raw"
    Write-Host -ForegroundColor Magenta "USER PATH After  - $user_path_text_clean"

    Write-Host -ForegroundColor Green "Success installing paths for $($pythons.Count) python interpreters!"
    return 0
}


Import-Module -Name $PSScriptRoot\..\start-elevated-context-block.psm1 -Force
Start-ElevatedContextBlock -Source $MyInvocation.MyCommand.Source -ScriptBlock $ScriptBlock
