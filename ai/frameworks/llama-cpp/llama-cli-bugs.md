# Interesting effects:

- crash when characters repeat a lot.
    - discussions:
        - [github bug](https://github.com/ggml-org/llama.cpp/issues/17636)
    - build: b9128-856c3adac
    - original (crash):
        - prompt: `give me some words of encouragement for a final exam in undergraduate operating systems. i think i studied thoroughly but i dont know how well im going to do`
        ```powershell
        llama-cli.exe -m "C:\Users\chris/downloads/models/Llama-3.2-1B-Instruct-UD-Q8_K_XL.gguf" -p "give me some words of encouragement for a final exam in undergraduate operating systems. i think i studied thoroughly but i dont know how well im going to do" -t 11 --no-display-prompt --single-turn --simple-io --temp 0.6 --top-p 0.95 --top-k 20 --min-p 0.00 --n-gpu-layers auto -n 512 --ctx-size 512 --chat-template-kwargs '{\"enable_thinking\":false}' --reasoning off --seed 69
        ```
    - modified (succeed):
        - prompt: `give me some words of encouragement for a final exam in undergraduate operating systems.`
        ```powershell
        llama-cli.exe -m "C:\Users\chris/downloads/models/Llama-3.2-1B-Instruct-UD-Q8_K_XL.gguf" -p "give me some words of encouragement for a final exam in undergraduate operating systems." -t 11 --no-display-prompt --single-turn --simple-io --temp 0.6 --top-p 0.95 --top-k 20 --min-p 0.00 --n-gpu-layers auto -n 512 --ctx-size 512 --chat-template-kwargs {\"enable_thinking\":false} --reasoning off --seed 69
        ```
    - modified (succeed):
        - prompt: `give me some words of encouragement for a final exam in undergraduate operating systems. I studied thoroughly but I dont know how well I'm going to do`
        ```powershell
        llama-cli.exe -m "C:\Users\chris/downloads/models/Llama-3.2-1B-Instruct-UD-Q8_K_XL.gguf" -p "give me some words of encouragement for a final exam in undergraduate operating systems. I studied thoroughly but I dont know how well I'm going to do" -t 11 --no-display-prompt --single-turn --simple-io --temp 0.6 --top-p 0.95 --top-k 20 --min-p 0.00 --n-gpu-layers auto -n 32768 --ctx-size 32768 --chat-template-kwargs {\"enable_thinking\":false} --reasoning off --seed 69
        ```
    - pathological (crash):
        - prompt: `give me some words of encouragement for a final exam in undergraduate operating systems. I studied i thoroughly but I dont know how well I'm going to do i`
        ```powershell
        llama-cli.exe -m "C:\Users\chris/downloads/models/Llama-3.2-1B-Instruct-UD-Q8_K_XL.gguf" -p "give me some words of encouragement for a final exam in undergraduate operating systems. I studied i thoroughly but I dont know how well I'm going to do i" -t 11 --no-display-prompt --single-turn --simple-io --temp 0.6 --top-p 0.95 --top-k 20 --min-p 0.00 --n-gpu-layers auto -n 32768 --ctx-size 32768 --chat-template-kwargs '{\"enable_thinking\":false}' --reasoning off --seed 69
        ```