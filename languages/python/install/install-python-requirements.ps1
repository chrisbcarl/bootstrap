try {
    $i = 0
    $first = ""
    where.exe python | foreach {
        if ($i -eq 0) {$first = $_}
        & $_ -m pip install --upgrade pip
        if ($LASTEXITCODE -ne 0) {
            throw "'$_' bad install of pip"
        }
        Write-Host -ForegroundColor Cyan "& $_ -m pip install -r `"$PSScriptRoot/requirements.txt`""
        & $_ -m pip install -r "$PSScriptRoot/requirements.txt"
        if ($LASTEXITCODE -ne 0) {
            throw "'$_' bad install of requirements"
        }
        $i += 1
    }

    Write-Host -ForegroundColor Cyan "& $first -m pip install -r `"$PSScriptRoot/requirements-media.txt`""
    & $first -m pip install -r "$PSScriptRoot/requirements-media.txt"
    if ($LASTEXITCODE -ne 0) {
        throw "'$first' bad install of requirements-media"
    }
}
catch {
    pause
    exit $LASTEXITCODE
}

exit 0

