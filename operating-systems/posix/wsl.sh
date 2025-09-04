wsl --install  # must start here


# copy ssh key from windows FS to wslFS
cp /mnt/c/Users/$(whoami)/.ssh/id_rsa ~/.ssh/id_rsa
sudo apt install dos2unix -y
dos2unix ~/.ssh/id_rsa 
chmod 600 ~/.ssh/id_rsa
eval $(ssh-agent)
ssh-add ~/.ssh/id_rsa
