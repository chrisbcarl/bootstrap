# 2025 16" ASUS ROG STRIX SCAR 16 (RTX5090) [CU2,24C,HX] + RTX PRO 6000 @ 32Gbps-TB4>TB5 (Minisforum DEG2) + Win11 // Blackwell eGPU + RTX 5090 dGPU working simultaneously
- [Source](https://egpu.io/forums/builds/2025-16-asus-rog-strix-scar-16-rtx5090-cu224chx-rtx-pro-6000-32gbps-tb4tb5-minisforum-deg2-win11-inc-procedure-to-get-blackwell-egpu-rtx-5090-dgpu-working-simultaneously/)

Document
[![ikawanaoki](https://secure.gravatar.com/avatar/8fcaee355f77b15e15fa9ddeff83404f?s=80&d=mm&r=g)](https://egpu.io/forums/profile/ikawanaoki/  "ikawanaoki")
[ikawanaoki](https://egpu.io/forums/profile/ikawanaoki/ "ikawanaoki")
(@ikawanaoki)
New Member
Joined: 2 months ago
[Builds: 1](/builds/?table_filter="\[ikawanaoki]%20"#search "show ikawanaoki's builds")
[Posts: 3](/forums/?wpfd=0&wpfob=date&wpfo=desc&wpfs=ikawanaoki&wpfin=user-posts&profile=ikawanaoki "show ikawanaoki's posts")
May 3, 2026 9:20 am


**Summary**
I successfully got an ASUS ROG STRIX SCAR 16 with an internal NVIDIA GeForce [RTX 5090](/go/nvidiartx5090 "Check price on Amazon") Laptop GPU working together with an external NVIDIA RTX PRO 6000 Blackwell Workstation Edition connected through a [DEG2](/go/minisforumdeg2 "Check price on Amazon") Thunderbolt 5 eGPU adapter.
Initially, I assumed that an INF modification might be required, because the GeForce Laptop GPU and RTX PRO GPU seemed to belong to different [NVIDIA driver](https://www.nvidia.com/Download/index.aspx?lang=en-us "Download link") categories. However, the final working solution did **not** require any INF modification.
The key was to use the NVIDIA Studio Driver package and register all INF files in the extracted `Display.Driver` folder with `pnputil`.
The result was:
> Code:
>
> Copy
>
> ```
> RTX 5090 Laptop GPU          → nvamsi.inf
> RTX PRO 6000 Blackwell eGPU  → nv_dispsi.inf
> ```
Both devices are now detected by Windows PnP and `nvidia-smi`.
**System specs** (model inc screen size, CPU, iGPU, dGPU, operating system which eGPU is being used)
2025 16" ASUS ROG STRIX SCAR 16
- Intel® Core™ Ultra 9 processor 275HX  (8P + 16E - 24C / 24T), up to 5.40 GHz
- Windows 11
- Internal GPU: NVIDIA GeForce [RTX 5090](/go/nvidiartx5090 "Check price on Amazon") Laptop GPU
  VRAM: 24GB
  Device ID: DEV\_2C58
  Subsystem ID: SUBSYS\_3E481043
**eGPU hardware** (eGPU enclosure, video card, external LCD attached to eGPU, any third-party [TB3 cable](/go/tb3cable "Check price on Amazon"), any custom mods)
- eGPU: [MINISFORUM DEG2](/go/minisforumdeg2 "Check price on Amazon") Thunderbolt 5 eGPU adapter
- NVIDIA RTX PRO 6000 Blackwell Workstation Edition
  VRAM: 96GB
  Device ID: DEV\_2BB1
  Subsystem ID: SUBSYS\_204B10DE
  Driver: NVIDIA Studio Driver 596.36
  CUDA 13.2
**Hardware pictures** (paste images or link eg:  [http://imgur.com](http://imgur.com/) . Underside systemboard pics if attaching M.2 eGPU are welcome)
[![image](https://egpu.io/wp-content/uploads/wpforo/attachments/255876/thumbnail/23185-image.png)](https://egpu.io/wp-content/uploads/wpforo/attachments/255876/23185-image.png)
**Final result**
`Get-PnpDevice` output:
> Code:
>
> Copy
>
> ```
> Get-PnpDevice -Class Display | Format-Table Status,FriendlyName,InstanceId -Auto
> ```
> Code:
>
> Copy
>
> ```
> Status FriendlyName                                      InstanceId
> ------ ------------                                      ----------
> OK     Intel(R) Graphics                                 PCI\VEN_8086&DEV_7D67&SUBSYS_3E481043...
> OK     NVIDIA GeForce RTX 5090 Laptop GPU                PCI\VEN_10DE&DEV_2C58&SUBSYS_3E481043...
> OK     NVIDIA RTX PRO 6000 Blackwell Workstation Edition PCI\VEN_10DE&DEV_2BB1&SUBSYS_204B10DE...
> ```
`nvidia-smi -L` output:
> Code:
>
> Copy
>
> ```
> GPU 0: NVIDIA GeForce RTX 5090 Laptop GPU
> GPU 1: NVIDIA RTX PRO 6000 Blackwell Workstation Edition
> ```
`nvidia-smi` showed both GPUs:
> Code:
>
> Copy
>
> ```
> +-----------------------------------------------------------------------------------------+
> | NVIDIA-SMI 596.36                 Driver Version: 596.36         CUDA Version: 13.2     |
> +-----------------------------------------+------------------------+----------------------+
> | GPU  Name                  Driver-Model | Bus-Id          Disp.A | Volatile Uncorr. ECC |
> | Fan  Temp   Perf          Pwr:Usage/Cap |           Memory-Usage | GPU-Util  Compute M. |
> |                                         |                        |               MIG M. |
> |=========================================+========================+======================|
> |   0  NVIDIA GeForce RTX 5090 ...  WDDM  |   00000000:01:00.0  On |                  N/A |
> | N/A   45C    P8             11W /   95W |     561MiB /  24463MiB |      0%      Default |
> |                                         |                        |                  N/A |
> +-----------------------------------------+------------------------+----------------------+
> |   1  NVIDIA RTX PRO 6000 Blac...  WDDM  |   00000000:09:00.0 Off |                  Off |
> | 30%   29C    P8              7W /  600W |       0MiB /  97887MiB |      0%      Default |
> |                                         |                        |                  N/A |
> +-----------------------------------------+------------------------+----------------------+
> ```
**Benchmarks** (Include [CUDA-Z](https://cuda-z.sourceforge.net "Download link") or [AIDA64](https://www.aida64.com/downloads "Download link") [eGPU bandwidth](https://egpu.io/builds#perf "Answers Q: What do the 'eGPU port' acronyms like 32Gbps-TB3 mean and what are their ranked & measured peak bandwidths? Includes pictural instructions on how to measure your eGPU port's bandwidth") (write/H2D) + [GPU-Z](https://www.techpowerup.com/download/techpowerup-gpu-z/ "Download link") pic. See bottom of [eGPU bandwidth](https://egpu.io/builds#perf "Answers Q: What do the 'eGPU port' acronyms like 32Gbps-TB3 mean and what are their ranked & measured peak bandwidths? Includes pictural instructions on how to measure your eGPU port's bandwidth") for click instructions if using [AIDA64](https://www.aida64.com/downloads "Download link") **Trial** to show **write** bandwidth. Optional: [Valley](https://benchmark.unigine.com/valley), [3dmark](https://www.futuremark.com/benchmarks), [llm-benchmark](https://github.com/aidatatools/ollama-benchmark) & note if it's on internal or external LCD).
**PCIe link verification**
[GPU-Z](https://www.techpowerup.com/download/techpowerup-gpu-z/ "Download link") 2.69.0 reports the external RTX PRO 6000 Blackwell as:
> PCIe x16 5.0 @ x4 4.0
`nvidia-smi -q` also reports the RTX PRO 6000 eGPU link as:
> PCIe Generation:
> Max: 4
> Current: 4
> Device Current: 4
> Device Max: 5
> Host Max: 4
>
> Link Width:
> Max: 16x
> Current: 4x
Therefore, the eGPU is exposed to Windows/[NVIDIA driver](https://www.nvidia.com/Download/index.aspx?lang=en-us "Download link") as a PCIe Gen4 x4 link through the [DEG2](/go/minisforumdeg2 "Check price on Amazon"). I used a [Thunderbolt 5 cable](/go/tb5cable "Check price on Amazon"), but I have not separately verified the raw Thunderbolt/USB4 negotiated link rate.
**ECC verification**
ECC was initially disabled on the RTX PRO 6000 Blackwell eGPU.
Initial state:
`nvidia-smi -i 1 -q -d ECC`
> ECC Mode
> Current : Disabled
> Pending : Disabled
I enabled ECC from an Administrator PowerShell:
`nvidia-smi -i 1 -e 1`
> The command succeeded:
>
> Enabled ECC support for GPU 00000000:09:00.0.
> All done.
> Reboot required.
After rebooting, ECC was enabled successfully:
`nvidia-smi -i 1 -q -d ECC`
> ECC Mode
> Current : Enabled
> Pending : Enabled
>
> All reported SRAM and DRAM ECC error counters were 0.
> Channel Repair Pending, TPC Repair Pending, and Unrepairable Memory were all No.
This confirms that ECC can be enabled on the RTX PRO 6000 Blackwell eGPU in this configuration using NVIDIA Studio Driver 596.36.
**Working procedure**
### 1. Clean up existing NVIDIA drivers with DDU
I first removed the existing [NVIDIA drivers](https://www.nvidia.com/Download/index.aspx?lang=en-us "Download link") using Display Driver Uninstaller.
At this stage, the [DEG2](/go/minisforumdeg2 "Check price on Amazon") eGPU was physically disconnected.
> Code:
>
> Copy
>
> ```
> State:
>   ROG laptop only
>   DEG2/eGPU disconnected
>   Network temporarily disconnected
> ```
### 2. Install NVIDIA Studio Driver
I installed NVIDIA Studio Driver 596.36 for the internal [RTX 5090](/go/nvidiartx5090 "Check price on Amazon") Laptop GPU.
After installation, I confirmed that the internal [RTX 5090](/go/nvidiartx5090 "Check price on Amazon") Laptop GPU was detected correctly.
###
### 3. Keep a copy of the extracted Display.Driver folder
During [NVIDIA driver](https://www.nvidia.com/Download/index.aspx?lang=en-us "Download link") installation, the installer extracts its files to a temporary folder, such as:
> Code:
>
> Copy
>
> ```
> C:\Windows\Temp\xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx\Display.Driver
> ```
Since this folder may disappear later, I copied it to a working folder.
Example:
> Code:
>
> Copy
>
> ```
> mkdir C:\NVIDIA_STUDIO_WORK
> robocopy "C:\Windows\Temp\xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx\Display.Driver" "C:\NVIDIA_STUDIO_WORK\Display.Driver" /E
> ```
###
### 4. Check the INF files for both Device IDs
Open an Administrator PowerShell and move to the copied `Display.Driver` folder.
> Code:
>
> Copy
>
> ```
> cd "C:\NVIDIA_STUDIO_WORK\Display.Driver"
> ```
Search for the [RTX 5090](/go/nvidiartx5090 "Check price on Amazon") Laptop GPU Device ID:
> Code:
>
> Copy
>
> ```
> findstr /i "2C58" *.inf
>
> C:\NVIDIA_STUDIO_WORK\Display.Driver>findstr /i "2C58" *.inf
> nvacsi.inf:%NVIDIA_DEV.2C58.1826.1025% = Section106, PCI\VEN_10DE&DEV_2C58&SUBSYS_18261025
> nvacsi.inf:%NVIDIA_DEV.2C58.182C.1025% = Section107, PCI\VEN_10DE&DEV_2C58&SUBSYS_182C1025
> nvacsi.inf:%NVIDIA_DEV.2C58.2063.1025% = Section109, PCI\VEN_10DE&DEV_2C58&SUBSYS_20631025
> nvacsi.inf:NVIDIA_DEV.2C58.1826.1025 = "NVIDIA GeForce RTX 5090 Laptop GPU"
> nvacsi.inf:NVIDIA_DEV.2C58.182C.1025 = "NVIDIA GeForce RTX 5090 Laptop GPU"
> nvacsi.inf:NVIDIA_DEV.2C58.2063.1025 = "NVIDIA GeForce RTX 5090 Laptop GPU"
> nvamsi.inf:%NVIDIA_DEV.2C58.3539.1043% = Section247, PCI\VEN_10DE&DEV_2C58&SUBSYS_35391043
> nvamsi.inf:%NVIDIA_DEV.2C58.35C9.1043% = Section248, PCI\VEN_10DE&DEV_2C58&SUBSYS_35C91043
> nvamsi.inf:%NVIDIA_DEV.2C58.39D8.1043% = Section250, PCI\VEN_10DE&DEV_2C58&SUBSYS_39D81043
> nvamsi.inf:%NVIDIA_DEV.2C58.3A28.1043% = Section252, PCI\VEN_10DE&DEV_2C58&SUBSYS_3A281043
> nvamsi.inf:%NVIDIA_DEV.2C58.3AD9.1043% = Section253, PCI\VEN_10DE&DEV_2C58&SUBSYS_3AD91043
> nvamsi.inf:%NVIDIA_DEV.2C58.3B29.1043% = Section254, PCI\VEN_10DE&DEV_2C58&SUBSYS_3B291043
> nvamsi.inf:%NVIDIA_DEV.2C58.3E48.1043% = Section256, PCI\VEN_10DE&DEV_2C58&SUBSYS_3E481043
> nvamsi.inf:%NVIDIA_DEV.2C58.3EC8.1043% = Section258, PCI\VEN_10DE&DEV_2C58&SUBSYS_3EC81043
> nvamsi.inf:NVIDIA_DEV.2C58.3539.1043 = "NVIDIA GeForce RTX 5090 Laptop GPU"
> nvamsi.inf:NVIDIA_DEV.2C58.35C9.1043 = "NVIDIA GeForce RTX 5090 Laptop GPU"
> nvamsi.inf:NVIDIA_DEV.2C58.39D8.1043 = "NVIDIA GeForce RTX 5090 Laptop GPU"
> nvamsi.inf:NVIDIA_DEV.2C58.3A28.1043 = "NVIDIA GeForce RTX 5090 Laptop GPU"
> nvamsi.inf:NVIDIA_DEV.2C58.3AD9.1043 = "NVIDIA GeForce RTX 5090 Laptop GPU"
> nvamsi.inf:NVIDIA_DEV.2C58.3B29.1043 = "NVIDIA GeForce RTX 5090 Laptop GPU"
> nvamsi.inf:NVIDIA_DEV.2C58.3E48.1043 = "NVIDIA GeForce RTX 5090 Laptop GPU"
> nvamsi.inf:NVIDIA_DEV.2C58.3EC8.1043 = "NVIDIA GeForce RTX 5090 Laptop GPU"
> nvbydsi.inf:%NVIDIA_DEV.2C58.8102.1B61% = Section018, PCI\VEN_10DE&DEV_2C58&SUBSYS_81021B61
> nvbydsi.inf:NVIDIA_DEV.2C58.8102.1B61 = "NVIDIA GeForce RTX 5090 Laptop GPU"
> nvcvsi.inf:%NVIDIA_DEV.2C58.5700.1558% = Section035, PCI\VEN_10DE&DEV_2C58&SUBSYS_57001558
> nvcvsi.inf:%NVIDIA_DEV.2C58.5802.1558% = Section035, PCI\VEN_10DE&DEV_2C58&SUBSYS_58021558
> nvcvsi.inf:NVIDIA_DEV.2C58.5700.1558 = "NVIDIA GeForce RTX 5090 Laptop GPU"
> nvcvsi.inf:NVIDIA_DEV.2C58.5802.1558 = "NVIDIA GeForce RTX 5090 Laptop GPU"
> nvdmsi.inf:%NVIDIA_DEV.2C58.0CCC.1028% = Section398, PCI\VEN_10DE&DEV_2C58&SUBSYS_0CCC1028
> nvdmsi.inf:%NVIDIA_DEV.2C58.0CCD.1028% = Section398, PCI\VEN_10DE&DEV_2C58&SUBSYS_0CCD1028
> nvdmsi.inf:%NVIDIA_DEV.2C58.0DFC.1028% = Section398, PCI\VEN_10DE&DEV_2C58&SUBSYS_0DFC1028
> nvdmsi.inf:%NVIDIA_DEV.2C58.0DFD.1028% = Section398, PCI\VEN_10DE&DEV_2C58&SUBSYS_0DFD1028
> nvdmsi.inf:NVIDIA_DEV.2C58.0CCC.1028 = "NVIDIA GeForce RTX 5090 Laptop GPU"
> nvdmsi.inf:NVIDIA_DEV.2C58.0CCD.1028 = "NVIDIA GeForce RTX 5090 Laptop GPU"
> nvdmsi.inf:NVIDIA_DEV.2C58.0DFC.1028 = "NVIDIA GeForce RTX 5090 Laptop GPU"
> nvdmsi.inf:NVIDIA_DEV.2C58.0DFD.1028 = "NVIDIA GeForce RTX 5090 Laptop GPU"
> nvgbsi.inf:%NVIDIA_DEV.2C58.8000.1458% = Section045, PCI\VEN_10DE&DEV_2C58&SUBSYS_80001458
> nvgbsi.inf:%NVIDIA_DEV.2C58.9205.1458% = Section047, PCI\VEN_10DE&DEV_2C58&SUBSYS_92051458
> nvgbsi.inf:NVIDIA_DEV.2C58.8000.1458 = "NVIDIA GeForce RTX 5090 Laptop GPU"
> nvgbsi.inf:NVIDIA_DEV.2C58.9205.1458 = "NVIDIA GeForce RTX 5090 Laptop GPU"
> nvhmsi.inf:%NVIDIA_DEV.2C58.8D41.103C% = Section106, PCI\VEN_10DE&DEV_2C58&SUBSYS_8D41103C
> nvhmsi.inf:%NVIDIA_DEV.2C58.8E9A.103C% = Section107, PCI\VEN_10DE&DEV_2C58&SUBSYS_8E9A103C
> nvhmsi.inf:NVIDIA_DEV.2C58.8D41.103C = "NVIDIA GeForce RTX 5090 Laptop GPU"
> nvhmsi.inf:NVIDIA_DEV.2C58.8E9A.103C = "NVIDIA GeForce RTX 5090 Laptop GPU"
> nvltsi.inf:%NVIDIA_DEV.2C58.3F94.17AA% = Section547, PCI\VEN_10DE&DEV_2C58&SUBSYS_3F9417AA
> nvltsi.inf:%NVIDIA_DEV.2C58.8010.17AA% = Section548, PCI\VEN_10DE&DEV_2C58&SUBSYS_801017AA
> nvltsi.inf:NVIDIA_DEV.2C58.3F94.17AA = "NVIDIA GeForce RTX 5090 Laptop GPU"
> nvltsi.inf:NVIDIA_DEV.2C58.8010.17AA = "NVIDIA GeForce RTX 5090 Laptop GPU"
> nvrzsi.inf:%NVIDIA_DEV.2C58.300E.1A58% = Section075, PCI\VEN_10DE&DEV_2C58&SUBSYS_300E1A58
> nvrzsi.inf:%NVIDIA_DEV.2C58.300F.1A58% = Section076, PCI\VEN_10DE&DEV_2C58&SUBSYS_300F1A58
> nvrzsi.inf:%NVIDIA_DEV.2C58.3010.1A58% = Section078, PCI\VEN_10DE&DEV_2C58&SUBSYS_30101A58
> nvrzsi.inf:%NVIDIA_DEV.2C58.3011.1A58% = Section080, PCI\VEN_10DE&DEV_2C58&SUBSYS_30111A58
> nvrzsi.inf:NVIDIA_DEV.2C58.300E.1A58 = "NVIDIA GeForce RTX 5090 Laptop GPU"
> nvrzsi.inf:NVIDIA_DEV.2C58.300F.1A58 = "NVIDIA GeForce RTX 5090 Laptop GPU"
> nvrzsi.inf:NVIDIA_DEV.2C58.3010.1A58 = "NVIDIA GeForce RTX 5090 Laptop GPU"
> nvrzsi.inf:NVIDIA_DEV.2C58.3011.1A58 = "NVIDIA GeForce RTX 5090 Laptop GPU"
> nvtfsi.inf:%NVIDIA_DEV.2C58.606D.1D05% = Section160, PCI\VEN_10DE&DEV_2C58&SUBSYS_606D1D05
> nvtfsi.inf:NVIDIA_DEV.2C58.606D.1D05 = "NVIDIA GeForce RTX 5090 Laptop GPU"
> ```
Search for the RTX PRO 6000 Blackwell Device ID:
> Code:
>
> Copy
>
> ```
> findstr /i "2BB1" *.inf
>
> C:\NVIDIA_STUDIO_WORK\Display.Driver>findstr /i "2BB1" *.inf
> nvdwsi.inf:%NVIDIA_DEV.2BB1.204B.1028% = Section019, PCI\VEN_10DE&DEV_2BB1&SUBSYS_204B1028
> nvdwsi.inf:NVIDIA_DEV.2BB1.204B.1028 = "NVIDIA RTX PRO 6000 Blackwell Workstation Edition"
> nvltsi.inf:%NVIDIA_DEV.1EB5.22BB.17AA% = Section005, PCI\VEN_10DE&DEV_1EB5&SUBSYS_22BB17AA
> nvltsi.inf:%NVIDIA_DEV.1EB6.22BB.17AA% = Section005, PCI\VEN_10DE&DEV_1EB6&SUBSYS_22BB17AA
> nvltsi.inf:%NVIDIA_DEV.1F36.22BB.17AA% = Section005, PCI\VEN_10DE&DEV_1F36&SUBSYS_22BB17AA
> nvltsi.inf:%NVIDIA_DEV.1FB8.22BB.17AA% = Section090, PCI\VEN_10DE&DEV_1FB8&SUBSYS_22BB17AA
> nvltsi.inf:%NVIDIA_DEV.1FB9.22BB.17AA% = Section090, PCI\VEN_10DE&DEV_1FB9&SUBSYS_22BB17AA
> nvlwsi.inf:%NVIDIA_DEV.2BB1.204B.17AA% = Section022, PCI\VEN_10DE&DEV_2BB1&SUBSYS_204B17AA
> nvlwsi.inf:NVIDIA_DEV.2BB1.204B.17AA = "NVIDIA RTX PRO 6000 Blackwell Workstation Edition"
> nvmisi.inf:%NVIDIA_DEV.1F95.12BB.1462% = Section025, PCI\VEN_10DE&DEV_1F95&SUBSYS_12BB1462
> nvmisi.inf:%NVIDIA_DEV.1F99.12BB.1462% = Section025, PCI\VEN_10DE&DEV_1F99&SUBSYS_12BB1462
> nvwusi.inf:%NVIDIA_DEV.2BB1.204B.103C% = Section017, PCI\VEN_10DE&DEV_2BB1&SUBSYS_204B103C
> nvwusi.inf:NVIDIA_DEV.2BB1.204B.103C = "NVIDIA RTX PRO 6000 Blackwell Workstation Edition"
> nv_dispsi.inf:%NVIDIA_DEV.2BB1.204B.10DE% = Section049, PCI\VEN_10DE&DEV_2BB1&SUBSYS_204B10DE
> nv_dispsi.inf:NVIDIA_DEV.2BB1.204B.10DE = "NVIDIA RTX PRO 6000 Blackwell Workstation Edition"
> ```
### 5. Shut down and connect the DEG2 + RTX PRO 6000
Shut down the PC:
> Code:
>
> Copy
>
> ```
> shutdown /s /t 0
> ```
Then connect the RTX PRO 6000 Blackwell to the [DEG2](/go/minisforumdeg2 "Check price on Amazon"), check the auxiliary power cables, connect the [Thunderbolt 5 cable](/go/tb5cable "Check price on Amazon"), and boot Windows.
###
### 6. Register all INF files with pnputil
This was the most important step.
Instead of manually selecting a driver for only one GPU through Device Manager, I registered all INF files from the NVIDIA Studio Driver `Display.Driver` folder.
Administrator PowerShell:
> Code:
>
> Copy
>
> ```
> cd "C:\NVIDIA_STUDIO_WORK\Display.Driver"
> pnputil /add-driver "*.inf" /install
> ```
I did not need `/subdirs` in my case, because the required INF files were directly under `Display.Driver`.
Windows then automatically selected the appropriate INF for each GPU:
> Code:
>
> Copy
>
> ```
> RTX 5090 Laptop GPU:
>   nvamsi.inf
> RTX PRO 6000 Blackwell Workstation Edition:
>   nv_dispsi.inf
> ```
###
### 7. Reboot
> Code:
>
> Copy
>
> ```
> shutdown /r /t 0
> ```
###
### 8. Verify
After rebooting, I verified the system with:
> Code:
>
> Copy
>
> ```
> Get-PnpDevice -Class Display | Format-Table Status,FriendlyName,InstanceId -Auto
> ```
> Code:
>
> Copy
>
> ```
> nvidia-smi
> ```
> Code:
>
> Copy
>
> ```
> nvidia-smi -L
> ```
> Code:
>
> Copy
>
> ```
> Command:
> pnputil /enum-devices /class Display /drivers
>
> Result summary:
>
> Device 1:
> Instance ID:
> PCI\VEN_8086&DEV_7D67&SUBSYS_3E481043&REV_06\3&11583659&0&10
>
> Device description:
> Intel(R) Graphics
>
> Class:
> Display
>
> Manufacturer:
> Intel Corporation
>
> Status:
> Started
>
> Installed driver:
> oem165.inf
>
> Extension driver:
> oem40.inf
>
> Matching drivers:
> - Driver name: oem165.inf
>   Original name: iigd_dch.inf
>   Provider: Intel Corporation
>   Class: Display
>   Driver version: 10/13/2025 32.0.101.8243
>   Signer: Microsoft Windows Hardware Compatibility Publisher
>   Matching device ID: PCI\VEN_8086&DEV_7D67&SUBSYS_3E481043
>   Driver rank: 00CF0001
>   Driver status: Best / Installed
>
> - Driver name: oem40.inf
>   Original name: iigd_ext.inf
>   Provider: Intel Corporation
>   Class: Extension
>   Driver version: 10/13/2025 32.0.101.8243
>   Signer: Microsoft Windows Hardware Compatibility Publisher
>   Matching device ID: PCI\VEN_8086&DEV_7D67&SUBSYS_3E481043
>   Driver rank: 00FF0001
>   Driver status: Best / Installed / Extension
>
> Device 2:
> Instance ID:
> PCI\VEN_10DE&DEV_2C58&SUBSYS_3E481043&REV_A1\8F3AF5BE932DB04800
>
> Device description:
> NVIDIA GeForce RTX 5090 Laptop GPU
>
> Class:
> Display
>
> Manufacturer:
> NVIDIA
>
> Status:
> Started
>
> Installed driver:
> oem30.inf
>
> Matching driver:
> - Driver name: oem30.inf
>   Original name: nvamsi.inf
>   Provider: NVIDIA
>   Class: Display
>   Driver version: 04/23/2026 32.0.15.9636
>   Signer: Microsoft Windows Hardware Compatibility Publisher
>   Matching device ID: PCI\VEN_10DE&DEV_2C58&SUBSYS_3E481043
>   Driver rank: 00CF0001
>   Driver status: Best / Installed
>
> Device 3:
> Instance ID:
> PCI\VEN_10DE&DEV_2BB1&SUBSYS_204B10DE&REV_A1\9EDF5900292DB04800
>
> Device description:
> NVIDIA RTX PRO 6000 Blackwell Workstation Edition
>
> Class:
> Display
>
> Manufacturer:
> NVIDIA
>
> Status:
> Started
>
> Installed driver:
> oem270.inf
>
> Matching driver:
> - Driver name: oem270.inf
>   Original name: nv_dispsi.inf
>   Provider: NVIDIA
>   Class: Display
>   Driver version: 04/23/2026 32.0.15.9636
>   Signer: Microsoft Windows Hardware Compatibility Publisher
>   Matching device ID: PCI\VEN_10DE&DEV_2BB1&SUBSYS_204B10DE
>   Driver rank: 00CF0001
>   Driver status: Best / Installed
> ```
**Important notes**
### No INF modification was required
At first, I considered adding the [RTX 5090](/go/nvidiartx5090 "Check price on Amazon") Laptop GPU Device ID to the RTX PRO INF file.
This turned out to be unnecessary.
The [RTX 5090](/go/nvidiartx5090 "Check price on Amazon") Laptop GPU was already properly defined in the ASUS/OEM mobile INF file, `nvamsi.inf`, with the correct `SUBSYS_3E481043`.
Forcing the laptop GPU into the RTX PRO INF section could potentially break laptop-specific behavior such as power management, MUX/Advanced Optimus behavior, or internal display handling.
###
### Avoid manually forcing one GPU to use the wrong driver
Manually selecting a driver for only one GPU through Device Manager can break the other GPU’s driver binding.
The successful approach was:
> Code:
>
> Copy
>
> ```
> Register all INF files and let Windows choose the best matching INF for each GPU.
> ```
###
### Be careful with Windows Update
Windows Update may install a different [NVIDIA driver](https://www.nvidia.com/Download/index.aspx?lang=en-us "Download link") version and break the working configuration.
Once the system is stable, it is better to manage [NVIDIA driver](https://www.nvidia.com/Download/index.aspx?lang=en-us "Download link") updates manually.
If Windows binds the wrong INF after a driver update, repeat the pnputil step from the same Display.Driver folder, or reinstall the known-working NVIDIA Studio Driver package.
**Using the RTX PRO 6000 as an AI compute GPU**
In this system, `nvidia-smi -L` reported:
> Code:
>
> Copy
>
> ```
> GPU 0: NVIDIA GeForce RTX 5090 Laptop GPU
> GPU 1: NVIDIA RTX PRO 6000 Blackwell Workstation Edition
> ```
Please verify the GPU index with nvidia-smi -L before setting CUDA\_VISIBLE\_DEVICES, because the index may vary depending on the system configuration.
To use only the RTX PRO 6000 for CUDA applications:
> Code:
>
> Copy
>
> ```
> $env:CUDA_VISIBLE_DEVICES="1"
> ```
Example for Ollama:
> Code:
>
> Copy
>
> ```
> $env:CUDA_VISIBLE_DEVICES="1"
> ollama serve
> ```
Example LM Studio launcher BAT:
> Code:
>
> Copy
>
> ```
> @echo off
> set CUDA_VISIBLE_DEVICES=1
> start "" "C:\Users\%USERNAME%\AppData\Local\Programs\LM Studio\LM Studio.exe"
> ```
**Conclusion**
This setup worked without modifying NVIDIA INF files.
> Code:
>
> Copy
>
> ```
> ASUS ROG STRIX SCAR 16
>   Internal GPU:
>     NVIDIA GeForce RTX 5090 Laptop GPU
>     DEV_2C58 / SUBSYS_3E481043
>     nvamsi.inf
> External GPU:
>   DEG2 TB5/USB4 eGPU adapter
>   NVIDIA RTX PRO 6000 Blackwell Workstation Edition
>   DEV_2BB1 / SUBSYS_204B10DE
>   nv_dispsi.inf
> Driver:
>   NVIDIA Studio Driver 596.36
>   CUDA 13.2
> ```
The key command was:
> Code:
>
> Copy
>
> ```
> pnputil /add-driver "*.inf" /install
> ```
This allowed Windows to bind each NVIDIA GPU to its correct INF file:
> Code:
>
> Copy
>
> ```
> RTX 5090 Laptop GPU → ASUS/OEM mobile INF
> RTX PRO 6000 eGPU  → RTX PRO INF
> ```
**ECC:**
Enabled after running nvidia-smi -i 1 -e 1 and rebooting
> ECC error counters: 0
**Benchmarks** (Include [CUDA-Z](https://cuda-z.sourceforge.net "Download link") or [AIDA64](https://www.aida64.com/downloads "Download link") [eGPU bandwidth](https://egpu.io/builds#perf "Answers Q: What do the 'eGPU port' acronyms like 32Gbps-TB3 mean and what are their ranked & measured peak bandwidths? Includes pictural instructions on how to measure your eGPU port's bandwidth") (write/H2D) + [GPU-Z](https://www.techpowerup.com/download/techpowerup-gpu-z/ "Download link") pic. See bottom of [eGPU bandwidth](https://egpu.io/builds#perf "Answers Q: What do the 'eGPU port' acronyms like 32Gbps-TB3 mean and what are their ranked & measured peak bandwidths? Includes pictural instructions on how to measure your eGPU port's bandwidth") for click instructions if using [AIDA64](https://www.aida64.com/downloads "Download link") **Trial** to show **write** bandwidth. Optional: [Valley](https://benchmark.unigine.com/valley), [3dmark](https://www.futuremark.com/benchmarks), [llm-benchmark](https://github.com/aidatatools/ollama-benchmark) & note if it's on internal or external LCD).
**Comments**
I hope this helps anyone trying to run a GeForce Laptop GPU and an RTX PRO Blackwell eGPU simultaneously on the same Windows system.
**Acknowledgement**
ChatGPT 5.5 helped with the analysis and with preparing this report.
---
**Update: LM Studio memory usage tip for Windows + large VRAM NVIDIA eGPU**
I also tested LM Studio on this Windows 11 + [DEG2](/go/minisforumdeg2 "Check price on Amazon") TB5/USB4 eGPU + NVIDIA RTX PRO 6000 Blackwell Workstation Edition setup.
One important finding is that LM Studio’s default load setting, especially **“Try mmap()”**, can cause very large system RAM usage even when the model itself is fully loaded into GPU VRAM.
Test model:
- Qwen3.6-35B-A3B
- Model size: approximately 36 GB class
- GPU: RTX PRO 6000 Blackwell, 96 GB VRAM
- System RAM: 64 GB
With **“Try mmap()” enabled**:
- RTX PRO 6000 VRAM usage: about 36 GB
- LM Studio process system RAM usage: about 35–38 GB
After disabling “Try mmap()” and reloading the model:
- RTX PRO 6000 VRAM usage: still about 36 GB
- LM Studio process system RAM usage: reduced to about 11.8 GB
In this configuration, disabling **“Try mmap()”** was very effective. The model still stayed in GPU VRAM, but the duplicate-looking system RAM usage was greatly reduced.
My current recommended LM Studio load settings for this large-VRAM eGPU setup are:
- GPU offload: maximum / all layers
- Offload KV cache to GPU memory: enabled
- Flash Attention: enabled
- Keep model in memory: disabled
- Try mmap(): disabled
This behavior may depend on the LM Studio version, model format, Windows memory management, and the llama.cpp/CUDA backend. Users with smaller VRAM or partial GPU offload setups may see different results.
For my RTX PRO 6000 96 GB eGPU setup, disabling **“Try mmap()”** made LM Studio much more practical with 64 GB of system RAM.
**Additional Update: Qwen3-Next-80B is also practical on this setup**
I also tested a larger model, **qwen/qwen3-next-80b**, on the same Windows 11 + [DEG2](/go/minisforumdeg2 "Check price on Amazon") TB5/USB4 eGPU + NVIDIA RTX PRO 6000 Blackwell setup.
One more important finding: the same LM Studio memory behavior also appeared with the 80B-class model. With the default load settings, system RAM usage became very high. After changing the load settings to disable both **“Keep model in memory”** and **“Try mmap()”**, the model became practical to run with 64 GB of system RAM.
Test environment
- Host PC: ASUS ROG STRIX SCAR 16
- OS: Windows 11
- eGPU adapter: [DEG2](/go/minisforumdeg2 "Check price on Amazon") TB5/USB4
- GPU: NVIDIA RTX PRO 6000 Blackwell Workstation Edition, 96 GB VRAM
- System RAM: 64 GB
- Page file: fixed at 65536 MB / 65536 MB
- LM Studio model: qwen/qwen3-next-80b
Initial load with default-like settings:
- System RAM in use: about 56.2 GB
- Available RAM: about 7.0 GB
- Committed memory: about 67 / 127 GB
After disabling **“Keep model in memory”** and **“Try mmap()”**, then reloading the model:
- System RAM in use: about 11.6 GB
- Available RAM: about 51.6 GB
- Committed memory: about 68 / 127 GB
- Cached memory: about 51.5 GB
This means the physical system RAM usage dropped from about **56 GB to about 12 GB**, while the committed memory remained roughly the same. In other words, disabling these two options greatly reduced physical RAM residency, even though LM Studio still reserved a large amount of commit.
Because of this behavior, increasing the Windows page file was also useful. I changed the page file to a fixed **64 GB** size, which increased the commit limit from about 73 GB to about 127 GB. This made the setup much more stable for larger models that reserve a large amount of committed memory.
My current practical settings for large models on this setup are:
- Keep model in memory: disabled
- Try mmap(): disabled
- GPU offload: maximum / all layers
- Offload KV cache to GPU memory: enabled
- Flash Attention: enabled
- Page file: fixed 65536 MB / 65536 MB
With these settings, **qwen/qwen3-next-80b became practical on this RTX PRO 6000 96 GB eGPU setup, even with only 64 GB of system RAM**.
This behavior may depend on the LM Studio version, Windows memory management, model format, and the llama.cpp/CUDA backend. However, for this large-VRAM eGPU configuration, disabling **“Try mmap()”** and **“Keep model in memory”** was essential.


This topic was modified 2 months ago

[2025 16" ASUS ROG STRIX SCAR 16](/go/a/ASUS+ROG+STRIX+SCAR+16 "Check price on Amazon") (RTX5090) [CU2,24C,HX] + [RTX PRO 6000](/go/ev/Nvidia+RTX+PRO+6000 "Check price on eBay") @ 32Gbps-TB4>TB5 ([Minisforum DEG2](/go/minisforumdeg2 "Check price on Amazon")) + Win11 // Blackwell eGPU + [RTX 5090](/go/nvidiartx5090 "Check price on Amazon") dGPU working simultaneously [[build link]](/forums/builds/2025-16-asus-rog-strix-scar-16-rtx5090-cu224chx-rtx-pro-6000-32gbps-tb4tb5-minisforum-deg2-win11-inc-procedure-to-get-blackwell-egpu-rtx-5090-dgpu-working-simultaneously/ "2025 16\" ASUS ROG STRIX SCAR 16 (RTX5090) [CU2,24C,HX] + RTX PRO 6000 @ 32Gbps-TB4>TB5 (Minisforum DEG2) + Win11 // Blackwell eGPU + RTX 5090 dGPU working simultaneously")

[Eric Stadtmueller](https://egpu.io/forums/profile/eric_stadtmueller/), [관상용치즈](https://egpu.io/forums/profile/syiops/) and [nando4](https://egpu.io/forums/profile/nando4/) liked
ReplyQuote
