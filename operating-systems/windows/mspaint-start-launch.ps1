Get-ChildItem | ForEach-Object {
    Start-Process mspaint.exe -ArgumentList $_.FullName
}
