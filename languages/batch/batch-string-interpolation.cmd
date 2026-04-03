:: https://stackoverflow.com/questions/15658475/how-do-i-make-a-batch-file-run-strings-as-commands

@echo off

:: declaring a variable
set script=
echo script: %script%
echo "script: %script%"

@REM set /p "user_input=user input: "
@REM echo user_input: %user_input%

:: substr - https://stackoverflow.com/a/19122727
set "script=hello.py"
echo script: %script%

set substr=%script:~0,-3%
echo substr:    %substr%

set cmdline=python -c "import time; print(time.time())"
echo %cmdline%

@REM python -c "import time; print(time.time())" >> file.log

%cmdline% >> file.log

echo see .\file.log for some piped output
