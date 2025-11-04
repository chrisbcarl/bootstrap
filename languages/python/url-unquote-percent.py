from urllib.parse import urlparse, unquote, unquote_plus

urls = '''
http://www.bing.com/search?q=%s&filters=ex1%3a%22ez0%22&tbs=qdr
http://www.bing.com/search?q=%s&filters=ex1%3a%22ez1%22&tbs=qdr
http://www.bing.com/search?q=%s&filters=ex1%3a%22ez2%22&tbs=qdr
http://www.bing.com/search?q=%s&filters=ex1%3a%22ez3%22&tbs=qdr
'''
url = 'https://www.bing.com/news/search?q=sam+altman+stealing+art&qft=interval%3d%229%22&form=PTFTNR'
print(unquote_plus(url))
