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
# non-capturing group example
result = re.sub(r'''\s*(?P<key>(?:(?!href|src)\b)[A-Za-z\d_-]+)\s*=\s*["'](?P<value>.*?)["']\s*''', '', html)
print(result)

# ungreedy, capture quotations, *?
print('\n\n\nex) 9: ungreedy, capture quotations, *?')
text = '''
Here we have a "quote" by a "great and respected author":
    "Bentham's panopticon is "totaly bad" and should be studied."
Honestly it's kind of strange how we keep getting suckered into reading about him.
Weird quote sticking out " without anybody to "capture" it--WARNING: WILL CAUSE PROBLEMS.
'''
result = re.sub(r'"(.*?)"', r"``\1''", text)
print(result)

# avoiding lookahead, find comma separated values in a markdown table
print('\n\n\nex) 10: avoid positive lookahead')
text = '''| Data is its effects | culture, revenue, corporate culture | policies, methodologies, corporate goals | --- |'''
result = re.sub(r'\| *([^\|]*?,[^\|]+) *\b', r'| \g<1>...', text)
print(result)

print('\n\n\nex) 11: unicode')
text = ''' −​–'''
result = re.sub(r'[^\x00-\x7F]+', r'', text)
print(f'{result!r}')

print('\n\nex) 12: repeating groups, like HTML list')
text = '''
# this definitley is
- Personal Organization: Grocery lists, to-do lists, and packing lists can help manage daily tasks and avoid impulse purchases.
- Project Management: Action lists for events, project tasks, and emergency contact lists are useful for organizing tasks and ensuring accountability.
- Creative Planning: Brainstorming lists for ideas, reading lists for books or articles, and data lists for information collection can enhance creativity and organization.

# this is not
# In — long special weak if ten company work bored email daughter; Clear hour... Musician eleven result monument: yellow phone heavy upload measure thirsty nature, fast by already car my. Planet stay clock probably build scrolcount old!
this-shouldnt capture
nor--should this

- is this a list? probably not, but maybe. arguably no.

1. same.

# this definitley is
3. Personal Organization: Grocery lists, to-do lists, and packing lists can help manage daily tasks and avoid impulse purchases.
  * plz
    ** plz
	 --plz plz plz
0. Project Management: Action lists for events, project tasks, and emergency contact lists are useful for organizing tasks and ensuring accountability.
'''
for ele in re.findall(r'(?:[ \t]*(?:[\d+]\.|[-\*]+)\s*(?:.+)\n){2,}', text):
    print(ele)
    print('-------------')

print('\n\n\nex) 13: capture HTML tag content')
html = '''        <script id="envjson" type="application/json" nonce="eIvwUJj9">
            {
                "useTrustedTypes": false,
                "promise_include_trace": false
            }</script>
        <script nonce="eIvwUJj9" src="data:application/x-javascript; charset=utf-8;base64,Oy8qRkJfUEtHX0RFTElNKi8KCnZhciBkYXRhRWxlbWVudD1kb2N1bWVudC5nZXRFbGVtZW50QnlJZCgiZW52anNvbiIpO2lmKGRhdGFFbGVtZW50IT1udWxsKXt2YXIgY29weVZhcmlhYmxlcz1mdW5jdGlvbihlKXtmb3IodmFyIG4gaW4gdmFyaWFibGVzKWVbbl09dmFyaWFibGVzW25dfSx2YXJpYWJsZXM9SlNPTi5wYXJzZShkYXRhRWxlbWVudC50ZXh0Q29udGVudCk7d2luZG93LnJlcXVpcmVMYXp5P3dpbmRvdy5yZXF1aXJlTGF6eShbIkVudiJdLGNvcHlWYXJpYWJsZXMpOih3aW5kb3cuRW52PXdpbmRvdy5FbnZ8fHt9LGNvcHlWYXJpYWJsZXMod2luZG93LkVudikpfQovLyMgc291cmNlVVJMPWh0dHBzOi8vc3RhdGljLmNkbmluc3RhZ3JhbS5jb20vcnNyYy5waHAvdjQveUIvci9kSGJxdGRyRnZ1bi5qcwo=" data-bootloader-hash="nxRKQO6" crossorigin="anonymous" data-p=":0" data-btmanifest="hcsv21031802928_main" data-c="1"></script>
        <script nonce="eIvwUJj9" src="data:application/x-javascript; charset=utf-8;base64,Oy8qRkJfUEtHX0RFTElNKi8KCl9fYW5ub3RhdG9yPWZ1bmN0aW9uKGUpe3JldHVybiBlfSxfX2Rfc3R1Yj1bXSxfX2Q9ZnVuY3Rpb24oZSx0LG4scil7X19kX3N0dWIucHVzaChbZSx0LG4scl0pfSxfX3JsX3N0dWI9W10scmVxdWlyZUxhenk9ZnVuY3Rpb24oKXtfX3JsX3N0dWIucHVzaChhcmd1bWVudHMpfTsKLy8jIHNvdXJjZVVSTD1odHRwczovL3N0YXRpYy5jZG5pbnN0YWdyYW0uY29tL3JzcmMucGhwL3Y0L3lvL3IvOHdEazBKcmVETUouanMK" data-bootloader-hash="W7CcKyc" crossorigin="anonymous" data-p=":0" data-btmanifest="hcsv21031802928_main" data-c="1"></script>
        <script nonce="eIvwUJj9" src="data:application/x-javascript; charset=utf-8;base64,Oy8qRkJfUEtHX0RFTElNKi8KCl9idGxkcj17fSxfbm93SW5sPWZ1bmN0aW9uKCl7dmFyIGU9d2luZG93LnBlcmZvcm1hbmNlO3JldHVybiBlJiZlLm5vdyYmZS50aW1pbmcmJmUudGltaW5nLm5hdmlnYXRpb25TdGFydD9lLm5vdygpK2UudGltaW5nLm5hdmlnYXRpb25TdGFydDpuZXcgRGF0ZSgpLmdldFRpbWUoKX0sX3FwbElubD0oZnVuY3Rpb24oKXt2YXIgZT17Y2xpZW50Ont9fTtyZXR1cm57YWRkUG9pbnQ6ZnVuY3Rpb24odCl7ZS5jbGllbnRbdF09X25vd0lubCgpfSxnZXRQb2ludHM6ZnVuY3Rpb24oKXtyZXR1cm4gZX19fSkoKSxfcXBsSW5sLmFkZFBvaW50KCJodG1sRmx1c2giKTsKLy8jIHNvdXJjZVVSTD1odHRwczovL3N0YXRpYy5jZG5pbnN0YWdyYW0uY29tL3JzcmMucGhwL3Y0L3lLL3Ivbk9hcGNQc1J3cFouanMK" data-bootloader-hash="678jA6i" crossorigin="anonymous" data-p=":0" data-btmanifest="hcsv21031802928_main" data-c="1"></script>
        <script id="__eqmc" type="application/json" nonce="eIvwUJj9">
            {
                "w": 0,
                "f": "NAfvu784UloWMgnfFj1b2m5hfHEdwu-WrDssuI3HbIfxBdMEgxQTjyw:17843691127146670:1767956463",
                "l": null
            }</script>'''
for mo in re.finditer(r'''<script\s+[^\>]+>(?P<script>.*?)<\/script>''', html, flags=re.DOTALL | re.MULTILINE):
    print(mo.groups([0]))
