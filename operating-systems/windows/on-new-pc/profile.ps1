
#region conda initialize
# !! Contents within this block are managed by 'conda init' !!
Write-Host -ForegroundColor Cyan "conda hook..."
If (Test-Path "C:\tools\Anaconda3\Scripts\conda.exe" -ErrorAction SilentlyContinue) {
    (& "C:\tools\Anaconda3\Scripts\conda.exe" "shell.powershell" "hook") | Out-String | ?{$_} | Invoke-Expression
    conda deactivate
}
#endregion

#region module import
Write-Host -ForegroundColor Cyan "psm1 imports..."
Get-ChildItem -Path $PSScriptRoot -Filter "*.psm1" | ForEach-Object {
    Import-Module -Name $_.FullName -Force
}
#endregion

Write-Host -ForegroundColor Green "Done!"
