$lst = @(1, 2, 3)
1 -in $lst
$lst.Contains(1)

# pop an element
$list = 1..5  # auto list builder
$middleIndex = $list.IndexOf(3)
$middleElement = $list[$middleIndex]
# array slicing
$list = $list[0..($middleIndex - 1)] + $list[($middleIndex + 1)..$($list.Count - 1)]
Write-Host "$middleElement, $list"
