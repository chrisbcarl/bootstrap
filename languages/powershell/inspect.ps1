$tasks = (Get-ScheduledTask)

$tasks[0] | Format-List  # get a list of all properties, print properties
$tasks | Format-Table  # truncated table of most important properties
$tasks[0] | ConvertTo-JSON
$tasks | ConvertTo-JSON
