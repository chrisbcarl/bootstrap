$files = Get-ChildItem

$interpolation = "first`: '$($files[0].FullName)', colon must be escaped"
Write-Host $interpolation

$multiline = @"
still interpolatable`: '$($files[0].FullName)'
"@
Write-Host $multiline

$search = "Hello world" -like "*hello*"
Write-Host $search
