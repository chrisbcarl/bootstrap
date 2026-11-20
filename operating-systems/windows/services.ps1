# get a json of all services and their executables
# https://stackoverflow.com/a/24449854
$json = Get-WmiObject win32_service | Select-Object * | ConvertTo-Json
Set-Content -Path \temp\services.json -Value $json


function Get-ChildProcesses ($ParentProcessId) {
    <#
    https://stackoverflow.com/a/70180276
    #>
    $filter = "parentprocessid = '$($ParentProcessId)'"
    Get-CIMInstance -ClassName win32_process -filter $filter | Foreach-Object {
            $_
            if ($_.ParentProcessId -ne $_.ProcessId) {
                Get-ChildProcesses $_.ProcessId
            }
        }
}

Get-ChildProcesses 4 | Select ProcessId, Name, ParentProcessId

# TODO: get recursive tree memory usage to figure out which services to disable and which procs to kill afterward