sudo apt update -y
sudo apt upgrade -y

# devtools
sudo apt install build-essential linux-headers-$(uname -r) -y
sudo apt install tmux htop nvtop -y

# benchmarkers
sudo apt install stress -y

# languages
sudo apt install default-jdk -y

# quality of life
sudo apt install network-manager -y
