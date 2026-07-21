# Install
- [repo](https://github.com/ggml-org/llama.cpp)

```powershell
# install WITHOUT admin privileges
winget install llama.cpp --accept-source-agreements --accept-package-agreements
$env:Path = [System.Environment]::GetEnvironmentVariable("Path","Machine") + ";" + [System.Environment]::GetEnvironmentVariable("Path","User")
llama-cli -h

winget upgrade llama.cpp --accept-source-agreements --accept-package-agreements
```

```bash
apt-get update
apt-get install pciutils build-essential cmake curl libcurl4-openssl-dev -y
git clone https://github.com/ggml-org/llama.cpp
cmake llama.cpp -B llama.cpp/build \
    -DBUILD_SHARED_LIBS=OFF -DGGML_CUDA=ON
cmake --build llama.cpp/build --config Release -j --clean-first --target llama-cli llama-mtmd-cli llama-server llama-gguf-split
cp llama.cpp/build/bin/llama-* llama.cpp
```

## Build w/ Cuda
- resources I used:
    - windows
        - https://help.visokio.com/support/solutions/articles/42000115649-how-to-run-local-llms-on-windows-with-nvidia-llama-cpp-cuda-
            - reminder about CUDA 12.8
        - https://aleksandarhaber.com/how-to-compile-and-build-the-gpu-version-of-llama-cpp-from-source-and-run-llm-models-on-gpu/
            - some alternate ideas
        - https://github.com/py-sandy/llama.cpp-windows-builder
            - bulk of logic and flow, theirs uses a checking system
    - linux
        - https://ecorbari.medium.com/running-local-llms-on-ubuntu-with-nvidia-gpu-using-llama-cpp-2ec2e010c040

### Windows
- open powershell
```powershell
winget source update --accept-package-agreements --accept-source-agreements

# overall sourced from https://github.com/py-sandy/llama.cpp-windows-builder
# install CUDA sdk 12.8.0 (13 is bricked in some ways)
winget install --id Nvidia.CUDA --version "12.8.0" --accept-package-agreements --accept-source-agreements

# download source for build tools / bootstrappers
mkdir build
mkdir repos
cd repos
git clone https://github.com/microsoft/vcpkg.git
git clone https://github.com/ggml-org/llama.cpp.git
```
- launch CMD
```batch
:: get some windows build tools
call vcpkg\bootstrap-vcpkg.bat
vcpkg\vcpkg.exe install curl:x64-windows  # optional: if you already have curl, good

:: download Visual Studio Community, find the installer
& "C:\Program Files (x86)\Microsoft Visual Studio\Installer\vswhere.exe" `
    -latest -products * `
    -requires Microsoft.VisualStudio.Component.VC.Tools.x86.x64 `
    -property installationPath
:: returns where the best vctools location is, use that location below

"C:\Program Files\Microsoft Visual Studio\2022\Community\VC\Auxiliary\Build\vcvars64.bat"
where cmake

:: figure out where vcpkg.cmake is
cmake -S .\llama.cpp -B .\build ^
    -G Ninja ^
    -DGGML_CUDA=ON ^
    -DGGML_CUDA_GRAPHS=ON ^
    -DGGML_CUDA_FA_ALL_QUANTS=ON ^
    -DLLAMA_CURL=ON ^
    -DCMAKE_CUDA_ARCHITECTURES=native ^
    -DCMAKE_BUILD_TYPE=Release ^
    -DCMAKE_TOOLCHAIN_FILE="C:\Program Files (x86)\Microsoft Visual Studio\2022\BuildTools\VC\vcpkg\scripts\buildsystems\vcpkg.cmake" ^
    -DVCPKG_TARGET_TRIPLET=x64-windows ^
    -DCMAKE_CXX_FLAGS="/W0"

cmake --build .\build -j %NUMBER_OF_PROCESSORS%
```
- exit to get back to powershell
```powershell
build\bin\llama-cli --list-devices

# reminder to add this new llama-cli to the PATH

# remove WITHOUT admin privileges
winget remove llama.cpp --accept-source-agreements
```


# WARNING: confirm that GPU shows up
```powershell
llama-cli --list-devices
```

## llama-cli
- [2-core CPU + 8GB DDR2](https://github.com/ggml-org/llama.cpp/discussions/21136) / [gist](https://gist.github.com/0ut0flin3/a64a97d31eb3d0e9261f54206c3bacf3)
```bash
llama-cli \
    -m path/to/your-model.gguf      \
    -t 8                            \  # physical cores
    --n-gpu-layers 0                \  # layers offloaded to GPU
    -n 256                          \  # number of tokens to generate
    --ctx-size 4096                 \ # default 512?
    -p "Your prompt here"           \

# other args to keep in mind
--reasoning off `
--chat-template-kwargs '{\"enable_thinking\": false}' `  # WARNING: MUST USE THIS ESCAPE
--single-turn `
--simple-io `
```


## llama-server
- [chat-app](http://localhost:8080)
- [chat-api](http://localhost:8080/v1/chat/completions)


```powershell
llama-server `
    -m downloads/models/Llama-3.2-1B-Instruct-UD-Q8_K_XL.gguf `
    --port 8080
```

```bash
curl -s --request POST \
    --url http://localhost:8080/completion \
    --header "Content-Type: application/json" \
    --data '{"prompt": "Building a website can be done in 10 simple steps:","n_predict": 128}' \
    | python3 -m json.tool
```

## Multi-Modal (images, audio etc)
- WARNING: as of 2026-04-21, the only way to use multi-modal is llama-server
```bash
llama-server.exe `
    -m "downloads/models/gemma-4-31B-it-UD-Q5_K_XL.gguf" `
    --mmproj "Downloads/models/mmproj/mmproj-F16_gemma-4-31B-it-GGUF.gguf"
```
- if [model](https://huggingface.co/unsloth/gemma-4-31B-it-GGUF/resolve/main/gemma-4-31B-it-UD-Q5_K_XL.gguf?download=true), then [mmproj](https://huggingface.co/unsloth/gemma-4-31B-it-GGUF/resolve/main/mmproj-F16.gguf?download=true) and I just renamed it
- documentation
    - https://github.com/ggml-org/llama.cpp/blob/master/docs/multimodal.md
    - https://github.com/ggml-org/llama.cpp/blob/master/tools/mtmd/README.md
