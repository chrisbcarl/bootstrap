# Namespace Projects

A folder that does not have `__init__.py` is a "namespace", a folder that has `__init__.py` is a "regular module". See [this](https://realpython.com/python-init-py/#what-happens-if-i-dont-add-an-__init__py-file) for more info.

Therefore, if you want to create a namespace project, the namespaces that are common CANNOT have `__init__.py` in those common folders in any project. See [this](https://github.com/python-poetry/poetry/issues/167#issuecomment-530895533) for an example.

```
library
├── .git
├── src
│   └── organization
│       ├── *MISSING __init__.py*
│       └── library
│           ├── *OPTIONAL __init__.py if this wont be extended*
│           ├── library_1
│           │   └── __init__.py
│           ├── library_2
│           │   └── __init__.py
│           └── library_3
│               └── __init__.py
└── pyproject.toml
```

```toml
[tool.poetry]
name = "library"
packages = [
  { include = "organization", from = "src" }
]
```



```
application_1
├── .git
├── src
│   └── organization
│       ├── *MISSING __init__.py*
│       └── application
│           ├── *MISSING __init__.py because this WILL be extended*
│           └── application_1
│               ├── __init__.py
│               └── __main__.py
└── pyproject.toml
```

```toml
[tool.poetry]
name = "application_1"
packages = [
  { include = "organization", from = "src" }
]
```


```
application_2
├── .git
├── src
│   └── organization
│       ├── *MISSING __init__.py*
│       └── application
│           ├── *MISSING __init__.py because this WILL be extended*
│           └── application_2
│               ├── __init__.py
│               └── __main__.py
└── pyproject.toml
```

```toml
[tool.poetry]
name = "application_2"
packages = [
  { include = "organization", from = "src" }
]
```
