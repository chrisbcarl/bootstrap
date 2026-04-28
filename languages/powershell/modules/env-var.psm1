Import-Module -Name "$PSScriptRoot/is-admin.psm1" -Force

function Get-CleanPath {
    <#
    -Content "%VARNAME%;C:\Whatever\\;C:\Whatever;C:\Python310"
    -RemoveList @('C:\Python310')

    returns
        "%VARNAME%;C:\Whatever
    #>
    [CmdletBinding()]
    param (
        [Parameter()][string]$Content,
        [Parameter()][string[]]$RemoveList
    )
    $visited = @{}
    $clean_path = @()
    $tokens = $Content -split ';'
    foreach ($_ in $tokens) {
        if (-Not $RemoveList.Contains($_)){
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
            Write-Host $token
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

function Set-EnvVarRefresh {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory=$true)][string]$Key,
        [Parameter(Mandatory=$true)][string]$Value
    )
    if (-not (Get-IsAdmin)) {
        throw [System.Exception]::new("not admin!")
    }
    $SystemRegKey = "HKLM:\SYSTEM\CurrentControlSet\Control\Session Manager\Environment"
    New-ItemProperty -Path $SystemRegKey `
        -Name $Key -Value $Value `
        -PropertyType ExpandString -Force
    #also includes default, options params -- '', 'DoNotExpandEnvironmentNames'
    $Expanded = (Get-Item -Path $SystemRegKey).GetValue($Key)
    [System.Environment]::SetEnvironmentVariable($Key, $Expanded)
}


Export-ModuleMember -Function Get-CleanPath,Set-EnvVarRefresh
