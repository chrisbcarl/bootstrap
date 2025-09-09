'''
This doc gets printed as part of the description

Usage:
    python languages/python/argument-parsing.py -h
    python languages/python/argument-parsing.py mode1 -h
    python languages/python/argument-parsing.py --dry
    python languages/python/argument-parsing.py mode1 plz --dry
'''

import os
import pprint
import argparse

PROG = os.path.splitext(__file__)[0]
SCRIPT_DIRPATH = os.path.dirname(__file__)
PROJECTS_ROOT = os.path.join(SCRIPT_DIRPATH, 'projects')
DEFAULT_EXTENSION = '.cc'


class NiceFormatter(argparse.ArgumentDefaultsHelpFormatter, argparse.RawDescriptionHelpFormatter):
    pass


def add_common_arguments(parser):
    group = parser.add_argument_group('common')
    group.add_argument('--dry', '-d', action='store_true', help='dont actually run?')
    group.add_argument('--log-level', type=str, default='DEBUG', help='log level?')


parser = argparse.ArgumentParser(prog=PROG, description=__doc__, formatter_class=NiceFormatter)
add_common_arguments(parser)
subparser_root = parser.add_subparsers(help='which mode do you want?')
parser.set_defaults(mode=None)

mode1 = subparser_root.add_parser('mode1', description='mode1', formatter_class=NiceFormatter)
mode1.set_defaults(mode='mode1')
group = mode1.add_argument_group('mode specific')
group.add_argument('required', type=str, help='required')
group.add_argument('--optional', type=str, default='optional', help='optional')
add_common_arguments(mode1)

mode2 = subparser_root.add_parser('mode2', description='mode2', formatter_class=NiceFormatter)
mode2.set_defaults(mode='mode2')
group = mode2.add_argument_group('mode specific')
group.add_argument('required', type=str, help='required')
group.add_argument('--optional', type=str, default='optional', help='optional')
add_common_arguments(mode2)

args = parser.parse_args()
pprint.pprint(vars(args))
