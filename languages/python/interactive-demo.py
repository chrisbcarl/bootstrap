import sys


def func():
    a = 1
    globals().update(locals())
    sys.exit(1)  # "breakpoint"
    # at this point, type a. you will get a 1


func()
