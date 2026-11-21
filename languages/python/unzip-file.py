# AI Disclosure:
# https://www.bing.com/search?q=python%20cookbook%20unzip&qs=n&form=QBRE&sp=-1&ghc=1&lq=0&pq=python%20cookbookunzip&sc=0-20&sk=&cvid=2795D386C9DE44E3B966E744918FD4D3
# 2026-03-08

import zipfile
import os


def unzip_file(zip_path, extract_to, password=None, print_progress=True):
    if not os.path.isfile(zip_path):
        raise FileNotFoundError(f"ZIP file not found: {zip_path}")
    os.makedirs(extract_to, exist_ok=True)
    try:
        with zipfile.ZipFile(zip_path, 'r') as zip_ref:
            pwd = password.encode() if password else None
            for member in zip_ref.infolist():
                # Prevent Zip Slip vulnerability
                extracted_path = os.path.join(extract_to, member.filename)
                if member.filename.startswith('__MACOSX/._') or member.filename.split('/')[-1].startswith('._'):
                    continue

                if not os.path.realpath(extracted_path).startswith(os.path.realpath(extract_to)):
                    raise Exception(f"Unsafe file path detected: {member.filename}")

                if print_progress:
                    print(member)
                if not os.path.exists(extracted_path):
                    zip_ref.extract(member, path=extract_to, pwd=pwd)

                basename, ext = os.path.splitext(member.filename)

                if ext == '.zip':
                    unzip_file(
                        os.path.join(extract_to, member.filename), os.path.join(extract_to, member.filename[-len(basename)]), password=password, print_progress=print_progress
                    )
    except zipfile.BadZipFile:
        raise zipfile.BadZipFile(f"Invalid ZIP file: {zip_path}")
    except RuntimeError as e:
        if "password required" in str(e).lower():
            raise RuntimeError("This ZIP file is password-protected. Please provide a valid password.")
        else:
            raise


unzip_file(r'languages\python\python.isazip', '/temp/isazip')
