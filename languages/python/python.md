# python interactive mode
python start interactive mode
python launch interactive mode from script
interactive mid-script
```python
# interactive-demo.py
import sys


def func():
    a = 1
    globals().update(locals())
    sys.exit(1)  # "breakpoint"
    # at this point, type a. you will get a 1


func()

```
```bash
python -i languages/python/interactive-demo.py --log-level DEBUG
```