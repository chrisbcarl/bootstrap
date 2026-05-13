# last frame
New-Item -ItemType Directory "$PSScriptRoot/frames" -ErrorAction SilentlyContinue
Get-ChildItem -Path $PSScriptRoot -Filter "*.gif" | ForEach-Object {
    # https://stackoverflow.com/a/56214610
    # $last_frame_id = $(magick "$($_.FullName)[-1]" `
    #     -format "%[scene]" info:)
    # Write-Host $output
    $filename = [IO.Path]::GetFileNameWithoutExtension($_.Name)
    magick "$($_.FullName)[-1]" "$PSScriptRoot/frames/$filename.png"
}
