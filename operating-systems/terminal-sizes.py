import sys
import re
import subprocess


def get_terminal_dimensions():
    # https://stackoverflow.com/questions/263890/how-do-i-find-the-width-height-of-a-terminal-window
    if sys.platform == 'win32':
        output = subprocess.check_output('mode', shell=True, universal_newlines=True)
        # Lines:          36
        # Columns:        159...
        width_mo = re.search(r'columns:\s+(\d+)', output, flags=re.IGNORECASE)
        height_mo = re.search(r'lines:\s+(\d+)', output, flags=re.IGNORECASE)
        if not width_mo or not height_mo:
            raise RuntimeError()
        width = width_mo.groups()[0]
        height = height_mo.groups()[0]
    else:
        width = subprocess.check_output(['tput', 'cols'], universal_newlines=True)
        height = subprocess.check_output(['tput', 'lines'], universal_newlines=True)
    return (int(width), int(height))


print(get_terminal_dimensions())
