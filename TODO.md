latex katex italics based on font

# powershell download using bits:
```powershell
# https://powershellfaqs.com/download-file-from-url-in-powershell/
# TEST WEBSITE FOR FILES: http://speed.transip.nl/

Set-Location $isodir  # v important


$isos = @(
    'https://archive.org/download/Windows-10-22H2-July-2024-64-bit-DVD-English/en-us_windows_10_business_editions_version_22h2_updated_july_2024_x64_dvd_c004521a.iso',
    'https://archive.org/download/Win11_24H2_English_x64/Win11_24H2_English_x64.iso'
)
$jobs = @()
$isos.foreach({
    $url = $_
    $tokens = ($url -split '/')
    $filename = $($tokens[$tokens.Count - 1])
    Write-Host "downloading $url"
    $jobs += @(Start-BitsTransfer -Source $url -Destination $filename -Asynchronous)
    # wget -UseBasicParsing  # slow, buffers to mem before disk
})
# async are jobs, so wait on them.
Get-BitsTransfer
$Activity = "Downloading"
# Transferring->Transferred
while ($jobs | Where-Object { $_.JobState -eq "Transferring" }) {
    $total_bytes = ($jobs | Select-Object -ExpandProperty BytesTotal | Measure-Object -Sum).Sum
    $elapsed_bytes = ($jobs | Select-Object -ExpandProperty BytesTransferred | Measure-Object -Sum).Sum

    $PercentComplete = $elapsed_bytes / $total_bytes * 100
    $Status = "$($jobs.Count) Files @ $PercentComplete%"
    Write-Progress -Activity $Activity -Status $Status -PercentComplete $PercentComplete
    Start-Sleep 1
}
Get-BitsTransfer | Complete-BitsTransfer
Set-Location $cwd
```
