'''
Author:         Chris Carl
Email:          chrisbcarl@outlook.com
Date:           2026-01-05
Description:
    Terminal settings

Updates:
    2026-01-05 01:26 - terminal-user-settings-write - initial commit
'''
import os
import sys
import json

# ~/AppData/Local/Packages/Microsoft.WindowsTerminal_8wekyb3d8bbwe/LocalState/settings.json
if sys.platform == 'win32':
    user_settings_json = os.path.abspath(os.path.expanduser("~/AppData/Local/Packages/Microsoft.WindowsTerminal_8wekyb3d8bbwe/LocalState/settings.json"))
else:
    raise NotImplementedError(sys.platform)

# read the bootstrap/settings.json by clearing out all of the comments
print("modifying the terminal user settings after copy")
with open(user_settings_json, 'r', encoding='utf-8') as r:
    user_settings = json.load(r)

keys_value_to_replace = {
    'warning.confirmCloseAllTabs': False,
    'warning.largePaste': False,
    'warning.multiLinePaste': False,
}

user_settings.update(keys_value_to_replace)

with open(user_settings_json, 'w', encoding='utf-8') as w:
    json.dump(user_settings, w, indent=4)
