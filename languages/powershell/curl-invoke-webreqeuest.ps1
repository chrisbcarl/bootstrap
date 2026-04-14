# GET
curl https://api.example.com/data
Invoke-WebRequest -Uri "https://www.google.com/url?sa=E&source=gmail&q=https://api.example.com/data"
iwr -UseBasicParsing -Uri "https://www.google.com/url?sa=E&source=gmail&q=https://api.example.com/data"

# POST
curl -X POST -d '{"key":"value"}' -H "Content-Type: application/json" https://api.example.com/post
Invoke-WebRequest -Uri "https://api.example.com/post" -Method Post -Body '{"key":"value"}' -ContentType "application/json"

# files
curl -o file.zip https://example.com/file.zip
Invoke-WebRequest -Uri "https://example.com/file.zip" -OutFile "file.zip"

# headers
curl -H "Authorization: Bearer TOKEN" https://api.example.com
Invoke-WebRequest -Uri "https://api.example.com" -Headers @{"Authorization"="Bearer TOKEN"}
