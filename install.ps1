

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
    $proc = Start-Process `
        powershell.exe `
        "-noprofile", "-executionpolicy", "bypass", "-File", `
        $script `
        -Verb RunAs `
        -PassThru -Wait  # note: PassThru necessary, https://stackoverflow.com/a/16018287

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
    $proc = Start-Process `
        -FilePath powershell.exe `
        -Verb RunAs `
        -ArgumentList $ArgumentList `
        -PassThru -Wait `  # note: PassThru necessary, https://stackoverflow.com/a/16018287

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
    poetry install
}
