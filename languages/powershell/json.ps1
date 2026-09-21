# JSON C, not handled by PS 5.1
$content = Get-Content "$env:USERPROFILE\AppData\Roaming\Code\User\settings.json"
$content = $content -replace '.*(\/\*|\/\/).*', ''
Write-Host $content
$json = $content | ConvertFrom-JSON
