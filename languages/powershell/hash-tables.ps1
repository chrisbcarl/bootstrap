$hash_table = @{
    a=1;
    b=@(
        2, 3, 4
    );
    c=@{
        nested=$true;
    };
}

Write-Host $hash_table.Contains("a")
Write-Host $hash_table["a"]

Write-Host ($null -eq $hash_table["b"])

$hash_table["d"] = 3.14


foreach ($item in $hash_table.GetEnumerator()) {
    $Key = $item.Key
    $Value = $item.Value
    Write-Host "$Key - $Value"
}