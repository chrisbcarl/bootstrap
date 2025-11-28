'''
Author:         Chris Carl
Email:          chrisbcarl@outlook.com
Date:           2025-11-25
Description:
    way to send this settings file to appdata just in case.
    Algo:
        copy bootstrap settings to user path
        read the bootstrap/settings.json by clearing out all of the comments
        read-replace-write any global-specific settings to the user path

Updates:
    2025-11-25 01:26 - user-settings-write - initial commit
'''
import os
import sys
import re
import json
import shutil

# C:\Users\chris\AppData\Roaming\Code\User\settings.json
if sys.platform == 'win32':
    user_settings_json = os.path.abspath(os.path.expanduser("~/AppData/Roaming/Code/User/settings.json"))
    user_keyboard_json = os.path.abspath(os.path.expanduser("~/AppData/Roaming/Code/User/keybindings.json"))
else:
    raise NotImplementedError(sys.platform)

bootstrap_settings_json = os.path.join(os.path.dirname(__file__), 'settings.json')
bootstrap_keybindings_json = os.path.join(os.path.dirname(__file__), 'settings.json')

# copy bootstrap settings to user path
print("copied to", shutil.copy2(bootstrap_settings_json, user_settings_json))
print("copied to", shutil.copy2(bootstrap_keybindings_json, bootstrap_settings_json))

# read the bootstrap/settings.json by clearing out all of the comments
print("modifying the user vscode settings after copy")
with open(bootstrap_settings_json, 'r', encoding='utf-8') as r:
    bootstrap_content = r.read()

# //
bootstrap_content = re.sub(r"//.*", "", bootstrap_content, flags=re.MULTILINE)
# /**/
# {"a": true,}
bootstrap_content = re.sub(r"/\*.*\*/", "", bootstrap_content, flags=re.MULTILINE)
bootstrap_content = re.sub(r",\s+\}", "}", bootstrap_content, flags=re.MULTILINE)
bootstrap_data = json.loads(bootstrap_content)
# print(json.dumps(data, indent=4))

# read-replace-write any global-specific settings to the user path
with open(user_settings_json, 'r', encoding='utf-8') as r:
    user_content = r.read()

keys_value_to_replace = [
    ('python.defaultInterpreterPath', os.path.abspath(sys.executable)),
]

for key, value in keys_value_to_replace:
    bootstrap_value = json.dumps(bootstrap_data[key])
    user_replace_value = json.dumps(value)
    print(f'    setting user setting "{key}" to "{user_replace_value}"')
    user_content = user_content.replace(bootstrap_value, user_replace_value)

# print(user_content)

with open(user_settings_json, 'w', encoding='utf-8') as w:
    w.write(user_content)
