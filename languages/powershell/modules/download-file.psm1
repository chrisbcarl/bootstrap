function Get-FileDownload {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory=$true)][string[]]$Urls,
        [Parameter()][string]$Destination="$env:USERPROFILE\downloads",
        [Parameter()][switch]$Force
    )

    $WEB_CLIENT = New-Object System.Net.WebClient

    $errors = @()
    foreach ($url in $Urls) {
        if ($null -eq $url) {
            continue
        }
        $basename = $url.Split('/')
        $basename = $basename[$basename.Count - 1]
        $basename = $basename.Split('?')[0]
        $filepath = [IO.Path]::GetFullPath("$Destination/$basename")
        if ((-Not $Force) -and (Test-Path -Path $filepath -ErrorAction SilentlyContinue)) {
            Write-Host -ForegroundColor Green "$basename exists at '$filepath'"
            continue
        }
        Write-Host -ForegroundColor Green "downloading $basename from $url to '$filepath'"
        try {
            $WEB_CLIENT.DownloadFile($url, $filepath)
            # WARNING:
            # Invoke-WebRequest -Uri $url -OutFile $filepath  # slow somehow
            Write-Host -ForegroundColor Green "'$filepath'"
        } catch {
            $errors += @($url)
        }
    }


    if ($errors.Count -gt 0) {
        Write-Warning 'could not download from:'
        foreach ($err in $errors) {
            Write-Warning "    $err"
        }
    }
}



Export-ModuleMember -Function Get-FileDownload
# Get-FileDownload -Urls 'https://download.msi.com/bos_exe/mb/7E70v2A23.zip'
