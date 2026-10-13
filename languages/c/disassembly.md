# Disassemble, skip to the "main" function
```bash
# jump to first instance of main, line numbers, preserve color
objdump -d main.exe | less -p '<main>' -N -R
```
