print('regex')
body = '''
561-809-4387
(561) 809-4388
chrisbcarl@outlook.com
klausgcarl@gmail.com
The big brown fox jumps over the lazy dog
'''

import re

print('\n\n\nex) 1: getting a perfect match without a compiled object')
exact_match = re.search(r'over the lazy dog$', body)
exact_match_string = exact_match.group()
print(exact_match_string)

print('\n\n\nex) 2: using a "compiled" regex object')
PHONE_NUMBER_REGEX = re.compile(r'\(?\d\d\d\)? ?-?\d\d\d-? ?\d\d\d\d')
first_match_object = PHONE_NUMBER_REGEX.search(body)
first_match_string = first_match_object.group()
print(first_match_string)

print('\n\n\nex) 3: get all matches')
all_match_strings = PHONE_NUMBER_REGEX.finditer(body)
for match_object in all_match_strings:
    match_string = match_object.group()
    print(match_string)

print('\n\n\nex) 4: multi group regexes')
ROUGH_EMAIL_REGEX = re.compile(r'([0-9A-Za-z\.-]+)@([0-9A-Za-z\.-]+)')
all_match_strings = ROUGH_EMAIL_REGEX.finditer(body)
for match_object in all_match_strings:
    match_strings = match_object.groups()
    print(match_strings)

print('\n\n\nex) 5: named group regexes')
ROUGH_EMAIL_REGEX = re.compile(r'(?P<user>[0-9A-Za-z\.-]+)@(?P<domain>[0-9A-Za-z\.-]+)')
all_match_strings = ROUGH_EMAIL_REGEX.finditer(body)
for match_object in all_match_strings:
    match_dict = match_object.groupdict()
    user = match_dict['user']
    domain = match_dict['domain']
    print(user, domain)

print('\n\n\nex) 6: every exactly 3 digits')
for match_object in re.finditer(r'\d{3}', body):
    exactly_3 = match_object.group()
    print(exactly_3)

print('\n\n\nex) 6: at least 3 digits')
for match_object in re.finditer(r'\d{3,}', body):
    exactly_3 = match_object.group()
    print(exactly_3)

print('\n\n\nex) 7: replace groups')
result = re.sub(r"\(?(\d{3})\)?[ -]?(\d{3})-?(\d{4})", r"\1\2\3", body)
print(result)

# takes 2 regexes
print('\n\n\nex) 8: remove HTML tag attributes')  # <p _data-start="hello_world:0.0; 0.1-0.3,0.4">
html = '''<path fill-rule="evenodd" clip-rule="evenodd" d="M10.3333 2.08496C14.7046 2.08496 18.2483 5.62867 18.2483 10C18.2483 14.3713 14.7046 17.915 10.3333 17.915C5.96192 17.915 2.41821 14.3713 2.41821 10C2.41821 5.62867 5.96192 2.08496 10.3333 2.08496ZM10.3333 3.41504C6.69646 3.41504 3.74829 6.3632 3.74829 10C3.74829 13.6368 6.69646 16.585 10.3333 16.585C13.97 16.585 16.9182 13.6368 16.9182 10C16.9182 6.3632 13.97 3.41504 10.3333 3.41504Z"></path></svg></div></div><div class="w-full" style="margin-bottom: 0px;"><div class="w-full"><div class="text-token-text-primary text-[14px] leading-5">Thought for 9m 10s</div></div><div class="QKycbG_markdown text-token-text-secondary text-[14px] leading-5 markdown prose dark:prose-invert w-full break-words light markdown-new-styling"><p data-start="0" data-end="4" data-is-last-node="" data-is-only-node="">Done</p></div></div></div></div></div></div></section>'''
# regex = r'''( ?[A-Za-z\d_-]+=["'][A-Za-z\-_\.,\d\[\]\(\) ;:\/\/]*["'] ?)'''
# this one is simpler I think, and avoids href/src matching, or you could jigger it so it only finds href n src
regex = r'''\s*(?P<key>(?:(?!href|src)\b)[A-Za-z\d_-]+)\s*=\s*["'](?P<value>.*?)["']\s*'''
result = re.sub(regex, '', html)
print(result)

# ungreedy, capture quotations, *?
print('\n\n\nex) 8: remove HTML tag attributes')  # <p _data-start="hello_world:0.0; 0.1-0.3,0.4">
text = '''
Here we have a "quote" by a "great and respected author":
    "Bentham's panopticon is "totaly bad" and should be studied."
Honestly it's kind of strange how we keep getting suckered into reading about him.
Weird quote sticking out " without anybody to "capture" it--WARNING: WILL CAUSE PROBLEMS.
'''
result = re.sub(r'"(.*?)"', r"``\1''", text)
print(result)
