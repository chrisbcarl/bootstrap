r'''
Author:         Chris Carl
Email:          chrisbcarl@outlook.com
Date:           2026-01-05
Description:
    Program that bootstraps projects. Usable as a "binary"

Example:
    project new -h (from anywhere if install.ps1 is used on the bootstrap project)

Updates:
    2026-01-23 23:39 - project - project-new added external venv installation and no-git
    2026-01-19 00:37 - project - project-new uses correct pyproject.toml, made it a template
    2026-01-05 04:13 - project - FEATURE: project-new
    2026-01-05 00:44 - project - initial commit

TODO:
    cpp types
    c types
'''

import os
import sys
import re
import json
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
    (os.path.join(TEMPLATE_DIRPATH, 'README.md'), ['name', 'description', 'project_new_invocation']),
    (os.path.join(TEMPLATE_DIRPATH, 'TODO.md'), []),
]
COMMON_FILEPATH_KEYS = [
    os.path.join(BOOTSTRAP_DIRPATH, '.gitignore'),
    os.path.join(BOOTSTRAP_DIRPATH, '.vscode', 'settings.json'),
    os.path.join(BOOTSTRAP_DIRPATH, '.vscode', 'launch.json'),
]
DEFAULT_AUTHOR = 'Chris Carl <chrisbcarl@outlook.com>'
REGEX_AUTHOR = re.compile(r'(?P<first>[A-Z][a-z\-]*) (?P<last>[^<]+)\s<(?P<email>[0-9A-Za-z\.-]+@[0-9A-Za-z\.-]+)>')

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


def run_commands(cmds, cwd=None, env=None):
    for c, cmd in enumerate(cmds):
        pid = -1
        fd, stdout = tempfile.mkstemp()
        os.close(fd)
        try:
            print_green(f'{c + 1}/{len(cmds)} - {subprocess.list2cmdline(cmd)} @ {cwd}')
            with open(stdout, 'w', encoding='utf-8') as w:
                p = subprocess.Popen(cmd, cwd=cwd, stdout=w, stderr=w, universal_newlines=True, env=env)
                pid = p.pid
                res = p.wait(timeout=60)  # NOTE: biber can actually take like 20 seconds or so
            if res != 0:
                with open(stdout, 'r', encoding='utf-8') as r:
                    print(r.read())
                print_red(f'{c + 1}/{len(cmds)} - ERROR: {subprocess.list2cmdline(cmd)}', file=sys.stderr)
                sys.exit(res)
        except subprocess.TimeoutExpired:
            if sys.platform == 'win32':
                subprocess.Popen(f'taskkill /f /PID {pid} /t ', shell=True).communicate()
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
    group.add_argument('description', type=str, default='New project.', help='description of the project')
    group.add_argument('--type', type=str, default=DEFAULT_PROJECT, choices=PROJECT_FILEPATHS, help='type of the project')
    group.add_argument('--author', type=str, default=DEFAULT_AUTHOR, help='author of the project, must be of "First Last <email@domain.com>"')
    group.add_argument('--dirpath', type=str, default=os.path.abspath(os.getcwd()), help='destination where to put this new project')
    group.add_argument('--module-type', action='store_true', help='will this project be a module or package?')
    group.add_argument('--no-chriscarl', action='store_true', help=':(')
    group.add_argument('--no-in-project-venv', action='store_true', help='explicitly create a poetry config that installs the .venv outside the project area')
    group.add_argument('--no-git', action='store_true', help='skip git stuff')

    args = parser.parse_args()
    args.dirpath = os.path.abspath(os.path.expanduser(args.dirpath))
    if not REGEX_AUTHOR.match(args.author):
        raise ValueError(f'--author not of the form "First Last <email@domain.com>"!')

    # pprint.pprint(vars(args))

    if args.mode == 'new':
        if args.type != 'python':
            raise NotImplementedError(f'project of type {args.type!r} not implemented!')

        if os.environ.get('VIRTUAL_ENV'):
            raise RuntimeError('venv detected! deactivate otherwise things get screwy')

        chriscarl_python_proj = os.path.abspath(os.path.join(SCRIPT_DIRPATH, '../../chriscarl.python'))

        print_green(args.mode, args.type)
        project_dirpath = os.path.join(args.dirpath, args.name)
        os.makedirs(project_dirpath, exist_ok=True)

        if args.type == 'python':
            pyproject_toml_src = os.path.abspath(os.path.join(SCRIPT_DIRPATH, '../', 'files/templates/pyproject.toml'))
            pyproject_toml_dst = os.path.abspath(os.path.join(project_dirpath, 'pyproject.toml'))
            shutil.copy(pyproject_toml_src, pyproject_toml_dst)
            # cmds = [
            #     ['poetry', 'new', args.name, '--src', '--name', args.name, '--author', args.author, '--license', 'MIT', '--readme', 'md'],
            # ]
            # run_commands(cmds, cwd=args.dirpath)

            with open(pyproject_toml_dst, 'r', encoding='utf-8') as r:
                content = r.read()

            content = re.sub(r'^name = [^\n]+', f'name = "{args.name}"', content, flags=re.MULTILINE)  # so the ^ sticks
            content = re.sub(r'description = [^\n]+', f'description = "{args.description}"', content)
            authors_str_existing = 'authors = [{name = "Chris Carl", email = "chrisbcarl@outlook.com"}]'
            mo = REGEX_AUTHOR.match(args.author)
            if not mo:
                raise RuntimeError('this shouldnt happen by this point')
            groups = mo.groupdict()
            authors_str_new = 'authors = [{name = "%s", email = "%s"}]' % (f'{groups["first"]} {groups["last"]}', groups["email"])
            content = content.replace(authors_str_existing, authors_str_new)
            content = re.sub(r'changelog = [^\n]+', f'changelog = "https://github.com/chrisbcarl/{args.name}/blob/main/CHANGELOG.md"', content)
            content = re.sub(r'repository = [^\n]+', f'repository = "https://github.com/chrisbcarl/{args.name}"', content)
            if args.module_type:
                content = re.sub(r'package-mode = [^\n]+', 'package-mode = true', content)
            if args.no_chriscarl:
                content = content.replace('{include = "chriscarl", from = "src"}', '')
                content = content.replace('chriscarl = {develop = true, path="../chriscarl.python"}  # version = ">0.0.0"', '')
            else:
                replacement = 'chriscarl = {develop = true, path="%s"}  # version = ">0.0.0"' % os.path.relpath(chriscarl_python_proj, project_dirpath).replace('\\', '/')
                content = content.replace('chriscarl = {develop = true, path="../chriscarl.python"}  # version = ">0.0.0"', replacement)
            with open(pyproject_toml_dst, 'w', encoding='utf-8', newline='\n') as w:
                w.write(content)

            poetry_lock = os.path.abspath(os.path.join(project_dirpath, 'poetry.lock'))
            if os.path.isfile(poetry_lock):
                os.remove(poetry_lock)

            cmds = []
            if args.no_in_project_venv:
                cmds += [
                    ['poetry', 'config', 'virtualenvs.in-project', 'false', '--local'],
                ]
            cmds += [
                ['poetry', 'install', '--all-extras'],
                ['poetry', 'add', 'pytest-cov', '--group', 'dev'],
            ]
            run_commands(cmds, cwd=project_dirpath)


            if args.no_in_project_venv:
                venv_dirpath = subprocess.check_output('poetry env list --full-path', cwd=project_dirpath, universal_newlines=True).strip()
            else:
                venv_dirpath = os.path.join(project_dirpath, '.venv')

            venv_python_exe = os.path.join(venv_dirpath, 'scripts', 'python.exe')
            if not os.path.isfile(venv_python_exe):
                raise RuntimeError(f'.venv installed incorrectly?! "{venv_python_exe}" is not real?!')
            cmds = [
                [os.path.abspath(os.path.join(venv_dirpath, 'scripts/mypy.exe')), '--install-types', '--non-interactive'],
            ]
            if not args.no_chriscarl:
                if os.path.isdir(chriscarl_python_proj):
                    cmds += [
                        [os.path.abspath(os.path.join(venv_dirpath, 'scripts/stubgen.exe')), '-o', 'dist/typing/chriscarl', '--no-analysis', chriscarl_python_proj],
                    ]
            run_commands(cmds, cwd=project_dirpath)

        now = datetime.datetime.now()
        argv = ['project'] + sys.argv[1:]
        template_data = dict(year=now.year, date=now.strftime('%Y-%m-%d'), name=args.name, description=args.description, project_new_invocation=subprocess.list2cmdline(sys.argv))
        for src, keys in TEMPLATE_FILEPATH_KEYS:
            dst = os.path.join(project_dirpath, os.path.basename(src))
            dirpath = os.path.dirname(dst)
            os.makedirs(dirpath, exist_ok=True)

            print_yellow(f'    "{src}" -> "{dst}"')
            with open(src, 'r', encoding='utf-8') as r, open(dst, 'w', encoding='utf-8', newline='\n') as w:
                template = r.read()
                template = template.format(**{key: template_data[key] for key in keys})
                w.write(template)

        for src in COMMON_FILEPATH_KEYS + PROJECT_FILEPATHS[args.type]:
            dst = os.path.relpath(src, BOOTSTRAP_DIRPATH)
            dst = os.path.join(project_dirpath, dst)
            dirpath = os.path.dirname(dst)
            os.makedirs(dirpath, exist_ok=True)

            print_yellow(f'    "{src}" -> "{dst}"')
            shutil.copy(src, dst)


        print_green('post processing!')
        if args.type == 'python':
            print_green('    python specifics')
            if args.no_in_project_venv:
                print_green('        - vscode settings venv modify')
                venv_dirpath = subprocess.check_output('poetry env list --full-path', cwd=project_dirpath, universal_newlines=True).strip()
                venv_python_exe = os.path.join(venv_dirpath, 'scripts', 'python.exe')
                vscode_settings_filepath = os.path.join(project_dirpath, '.vscode', 'settings.json')
                with open(vscode_settings_filepath, 'r', encoding='utf-8') as r:
                    vscode_settings = r.read()
                vscode_settings = vscode_settings.replace(r'"${workspaceFolder}\\.venv\\scripts\\python.exe"', json.dumps(venv_python_exe))
                with open(vscode_settings_filepath, 'w', encoding='utf-8', newline='\n') as w:
                    w.write(vscode_settings)

        if args.no_git:
            print_yellow('skipping git!')
        else:
            cmds = [
                ['git', 'init'],
                ['git', 'add', '-A'],
                ['git', 'commit', '-m', 'initial commit'],
            ]
            run_commands(cmds, cwd=project_dirpath)

        subprocess.check_call(['code', project_dirpath], shell=True)

    print_green("Done!")
    reminders = [
        # 'chriscarl.python as a dev requirement to start generating cannonical files!',  # added as part of pyproject
    ]
    if reminders:
        print("    Reminders:")
        for reminder in reminders:
            print(f"        - {reminder}")
