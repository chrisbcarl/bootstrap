# python interactive mode
python start interactive mode
python launch interactive mode from script
interactive mid-script
```python
def func():
    a = 1
    globals().update(locals())
    sys.exit(1)  # "breakpoint"

func()
```
```bash
python -i src\chriscarl\tools\house.py browse --log-level DEBUG
```