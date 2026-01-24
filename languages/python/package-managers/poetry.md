- install
    typically suggets `pipx`, i find that cumbersome because then you need to install `scoop` so that's 2 extra dependencies to get to the one I give a damn about
    ```powershell
    where.exe python | foreach {
        & $_ -m pip install --upgrade pip
        & $_ -m pip install poetry
    }
    ```
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
    poetry config virtualenvs.create true
    # poetry config virtualenvs.create --unset
    poetry config virtualenvs.in-project true
    # poetry config virtualenvs.in-project --unset
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
    poetry config virtualenvs.create true
    # poetry config virtualenvs.create --unset
    poetry config virtualenvs.in-project true
    # poetry config virtualenvs.in-project --unset
    poetry install
    ```
- use the default functionality:
    ```powershell
    poetry install  # WITHOUT configuring in-project, creates a new env SOMEWHERE
    poetry env list --full-path  # this contains the associated created environment WHEREVER that is
    & "$(poetry env list --full-path)/scripts/activate.ps1"
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
- pytorch, some special stuff
    ```powershell
    # https://stackoverflow.com/a/76359919
    poetry remove torch torchvision torchaudio  # remove if you've already got it installed

    # https://python-poetry.org/docs/repositories/#supplemental-package-sources
    poetry source add --priority explicit pytorch-cu128 https://download.pytorch.org/whl/cu128  # similar to --index-url in pip
    poetry add --source pytorch-cu128 torch torchvision torchaudio  # actually install
    ```
- delete environment
    ```powershell
    poetry env list --full-path
    poetry env remove /full/path/to/python python3.7 3.7 test-O3eWbxRl-py3.7 etc
    # Access denied
    poetry env remove --all
    ```

# Need to Reinstall a Development Package?
```bash
pip uninstall development-package -y
poetry install
```


# Need to add a development package?
```bash
poetry add --editable /pth
```
