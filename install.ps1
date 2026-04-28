<#
'''
Author:         Chris Carl
Email:          chrisbcarl@outlook.com
Date:           2026-01-05
Description:
    Terminal settings

Updates:
    2026-04-28 12:43 - install - refactor into a script invoking function, add ps-profile install
    2026-01-25 14:31 - install - added git config, -Yes global, src projects
    2026-01-05 01:26 - install - added the terminal settings
#>

[CmdletBinding()]
param (
    [Parameter()][Switch]$Yes
)


$modules = @(
    "$PSScriptRoot\languages\powershell\modules\env-var.psm1",
    "$PSScriptRoot\languages\powershell\modules\start-process-invoke-script.psm1"
)
foreach ($module in $modules) {
    Import-Module -Name $([IO.Path]::GetFullPath($module)) -Force
}


function Get-Yes {
    [CmdletBinding()]
    param (
        [Parameter()][string]$Prompt
    )
    if ($Yes) {
        Write-Host -ForeGroundColor Cyan "$Prompt"
        return $true
    }
    Write-Host -ForeGroundColor Cyan "$Prompt (y/n)?" -NoNewline
    $confirmation = (Read-Host " ").ToLower()
    return ($confirmation.Count -gt 0) -and ($confirmation[0] -eq 'y')
}


function Invoke-ScriptInteractive {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory=$true)][string]$Exe,
        [Parameter(Mandatory=$true)][string]$ScriptPath,
        [Parameter()][switch]$Admin
    )
    $ScriptShort = $([IO.Path]::GetFileNameWithoutExtension($ScriptPath))
    if (Get-Yes -Prompt "Install - $ScriptShort") {
        if ($Admin) {
            Invoke-Script -Exe $Exe -ScriptPath $ScriptPath -Admin
        } else {
            Invoke-Script -Exe $Exe -ScriptPath $ScriptPath
        }
    }
}


function Invoke-ScriptBlockInteractive {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory=$true)][string]$ScriptBlock,
        [Parameter()][switch]$Admin
    )
    if (Get-Yes -Prompt "Install - $ScriptBlock") {
        if ($Admin) {
            Invoke-ScriptBlock -ScriptBlock $ScriptBlock -Admin
        } else {
            Invoke-ScriptBlock -ScriptBlock $ScriptBlock
        }
    }
}



if (-Not $Yes) {
    if (Get-Yes -Prompt "Install - conda hook toggle, current val $($env:CONDA_HOOK)?") {
        $conda_hook = $(if ($env:CONDA_HOOK -eq "1") { "0" } else { "1" })
        $env_var = [IO.Path]::GetFullPath("$PSScriptRoot\languages\powershell\modules\env-var.psm1")
        $ScriptBlock = @"
            Import-Module -Name "$env_var" -Force
            Set-EnvVarRefresh -Key "CONDA_HOOK" -Value "$conda_hook"
            pause
"@
        Invoke-ScriptBlockInteractive -ScriptBlock $ScriptBlock -Admin
    }
}


Invoke-ScriptInteractive `
    -Exe "powershell.exe" `
    -ScriptPath "$PSScriptRoot\operating-systems\windows\on-new-pc\install-ps-profile.ps1"


Invoke-ScriptInteractive `
    -Admin `
    -Exe "powershell.exe" `
    -ScriptPath "$PSScriptRoot\languages\python\install\uninstall-ms-store.ps1"


Invoke-ScriptInteractive `
    -Admin `
    -Exe "powershell.exe" `
    -ScriptPath "$PSScriptRoot\languages\python\install\install-python-requirements.ps1"


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
    Invoke-ScriptBlock -ScriptBlock $ScriptBlock -Admin

    Write-Host -ForegroundColor Yellow  "SYSTEM PATH Before - $system_path_text_raw"
    Write-Host -ForegroundColor Green   "SYSTEM PATH After  - $system_path_text_clean"
}

if (Get-Yes -Prompt "Install - poetry config") {
    poetry config virtualenvs.create true
    poetry config virtualenvs.in-project true
}


if (Get-Yes -Prompt "Install - git config") {
    git config --global user.email "chrisbcarl@outlook.com"
    git config --global user.name "Chris Carl"
    git config --global core.autocrlf false
    git config --global core.eol lf
}


if (Get-Yes -Prompt "Install - bootstrap .venv") {
    poetry install --all-extras
}


Invoke-ScriptInteractive `
    -Exe "python.exe" `
    -ScriptPath "$PSScriptRoot\.vscode\vscode-user-settings-write.py"


Invoke-ScriptInteractive `
    -Exe "python.exe" `
    -ScriptPath "$PSScriptRoot\operating-systems\windows\terminal\terminal-user-settings-write.py"


$script_short = "src projects"
if (Get-Yes -Prompt "Install - $script_short") {
    $projects = @(
        # modules
        'chriscarl.python.web',

        # tools
        'chriscarl.tools.ai',
        'chriscarl.tools.analyze-disk-performance',
        'chriscarl.tools.academia',
        'chriscarl.tools.calculators',
        'chriscarl.tools.documents',
        'chriscarl.tools.downloaders',
        'chriscarl.tools.house',
        'chriscarl.tools.youtube-utilities',

        # other projects
        'chriscarl.sjsu',
        'chriscarl.com'
    )
    $heavy_projects = @(
        'pgp-aiml'
    )

    $cwd = Get-Location
    $src = (Get-Item "~/src").ToString()
    if (-Not (Test-Path $src -ErrorAction SilentlyContinue)) {
        New-Item -ItemType Directory -Path $src -ErrorAction SilentlyContinue
    }
    try {
        Set-Location $src
        $src = Get-Location

        if (-Not (Test-Path bootstrap -ErrorAction SilentlyContinue)) {
            git clone git@github.com:chrisbcarl/bootstrap.git
            if ($LASTEXITCODE -ne 0) {
                Write-Host -ForeGroundColor DarkRed "FAILED: $script_short, ec $($LASTEXITCODE)!"
                exit $LASTEXITCODE
            }
            Set-Location bootstrap
            # .\install.ps1 -Yes  # TODO: figure out how to do this in order
            poetry install
            Set-Location $src
        }

        if (-Not (Test-Path chriscarl.python -ErrorAction SilentlyContinue)) {
            git clone git@github.com:chrisbcarl/chriscarl.python
            Set-Location chriscarl.python
            poetry install
            Set-Location $src
        }

        foreach($project in $projects) {
            if (Test-Path $project -ErrorAction SilentlyContinue) {
                continue
            }
            git clone git@github.com:chrisbcarl/$project
            Set-Location $project
            if (Test-Path "pyproject.toml" -ErrorAction SilentlyContinue) {
                poetry install
            }
            New-Item -ItemType Directory -Path "ignoreme" -ErrorAction SilentlyContinue
            Set-Location $src
        }

        foreach($heavy_project in $heavy_projects) {
            if (Test-Path $heavy_project -ErrorAction SilentlyContinue) {
                continue
            }
            git clone git@github.com:chrisbcarl/$heavy_project
            Set-Location $heavy_project
            if (Test-Path "pyproject.toml" -ErrorAction SilentlyContinue) {
                poetry install
            }
            Set-Location $src
        }
    }
    finally {
        Set-Location $cwd
    }

}

