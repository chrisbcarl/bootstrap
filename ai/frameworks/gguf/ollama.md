# Links
- https://docs.ollama.com/api/introduction
- https://github.com/open-webui/open-webui as a chat integration


```cmd
taskkill /f /t /im "ollama app.exe"
```

# install models
```bash
OLLAMA_HOST=127.0.0.1:11434  # IP Address for the ollama server (default 127.0.0.1:11434)
OLLAMA_KEEP_ALIVE=15s        # The duration that models stay loaded in memory (default "5m")
ollama pull gemma4:latest
ollama pull gwen3.5:latest
ollama serve
```

# select one model or another
```bash
curl -X GET http://localhost:11434/api/tags -H "Content-Type: application/json"
curl -X POST http://localhost:11434/api/generate -d '{
  "model": "qwen3.5:latest",
  "prompt": "echo hello world"
}'
curl -X POST http://localhost:11434/api/generate -d '{
  "model": "gemma4",
  "prompt": "echo hello world"
}'
```