# create a compute engine instance
us-west1, e2-micro, SPOT, network: STANDARD, image-change-ubuntu


# total google cloud adventure:
cloud init
gcloud auth list
gcloud projects list  | findstr "My First Project "  # numeric-scope-486007-a7


# add ssh keys
# enable the service visavis the project...
# https://docs.cloud.google.com/compute/docs/oslogin/set-up-oslogin
# https://docs.cloud.google.com/compute/docs/connect/add-ssh-keys#os-login
gcloud compute project-info add-metadata --metadata=enable-oslogin=TRUE
gcloud compute project-info add-metadata --metadata-from-file ssh-keys=~/.ssh/id_ed25519.pub
gcloud compute os-login ssh-keys add --key-file ~/.ssh/id_ed25519.pub --ttl "999d"


# get ip address
gcloud compute instances list  # machine type e2-micro
gcloud compute instances describe instance-20260206-022139 | findstr "natIP:"  # natIP: 35.212.209.210
ssh chris_carl_sjsu_edu@35.212.239.4


# bootstrap
ssh chris_carl_sjsu_edu@35.212.239.4 'sudo sh -c "yes | unminimize"'

ssh chris_carl_sjsu_edu@35.212.239.4 sudo apt install unzip -y

ssh chris_carl_sjsu_edu@35.212.239.4 mkdir ~/downloads
ssh chris_carl_sjsu_edu@35.212.239.4 curl -o ~/downloads/bootstrap-main.zip -L https://github.com/chrisbcarl/bootstrap/archive/refs/heads/main.zip  # -o output file, -L follow the redirects
ssh chris_carl_sjsu_edu@35.212.239.4 unzip ~/downloads/bootstrap-main.zip -d ~/downloads  # since its one folder nested, boostrap-main will just reveal itself

ssh chris_carl_sjsu_edu@35.212.239.4 chmod +x ~/downloads/bootstrap-main/operating-systems/posix/ubuntu-on-new-pc.sh
ssh chris_carl_sjsu_edu@35.212.239.4 sudo ~/downloads/bootstrap-main/operating-systems/posix/ubuntu-on-new-pc.sh
