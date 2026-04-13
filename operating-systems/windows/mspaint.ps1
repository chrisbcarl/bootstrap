Get-ChildItem -Path "pngs-dirpath" | ForEach-Object {
    Start-Process mspaint.exe -ArgumentList $_.FullName
}
