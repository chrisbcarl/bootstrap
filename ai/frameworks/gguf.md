# GGUF
- GPT framework, fairly dominant as a standard

## Download
- [repo](https://huggingface.co/unsloth/Qwen3.6-35B-A3B-GGUF/tree/main)
- [download](https://huggingface.co/unsloth/Qwen3.6-35B-A3B-GGUF/resolve/main/Qwen3.6-35B-A3B-UD-Q4_K_XL.gguf?download=true)

```bash
# https://gemini.google.com/app/14f003d791b2e23b
pip install huggingface_hub
huggingface-cli download Bartowski/Llama-3-8B-Instruct-GGUF --include "Llama-3-8B-Instruct-Q4_K_M.gguf" --local-dir ./
```

```python
# https://gemini.google.com/app/14f003d791b2e23b
from huggingface_hub import hf_hub_download
file_path = hf_hub_download(
    repo_id="Bartowski/Llama-3-8B-Instruct-GGUF",
    filename="Llama-3-8B-Instruct-Q4_K_M.gguf",
    local_dir="./"
)
print(f"File downloaded to: {file_path}")
```
