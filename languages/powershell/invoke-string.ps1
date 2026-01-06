$cmd = @"
`$global:LASTEXITCODE = 0;  # reset the global state
cmd /k "echo shit & exit 69";
return `$LASTEXITCODE  # allow the automatic variable to populate correctly
"@
$ScriptBlock = [scriptblock]::Create($cmd)


# works
Write-Host -ForegroundColor Cyan "Invoke-Command $cmd"
$rc = (Invoke-Command -ScriptBlock $ScriptBlock)
Write-Host "exit code: $LASTEXITCODE, stdout: '$rc'"


# works
Write-Host -ForegroundColor Cyan "Invoke-Expression $cmd"
$rc = (Invoke-Expression $cmd)
Write-Host "exit code: $LASTEXITCODE, stdout: '$rc'"
