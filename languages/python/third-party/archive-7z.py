# pip install py7zr
import os
import py7zr
fn = 'C:/temp/archive.7z'
dirs = ['C:/temp', '/whatever']
pw = 'bigass-password-1234567890'
with py7zr.SevenZipFile(fn, 'w', password=pw) as archive:
    for d, directory in enumerate(dirs):
        tokens = directory.split(os.sep)
        basename = os.path.join(tokens[-2], tokens[-1])
        print(f'{(d + 1) / len(dirs) * 100:0.3f}%: {d + 1} / {len(dirs)} - "{directory}" - "{basename}"')
        archive.writeall(directory, basename)


