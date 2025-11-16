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

('\n\n\nex) 7: replace groups')
result = re.sub(r"\(?(\d{3})\)?[ -]?(\d{3})-?(\d{4})", r"\1\2\3", body)
print(result)
