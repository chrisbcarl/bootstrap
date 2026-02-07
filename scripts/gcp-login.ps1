[CmdletBinding()]
param (
    [Parameter()][string]$Username="chris_carl_sjsu_edu",
    [Parameter()][string]$MachineType="e2-micro"
)
$instance_micro_name = $null
$instance_micro_ip = $null

$output = (gcloud compute instances list)
$headers = $output[0] -split "\s+"
$rows = @()

for ($i = 1; $i -lt $output.Count; $i++) {
    $row = @{}
    $line = $output[$i] -split "\s+"
    for ($j = 0; $j -lt $headers.Count; $j++) {
        $row[$headers[$j]] = $line[$j]

    }
    if ($row['MACHINE_TYPE'] -eq $MachineType) {
        $instance_micro_name = $row['NAME']
        $instance_micro_ip = $row['EXTERNAL_IP']
    }
    $rows += @($row)
}


# $rows | Format-List
if ($null -eq $instance_micro_name) {
    Write-Warning "Could not find a machine of type '$MachineType'!"
    exit 1
}

Write-Host -ForegroundColor Cyan "ssh `"$Username@$instance_micro_ip`""
ssh "$Username@$instance_micro_ip"
