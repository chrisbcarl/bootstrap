# Install on WSL
https://docs.nvidia.com/cuda/wsl-user-guide/index.html
```powershell
```

Install

```bash
sudo apt remove --purge cuda-keyring -y  # may not exist, that's fine
cd /tmp
wget https://developer.download.nvidia.com/compute/cuda/repos/ubuntu2604/x86_64/cuda-keyring_1.1-1_all.deb
sudo dpkg -i cuda-keyring_1.1-1_all.deb
sudo apt update -y
sudo apt install cuda-toolkit -y
export CUDA_HOME=/usr/local/cuda   # replace with your CUDA version
export PATH=$CUDA_HOME/bin:$PATH
```



- install llama on prem (requires compilation with cmake + nvcc on pip install)
    - download [cuda SDK](https://developer.nvidia.com/cuda-12-5-0-download-archive?target_os=Windows&target_arch=x86_64&target_version=10&target_type=exe_local)
    - READ THE SETUP, IT MIGHT SAY YOU NEED TO MODIFY THE PATH
        - I like to do "PATH=%PATH_NVIDIA%;"
    - make sure `$env:CUDA_PATH` was modified to the right version
    - confirm with `nvidia-smi.exe`, `nvcc --version`
    - install via:
        ```powershell
        $env:CMAKE_ARGS="-DGGML_CUDA=on"
        $env:FORCE_CMAKE=1
        pip install llama-cpp-python   # --extra-index-url https://abetlen.github.io/llama-cpp-python/whl/cu125
        ```
