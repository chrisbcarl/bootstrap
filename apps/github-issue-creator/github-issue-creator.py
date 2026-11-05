#!/usr/bin/env python
# -*- coding: utf-8 -*-
r'''
Author:         Chris Carl
Email:          chrisbcarl@outlook.com
Date:           2026-11-05
Description:

Comes from "gh extension install ntsk/gh-issue-bulk-create", so it uses that same ethos, but no. no i'm not gonna waste my time learning Go.

python "apps/github-issue-creator/github-issue-creator.py" `
    --template "./apps/github-issue-creator/issue-template.md" `
    --csv "./apps/github-issue-creator/issues.csv" `
    --repo "chrisbcarl/bootstrap" `
    --dry-run

```powershell
choco install gh -y
gh auth login  # skip ssh option
gh auth refresh -h github.com -s admin:public_key  # authorize auth to use ssh
gh ssh-key add --title "envy-fc0033dx" ~/.ssh/id_ed25519.pub
```

```log
? Where do you use GitHub? GitHub.com
! Did you know that expiring tokens can be requested with --expiring? Read more at https://gh.io/gh-expiring-tokens
? How would you like to authenticate GitHub CLI? Login with a web browser
? What is your preferred protocol for Git operations on this host? SSH
? Upload your SSH public key to your GitHub account? Skip

! One-time code (4309-5881) copied to clipboard
Press Enter to open https://github.com/login/device in your browser...
✓ Authentication complete.
- gh config set -h github.com git_protocol ssh
✓ Configured git protocol
✓ Logged in as chrisbcarl
```

Updates:
    2026-11-05 - github-issue-creator - initial commit
'''

import os
import sys
import csv
import shutil
import logging
import tempfile
import argparse
import subprocess
from collections import OrderedDict

LOGGER = logging.getLogger(__name__)
PROG = os.path.splitext(os.path.basename(__file__))[0]
SCRIPT_DIRPATH = os.path.dirname(__file__)
OPTIONS = [
    line.split(' ')[4][2:] for line in '''
$ gh issue create --title "I found a bug" --body "Nothing works"
$ gh issue create --body "Nothing works"
$ gh issue create --attach './login.png#The login error state'
$ gh issue create --attach ./before.png --attach ./after.png
$ gh issue create --label "bug,help wanted"
$ gh issue create --label bug --label "help wanted"
$ gh issue create --assignee monalisa,hubot
$ gh issue create --assignee "@me"
$ gh issue create --assignee "@copilot"
$ gh issue create --project "Roadmap"
$ gh issue create --template "Bug Report"
$ gh issue create --type Bug
$ gh issue create --parent 100
$ gh issue create --parent https://github.com/cli/go-gh/issues/42
$ gh issue create --blocked-by 200,201
$ gh issue create --blocking 300
$ gh issue create --milestone <name>
'''.splitlines() if line
]
OPTIONS = list(OrderedDict((option, None) for option in OPTIONS))
OPTIONS_REQUIRED = ['milestone', 'title', 'label', 'assignee']
DEFAULT_REPO = 'chrisbcarl/bootstrap'
DEFAULT_BODY_TEMPLATE_FILEPATH = os.path.join(SCRIPT_DIRPATH, '../.github/artifacts/issue-template.md')
TEMP_DIRPATH = '/temp' if sys.platform == 'win32' else '/tmp'


class NiceFormatter(argparse.ArgumentDefaultsHelpFormatter, argparse.RawDescriptionHelpFormatter):
    pass


def add_common_arguments(parser):
    group = parser.add_argument_group('gh')
    group.add_argument('--repo', type=str, default=DEFAULT_REPO, help='Select another repository using the [HOST/]OWNER/REPO format')
    for option in OPTIONS:
        group.add_argument(f'--{option}', type=str, nargs='*', help='if this is provided, it will override every entry in the csv with THIS value for THIS key')
    group.add_argument(
        '--body-template-filepath',
        type=str,
        default=DEFAULT_BODY_TEMPLATE_FILEPATH,
        help='Issue body template, templated by any keys in the csv headers, including the required ones.'
    )

    group = parser.add_argument_group('common')
    group.add_argument('--dry', '-d', action='store_true', help='dont actually run?')
    group.add_argument('--log-level', type=str, default='DEBUG', help='log level?')


def dict_to_cmd_args(dick, repo):
    cmd = ['gh', 'issue', 'create', '--repo', repo]
    for header in OPTIONS:
        value = dick.get(header, '')
        if value is not None and value != '':
            if isinstance(value, list):
                for k, v in zip([f'--{header}'] * len(value), value):
                    cmd += [k, v]
            else:
                cmd += [f'--{header}', value]
    return cmd


def main():
    parser = argparse.ArgumentParser(prog=PROG, description=__doc__, formatter_class=NiceFormatter)

    subparser_root = parser.add_subparsers(help='which mode do you want?')
    parser.set_defaults(mode=None)

    csv_mode = subparser_root.add_parser('csv', description='csv_mode', formatter_class=NiceFormatter)
    csv_mode.set_defaults(mode='csv')
    group = csv_mode.add_argument_group('csv mode specific')
    group.add_argument('filepath', type=str, help='required')
    add_common_arguments(csv_mode)

    single = subparser_root.add_parser('single', description='single', formatter_class=NiceFormatter)
    single.set_defaults(mode='single')
    group = single.add_argument_group('mode specific')
    add_common_arguments(single)

    add_common_arguments(parser)
    args = parser.parse_args()
    overrides = {}
    for header in OPTIONS:
        value = getattr(args, header.replace('-', '_'))
        if value is not None and value != '':
            overrides[header] = value

    logging.basicConfig(level=args.log_level, format="%(asctime)s - %(message)s")  # %(name)s - %(levelname)s -

    with open(args.body_template_filepath, 'r', encoding='utf-8') as r:
        template = r.read()

    with open(f'{TEMP_DIRPATH}/{PROG}', 'r+', encoding='utf-8') as rw:
        content = rw.read().strip()
        if os.path.isdir(content):
            dirpath = content
        else:
            dirpath = tempfile.mkdtemp()
            rw.write(dirpath)
    try:
        cmds = []
        if args.mode == 'csv':
            with open(args.filepath, 'r', encoding='utf-8') as r:
                reader = csv.DictReader(r)
                rows = list(reader)

            for r, row in enumerate(rows):
                row.update(overrides)
                if not (required in row for required in OPTIONS_REQUIRED):
                    LOGGER.error('"%s" does not have all required options enumerated! %s', args.filepath, OPTIONS_REQUIRED)
                    sys.exit(1)
                cmd = dict_to_cmd_args(row, args.repo)
                if 'body' not in row:
                    body_filepath = os.path.join(dirpath, f'{r}-body.md')
                    with open(body_filepath, 'w') as w:
                        w.write(template.format(**row))
                    cmd += [f'--body-file', body_filepath]
                cmds.append(cmd)
        else:
            cmd = dict_to_cmd_args(vars(args), args.repo)
            cmds.append(cmd)

        for cmd in cmds:
            LOGGER.info(subprocess.list2cmdline(cmd))
            if not args.dry:
                rc = subprocess.Popen(cmd).wait()
                if rc != 0:
                    sys.exit(rc)
    finally:
        if not args.dry:
            shutil.rmtree(dirpath)

    sys.exit(0)


if __name__ == '__main__':
    main()
