<#
'''
Author:         Chris Carl
Email:          chrisbcarl@outlook.com
Date:           2026-01-05
Description:
    Terminal settings

Updates:
    2026-01-05 01:26 - install - added the terminal settings
#>

function Get-Yes {
    [CmdletBinding()]
    param (
        [Parameter()][string]$Prompt
    )
    Write-Host -ForeGroundColor Cyan "$Prompt (y/n)?" -NoNewline
    $confirmation = (Read-Host " ").ToLower()
    return ($confirmation.Count -gt 0) -and ($confirmation[0] -eq 'y')
}


$script = "$PSScriptRoot\languages\python\install\install-python-requirements.ps1"
$script_short = $([IO.Path]::GetFileNameWithoutExtension($script))
if (Get-Yes -Prompt "Install - $script_short") {
    Write-Host -ForeGroundColor Cyan "    Please wait..."
    # -NoNewWindow does not work with -Verb`
    # note: PassThru necessary, https://stackoverflow.com/a/16018287
    $proc = Start-Process `
        -Filepath powershell.exe `
        -ArgumentList "-noprofile", "-executionpolicy", "bypass", "-File", $script `
        -Verb RunAs `
        -PassThru -Wait

    if ($proc.ExitCode -ne 0) {
        Write-Host -ForeGroundColor DarkRed "FAILED: $script_short, ec $($proc.ExitCode)!"
        exit $proc.ExitCode
    }
}


$env_var_module = [IO.Path]::GetFullPath("$PSScriptRoot/languages/powershell/modules/env-var.psm1")
Import-Module -Name $env_var_module -Force


$script_short = "PATH bootstrap/scripts"
if (Get-Yes -Prompt "Install - $script_short") {
    $SystemRegKey = "HKLM:\SYSTEM\CurrentControlSet\Control\Session Manager\Environment"
    $AddList = @(
        [IO.Path]::GetFullPath("$PSScriptRoot/scripts")
    )
    $AddContent = $AddList -join ';'
    $system_path_text_raw = (Get-Item -Path $SystemRegKey).GetValue('Path', '', 'DoNotExpandEnvironmentNames')
    $system_path_text_clean = Get-CleanPath -Content $system_path_text_raw -RemoveList $AddList
    $system_path_text_clean = "$AddContent;$system_path_text_clean"

    $ScriptBlock = @"
        New-ItemProperty -Path '$SystemRegKey' -Name "Path" -Value '$system_path_text_clean' -PropertyType ExpandString -Force
        Write-Host '$system_path_text_clean'
        pause
"@
    Write-Host $ScriptBlock.ToString()
    $ArgumentList = @(
        "-Command",
        "&",
        "{$ScriptBlock}"
    )
    # -NoNewWindow does not work with -Verb`
    # note: PassThru necessary, https://stackoverflow.com/a/16018287
    $proc = Start-Process `
        -FilePath powershell.exe `
        -ArgumentList $ArgumentList `
        -Verb RunAs `
        -PassThru -Wait

    if ($proc.ExitCode -ne 0) {
        Write-Host -ForeGroundColor DarkRed "FAILED: $script_short, ec $($proc.ExitCode)!"
        exit $proc.ExitCode
    }

    Write-Host -ForegroundColor Yellow  "SYSTEM PATH Before - $system_path_text_raw"
    Write-Host -ForegroundColor Green   "SYSTEM PATH After  - $system_path_text_clean"
}

if (Get-Yes -Prompt "Install - poetry config") {
    poetry config virtualenvs.create true
    poetry config virtualenvs.in-project true
}


if (Get-Yes -Prompt "Install - bootstrap .venv") {
    poetry install --all-extras
}


$script = "$PSScriptRoot\.vscode\vscode-user-settings-write.py"
$script_short = $([IO.Path]::GetFileNameWithoutExtension($script))
if (Get-Yes -Prompt "Install - $script_short") {
    Write-Host -ForeGroundColor Cyan "    Please wait..."
    # note: PassThru necessary, https://stackoverflow.com/a/16018287
    # -Verb RunAs `
    $proc = Start-Process `
        -Filepath python.exe `
        -ArgumentList $script `
        -NoNewWindow `
        -PassThru -Wait

    if ($proc.ExitCode -ne 0) {
        Write-Host -ForeGroundColor DarkRed "FAILED: $script_short, ec $($proc.ExitCode)!"
        exit $proc.ExitCode
    }
}


$script = "$PSScriptRoot\operating-systems\windows\terminal\terminal-user-settings-write.py"
$script_short = $([IO.Path]::GetFileNameWithoutExtension($script))
if (Get-Yes -Prompt "Install - $script_short") {
    Write-Host -ForeGroundColor Cyan "    Please wait..."
    # note: PassThru necessary, https://stackoverflow.com/a/16018287
    # -Verb RunAs `
    $proc = Start-Process `
        -Filepath python.exe `
        -ArgumentList $script `
        -NoNewWindow `
        -PassThru -Wait

    if ($proc.ExitCode -ne 0) {
        Write-Host -ForeGroundColor DarkRed "FAILED: $script_short, ec $($proc.ExitCode)!"
        exit $proc.ExitCode
    }
}

