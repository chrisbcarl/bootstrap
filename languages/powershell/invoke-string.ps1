$rc = (cmd /k "echo shit & exit 69")
Write-Host "exit code: $LASTEXITCODE, stdout: '$rc'"  # "shit "


$cmd = 'cmd /k "echo shit & exit 69"'

$StringWrapper = @"
`$global:LASTEXITCODE = 0;  # reset the global state
$cmd;
return `$LASTEXITCODE  # allow the automatic variable to populate correctly
"@
$ScriptBlock = [scriptblock]::Create($StringWrapper)


# works
Write-Host -ForegroundColor Cyan "Invoke-Command $StringWrapper"
$rc = (Invoke-Command -ScriptBlock $ScriptBlock)
Write-Host "exit code: $LASTEXITCODE, stdout: '$rc'"  # "shit 69"


# works
Write-Host -ForegroundColor Cyan "Invoke-Expression $StringWrapper"
$rc = (Invoke-Expression $StringWrapper)
Write-Host "exit code: $LASTEXITCODE, stdout: '$rc'"  # "shit 69"
