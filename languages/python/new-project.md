## Setup
This is from MY perspective, a retrospective history of how I started this whole thing.

### Windows
1. `poetry new chriscarl --src`
    - creates a pyproject.toml and file structure in the `src/module` packaging vein
    - add `packages` in `[tools.poetry]`
2. rename to chriscarl-python
3. add some files, little stuff
4. create virtualenv in-dir
    ```powershell
    # https://python-poetry.org/docs/configuration/#virtualenvscreate
    $env:POETRY_VIRTUALENVS_CREATE = 1
    $env:POETRY_VIRTUALENVS_IN_PROJECT = 1
    poetry install

    # more permanently
    poetry config virtualenvs.in-project true
    poetry install
    ```
5. activate the .venv by setting .vscode/settings.json `"python.defaultInterpreterPath": "${workspaceFolder}\\.venv\\scripts\\python.exe",`
6. install project in editable mode
7. `pip install -e .`

### WSL
```bash
apt update --fix-missing
apt upgrade -y
sudo apt install python3-pip -y
sudo apt install python3-venv -y
sudo apt install pipx -y
pipx ensurepath
pipx install poetry
poetry config virtualenvs.in-project true
mkdir ~/src/new-project
cd ~/src/new-project
poetry init --quiet
pipx inject poetry poetry-plugin-shell
poetry add Flask
poetry shell
```

# Additional Setup
1. configure `.vscode/settings.json`
    - set generic vscode settings
    - set the yapf formatter
    - set the default interpreter path
    - set the stub path
    - set the extra paths path
    - set the mypy type checker args
2. `mypy --install-types --non-interactive` install mypy types
3. change the toml and add `mypy` and `pytest` tool additions
