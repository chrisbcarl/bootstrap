sudo apt update -y
sudo apt upgrade -y

# server management
sudo apt install ssh -y  # i've seen machines NOT come with this installed / enabled out of the box
sudo apt install tmux htop nvtop -y


# tools
sudo apt install dos2unix -y


# devtools / languages
sudo apt install build-essential linux-headers-$(uname -r) -y
sudo apt install git -y
git config --global user.email "chrisbcarl@outlook.com"
git config --global user.name "Chris Carl"
sudo apt install default-jdk -y
sudo apt install -y gcc g++ make cmake gdb valgrind
sudo apt install python3 -y
sudo ln -s $(which python3) /usr/bin/python -f
sudo apt install vim -y
sudo apt install moreutils -y  # provides access to errno -l, useful in C programming with errno.h errorhandling lookup table


# quality of life
sudo apt install network-manager -y


# apps
sudo snap install code --classic  # https://documentation.ubuntu.com/ubuntu-for-developers/howto/gcc-setup/
sudo snap install vlc


# warm restart
sudo shutdown -r now
