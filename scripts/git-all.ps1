$count = 0
$ArgsCopy = $args
Get-ChildItem | ForEach-Object {
    if (Test-Path -Path "$($_.FullName)/.git" -ErrorAction SilentlyContinue) {
        Write-Host -ForegroundColor Green $_;
        $FullArgs = @("-C", $_) + $ArgsCopy
        $cmd = "git $FullArgs"
        Write-Host -ForegroundColor Cyan $cmd
        # Write-Host $FullArgs
        & git @FullArgs
        # Start-Process -FilePath 'git' -ArgumentList $FullArgs -Wait
        if ($LASTEXITCODE -ne 0) {
            Write-Warning "FAILED: $cmd"
            exit $LASTEXITCODE
        }
        $count += 1
    }
}
if ($count -eq 0) {
    Write-Warning "No git repositories found--try different directory?"
    exit 1
}
