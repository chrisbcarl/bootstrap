$BootstrapRoot = [IO.Path]::GetFullPath("$PSScriptRoot\..\..\..\")
$KnownModules = @(
    "$BootstrapRoot\ai\frameworks\llama-cli-func-ex.psm1"
)

foreach ($KnownModule in $KnownModules) {
    if (-Not (Test-Path -Path $KnownModule -ErrorAction SilentlyContinue)) {
        Write-Warning "No module found at '$KnownModule', maybe wrong working directory?"
    }
}


$MyDocs = [Environment]::GetFolderPath([Environment+SpecialFolder]::MyDocuments)
$profile_ps1_src = [IO.Path]::GetFullPath("$PSScriptRoot/profile.ps1")
$profile_ps1_dst = [IO.Path]::GetFullPath("$MyDocs/WindowsPowerShell")

New-Item -ItemType Directory -Path $profile_ps1_dst -ErrorAction SilentlyContinue

Write-Host -ForegroundColor Cyan "Installing profile.ps1 and accompanying modules..."
Copy-Item -Path $profile_ps1_src -Destination $profile_ps1_dst -Force
foreach ($KnownModule in $KnownModules) {
    Copy-Item -Path $KnownModule -Destination $profile_ps1_dst -Force
}

Write-Host -ForegroundColor Green "Done!"
