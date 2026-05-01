# otherwise you cannot enable macros
$census2010_accessdb = 'https://www2.census.gov/census_2010/03-Demographic_Profile/DPSF2010_Access.accdb'
$filepath = "$($env:USERPROFILE)/downloads/DPSF2010_Access.accdb"
Invoke-WebRequest -Uri $census2010_accessdb -OutFile $filepath  # slow somehow, see download-file.ps1

Start-Process $filepath

# Unblock-File -Path $filepath  # do this to even enable the "enable macros" btn
