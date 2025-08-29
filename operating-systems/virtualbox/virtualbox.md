# SSH into VirtualBox
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
