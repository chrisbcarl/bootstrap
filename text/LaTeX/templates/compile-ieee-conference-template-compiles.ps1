$cwd = Get-Location
Set-Location $PSScriptRoot

$name = "ieee-conference-template-compiles"

try {
    latexmk -C  # clean all aux files
    pdflatex $name
    bibtex $name
    pdflatex $name
    pdflatex $name
}
finally {
    Set-Location $cwd
}
