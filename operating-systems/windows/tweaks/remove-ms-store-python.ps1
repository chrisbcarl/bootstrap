$filepath = "$env:USERPROFILE\AppData\Local\Microsoft\WindowsApps\python.exe"
if (Test-Path -Path $filepath -ErrorAction SilentlyContinue) {
    Write-Warning "removing..."
    Remove-Item -Path $filepath -Force
} else {
    Write-Host -ForegroundColor Green "didnt exist!"
}
return 0