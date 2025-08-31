# confirm virtualization enabled
Get-WmiObject -Class Win32_Processor | Select-Object Name, Manufacturer, Caption, AddressWidth, CoreCount, VirtualizationFirmwareEnabled
# Name                          : AMD Ryzen 9 9950X3D 16-Core Processor
# Manufacturer                  : AuthenticAMD
# Caption                       : AMD64 Family 26 Model 68 Stepping 0
# AddressWidth                  : 64
# CoreCount                     :
# VirtualizationFirmwareEnabled : True

wsl --install  # the foundation that docker actually runs on
wsl --shutdown  # WARNING: shutdown wsl if ram usage too high TODO: doesnt actually shut things down... not sure why

choco install docker-desktop docker-cli -y
# TODO: WARNING: set start at login thorugh the gui

# full lifecycle example:
docker pull fedora:rawhide
# launch the image with a bunch of options, -itd most important, sets interactive, tty, daemon
docker run -itd --name fedora --memory="512m" --cpuset-cpus="3-6" --gpus all -v c:\temp:/tmp/c-temp -e DB_HOST=localhost -p 5000:5000 fedora:rawhide
docker ps -a  # list image instances
docker ps -a -q  # lists all image ids
docker attach fedora  # attaches to the naturally running /bin/bash

# interactive, do whatever you like here
whoami
uname -a
cat /etc/*-release
dnf check-update
dnf upgrade -y
dnf group install development-tools -y
dnf install tmux nvtop htop stress -y
exit

# image is now stopped
docker ps -a  # fedora is stopped because you exited
docker commit fedora rawhide-v2  # creates a NEW image, different from the original
docker images  # list em all
docker start fedora  # if you want to reattach
docker stop fedora  # idempotent
docker rm fedora  # removes the image from possible running (causes any progress youve made to reset next time)

# launching fedora, fedora2 so you can demo the changes
docker run --name fedora -itd fedora:rawhide
docker exec fedora nvtop --version  # error
docker run --name fedora2 -itd rawhide-v2
docker exec fedora2 nvtop --version  # success
docker stop fedora fedora2  # stop multiple running images
docker rm fedora fedora2  # remove multiple potential images

# invoking
## stress test
docker run -itd --name fedora2 --memory="512m" --cpuset-cpus="3-6" --gpus all -v c:\temp:/tmp/c-temp -e DB_HOST=localhost -p 5000:5000 rawhide-v2
docker exec --env DB_HOST=localhost fedora2 /bin/bash -c 'echo $DB_HOST; stress --cpu $(nproc) --timeout 15'  # blocks and waits till finished
docker stats fedora2  # get usage statistics in another terminal, since the above is blocking
# run a command that needs a tty
docker run -it --name ubu ubuntu /bin/bash  # typing exit will cause the container to stop
docker run ubuntu bash -c 'cat /etc/*-release'  # auto exits, needs -c for the escapability

# daemon
docker run --name ubu -itd ubuntu
# exec on a daemon
docker exec ubu ls -lah
docker stop ubu
docker rm ubu

# extras
docker rmi python:3.9-slim  # remove image from downloaded images
docker image prune  # remove all images period
docker stop $(docker ps -a -q)  # stop all images
docker rm $(docker ps -a -q)  # remove all images

# notable images
docker pull hello-world:linux  # it just prints, cannot be interacted with
docker pull python:3.9  # it launches with python, typing exit() stops the container
docker pull fedora:rawhide  # fedora
docker pull ubuntu  # ubuntu latest
