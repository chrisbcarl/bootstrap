import argparse
import io


class fmter(argparse.RawDescriptionHelpFormatter, argparse.ArgumentDefaultsHelpFormatter):
    pass


PROG = 'getopt'

USAGE = f'''
    How to use getopt.h


Examples:
    $ {PROG} -d -n 5
'''

parser = argparse.ArgumentParser(prog=PROG, description=USAGE, formatter_class=fmter)
required = parser.add_argument_group('required')

optional = parser.add_argument_group('optional')
optional.add_argument('-n', default=0, help='N?')
optional.add_argument('-d', '--debug', help='add debug messages?')

# args = parser.parse_args()

sb = io.StringIO()
parser.print_help(sb)
lines = sb.getvalue().replace('"', '\\"').splitlines()
print(f'const char* PROG = "{PROG}";')
print('const char* USAGE = "\\')
print('\n'.join(f'{line}\\n\\' for line in lines))
print('";')
