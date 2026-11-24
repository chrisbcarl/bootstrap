# languages\powershell\argument-passthrough.ps1 -Debug -Verbose
# NEEDS CmdletBinding...
[CmdletBinding()]
param ()
$PSBoundParameters | Format-Table  # prints if populated
$Debug = $PSBoundParameters.ContainsKey('Debug') -and $PSBoundParameters['Debug'].IsPresent

& $PSScriptRoot\argument-passthrough-child.ps1 -Debug:$Debug
