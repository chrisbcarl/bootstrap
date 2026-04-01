$root = Resolve-Path -Path "~\AppData\Local\Microsoft\WindowsApps"
if (Test-Path "$root\python.exe") {
    Write-Warning "removing MS Store python.exe"
    Remove-Item "$root\python.exe"
}
if (Test-Path "$root\python3.exe") {
    Write-Warning "removing MS Store python3.exe"
    Remove-Item "$root\python3.exe"
}
