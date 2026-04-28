function Invoke-Script {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory=$true)][string]$Exe,
        [Parameter(Mandatory=$true)][string]$ScriptPath,
        [Parameter()][switch]$Admin
    )
    $ScriptShort = $([IO.Path]::GetFileNameWithoutExtension($ScriptPath))
    Write-Host -ForeGroundColor Cyan "Running '$ScriptShort', please wait..."
    if ($exe -eq "powershell.exe") {
        $ArgumentList = @("-noprofile", "-executionpolicy", "bypass", "-File", $ScriptPath)
    } else {
        $ArgumentList = $ScriptPath
    }
    if ($Admin) {
        # -NoNewWindow does not work with -Verb`
        # note: PassThru necessary, https://stackoverflow.com/a/16018287
        $proc = Start-Process `
            -Filepath $Exe `
            -ArgumentList $ArgumentList `
            -Verb RunAs `
            -PassThru -Wait
    } else {
        $proc = Start-Process `
            -Filepath $Exe `
            -ArgumentList $ArgumentList `
            -NoNewWindow `
            -PassThru -Wait
    }

    if ($proc.ExitCode -ne 0) {
        Write-Host -ForeGroundColor DarkRed "FAILED: $script_short, ec $($proc.ExitCode)!"
        exit $proc.ExitCode
    }
}

function Invoke-ScriptBlock {
    <#
    $ScriptBlock = @"
        # whatever
        New-ItemProperty -Path '$SystemRegKey' -Name "Path" -Value '$system_path_text_clean' -PropertyType ExpandString -Force
        Write-Host '$system_path_text_clean'
        pause
    "@
    Invoke-ScriptBlock -ScriptBlock $ScriptBlock
    #>
    [CmdletBinding()]
    param (
        [Parameter(Mandatory=$true)][string]$ScriptBlock,
        [Parameter()][switch]$Admin
    )
    Write-Host -ForeGroundColor Cyan "Running 'ScriptBlock', please wait..."
    Write-Host -ForeGroundColor Cyan $ScriptBlock.ToString()

    $ArgumentList = @(
        "-Command",
        "&",
        "{$ScriptBlock}"
    )
    if ($Admin) {
        # -NoNewWindow does not work with -Verb`
        # note: PassThru necessary, https://stackoverflow.com/a/16018287
        $proc = Start-Process `
            -FilePath powershell.exe `
            -ArgumentList $ArgumentList `
            -Verb RunAs `
            -PassThru -Wait
    } else {
        $proc = Start-Process `
            -FilePath powershell.exe `
            -ArgumentList $ArgumentList `
            -PassThru -Wait
    }

    if ($proc.ExitCode -ne 0) {
        Write-Host -ForeGroundColor DarkRed "FAILED: $script_short, ec $($proc.ExitCode)!"
        exit $proc.ExitCode
    }

}


# Invoke-Script `
#     -Exe "powershell.exe" `
#     -ScriptPath "languages\powershell\download-file.ps1"


Export-ModuleMember -Function Invoke-Script,Invoke-ScriptBlock
