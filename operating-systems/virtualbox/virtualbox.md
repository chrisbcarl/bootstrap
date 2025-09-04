# SSH into VirtualBox
- WARNING: set network addapters to "82543GC" so they auto acquire ip's: https://superuser.com/questions/1146122/ubuntu-virtualbox-guest-does-not-get-ipv4-in-bridged-mode#comment2385399_1256940
- (Box must be off) Settings > Network Adapaters > Pick a network adapter tab that isnt used
    - enable
    - Host-only adapter
    - on restart it will autoconfigure (at this point you can nmcli to set it to static or something)
- `sudo apt install nmcli -y`
- `ip a` to figure out ip address
- edit host file at `C:\Windows\System32\drivers\etc\hosts`
    - add 192.168.54.101 virtualbox
- `ssh osc@virtualbox`, `ssh-copy-id osc@virtualbox`


# Example Virtualboxes
- https://codex.cs.yale.edu/avi/os-book/OS10/VM/OSC10e.ova (Ubuntu 16 LTS)
- https://cs.westminstercollege.edu/~greg/osc10e/vm/index.html (OSC10e, a Ubuntu 16 LTS box)
- https://appuals.com/export-virtual-machine-to-ova-file-in-oracle-vm-virtualbox/

# CLI
- https://www.oracle.com/technical-resources/articles/it-infrastructure/admin-manage-vbox-cli.html
- https://www.virtualbox.org/wiki/Guest_OSes


# Creating a Virtualbox:
- https://ubuntu.com/tutorials/how-to-run-ubuntu-desktop-on-a-virtual-machine-using-virtualbox#2-create-a-new-virtual-machine
    
