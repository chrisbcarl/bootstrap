$count = 0
$ArgsCopy = "$args"
Get-ChildItem | ForEach-Object {
    if (Test-Path -Path "$($_.FullName)/.git" -ErrorAction SilentlyContinue) {
        Write-Host -ForegroundColor Green $_;
        git -C $_ $ArgsCopy
        $count += 1
    }
}
if ($count -eq 0) {
    Write-Warning "No git repositories found--try different directory?"
    exit 1
}
