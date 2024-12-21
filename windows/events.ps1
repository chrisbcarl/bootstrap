Get-EventLog -List | ForEach-Object {
    Write-Host $_.Log
    Get-EventLog -LogName "$_.Log" -After (Get-Date).AddHours(-6) | Export-CSV -Path "C:\temp\lol\$($_.Log).csv" -NoTypeInformation
}
Get-WinEvent -ListLog * | ForEach-Object {
    Get-WinEvent -LogName $_.LogName etc...
}


<#
Python Parsing

import csv
import os
import json
dirname = os.path.dirname(__file__)
events = {}
username = 'chris'
for filename in os.listdir(dirname):
    if not filename.endswith('.csv'):
        continue
    filepath = os.path.join(dirname, filename)
    print(filename)
    with open(filepath, 'r') as r:
        reader = csv.DictReader(r)
        rows = list(reader)
    if not rows:
        continue
    print(rows[0])
    subevents = events[filename] = []
    for row in rows:
        if username in row['Message'].lower():
            if int(row['EventID']) not in subevents:
                subevents.append(int(row['EventID']))
print(json.dumps(events, indent=2))
#>
