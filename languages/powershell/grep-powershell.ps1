# https://stackoverflow.com/a/41871326

# classic grep output
gci -Path $PSScriptRoot | Select-String -Pattern "\$"

# select files which have this
(Get-ChildItem -Path $PSScriptRoot -File | Where-Object { Select-String -Path $($_.FullName) -Pattern "[Hh]ello [Ww]orld" }).FullName
