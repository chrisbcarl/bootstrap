import os
from PIL import Image  # pip install pillow
from PIL.ExifTags import TAGS

filepath = r''

filepaths = [
    r'X:\iphone\2026-02-21\Photos\IMG_2137.JPG',
    r'X:\iphone\2026-02-21\Photos\IMG_2081.JPG',
]

i, count = 0, 10
filepaths = []
for d, _, fs in os.walk(r'X:\iphone\2026-02-21\Photos'):
    for f in fs:
        filepath = os.path.join(d, f)
        filepaths.append(filepath)
        i += 1
        if i == count:
            break

for filepath in filepaths:
    image = Image.open(filepath)
    exif_data = image.getexif()
    print(filepath)
    for tag_id, value in exif_data.items():
        tag_name = TAGS.get(tag_id, tag_id)
        print(f"    {tag_name:25}: {value}")
