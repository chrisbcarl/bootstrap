# https://stackoverflow.com/a/31845512
# reload / refreshenv
$env:Path = [System.Environment]::GetEnvironmentVariable("Path","Machine") + ";" + [System.Environment]::GetEnvironmentVariable("Path","User")
