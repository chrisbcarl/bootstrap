$items = 1..10
$idx = 0
$Activity = "Lorem ipsum"
foreach ($item in $items) {
    $PercentComplete = ($idx / $items.Count * 100)
    $Status = "$idx / $($items.Count) - $item @ $PercentComplete%"
    Write-Progress -Activity $Activity -Status $Status -PercentComplete $PercentComplete
    $idx += 1

    # work goes here
    Start-Sleep 1
}
