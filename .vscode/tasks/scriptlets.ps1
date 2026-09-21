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
    "operating-systems\windows\terminal\settings.json"="$env:USERPROFILE\AppData\Local\Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState\settings.json";
}
$ignore_keys = @{
    ".vscode\settings.json"=@('python.defaultInterpreterPath');
    "operating-systems\windows\terminal\settings.json"=@('profiles');
}
# TODO: doesn't work with JSONC and powershell 5.1... UNTESTED
if ($PSVersionTable.PSVersion -gt 5.2) {
    foreach ($item in $pairs.GetEnumerator()) {
        $Key = $item.Key
        $Value = $item.Value
        git diff "$ProjectRoot\$Key" $Value | Out-Null
        if ($LASTEXITCODE -ne 0) {
            try {
                $mine = Get-Content "$ProjectRoot\$Key" | ConvertFrom-JSON
                $disk = Get-Content $Value | ConvertFrom-JSON

                foreach ($ignore_key in $ignore_keys) {
                    $mine.Remove($ignore_key)
                    $disk.Remove($ignore_key)
                }

                $mine_item = New-TemporaryFile
                Set-Content -Path $mine_item -Content ($mine | ConvertTo-JSON)
                $disk_item = New-TemporaryFile
                Set-Content -Path $disk_item -Content ($disk | ConvertTo-JSON)

            }
            catch {
                continue
            }

            git diff ($mine_item.FullName) ($disk_item.FullName) | Out-Null
            if ($LASTEXITCODE -ne 0) {
                Write-Warning "'$Key' needs updating!"
                code $Key
                code $Value
            }

            Remove-Item $mine_item
            Remove-Item $disk_item
        }
    }
}
