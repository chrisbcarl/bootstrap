ls
# (hd0) (hd0,msdos4) (hd0,msdos3)...
# ls (hd0,4) ... boot/ dos/ windows/ etc/
# ls (hd0,3) ... vmlinuz-4.15.0-45-generic ...
set root=(hd0,4)
set prefix= (hd0,3)/grub
insmod normal
normal
