'''
Author:      Chris Carl
Date:        2024-11-11
Email:       chrisbcarl@outlook.com

Description:
    by default jupyter notebook autosaves, but that doesnt jive well with the fact that we're given reference materials
    i'd rather not modify the reference materials


Updated:
    2024-12-16 - chriscarl - juypiter.config-settings adding css container widening because why the fuck is it centered.
    2024-11-23 - chriscarl - juypiter.disable-autosave more prints and upsert
    2024-11-01 - chriscarl - juypiter.disable-autosave initial commit
'''
import os
import json
import argparse

SETTINGS = {
    "autosave": False,
    "autosaveInterval": 120,
}
# finding the actual root with:
#   jupyter --paths
#   jupyter --config-dir -> C:\Users\chris\.jupyter
# https://discourse.jupyter.org/t/configure-which-extension-opens-which-file-type/23932/2
# C:/Users/chris/.jupyter/lab/user-settings/@jupyterlab/docmanager-extension
CONFIG_FILEPATH = os.path.abspath(os.path.expanduser('~/.jupyter/lab/user-settings/@jupyterlab/docmanager-extension/plugin.jupyterlab-settings'))
CONFIG_DIRPATH = os.path.dirname(CONFIG_FILEPATH)
CSS_FILEPATH = os.path.abspath(os.path.expanduser('~/.jupyter/custom/custom.scss'))
CSS_TEXT = '''
/* https://stackoverflow.com/a/35342269
 * https://stackoverflow.com/questions/21971449/how-do-i-increase-the-cell-width-of-the-jupyter-ipython-notebook-in-my-browser
 * Make the notebook cells take almost all available width */

:root { --jp-notebook-max-width: 99% !important; }

.container {
    width: 99% !important;
}

/* Prevent the edit cell highlight box from getting clipped;
 * important so that it also works when cell is in edit mode */
div.cell.selected {
    border-left-width: 1px !important;
}
'''

if __name__ == '__main__':
    parser = argparse.ArgumentParser()
    parser.add_argument('--revert', action='store_true', help='by default we enable MY preferences')
    parser.add_argument('--interval', type=int, default=120, help='seconds between saving')

    args = parser.parse_args()

    css_dirpath = os.path.dirname(CSS_FILEPATH)
    if not os.path.isdir(css_dirpath):
        os.makedirs(css_dirpath)
    if not os.path.isfile(CSS_FILEPATH):
        with open(CSS_FILEPATH, 'w', encoding='utf-8') as w:
            w.write('')
    with open(CSS_FILEPATH, 'r', encoding='utf-8') as r:
        css_content = r.read()

    if not os.path.isdir(CONFIG_DIRPATH):
        os.makedirs(CONFIG_DIRPATH)
    if not os.path.isfile(CONFIG_FILEPATH):
        with open(CONFIG_FILEPATH, 'w', encoding='utf-8') as w:
            json.dump(SETTINGS, w, indent=4)
        settings = SETTINGS
    else:
        with open(CONFIG_FILEPATH, 'r', encoding='utf-8') as r:
            settings = json.load(r)

    if args.revert:
        settings.update({"autosave": True, "autosaveInterval": args.interval})
        print('settings reverted')
        if CSS_TEXT in css_content:
            with open(CSS_FILEPATH, 'w', encoding='utf-8') as w:
                w.write(css_content.replace(CSS_TEXT, ''))
            print('css reverted')
    else:
        settings.update({"autosave": False})
        print('settings enabled to my preferences')

        if CSS_TEXT not in css_content:
            print('css written to my preferences')
            with open(CSS_FILEPATH, 'w', encoding='utf-8') as w:
                w.write(f'{css_content}\n{CSS_TEXT}')

    with open(CONFIG_FILEPATH, 'w', encoding='utf-8') as w:
        json.dump(settings, w, indent=4)
    print(f'settings: "{CONFIG_FILEPATH}"\n', settings)
    with open(CSS_FILEPATH, 'r', encoding='utf-8') as r:
        css_content = r.read()
    print(f'css: "{CSS_FILEPATH}"\n', css_content)
