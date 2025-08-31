import os
from urllib.request import urlretrieve
from urllib.parse import urlparse, unquote, unquote_plus

OUTPUT_DIRPATH = os.path.abspath(os.path.expanduser('~/downloads/X870E-P'))
os.makedirs(OUTPUT_DIRPATH, exist_ok=True)
URLS = '''
https://download.msi.com/dvr_exe/mb/amd_vga_driver_am5.zip
https://download.msi.com/dvr_exe/mb/realtek_audio_R.zip
https://download.msi.com/dvr_exe/mb/qualcomm_ncm865_bt.zip
https://download.msi.com/dvr_exe/mb/qualcomm_ncm865_wifi.zip
https://download.msi.com/dvr_exe/mb/AMD_RAID_Driver_am5.zip
https://download.msi.com/dvr_exe/mb/realtek_pcielan_w11.zip
'''

errors = []
for url in URLS.splitlines():
    if not url:
        continue
    url = unquote(url)
    basename = url.split('/')[-1]
    filepath = os.path.join(OUTPUT_DIRPATH, basename)
    if os.path.isfile(filepath):
        print(basename, 'exists at', filepath)
        continue
    print('downloading', basename, 'from', url, 'to', filepath)
    try:
        urlretrieve(url, filepath)
        print(f"{filepath}")
    except Exception:
        errors.append(url)

if errors:
    print('could not download from:')
    for error in errors:
        print(' ' * 3, error)
