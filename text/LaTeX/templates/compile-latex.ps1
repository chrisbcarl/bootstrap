$cwd = Get-Location
Set-Location $PSScriptRoot

try {
    latexmk -C  # clean all aux files
    Remove-Item "LaTeX.bbl" -ErrorAction SilentlyContinue
    pdflatex LaTeX
}
finally {
    Set-Location $cwd
}
