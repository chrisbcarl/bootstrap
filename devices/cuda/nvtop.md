# WSL Nvtop Error
[self-built nvtop crashes on WSL Debian 12](https://github.com/Syllo/nvtop/issues/382)
```
nvtop: ./src/extract_gpuinfo.c:222: gpuinfo_populate_process_info: Assertion `device->processes[j].gpu_memory_percentage <= 100' failed.
                                                                                                                                        Aborted (core dumped)
```

```bash
git clone https://github.com/Syllo/nvtop.git
cd nvtop
mkdir build
cd build
sudo apt install libudev-dev libdrm-dev -y
sudo apt install cmake libncurses5-dev libncursesw5-dev gcc g++ git -y
cmake .. -DAMDGPU_SUPPORT=OFF -DINTEL_SUPPORT=OFF -DMSM_SUPPORT=OFF -DAPPLE_SUPPORT=OFF -DPANFROST_SUPPORT=OFF -DPANTHOR_SUPPORT=OFF -DASCEND_SUPPORT=OFF -DV3D_SUPPORT=OFF -DTPU_SUPPORT=OFF -DNVIDIA_SUPPORT=ON
sudo make install -j
sudo ./src/nvtop  # test that it works
sudo cp ./src/nvtop /usr/local/bin/nvtop
shutdown -r now
nvtop  # back in business
```

