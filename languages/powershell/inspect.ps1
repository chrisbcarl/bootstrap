# https://learn.microsoft.com/en-us/powershell/scripting/learn/ps101/03-discovering-objects?view=powershell-7.6

Get-Disk | Select-Object *
Get-Disk | Get-Member

$tasks = (Get-ScheduledTask)

$tasks[0] | Format-List  # get a list of all properties, print properties
$tasks | Format-Table  # truncated table of most important properties
$tasks[0] | ConvertTo-JSON
$tasks | ConvertTo-JSON
