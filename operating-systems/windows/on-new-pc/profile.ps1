
#region conda initialize
# !! Contents within this block are managed by 'conda init' !!
if ([System.Environment]::GetEnvironmentVariable('CONDA_HOOK') -and ($env:CONDA_HOOK -eq "1")) {
    Write-Host -ForegroundColor Cyan "conda hook..."
    If (Test-Path "C:\tools\Anaconda3\Scripts\conda.exe" -ErrorAction SilentlyContinue) {
        (& "C:\tools\Anaconda3\Scripts\conda.exe" "shell.powershell" "hook") | Out-String | ?{$_} | Invoke-Expression
        conda deactivate
    }
} else {
    Write-Warning "skipping conda hook..."
}
#endregion

#region module import
Write-Host -ForegroundColor Cyan "psm1 imports..."
Get-ChildItem -Path $PSScriptRoot -Filter "*.psm1" | ForEach-Object {
    Import-Module -Name $_.FullName -Force
    $ModuleName = [IO.Path]::GetFileNameWithoutExtension($_.Name)  # must be base name
    Write-Host -ForegroundColor Cyan "    $ModuleName.psm1"
    Get-Command -Module $ModuleName | ForEach-Object {
        Write-Host "        * $($_.Name)"  # Invoke-Prompt, whatever
    }
}
#endregion
