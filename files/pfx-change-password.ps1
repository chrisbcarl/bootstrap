# change pfx password | pfx change password

# https://mcilis.medium.com/how-to-change-the-password-of-a-pfx-file-ba46cb193dfe

openssl pkcs12 -in Something.pfx -out /temp/temp.pem -nodes
# password will be prompted

openssl pkcs12 -export -out NewPassword.pfx -in /temp/temp.pem
# password will be prompted
