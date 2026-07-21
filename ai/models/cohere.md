# North Mini Code
- [huggingface blog](https://huggingface.co/blog/CohereLabs/introducing-north-mini-code)
- [Cohere Blog](https://cohere.com/blog/north-mini-code)
- [unsloth](https://huggingface.co/unsloth/North-Mini-Code-1.0-GGUF)
```powershell
& C:\bin\llama-cli.exe  -m "C:\Users\chris\.lmstudio\models\unsloth\North-Mini-Code-1.0-GGUF\North-Mini-Code-1.0-UD-Q4_K_S.gguf" -p "create a nice webpage with a single html" -t 19 --no-display-prompt --single-turn --simple-io --temp 0.6 --top-p 0.95 --top-k 20 --min-p 0.00 --n-gpu-layers auto -n (16*1024) --ctx-size (16 * 1024) --chat-template-kwargs '{\"enable_thinking\":true}' --reasoning on --seed 69
```
