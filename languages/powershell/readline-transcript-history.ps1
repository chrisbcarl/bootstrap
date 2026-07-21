$transcript = "\temp\transcript.txt"
Start-Transcript -Path $transcript -Force

echo hello world
write-host "hello world"
# $hist = history  # alias
$hist = Get-History
$hist | ForEach-Object {
    # Write-Host $_.Id
    Write-Host ""
    $_.CommandLine | ForEach-Object {
        Write-Host "   $_"
    }
}


Stop-Transcript
start $transcript
