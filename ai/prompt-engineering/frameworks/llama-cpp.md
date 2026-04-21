# Install
- [repo](https://github.com/ggml-org/llama.cpp)

```powershell
winget install llama.cpp --accept-source-agreements --accept-package-agreements
$env:Path = [System.Environment]::GetEnvironmentVariable("Path","Machine") + ";" + [System.Environment]::GetEnvironmentVariable("Path","User")
llama-cli -h
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

