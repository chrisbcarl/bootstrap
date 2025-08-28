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
