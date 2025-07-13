# https://www.pythonrequests.com/python-requests-post-multipart-form-data/
# https://requests.readthedocs.io/en/latest/user/advanced/#post-multiple-multipart-encoded-files
import os
import requests

SCRIPT_DIRPATH = os.path.abspath(os.path.dirname(__file__))

url = 'http://localhost:5000/upload'
files = {'file': open(os.path.join(SCRIPT_DIRPATH, 'file.txt'), 'rb')}
data = {'name': 'hello', 'email': 'hello@world.com'}
response = requests.post(url, files=files, data=data)
print(response.status_code, response.text)
