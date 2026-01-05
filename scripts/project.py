r'''
Author:         Chris Carl
Email:          chrisbcarl@outlook.com
Date:           2026-01-05
Description:
    Program that bootstraps projects. Usable as a "binary"

Example:
    project new -h (from anywhere if install.ps1 is used on the bootstrap project)

Updates:
    2026-01-05 04:13 - project - FEATURE: project-new
    2026-01-05 00:44 - project - initial commit

TODO:
    cpp types
    c types
'''

import os
import sys
import pprint
import shutil
import argparse
import datetime
import tempfile
import subprocess

PROG = os.path.splitext(__file__)[0]
SCRIPT_DIRPATH = os.path.abspath(os.path.dirname(__file__))
BOOTSTRAP_DIRPATH = os.path.abspath(os.path.join(SCRIPT_DIRPATH, '..'))
TEMPLATE_DIRPATH = os.path.join(BOOTSTRAP_DIRPATH, 'files', 'templates')
PROJECT_FILEPATHS = {
    'python': [
        os.path.join(BOOTSTRAP_DIRPATH, '.flake8'),
        os.path.join(BOOTSTRAP_DIRPATH, '.pylintrc'),
        os.path.join(BOOTSTRAP_DIRPATH, '.style.yapf'),
    ],
    'cpp': [
        (os.path.join(TEMPLATE_DIRPATH, '.vscode', 'tasks.json')),
        (os.path.join(TEMPLATE_DIRPATH, '.vscode', 'c_cpp_properties.json')),
    ],
    'c': [
        (os.path.join(TEMPLATE_DIRPATH, '.vscode', 'tasks.json')),
        (os.path.join(TEMPLATE_DIRPATH, '.vscode', 'c_cpp_properties.json')),
    ],
}
DEFAULT_PROJECT = list(PROJECT_FILEPATHS.keys())[0]
TEMPLATE_FILEPATH_KEYS = [
    (os.path.join(TEMPLATE_DIRPATH, 'CHANGELOG.md'), ['date']),
    (os.path.join(TEMPLATE_DIRPATH, 'LICENSE'), ['year']),
    (os.path.join(TEMPLATE_DIRPATH, 'README.md'), ['name', 'description']),
    (os.path.join(TEMPLATE_DIRPATH, 'TODO.md'), []),
]
COMMON_FILEPATH_KEYS = [
    os.path.join(BOOTSTRAP_DIRPATH, '.gitignore'),
    os.path.join(BOOTSTRAP_DIRPATH, '.vscode', 'settings.json'),
    os.path.join(BOOTSTRAP_DIRPATH, '.vscode', 'launch.json'),
]
DEFAULT_AUTHOR = 'Chris Carl <chrisbcarl@outlook.com>'

RESET = '\x1b[39m'
GREEN = '\x1b[32m'
YELLOW = '\x1b[33m'
CYAN = '\x1b[36m'
RED = '\x1b[31m'


def print_red(*args, **kwargs):
    print(f'{RED}{" ".join(str(arg) for arg in args)}{RESET}', **kwargs)


def print_green(*args, **kwargs):
    print(f'{GREEN}{" ".join(str(arg) for arg in args)}{RESET}', **kwargs)


def print_cyan(*args, **kwargs):
    print(f'{CYAN}{" ".join(str(arg) for arg in args)}{RESET}', **kwargs)


def print_yellow(*args, **kwargs):
    print(f'{YELLOW}{" ".join(str(arg) for arg in args)}{RESET}', **kwargs)


def run_commands(cmds, cwd=None):
    for c, cmd in enumerate(cmds):
        p = None
        fd, stdout = tempfile.mkstemp()
        os.close(fd)
        try:
            print_green(f'{c + 1}/{len(cmds)} - {subprocess.list2cmdline(cmd)}')
            with open(stdout, 'w', encoding='utf-8') as w:
                p = subprocess.Popen(cmd, cwd=cwd, stdout=w, stderr=w, universal_newlines=True)
                res = p.wait(timeout=60)  # NOTE: biber can actually take like 20 seconds or so
            if res != 0:
                with open(stdout, 'r', encoding='utf-8') as r:
                    print(r.read())
                print_red(f'{c + 1}/{len(cmds)} - ERROR: {subprocess.list2cmdline(cmd)}', file=sys.stderr)
                sys.exit(res)
        except subprocess.TimeoutExpired:
            if sys.platform == 'win32':
                subprocess.Popen(f'taskkill /f /PID {p.pid} /t ', shell=True).communicate()
            else:
                p.kill()
            with open(stdout, 'r', encoding='utf-8') as r:
                print(r.read())
            print_red(f'{c + 1}/{len(cmds)} - ERROR: {subprocess.list2cmdline(cmd)}', file=sys.stderr)
            sys.exit(2)
        finally:
            os.remove(stdout)


class NiceFormatter(argparse.ArgumentDefaultsHelpFormatter, argparse.RawDescriptionHelpFormatter):
    pass


if __name__ == '__main__':
    parser = argparse.ArgumentParser(prog=PROG, description=__doc__, formatter_class=NiceFormatter)

    subparser_root = parser.add_subparsers(help='which mode do you want?')
    parser.set_defaults(mode=None)

    new = subparser_root.add_parser('new', description='new', formatter_class=NiceFormatter)
    new.set_defaults(mode='new')
    group = new.add_argument_group('new specific')
    group.add_argument('name', type=str, help='name of the project')
    group.add_argument('--description', type=str, default='New project.', help='description of the project')
    group.add_argument('--type', type=str, default=DEFAULT_PROJECT, choices=PROJECT_FILEPATHS, help='type of the project')
    group.add_argument('--author', type=str, default=DEFAULT_AUTHOR, help='author of the project')
    group.add_argument('--path', type=str, default=os.path.abspath(os.getcwd()), help='destination where to put this new project')
    group.add_argument('--module-type', action='store_true', help='will this project be a module or package?')

    args = parser.parse_args()
    args.path = os.path.abspath(args.path)
    # pprint.pprint(vars(args))

    if args.mode == 'new':
        if args.type != 'python':
            raise NotImplementedError(f'project of type {args.type!r} not implemented!')

        print_green(args.mode, args.type)
        project_dirpath = os.path.join(args.path, args.name)

        if args.type == 'python':
            cmds = [
                ['poetry', 'new', args.name, '--src', '--name', args.name, '--author', args.author, '--license', 'MIT', '--readme', 'md'],
            ]
            run_commands(cmds, cwd=args.path)

            # if it is a package based
            pyproject_toml = os.path.join(args.path, args.name, 'pyproject.toml')
            with open(pyproject_toml, 'r', encoding='utf-8') as r:
                content = r.read()
                content = content.replace('dependencies = [', f'package-mode = {"true" if args.module_type else "false"}\ndependencies = [')

            cmds = [
                ['poetry', 'install'],
            ]
            run_commands(cmds, cwd=project_dirpath)

        now = datetime.datetime.now()
        data = dict(year=now.year, date=now.strftime('%Y-%m-%d'), name=args.name, description=args.description)
        for src, keys in TEMPLATE_FILEPATH_KEYS:
            dst = os.path.join(project_dirpath, os.path.basename(src))
            dirpath = os.path.dirname(dst)
            os.makedirs(dirpath, exist_ok=True)

            print_yellow(f'    "{src}" -> "{dst}"')
            with open(src, 'r', encoding='utf-8') as r, open(dst, 'w', encoding='utf-8') as w:
                template = r.read()
                template = template.format(**{key: data[key] for key in keys})
                w.write(template)

        for src in COMMON_FILEPATH_KEYS + PROJECT_FILEPATHS[args.type]:
            dst = os.path.relpath(src, BOOTSTRAP_DIRPATH)
            dst = os.path.join(project_dirpath, dst)
            dirpath = os.path.dirname(dst)
            os.makedirs(dirpath, exist_ok=True)

            print_yellow(f'    "{src}" -> "{dst}"')
            shutil.copy(src, dst)

    print_green("Done!")
    print("    Reminders:")
    print("        - chriscarl.python as a dev requirement to start generating cannonical files!")
