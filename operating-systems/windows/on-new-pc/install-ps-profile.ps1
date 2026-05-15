$BootstrapRoot = [IO.Path]::GetFullPath("$PSScriptRoot\..\..\..\")
$KnownModules = @(
    "$BootstrapRoot\languages\powershell\modules"          # directory
    # "$BootstrapRoot\ai\frameworks\llama-cli-func-ex.psm1"   # module
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
    if (Test-Path $KnownModule -PathType Container) {
        Get-ChildItem -Path $KnownModule -Filter "*.psm1" | ForEach-Object {
            Copy-Item -Path $_.FullName -Destination $profile_ps1_dst -Force
        }
    } else {
        Copy-Item -Path $KnownModule -Destination $profile_ps1_dst -Force
    }
}

Write-Host -ForegroundColor Green "Done!"
