[CmdletBinding()]
    param (
        [Parameter(Mandatory=$true)][string]$Path,
        [Parameter()][string]$Extension='.png'
    )

$images = Get-ChildItem -Path $Path -Filter "*$Extension" | Sort-Object | ForEach-Object {"$($_.FullName)"}

Write-Host -ForegroundColor Cyan "Merging $($images.Count) $Extension into 1 pdf..."

magick -density 300 `
    $images  `
    "$Path\output.pdf"

Write-Host -ForegroundColor Green "'$Path\output.pdf'"
