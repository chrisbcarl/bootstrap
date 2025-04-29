- config
    ```toml
    [tools.poetry]package-mode = false  # if you're only using poetry for dep management, not package development
    ```
    ```jsonc
    // .vscode/settings.json
    {
        "python.defaultInterpreterPath": "${workspaceFolder}\\.venv\\scripts\\python.exe"
    }
    ```
- from scratch
    ```powershell
    $env:POETRY_VIRTUALENVS_CREATE = 1
    $env:POETRY_VIRTUALENVS_IN_PROJECT = 1
    poetry new directory --src  # creates a pypa project
    ```
- install requirements from a .txt
    ```powershell
    poetry add $(cat requirements.txt)
    rm requirements.txt
    ```
- install requirements to a specific group
    ```powershell
    poetry add flask  # its a project-wide dependency
    poetry add pylint yapf tox flake8 --group test  # only needed to "run tests"
    poetry add pyinstaller --group dev  # only needed to "do development"
    ```
- initialize an existing project
    ```powershell
    # given a new directory that you want to poetry-ize:
    cd directory
    poetry init

    # create a venv

    # option A: https://github.com/python-poetry/poetry/issues/5490#issuecomment-1312811998
    python -m venv .venv  # create a new venv ahead of poetry install

    # option B (preferred)
    $env:POETRY_VIRTUALENVS_CREATE = 1
    $env:POETRY_VIRTUALENVS_IN_PROJECT = 1
    poetry install
    ```
- misc cool funcs:
    ```powershell
    pipx inject poetry poetry-plugin-shell
    poetry shell  # invokes a new shell with the venv activated
    poetry run main.py  # invokes main.py with your venv
    poetry show --tree  # list deps in graph form
    ```
- update / upgrade
    ```powershell
    poetry update  # update the packages to the best of its ability
    ```
