$cwd = Get-Location
Set-Location $PSScriptRoot

try {
    # not trolling, you need to run pdflatex FOUR TIMES...
    # pdflatex ieee-conference-template-compiles.tex
    # https://www.overleaf.com/learn/latex/Bibliography_management_with_bibtex
    latexmk -C  # clean all aux files
    Remove-Item "BibTeX.bbl" -ErrorAction SilentlyContinue
    Write-Host -ForegroundColor Green "1st latex"
    pdflatex BibTeX
    Write-Host -ForegroundColor Green "bibtex"
    bibtex BibTeX
    Write-Host -ForegroundColor Green "2nd latex"
    pdflatex BibTeX
    Write-Host -ForegroundColor Green "3rd latex"
    pdflatex BibTeX
}
finally {
    Set-Location $cwd
}
