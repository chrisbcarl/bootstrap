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

Invoke-Script `
    -Exe "powershell.exe" `
    -ScriptPath "languages\powershell\download-file.ps1"
