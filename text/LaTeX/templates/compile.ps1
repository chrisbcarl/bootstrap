$cwd = Get-Location
Set-Location $PSScriptRoot

try {
    # pdflatex ieee-conference-template-compiles.tex
    # https://www.overleaf.com/learn/latex/Bibliography_management_with_bibtex
    latexmk -C  # clean all aux files
    Remove-Item "LaTeX.bbl" -ErrorAction SilentlyContinue
    Write-Host -ForegroundColor Green "1st latex"
    pdflatex LaTeX
    Write-Host -ForegroundColor Green "bibtex"
    bibtex LaTeX
    Write-Host -ForegroundColor Green "2nd latex"
    pdflatex LaTeX
    Write-Host -ForegroundColor Green "3rd latex"
    pdflatex LaTeX
}
finally {
    Set-Location $cwd
}
