- https://stackoverflow.com/questions/9811742/boot-a-native-os-on-a-hard-disk-as-a-virtual-machine
- New Virtual Machine
    - Typical
    - I will install the operating system later
    - Guest operating system > Other
    - Version > Other
    - Store virtual disk as a single file
- RUN AS ADMINISTRATOR
- Settings
    - Change memory/processors
    - Add...
        - Hard Disk
        - SATA
        - Use a physical disk (for advanced users)
            - Powershell

            ```powershell
            Get-Disk  # to find the physical disk drive number
            ```

            - Device > PhysicalDriveX
            - Disk File > STORE IT WHERE YOU STORE VMS, otherwise it goes to the default location, maybe you've changed it
    - Options tab
        - Advanced
            - Disable Enable side channel mitigations for Hyper-V enabled hosts