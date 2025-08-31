$OUTPUT_DIRPATH = "$env:USERPROFILE/downloads"
$URLS = @(
    'https://download.msi.com/bos_exe/mb/7E70v2A23.zip'
)
$WEB_CLIENT = New-Object System.Net.WebClient


$errors = @()
foreach ($url in $URLS) {
    if ($null -eq $url) {
        continue
    }
    $basename = $url.Split('/')
    $basename = $basename[$basename.Count - 1]
    $filepath = [IO.Path]::GetFullPath("$OUTPUT_DIRPATH/$basename")
    if (Test-Path -Path $filepath -ErrorAction SilentlyContinue) {
        Write-Host -ForegroundColor Green "$basename exists at '$filepath'"
        continue
    }
    Write-Host -ForegroundColor Green "downloading $basename from $url to '$filepath'"
    try {
        $WEB_CLIENT.DownloadFile($url, $filepath)
        # Invoke-WebRequest -Uri $url -OutFile $filepath  # slow somehow
        Write-Host -ForegroundColor Green "'$filepath'"
    } catch {
        $errors += @(url)
    }
}


if ($errors.Count -gt 0) {
    Write-Warning 'could not download from:'
    foreach ($err in $errors) {
        Write-Warning "    $err"
    }
}
