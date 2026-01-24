schtasks /query /fo LIST /v | Where-Object {
    $_ -like "Task To Run*"
        -or
    $_ -like "Author*"
}
