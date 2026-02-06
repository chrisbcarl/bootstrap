# https://www.digitalocean.com/community/tutorials/how-to-add-swap-space-on-ubuntu-20-04
sudo swapon --show
free -h
df -h
sudo fallocate -l 2G /swapfile
sudo fallocate --collapse-range --length 1G /swapfile
ls -lh /swapfile
sudo chmod 600 /swapfile
ls -lh /swapfile
sudo mkswap /swapfile
sudo swapon /swapfile
sudo swapon --show
free -h
sudo cp /etc/fstab /etc/fstab.bak
echo '/swapfile none swap sw 0 0' | sudo tee -a /etc/fstab
