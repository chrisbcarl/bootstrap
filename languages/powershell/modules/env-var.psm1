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
    $Content -split ';' | ForEach-Object {
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
