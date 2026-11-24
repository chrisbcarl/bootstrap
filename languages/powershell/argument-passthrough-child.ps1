[CmdletBinding()]
param (
    [Parameter()][switch]$plz
)

$Debug = $PSBoundParameters.ContainsKey('Debug') -and $PSBoundParameters['Debug'].IsPresent
Write-Host "Debug $Debug"
Write-Host "DebugPreference $DebugPreference"
