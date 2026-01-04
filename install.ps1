where.exe python | foreach-object {
    & $_ -m pip install --upgrade pip
    & $_ -m pip install poetry
}

poetry config virtualenvs.create true
poetry config virtualenvs.in-project true
poetry install
