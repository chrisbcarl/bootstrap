import requests
import shutil

USER_AGENT = 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36 Edg/143.0.0.0'

def download(url, filepath):
    # https://stackoverflow.com/a/13137873
    # use a user-agent so that you can download from some places like wikipedia. they reject all python agents instantly...
    with requests.get(url, stream=True, headers={'user-agent': USER_AGENT}) as request, open(filepath, 'wb') as wb:
        # request.raw.decode_content = True
        shutil.copyfileobj(request.raw, wb)