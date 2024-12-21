[CmdletBinding()]
param (
    [Parameter()][String]$Pwd="$PSScriptRoot/../",
    [Parameter()][Switch]$NoMp
)


$ScriptBlock = {
    Write-Host -ForegroundColor Magenta "Starting jupyter notebook. Eta 10 sec if done before. If its the first time, it'll take a while before browser autolaunches."
    & $PSScriptRoot/../../.venv/scripts/activate.ps1
    python -m jupyter notebook
}

$url = "http://localhost:8888/tree"
try {
    Invoke-WebRequest $url -TimeoutSec 1 -ErrorAction Stop | Out-Null
    $response = $true
}
catch {
    $response = $false
}
if (-Not $response) {
    Write-Host -ForegroundColor Cyan "Launching..."
    if ($NoMp) {
        & $ScriptBlock
    } else {
        Write-Host -ForegroundColor Yellow "Setting start location to '$Pwd'"
        # https://stackoverflow.com/a/17388991
        $job = Start-Job -Init ([ScriptBlock]::Create("Set-Location '$Pwd'")) $ScriptBlock
        $job
        Write-Host -ForegroundColor Yellow "Waiting for a response from the server..."
        while (-Not $response) {
            try {
                Invoke-WebRequest $url -TimeoutSec 1 -ErrorAction Stop | Out-Null
                $response = $true
            }
            catch {
                $response = $false
            }
        }
        # Set-Content -Path "$PSScriptRoot/.jobid" -Value $job.Id
        Write-Host -ForegroundColor Yellow "Launching page..."
        & 'c:\Program Files (x86)\Microsoft\Edge\Application\msedge.exe' $url
        Write-Host -ForegroundColor Green "Launched!"
    }
} else {
    Write-Host -ForegroundColor Green "Already running!"
}

