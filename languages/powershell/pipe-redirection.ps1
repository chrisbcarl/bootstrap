$cmd="python -c `"import sys; print('stdout', file=sys.stdout);  print('stderr', file=sys.stderr);`""

# send stdout to file
iex $cmd > /temp/stdout.txt

# send stderr to file
iex $cmd 2> /temp/stderr.txt

# oneline, 2 files
iex $cmd 1> /temp/stdout.txt 2> /temp/stderr.txt

# onefile, 1 file
iex $cmd > /temp/out.txt *>&1

# TODO: can't figure out why its not hiding outpu correctly...
New-Item -Path "/temp" -ItemType Directory  # error
New-Item -Path "/temp" -ItemType Directory -ErrorAction SilentlyContinue
New-Item -Path "/temp" -ItemType Directory | Out-Null  # nulls output
$null = New-Item -Path "/temp" -ItemType Directory  # nulls output, faster
