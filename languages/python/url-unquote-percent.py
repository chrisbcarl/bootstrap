from urllib.parse import urlparse, unquote, unquote_plus

urls = '''
http://www.bing.com/search?q=%s&filters=ex1%3a%22ez0%22&tbs=qdr
http://www.bing.com/search?q=%s&filters=ex1%3a%22ez1%22&tbs=qdr
http://www.bing.com/search?q=%s&filters=ex1%3a%22ez2%22&tbs=qdr
http://www.bing.com/search?q=%s&filters=ex1%3a%22ez3%22&tbs=qdr
https://sjsu.campusconcourse.com/view_syllabus?course_id%3D66294%26set_redirect_target%3D1&source=gmail-imap&ust=1765241976000000&usg=AOvVaw3aeuxnGKNWM58gp6pDRKLT
'''
url = 'https://www.bing.com/news/search?q=sam+altman+stealing+art&qft=interval%3d%229%22&form=PTFTNR'
print(unquote_plus(url))
for url in urls.splitlines():
    if url:
        print(unquote_plus(url))
