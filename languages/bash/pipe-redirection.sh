cmd=(python3 -c "import sys; print('stdout', file=sys.stdout);  print('stderr', file=sys.stderr);")

# send stdout to file
"${cmd[@]}" > /tmp/stdout.txt

# send stderr to file
"${cmd[@]}" 2> /tmp/stderr.txt

# oneline, 2 files
"${cmd[@]}" > /tmp/stdout.txt 2> /tmp/stderr.txt

# onefile, 1 file
"${cmd[@]}" > /tmp/out.txt 2>&1
