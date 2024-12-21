# & .venv/scripts/activate.ps1
# python -m jupyter notebook stop  # doesnt work...

# $jobidPath = "$PSScriptRoot/.jobid"
# if (Test-Path -Path $jobidPath -ErrorAction SilentlyContinue) {
#     $jobid = Get-Content -Path $jobidPath
#     $jobid = $jobid.Trim()
#     Write-Warning "Stopping jobid $jobid..."
#     Stop-Job -Id $jobid
#     Remove-Item -Path $jobidPath
# }

Write-Host -ForegroundColor Cyan "Stopping..."
taskkill /f /t /im jupyter-notebook.EXE
Write-Host -ForegroundColor Green "Done!"
