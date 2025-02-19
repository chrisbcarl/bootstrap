# https://stackoverflow.com/a/57342752
$adapters = $(get-netadapter)
$adapters[0] | Get-Member                   # object methods, properties, everything but not pprint
$adapters[0] | Select-Object                # public pprint
$adapters[0] | Select-Object -Property *    # private pprint
$adapters[0] | ConvertTo-Json -Depth 1      # json, real nice

