# works
llama-server.exe `
    -m "downloads/models/gemma-4-31B-it-UD-Q5_K_XL.gguf" `
    --mmproj "Downloads/models/mmproj/mmproj-F16_gemma-4-31B-it-GGUF.gguf"

# on mmproj
#      if model @ https://huggingface.co/unsloth/gemma-4-31B-it-GGUF/resolve/main/gemma-4-31B-it-UD-Q5_K_XL.gguf?download=true
#   then mmproj @ https://huggingface.co/unsloth/gemma-4-31B-it-GGUF/resolve/main/mmproj-F16.gguf?download=true
# i just renamed it here

# BUG: DOES NOT WORK...
llama-mtmd-cli.exe `
    -p "output a summary of this image" `
    --image "Downloads/saturn.webp" `
    -m "downloads/models/gemma-4-31B-it-UD-Q5_K_XL.gguf" `
    --mmproj "Downloads/models/mmproj/mmproj-F16_gemma-4-31B-it-GGUF.gguf"
