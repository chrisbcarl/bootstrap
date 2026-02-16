import hashlib

text = 'Hello World'
md5 = hashlib.md5(text.encode())
print(type(md5.hexdigest()), md5.hexdigest())
print(type(md5.digest()), md5.digest())
