$i = 0
$first = ""
where.exe python | foreach {
    if ($i -eq 0) {$first = $_}
    & $_ -m pip install --upgrade pip
    & $_ -m pip install -r "$PSScriptRoot/requirements.txt"
    $i += 1
}

# media install like yt-dlp
& $_ -m pip install -r "$PSScriptRoot/requirements-media.txt"
