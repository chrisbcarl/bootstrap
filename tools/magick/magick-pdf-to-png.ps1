[CmdletBinding()]
    param (
        [Parameter(Mandatory=$true)][string]$Path
    )

$png_dirpath = [IO.Path]::GetDirectoryName($Path)
$pngs = "$png_dirpath\pngs"
New-Item -ItemType Directory $pngs -ErrorAction SilentlyContinue
magick -density 300 `
    "$Path"  `
    "$pngs\output-%05d.png"
