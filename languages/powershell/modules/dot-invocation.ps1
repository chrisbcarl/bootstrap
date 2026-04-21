$script_string = @'
Write-Host 'plz'
$var1 = 69
'@

$tf = New-TemporaryFile
Set-Content -Path $tf.FullName -Value $script_string

$ps1_name = "$($tf.Name).ps1"
$ps1_fullname = "$($tf.Directory.FullName)/$ps1_name"
$item = Move-Item -Path $tf.FullName -Destination $ps1_fullname
Write-Host $ps1_fullname

# dot invocation
. $ps1_fullname

Write-Host "var1 = $var1"

Remove-Item -Path $ps1_fullname
