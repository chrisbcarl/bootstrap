<#
Modified from AI prompt due to logic and edge cases:
    Invoke-Prompt "create a powershell script that validates if recursively copied files and subdirectories in directory B match source files in directory A using last modified and size. output only the powershell script" -Model $env:ModelLg -Thinking -Huge
    llama-cli.exe -m "C:\Users\chris\downloads\models\Qwen3.6-35B-A3B-UD-Q5_K_XL.gguf" -p "create a powershell script that validates if recursively copied files and subdirectories in directory B match source files in directory A using last modified and size. output only the powershell script" -t 11 --no-display-prompt --single-turn --simple-io --temp 0.6 --top-p 0.95 --top-k 20 --min-p 0.00 --n-gpu-layers auto -n 32768 --ctx-size 32768 --seed 69
#>


param(
    [Parameter(Mandatory=$true)][string]$SourcePath,
    [Parameter(Mandatory=$true)][string]$DestinationPath,
    [Parameter()][string[]]$ExcludeDirectories,
    [Parameter()][string[]]$ExcludeFilenames,
    [Parameter()][double]$TimeToleranceSeconds = 1.0
)


if (-Not ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
    Write-Warning "Rerun as Admin!"
    exit 1
}


$transcript = "\temp\copy-items-validate.txt"
if (Test-Path $transcript -ErrorAction SilentlyContinue) {
    Remove-Item $transcript
}
New-Item -ItemType Directory '\' -ErrorAction SilentlyContinue
Start-Transcript -Path $transcript -Force


# NOTE: allows gci to get drives like Get-ChildItem 'C:'
$fs = Get-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Control\FileSystem"
if ($fs.LongPathsEnabled -ne 1) {
    Write-Warning "LongPathsEnabled disabled!"
    Set-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Control\FileSystem" -Name LongPathsEnabled -Type DWord -Value 1
    Write-Warning "Rerun!"
    exit 1
}


try {
    $SourcePath = (Resolve-Path $SourcePath).Path
    if ($SourcePath.EndsWith('\')) {
        $SourcePath = $SourcePath.TrimEnd('\')
    }
    Write-Host -ForegroundColor Green "SourcePath - '$SourcePath'"
} catch {
    Write-Warning "SourcePath invalid: $_"
    Stop-Transcript
    Start-Process $transcript
    exit 1
}
try {
    $DestinationPath = (Resolve-Path $DestinationPath).Path
    if ($DestinationPath.EndsWith('\')) {
        $DestinationPath = $DestinationPath.TrimEnd('\')
    }
    Write-Host -ForegroundColor Green "DestinationPath - '$DestinationPath'"
} catch {
    Write-Warning "DestinationPath invalid: $_"
    Stop-Transcript
    Start-Process $transcript
    exit 1
}


Write-Host -ForegroundColor Cyan "Scanning source..."
# NOTE: -Force fails to complete on bad drives/files
# Find all the good folders
if ($ExcludeDirectories.Count -gt 0) {
    $BadDirs = (Get-ChildItem -Path $SourcePath -Recurse -Directory | Where-Object -Property Name -Match ($ExcludeDirectories -join "|")).FullName
    $BadDirsRegex = ($BadDirs | ForEach-Object {[Regex]::Escape($_)}) -join "|"
    $SourceGoodDirectories = Get-ChildItem -Path $SourcePath -Recurse -Directory | Where-Object -Property FullName -NotMatch $BadDirsRegex
    if ($ExcludeFilenames.Count -gt 0) {
        $SourceFiles = $SourceGoodDirectories | Get-ChildItem -Recurse -File | Where-Object -Property Name -NotMatch ($ExcludeFilenames -join "|") | ForEach-Object {
            $RelativePath = $_.FullName.Substring($SourcePath.Length + 1)
            [PSCustomObject]@{
                RelativePath = $RelativePath
                Length         = $_.Length
                LastWriteTime    = $_.LastWriteTime
            }
        }
    } else {
        $SourceFiles = $SourceGoodDirectories | Get-ChildItem -Recurse -File | ForEach-Object {
            $RelativePath = $_.FullName.Substring($SourcePath.Length + 1)
            [PSCustomObject]@{
                RelativePath = $RelativePath
                Length         = $_.Length
                LastWriteTime    = $_.LastWriteTime
            }
        }
    }
} else {
    $SourceFiles = Get-ChildItem -Path $SourcePath -Recurse -File | ForEach-Object {
        $RelativePath = $_.FullName.Substring($SourcePath.Length + 1)
        [PSCustomObject]@{
            RelativePath = $RelativePath
            Length         = $_.Length
            LastWriteTime    = $_.LastWriteTime
        }
    }
}


Write-Host -ForegroundColor Cyan "Scanning dest..."
# NOTE: -Force fails to complete on bad drives/files
if ($ExcludeDirectories.Count -gt 0) {
    $BadDirs = (Get-ChildItem -Path $DestinationPath -Recurse -Directory | Where-Object -Property Name -Match ($ExcludeDirectories -join "|")).FullName
    $BadDirsRegex = ($BadDirs | ForEach-Object {[Regex]::Escape($_)}) -join "|"
    $DestinationGoodDirectories = Get-ChildItem -Path $DestinationPath -Recurse -Directory | Where-Object -Property FullName -NotMatch $BadDirsRegex
    if ($ExcludeFilenames.Count -gt 0) {
        $DestinationFiles = $DestinationGoodDirectories | Get-ChildItem -Recurse -File | Where-Object -Property Name -NotMatch ($ExcludeFilenames -join "|") | ForEach-Object {
            $RelativePath = $_.FullName.Substring($DestinationPath.Length + 1)
            [PSCustomObject]@{
                RelativePath = $RelativePath
                Length         = $_.Length
                LastWriteTime    = $_.LastWriteTime
            }
        }
    } else {
        $DestinationFiles = $DestinationGoodDirectories | Get-ChildItem -Recurse -File | ForEach-Object {
            $RelativePath = $_.FullName.Substring($DestinationPath.Length + 1)
            [PSCustomObject]@{
                RelativePath = $RelativePath
                Length         = $_.Length
                LastWriteTime    = $_.LastWriteTime
            }
        }
    }
} else {
    $DestinationFiles = Get-ChildItem -Path $DestinationPath -Recurse -File | ForEach-Object {
        $RelativePath = $_.FullName.Substring($DestinationPath.Length + 1)
        [PSCustomObject]@{
            RelativePath = $RelativePath
            Length         = $_.Length
            LastWriteTime    = $_.LastWriteTime
        }
    }
}


Write-Host -ForegroundColor Cyan "Comparing..."
$SourceMap = @{}
$DestMap = @{}
foreach ($f in $SourceFiles) { $SourceMap[$f.RelativePath] = $f }
foreach ($f in $DestinationFiles) { $DestMap[$f.RelativePath] = $f }


$Missing = @()
$Extra = @()
$LengthMismatches = @()
$TimeMismatches = @()
$Matched = 0


foreach ($path in $SourceMap.Keys) {
    if ($DestMap.ContainsKey($path)) {
        $s = $SourceMap[$path]
        $d = $DestMap[$path]
        $sizeMatch = ($s.Length -eq $d.Length)
        $timeDiff = [Math]::Abs(($s.LastWriteTime - $d.LastWriteTime).TotalSeconds)
        $timeMatch = ($timeDiff -le $TimeToleranceSeconds)

        if ($sizeMatch -and $timeMatch) {
            $Matched++
        } else {
            if (-not $sizeMatch) {
                $LengthMismatches += [PSCustomObject]@{ Path=$path; SourceLength=$s.Length; DestLength=$d.Length }
            }
            if (-not $timeMatch) {
                $TimeMismatches += [PSCustomObject]@{ Path=$path; SourceTime=$s.LastWriteTime; DestTime=$d.LastWriteTime }
            }
        }
    } else {
        $Missing += $path
    }
}


foreach ($path in $DestMap.Keys) {
    if (-not $SourceMap.ContainsKey($path)) {
        $Extra += $path
    }
}


Write-Host -ForegroundColor Cyan "=== Sorting ==="
$Missing = $Missing | Sort-Object
$Extra = $Extra | Sort-Object
$LengthMismatches = $LengthMismatches | Sort-Object
$TimeMismatches = $TimeMismatches | Sort-Object


Write-Host -ForegroundColor Cyan "=== Directory Validation Results ==="
Write-Host -ForegroundColor Green "Matched: $Matched"
if ($Extra.Count -gt 0) {
    Write-Host -ForegroundColor Yellow "Extra in Destination: $($Extra.Count)"
    $Extra | ForEach-Object { Write-Host "  - $_" }
}
if ($Missing.Count -gt 0) {
    Write-Host -ForegroundColor Red "Missing in Destination: $($Missing.Count)"
    $Missing | ForEach-Object { Write-Host "  - $_" }
}
if ($LengthMismatches.Count -gt 0) {
    Write-Host -ForegroundColor Red "Length Mismatches: $($LengthMismatches.Count)"
    $LengthMismatches | ForEach-Object { Write-Host "  - $($_.Path) [Src: $($_.SourceLength), Dest: $($_.DestLength)]" }
}
if ($TimeMismatches.Count -gt 0) {
    Write-Host -ForegroundColor Red "Time Mismatches: $($TimeMismatches.Count)"
    $TimeMismatches | ForEach-Object { Write-Host "  - $($_.Path) [Src: $($_.SourceTime), Dest: $($_.DestTime)]" }
}


$Missing | ForEach-Object {Split-Path $_ -Parent} | ForEach-Object {
    $null = New-Item -ItemType Directory -Path "$DestinationPath\$_" -ErrorAction SilentlyContinue
}
$ErrorMissing = @()
$idx = 0
$Activity = "Attempting copy of $($Missing.Count) Missing"
foreach ($item in $Missing) {
    $PercentComplete = ($idx / $Missing.Count * 100)
    $Status = "$idx / $($Missing.Count) - $item @ $PercentComplete%"
    Write-Progress -Activity $Activity -Status $Status -PercentComplete $PercentComplete
    $idx += 1

    try {
        Copy-Item -Path "$SourcePath\$item" -Destination "$DestinationPath\$item"
    }
    catch {
        $ErrorMissing += @("$SourcePath\$item")
    }
}


if ($ErrorMissing.Count -gt 0) {
    Write-Host -ForegroundColor Yellow "=== Missing Copy Results - Failures: $($ErrorMissing.Count) ==="
    $ErrorMissing | ForEach-Object { Write-Host "  - $_" }
}


Write-Host "Done."
Stop-Transcript
Copy-Item -Path $transcript -Destination $DestinationPath
if (($Missing.Count -eq 0) -and ($Extra.Count -eq 0) -and ($LengthMismatches.Count -eq 0) -and ($TimeMismatches.Count -eq 0)) {
    Write-Host -ForegroundColor Green "All files match successfully!"
    exit 0
} else {
    Write-Warning "Validation found discrepancies."
    Start-Process $transcript
    exit 1
}
