<#
Slightly modified from:
    Invoke-Prompt "create a powershell script that validates if recursively copied files and subdirectories in directory B match source files in directory A using last modified and size. output only the powershell script" -Model $env:ModelLg -Thinking -Huge
    llama-cli.exe -m "C:\Users\chris\downloads\models\Qwen3.6-35B-A3B-UD-Q5_K_XL.gguf" -p "create a powershell script that validates if recursively copied files and subdirectories in directory B match source files in directory A using last modified and size. output only the powershell script" -t 11 --no-display-prompt --single-turn --simple-io --temp 0.6 --top-p 0.95 --top-k 20 --min-p 0.00 --n-gpu-layers auto -n 32768 --ctx-size 32768 --seed 69
#>

param(
    [Parameter(Mandatory=$true)][string]$SourcePath,
    [Parameter(Mandatory=$true)][string]$DestinationPath,
    [Parameter()][double]$TimeToleranceSeconds = 1.0
)


$transcript = "\temp\copy-items-validate.txt"
New-Item -ItemType Directory '\' -ErrorAction SilentlyContinue
Start-Transcript -Path $transcript


try {
    $SourcePath = (Resolve-Path $SourcePath).Path
    if ($SourcePath.EndsWith('\')) {
        $SourcePath = $SourcePath.TrimEnd('\')
    }
} catch {
    Write-Warning "SourcePath invalid: $_"
    Start-Process $transcript
    exit 1
}
try {
    $DestinationPath = (Resolve-Path $DestinationPath).Path
    if ($DestinationPath.EndsWith('\')) {
        $DestinationPath = $DestinationPath.TrimEnd('\')
    }
} catch {
    Write-Warning "DestinationPath invalid: $_"
    Start-Process $transcript
    exit 1
}


$SourceFiles = Get-ChildItem -Path $SourcePath -Recurse -File -Force | ForEach-Object {
    $RelativePath = $_.FullName.Substring($SourcePath.Length + 1)
    [PSCustomObject]@{
        RelativePath = $RelativePath
        Size         = $_.Length
        LastWrite    = $_.LastWriteTime
    }
}


$DestFiles = Get-ChildItem -Path $DestinationPath -Recurse -File -Force | ForEach-Object {
    $RelativePath = $_.FullName.Substring($DestinationPath.Length + 1)
    [PSCustomObject]@{
        RelativePath = $RelativePath
        Size         = $_.Length
        LastWrite    = $_.LastWriteTime
    }
}


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


Write-Host "=== Directory Validation Results ===" -ForegroundColor Cyan
Write-Host "Matched: $Matched" -ForegroundColor Green
if ($Missing.Count -gt 0) {
    Write-Host "Missing in Destination: $($Missing.Count)" -ForegroundColor Red
    $Missing | ForEach-Object { Write-Host "  - $_" }
}
if ($Extra.Count -gt 0) {
    Write-Host "Extra in Destination: $($Extra.Count)" -ForegroundColor Yellow
    $Extra | ForEach-Object { Write-Host "  - $_" }
}
if ($SizeMismatches.Count -gt 0) {
    Write-Host "Size Mismatches: $($SizeMismatches.Count)" -ForegroundColor Red
    $SizeMismatches | ForEach-Object { Write-Host "  - $($_.Path) [Src: $($_.SourceSize), Dest: $($_.DestSize)]" }
}
if ($TimeMismatches.Count -gt 0) {
    Write-Host "Time Mismatches: $($TimeMismatches.Count)" -ForegroundColor Red
    $TimeMismatches | ForEach-Object { Write-Host "  - $($_.Path) [Src: $($_.SourceTime), Dest: $($_.DestTime)]" }
}

if ($Missing.Count -eq 0 -and $Extra.Count -eq 0 -and $SizeMismatches.Count -eq 0 -and $TimeMismatches.Count -eq 0) {
    Write-Host "All files match successfully!" -ForegroundColor Green
    exit 0
} else {
    Write-Warning "Validation found discrepancies."
    Start-Process $transcript
    exit 1
}