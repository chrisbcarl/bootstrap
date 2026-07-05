[CmdletBinding()]
param (
    [Parameter()][Switch]$Launch
)

$Count = 0


if ($Launch) {
    Write-Host -ForegroundColor Green "Launching if there is unfinished work..."
    Get-ChildItem | ForEach-Object {
        if (Test-Path -Path "$_/.git" -ErrorAction SilentlyContinue) {
            $FullArgs = @("-C", $_, 'status')
            $output = & git @FullArgs
            if ($output -like '*not staged for commit:*') {
                Write-Host -ForegroundColor Cyan "    code $_"
                code $_
                $Count += 1
            }
        }
    }
    exit 0
}

$ArgsCopy = $args
Get-ChildItem | ForEach-Object {
    if (Test-Path -Path "$($_.FullName)/.git" -ErrorAction SilentlyContinue) {
        Write-Host -ForegroundColor Green $_;
        $FullArgs = @("-C", $_) + $ArgsCopy
        $cmd = "git $FullArgs"
        Write-Host -ForegroundColor Cyan "    $cmd"
        & git @FullArgs
        # Start-Process -FilePath 'git' -ArgumentList $FullArgs -Wait
        if ($LASTEXITCODE -ne 0) {
            Write-Warning "FAILED: $cmd"
            exit $LASTEXITCODE
        }
        $Count += 1
    }
}

if ($Count -eq 0) {
    Write-Warning "No git repositories found--try different directory?"
    exit 1
} else {
    Write-Host -ForegroundColor Green "Processed $Count git repositories."
}
