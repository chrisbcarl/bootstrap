[CmdletBinding()]
param (
    [Parameter(Mandatory=$true)][string]$InputDirpath,
    [Parameter()][string]$OutputDirpath=$null,
    [Parameter()][string]$FileType="png",
    [Parameter()][string]$OutputPdfFilename="binder.pdf",
    [Parameter()][int]$Rotate=0,
    [Parameter()][switch]$Pdf,
    [Parameter()][switch]$Bw,
    [Parameter()][int]$BwThreshold=30
)

Get-Command magick -ErrorAction Stop | Out-Null

$InputDirpath = [IO.Path]::GetFullPath($InputDirpath)
if (-Not [string]::IsNullOrEmpty($OutputDirpath)) {
    $OutputDirpath = [IO.Path]::GetFullPath($OutputDirpath)
} else {
    $OutputDirpath = $InputDirpath
}


$filepaths = Get-ChildItem -Path $InputDirpath -Filter "*.$FileType" | ForEach-Object {$_.FullName}
if ($null -eq $filepaths) {
    Write-Warning "No filepaths detected on '$InputDirpath' over *.$FileType!"
    exit 1
}


New-Item -ItemType Directory -Path "$OutputDirpath/bw" -ErrorAction SilentlyContinue | Out-Null
$bwFilepaths = @()
foreach ($filepath in $filepaths) {
    $cmd = "magick '$filepath'"
    if ($Rotate -ne 0) {
        # https://unix.stackexchange.com/questions/92871/how-to-rotate-all-images-in-a-directory-with-imagemagick
        $cmd = "$cmd -rotate $Rotate"
    }
    if ($Bw) {
        # https://stackoverflow.com/a/65999445
        # $cmd = "$cmd -alpha off -auto-threshold otsu"
        # https://github.com/ImageMagick/ImageMagick/discussions/6282
        # $cmd = "$cmd -contrast-stretch 10x70%"
        # $cmd = "$cmd -level 40,90%"
        # https://gemini.google.com/app/0ebb599209aceacb
        #   gemini-3t@20260324: Create a magick command line invocation that converts each uploaded image into the *most* legible black and white render. Enumerate the steps evaluated to reach the final invocation.
        #   modified from threshold 10 to 30 and removed -negate
        $cmd = "$cmd -colorspace Gray -normalize -morphology TopHat:BlackHat `"disk:2`" -threshold $BwThreshold%"
        # https://chatgpt.com/g/g-p-69158412c608819183246f487e6363ca-misc/c/69c36c56-2b20-832e-b6b0-7509feaca872
        #   gpt-5.4ts@20260324
        #   modified from threshold 58 to 30
        #   kinda slow...
        # $cmd = "$cmd -auto-orient -colorspace Gray ``( +clone -blur 0x35 ``) -compose divide_src -composite -normalize -threshold $BwThreshold%"
    }
    $basename = [IO.Path]::GetFileName($filepath)
    if ($OutputDirpath -eq $InputDirpath) {
        $ext = [IO.Path]::GetExtension($basename)
        $name = [IO.Path]::GetFileNameWithoutExtension($basename)
        $basename = "$name-bw$ext"
    }
    $outputFilepath = [IO.Path]::GetFullPath("$OutputDirpath/bw/$basename")
    $bwFilepaths += @($outputFilepath)
    $cmd = "$cmd '$outputFilepath'"

    Write-Host -ForegroundColor Green $cmd
    Invoke-Expression $cmd
}

$cwd = Get-Location
try {
    Write-Host -ForegroundColor Green "cd '$($cwd.Path)'"
    Set-Location $OutputDirpath
    # https://askubuntu.com/questions/493584/convert-images-to-pdf
    $cmd = "magick $($bwFilepaths -Join " ") -quality 100 '$OutputPdfFilename'"

    Write-Host -ForegroundColor Green $cmd
    Invoke-Expression $cmd

    Write-Host -ForegroundColor Cyan "output at '$OutputPdfFilename'"
}
finally {
    Set-Location $cwd
}
