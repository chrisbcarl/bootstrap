$gcloud = Get-Command gcloud -ErrorAction SilentlyContinue
if ($null -eq $gcloud) {
    Write-Warning "gcloud not installed!"
    Write-Host "    https://docs.cloud.google.com/sdk/docs/install-sdk"
    Write-Host -ForegroundColor Cyan @'
    (New-Object Net.WebClient).DownloadFile("https://dl.google.com/dl/cloudsdk/channels/rapid/GoogleCloudSDKInstaller.exe", "$env:Temp\GoogleCloudSDKInstaller.exe")
    & $env:Temp\GoogleCloudSDKInstaller.exe
'@
    exit 1
}


$ssh_dirpath = (Resolve-Path ~/.ssh).Path
$items = (Get-ChildItem -Path $ssh_dirpath)
$ssh_pub_key = $null
foreach ($item in $items) {
    if (([IO.Path]::GetExtension($item.Name)) -eq '.pub') {
        $ssh_pub_key = [IO.Path]::GetFullPath("$ssh_dirpath\$item")
        Write-Host $ssh_pub_key
        break
    }
}

if ($null -ne $ssh_pub_key) {
    gcloud compute os-login ssh-keys add --key-file $ssh_pub_key --ttl "999d"
} else {
    Write-Warning "Could not determine .pub keyfile from '$ssh_dirpath'!"
}
