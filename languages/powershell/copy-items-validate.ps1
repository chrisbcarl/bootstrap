<#
Modified from AI prompt due to logic and edge cases:
    Invoke-Prompt "create a powershell script that validates if recursively copied files and subdirectories in directory B match source files in directory A using last modified and size. output only the powershell script" -Model $env:ModelLg -Thinking -Huge
    llama-cli.exe -m "C:\Users\chris\downloads\models\Qwen3.6-35B-A3B-UD-Q5_K_XL.gguf" -p "create a powershell script that validates if recursively copied files and subdirectories in directory B match source files in directory A using last modified and size. output only the powershell script" -t 11 --no-display-prompt --single-turn --simple-io --temp 0.6 --top-p 0.95 --top-k 20 --min-p 0.00 --n-gpu-layers auto -n 32768 --ctx-size 32768 --seed 69
#>

param(
    [Parameter(Mandatory=$true)][string]$SourcePath,
    [Parameter(Mandatory=$true)][string]$DestinationPath,
    [Parameter()][double]$TimeToleranceSeconds = 1.0
)


$transcript = "\temp\copy-items-validate.txt"
if (Test-Path $transcript -ErrorAction SilentlyContinue) {
    Remove-Item $transcript
}
New-Item -ItemType Directory '\' -ErrorAction SilentlyContinue
Start-Transcript -Path $transcript -Force


# NOTE: allows gci to get drives like Get-ChildItem 'C:'
Set-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Control\FileSystem" -Name LongPathsEnabled -Type DWord -Value 1


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
$SourceFiles = Get-ChildItem -Path $SourcePath -Recurse -File | ForEach-Object {
    $RelativePath = $_.FullName.Substring($SourcePath.Length + 1)
    [PSCustomObject]@{
        RelativePath = $RelativePath
        Size         = $_.Length
        LastWrite    = $_.LastWriteTime
    }
}


Write-Host -ForegroundColor Cyan "Scanning dest..."
# NOTE: -Force fails to complete on bad drives/files
$DestFiles = Get-ChildItem -Path $DestinationPath -Recurse -File | ForEach-Object {
    $RelativePath = $_.FullName.Substring($DestinationPath.Length + 1)
    [PSCustomObject]@{
        RelativePath = $RelativePath
        Size         = $_.Length
        LastWrite    = $_.LastWriteTime
    }
}


Write-Host -ForegroundColor Cyan "Comparing..."
$SourceMap = @{}
$DestMap = @{}
foreach ($f in $SourceFiles) { $SourceMap[$f.RelativePath] = $f }
foreach ($f in $DestFiles) { $DestMap[$f.RelativePath] = $f }


$Missing = @()
$Extra = @()
$SizeMismatches = @()
$TimeMismatches = @()
$Matched = 0


foreach ($path in $SourceMap.Keys) {
    if ($DestMap.ContainsKey($path)) {
        $s = $SourceMap[$path]
        $d = $DestMap[$path]
        $sizeMatch = ($s.Size -eq $d.Size)
        $timeDiff = [Math]::Abs(($s.LastWriteTime - $d.LastWriteTime).TotalSeconds)
        $timeMatch = ($timeDiff -le $TimeToleranceSeconds)

        if ($sizeMatch -and $timeMatch) {
            $Matched++
        } else {
            if (-not $sizeMatch) {
                $SizeMismatches += [PSCustomObject]@{ Path=$path; SourceSize=$s.Size; DestSize=$d.Size }
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
$SizeMismatches = $SizeMismatches | Sort-Object
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
if ($SizeMismatches.Count -gt 0) {
    Write-Host -ForegroundColor Red "Size Mismatches: $($SizeMismatches.Count)"
    $SizeMismatches | ForEach-Object { Write-Host "  - $($_.Path) [Src: $($_.SourceSize), Dest: $($_.DestSize)]" }
}
if ($TimeMismatches.Count -gt 0) {
    Write-Host -ForegroundColor Red "Time Mismatches: $($TimeMismatches.Count)"
    $TimeMismatches | ForEach-Object { Write-Host "  - $($_.Path) [Src: $($_.SourceTime), Dest: $($_.DestTime)]" }
}


$Missing | ForEach-Object {Split-Path $_ -Parent} | ForEach-Object {
    New-Item -ItemType Directory -Path $_ -ErrorAction SilentlyContinue
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


Write-Host -ForegroundColor Cyan "=== Missing Copy Results ==="
if ($ErrorMissing.Count -gt 0) {
    Write-Host -ForegroundColor Yellow "Missing Copy Failures: $($ErrorMissing.Count)"
    $ErrorMissing | ForEach-Object { Write-Host "  - $_" }
}


Stop-Transcript
if ($Missing.Count -eq 0 -and $Extra.Count -eq 0 -and $SizeMismatches.Count -eq 0 -and $TimeMismatches.Count -eq 0) {
    Write-Host -ForegroundColor Green "All files match successfully!"
    exit 0
} else {
    Write-Warning "Validation found discrepancies."
    Start-Process $transcript
    exit 1
}
