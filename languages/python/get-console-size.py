#import curses
#from curses.textpad import Textbox, rectangle

# def main(stdscr):
#     stdscr.addstr(0, 0, "Enter IM message: (hit Ctrl-G to send)")

#     editwin = curses.newwin(5,30, 2,1)
#     rectangle(stdscr, 1,0, 1+5+1, 1+30+1)
#     stdscr.refresh()

#     box = Textbox(editwin)

#     # Let the user edit until Ctrl-G is struck.
#     box.edit()

#     # Get resulting contents
#     message = box.gather()

import random
import string
import sys
from shutil import get_terminal_size
    
def func():
    columns = -1
    rows = -1
    terminal_size = get_terminal_size(fallback=(columns, rows))
    return terminal_size.columns, terminal_size.lines

def fill_rand(length, width):
    buffer = []
    c = ' '
    for i in range(0, length):
        for j in range(0, width):
            c = random.choice("01")
            buffer.append(c)
    return "".join(buffer)

if __name__ == "__main__":
    while True:
        try:
            cols, lins = func()
            buffer = fill_rand(cols, lins)
            sys.stdout.write(buffer)
            sys.stdout.flush()
        except KeyboardInterrupt:
            break