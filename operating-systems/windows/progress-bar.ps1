$items = 1..10
$idx = 0
$Activity = "Lorem ipsum"
foreach ($item in $items) {
    $PercentComplete = (($idx + 1) / $items.Count * 100)
    $Status = "$($idx + 1) / $($items.Count) - $item @ $PercentComplete%"
    Write-Progress -Activity $Activity -Status $Status -PercentComplete $PercentComplete
    Start-Sleep 1
    $idx += 1
}
