- `~/.wslconfig` - set networking mirrored so you can curl between host and wsl
```ini
[wsl2]
networkingMode=mirrored
```
```powershell
wsl --shutdown  # wait
wsl
```