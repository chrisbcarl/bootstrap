<#
Author:      Chris Carl
Date:        2024-11-21
Email:       chrisbcarl@outlook.com

Description:
    import this module and you can run a script block into it--though it doesnt get $LASTEXITCODE...

Updated:
    2024-11-13 - chriscarl - start-elevated-context-block initial commit
#>


function Start-ElevatedContextBlock {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory=$true)][String]$Source,
        [Parameter(Mandatory=$true)][ScriptBlock]$ScriptBlock,
        [Parameter()][String[]]$Arguments
    )
    # https://serverfault.com/a/1058407
    if (-Not
        (New-Object Security.Principal.WindowsPrincipal(
            [Security.Principal.WindowsIdentity]::GetCurrent()
        )).IsInRole(
            [Security.Principal.WindowsBuiltInRole]::Administrator
        )
    ) {
        # flatten to single array
        $ArgumentList = @('-File', $Source)
        if ($Arguments.Count -gt 0) {
            $ArgumentList += ($Arguments | ForEach-Object { $_ } )
        }
        Start-Process -FilePath 'powershell' -ArgumentList $ArgumentList -Verb RunAs
        exit
    }

    # https://stackoverflow.com/a/8550697
    if ($Arguments.Count -gt 0) {
        $ArgumentList = ($Arguments | ForEach-Object { $_ } )
        Invoke-Command $ScriptBlock -ArgumentList $ArgumentList
    } else {
        Invoke-Command $ScriptBlock
    }
    # TODO: cant get an exit code out of it...
    # if (($null -eq $ec) -or (0 -eq $ec)) {
    #     Write-Host -ForegroundColor Green "Success!"
    # } else {
    #     Write-Warning "Failure exit code $ec othercode $?!"
    # }
    Pause  # quality of life
    exit $ec
}

