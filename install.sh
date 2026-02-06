# run this from any new vm instance

sudo sh -c "yes | unminimize"
sudo apt install unzip -y

mkdir ~/downloads
curl -o ~/downloads/bootstrap-main.zip -L https://github.com/chrisbcarl/bootstrap/archive/refs/heads/main.zip  # -o output file, -L follow the redirects
unzip ~/downloads/bootstrap-main.zip -d ~/downloads  # since its one folder nested, boostrap-main will just reveal itself

# create a swap file first...
# TODO: create guards around this, see if other ubuntus have this as well...
# chmod +x ~/downloads/bootstrap-main/operating-systems/posix/swapfile.sh
# sudo ~/downloads/bootstrap-main/operating-systems/posix/swapfile.sh

# install stuff
chmod +x ~/downloads/bootstrap-main/operating-systems/posix/ubuntu-on-new-pc.sh
sudo ~/downloads/bootstrap-main/operating-systems/posix/ubuntu-on-new-pc.sh

# TODO: elaborate this section like .ps1
poetry config virtualenvs.create true
poetry config virtualenvs.in-project true
poetry install
