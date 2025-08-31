# dealing with leading zeros
lst = range(0, 20, 3)

# formatting is pretty straightforward
for ele in lst:
    percent_style = '%02d' % ele
    format_style = '{:02d}'.format(ele)
    f_style = f'{ele:02d}'
    assert percent_style == format_style
    assert percent_style == f_style

# parse a number with leading zeros
num = '000069'
print(int(num.lstrip('0')))  # TODO: think about these if necessary.lstrip('0x').lstrip('0o').lstrip('0b')
