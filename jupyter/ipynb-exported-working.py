#!/usr/bin/env python
# coding: utf-8

# # IPython Notebook
# the actual data structure of an ipynb is just... json.
#
# ## Metadata
# <div style="display: inline-block">
# <!-- get the table rendered to the left rather than default center, the spaces after the raw html are important for markdown https://stackoverflow.com/a/78525025 -->
#
# | Key | Value |
# | :--- | :--- |
# | author | [Chris Carl](mailto:chrisbcarl@outlook.com) |
# | date | 2025-12-20 |
# | dataset | na.csv © 2024 Chris Carl |
# | url | https://chriscarl.com |
#
# <!-- get the table rendered to the left rather than default center, the spaces after the raw html are important for markdown https://stackoverflow.com/a/78525025 -->
# </div>
#
# ## Changelog
# - 2025-01-24 - jupyter.ipynb.ipynb - FEATURE: ipynb-matplotlib-widgets
# - 2024-12-20 - jupyter.ipynb.ipynb - initial commit
#
# ## TOC (Raw HTML Anchors)
# * [Setup](#Setup)
# * [IPython Notebooks are Just JSON](#just-json)
# * [VS Code Shortcuts](#shortcuts)
# * [Input/Output Widgets](#input-output-widgets)
# * [Useful Magics](#useful-magics)
#
# ## LaTeX
# $LaTeX$ support available

# # Setup <a id="Setup"></a>

# stdlib imports
import __main__
import os
import sys
import pprint
import importlib
import subprocess
from IPython import get_ipython

SCRIPT_FILEPATH = ''
SCRIPT_FILENAME = ''
# None if running in vanilla python, usual export just litters get_ipython() everywhere, so for the diff's sake, I leave it. You could replace it with the variable name.
IPYTHON_SHELL = get_ipython()
if IPYTHON_SHELL:
    SCRIPT_DIRPATH = IPYTHON_SHELL.run_line_magic('pwd', ' # %pwd is a "magic" command  https://ipython.readthedocs.io/en/stable/interactive/magics.html')
    if hasattr(__main__, '__vsc_ipynb_file__'):  # vscode
        SCRIPT_FILEPATH = __main__.__vsc_ipynb_file__
    elif hasattr(__main__, '__session__'):  # localhost:8888/notebooks
        SCRIPT_FILEPATH = __main__.__session__
else:
    SCRIPT_FILEPATH = __file__
    SCRIPT_DIRPATH = os.path.dirname(SCRIPT_FILEPATH)

SCRIPT_FILENAME = os.path.splitext(os.path.basename(SCRIPT_FILEPATH))[0]

pprint.pprint(dict(dir=SCRIPT_DIRPATH, fp=SCRIPT_FILEPATH, fn=SCRIPT_FILENAME), indent=2)

packages = {'Werkzeug': 'werkzeug'}  # package name: module name
modules = ['pandas', 'numpy', 'seaborn', 'ipympl', 'ipywidgets']  # , 'paramiko', 'requests'
packages.update({m: m for m in modules})
package, module = '', ''
install_string = ' '.join(packages)
print('this ipynb uses the following packages:', install_string)
try:
    for package, module in packages.items():
        importlib.import_module(module)
except ImportError:
    print(f'executing "pip install {package}"', file=sys.stderr)
    if get_ipython():
        get_ipython().run_line_magic('pip', 'install {install_string}')
    else:
        subprocess.check_call(f'pip install {install_string}', stdout=sys.stdout, stderr=sys.stderr, stdin=sys.stdin)

# third imports
from IPython.display import display
import ipywidgets as widgets

import pandas as pd
import numpy as np
import matplotlib.pyplot as plt
import seaborn as sns

np.set_printoptions(precision=4, edgeitems=2, linewidth=9999)  # threshold=4,

pd.set_option('display.precision', 4)
pd.set_option('display.width', None)
pd.set_option('display.max_colwidth', None)
pd.set_option('display.max_rows', 5)  # .describe has 9
pd.set_option('display.max_columns', None)
pd.set_option('display.expand_frame_repr', False)  # prevents wrapping when colwidth exceeds width

with pd.option_context('display.max_rows', None, 'display.max_columns', None):
    pass

if IPYTHON_SHELL:
    # if sys.platform == 'win32':
    #     res = IPYTHON_SHELL.getoutput('where.exe latex')
    #     latex_exists = res[0].startswith('INFO')
    # else:
    #     res = IPYTHON_SHELL.getoutput('which latex')
    #     latex_exists = bool(res)
    if sys.platform == 'win32':
        res = get_ipython().getoutput('where.exe latex')
        latex_exists = res[0].startswith('INFO')
    else:
        res = get_ipython().getoutput('which latex')
        latex_exists = bool(res)
else:
    if sys.platform == 'win32':
        res = subprocess.check_output('where.exe latex', universal_newlines=True)
        print(res)
        latex_exists = res.startswith('INFO')
    else:
        res = subprocess.check_output('which latex', universal_newlines=True)
        latex_exists = bool(res)

plt.rcParams.update({'text.usetex': latex_exists})  # , 'font.family': 'Helvetica'  # requires latex installed

# command to tell the notebook to plt.show() IN THE NOTEBOOK, otherwise you call plt.show()
if IPYTHON_SHELL:
    get_ipython().run_line_magic('matplotlib', 'inline')
# command to tell the notebook to render interactable matplotlib, requires pip install ipympl
# FEATURE: ipynb-matplotlib-widgets
# this is only really usefull when doing ipynb + 3d. otherwise, eh
# %matplotlib widget

5
# normally the 5 would be printed, adding ; disables the print

# keyboard shortcuts
# 1. Shift + Enter - exec current cell
# 2. Ctrl + Enter - exec the current cell and stay
# 3. Enter - edit mode
# 4. Y - change cell type to code
# 5. M - change the cell type to markdown
# 6. A - insert above current
# 7. B - insert below current

# # IPython Notebooks are Just JSON <a id="just-json"></a>

import json
if IPYTHON_SHELL:
    with open(SCRIPT_FILEPATH, 'r', encoding='utf-8') as r:
        body = json.load(r)
        print(json.dumps(body['cells'][0], indent=2))
        print(json.dumps(body['cells'][1], indent=2))
else:
    print('WARNING: NOT RUNNING AN IPYNB, THIS FILE IS NOT A JSON')
    with open(SCRIPT_FILEPATH, 'r', encoding='utf-8') as r:
        body = r.read()
        print(print(repr(body[50:150])))

# # VS Code Keyboard Shortcuts <a id="shortcuts"></a>
# [VS Code Keyboard Shortcuts](https://blog.chaitanyashahare.com/posts/vscode-jupyter-notebooks-keyboard-shortcuts/)
# 1. Shift + Enter - exec current cell
# 2. Ctrl + Enter - exec the current cell and stay
# 3. Enter - edit mode
# 4. Y - change cell type to code
# 5. M - change the cell type to markdown
# 6. A - insert above current
# 7. B - insert below current
#

# # Pandas / Numpy
#

display(np.arange(1000))  # will display everything thanks to settings

array = np.arange(27).reshape((3, 3, 3))
array

import string

df = pd.DataFrame([{k: v for k, v in zip(string.ascii_lowercase, np.arange(len(string.ascii_lowercase)))}] * 10)

# display explicitly with non-default behavior
with pd.option_context('display.max_rows', None, 'display.max_columns', None):
    display(df)

# display with default behavior
df

# # Matplotlib

# Fixing random state for reproducibility
np.random.seed(19680801)


def randrange(n, vmin, vmax):
    """
    Helper function to make an array of random numbers having shape (n, )
    with each number distributed Uniform(vmin, vmax).
    """
    return (vmax - vmin) * np.random.rand(n) + vmin


fig = plt.figure()
ax = fig.add_subplot(projection='3d')

n = 100

# For each set of style and range settings, plot n random points in the box
# defined by x in [23, 32], y in [0, 100], z in [zlow, zhigh].
for m, zlow, zhigh in [('o', -50, -5), ('^', 50, 5)]:
    xs = randrange(n, 23, 32)
    ys = randrange(n, 0, 100)
    zs = randrange(n, zlow, zhigh)
    ax.scatter(xs, ys, zs, marker=m)

xx, yy = np.meshgrid(np.linspace(23, 32, 10), np.linspace(0, 100, 10))
a, b, c = -50, 1, 1
zz = a + b * xx + c * yy
ax.plot_surface(xx, yy, zz, color='blue', alpha=0.5)  # 2d plane

ax.set_xlabel('X Label')
ax.set_ylabel('Y Label')
ax.set_zlabel('Z Label')
plt.show()

# # Input/Output Widgets <a id="input-output-widgets"></a>
#

print('enter some values!')

wgs = []

int_slider = widgets.IntSlider(
    value=69, min=0, max=100, step=1, description='int values', disabled=False, continuous_update=False, orientation='horizontal', readout=True, readout_format='d'
)
wgs.append(int_slider)

float_slider = widgets.FloatSlider(
    value=69,
    min=0,
    max=100,
    step=0.01,
    description='float values',
    disabled=False,
    continuous_update=False,
    orientation='horizontal',
    readout=True,
    readout_format='.2f',
)
wgs.append(float_slider)

text_box = widgets.Text(value='', placeholder='Type something', description='Whatever you like', disabled=False)
wgs.append(text_box)

for widget in wgs:
    display(widget)


def print_widget_values(x):
    print(x)
    for w, widget in enumerate(wgs):
        print(w, widget.value)


button = widgets.Button(
    description='Click me!',
    disabled=False,
    button_style='',  # 'success', 'info', 'warning', 'danger' or ''
    tooltip='Change the values with the sliders to try things out!',
    icon='check'  # (FontAwesome names without the `fa-` prefix)
)
display(button)
button.on_click(print_widget_values)

# # Useful Magics <a id="useful-magics"></a>
#

if IPYTHON_SHELL:
    get_ipython().run_cell_magic(
        'time', '',
        "# %%time has to be at the top of the cell, works like a context manager\n\n# change cli arguments with variables\nprint_me = 'ipynb'\n\n# run shell commands like installing packages and other wild stuff\nstdout = !echo hello {print_me}\nprint(stdout)\n\n# jupyter nb commands\n!jupyter nbconvert --to html --template lab {SCRIPT_FILEPATH}\n!jupyter nbconvert --to python --no-prompt {SCRIPT_FILEPATH}\n# # the following line would cause infinite recursion lol\n# !jupyter nbconvert --execute --to notebook --inplace {SCRIPT_FILEPATH}\n\n# !pip install matplotlib\n"
    )

if IPYTHON_SHELL:
    get_ipython().run_cell_magic('writefile', "{os.path.join(SCRIPT_DIRPATH, 'ipynb-magics.txt')}", '# %%writefile must be at the top of the cell, cannot be mixed with %%time\n')
