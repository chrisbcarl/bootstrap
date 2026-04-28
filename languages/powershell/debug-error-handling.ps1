Start-Transcript -OutputDirectory "/temp/powershell"


function Throws {
    throw "message"
}


Set-PSDebug -Trace 1


try {
    Throws
} catch {
    Write-Host "err: $($Error[0].Message)"
}

0/0


Set-PSDebug -Off


Stop-Transcript