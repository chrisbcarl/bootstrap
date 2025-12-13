import csv
import os
import py7zr
import json

# Everything > File > Export
with open(r'C:\temp\efu.efu') as r:
    reader = csv.DictReader(r)
    rows = list(reader)
paths = {}
for row in rows:
    Filename = row['Filename']
    tokens = os.path.dirname(Filename).split(os.sep)
    if len(tokens) > 3:
        basename = os.path.join(tokens[-4], tokens[-3], tokens[-2], tokens[-1])
    else:
        basename = os.path.join(tokens[-3], tokens[-2], tokens[-1])
    if basename not in paths:
        paths[basename] = []
    paths[basename].append(Filename)

fn = 'C:/temp/everything.7z'
pw = 'wav-files-found-via-everything'
errors = []
with py7zr.SevenZipFile(fn, 'w', password=pw) as archive:
    archive.writeall(r'C:\temp\efu.efu', 'manifest.efu')
    for d, tpl in enumerate(paths.items()):
        basedir, filepaths = tpl
        for filepath in filepaths:
            basename = os.path.join(basedir, os.path.basename(filepath))
            print(f'{(d + 1) / len(paths) * 100:0.3f}%: {d + 1} / {len(paths)} - "{filepath}" - "{basename}"')
            try:
                archive.writeall(filepath, basename)
            except Exception as ex:
                errors.append({'filepath': filepath, 'exception': str(ex), 'basename': basename})
    print(f'{len(errors)} errors')
    with open('/temp/errors.json', 'w', encoding='utf-8') as w:
        json.dump(errors, w, indent=4)
    archive.writeall('/temp/errors.json', 'errors.json')
os.remove('/temp/errors.json')