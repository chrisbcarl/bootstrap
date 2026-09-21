$ProjectRoot = "$PSScriptRoot\..\.."

# if there is a poetry env to invoke
$poetry_env_list=$(poetry env list)
& "$env:LOCALAPPDATA/pypoetry/Cache/virtualenvs/$poetry_env_list/Scripts/Activate.ps1"
$open_me = @(
    "..\..\TODO.md"
)

$open_me | ForEach-Object {
    Write-Host -ForegroundColor Green "code '$_'..."
    code "$PSScriptRoot\$_"
}

$pairs = @{
    ".vscode\settings.json"="$env:USERPROFILE\AppData\Roaming\Code\User\settings.json";
    "operating-systems\windows\terminal\settings.json"="$env:USERPROFILE\AppData\Local\Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState\settings.json"
}
foreach ($item in $pairs.GetEnumerator()) {
    $Key = $item.Key
    $Value = $item.Value
    git diff "$ProjectRoot\$Key" $Value | Out-Null
    if ($LASTEXITCODE -ne 0) {
        Write-Warning "'$Key' needs updating!"
        code $Key
        code $Value
    }
}
