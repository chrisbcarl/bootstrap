:: parse pretty complex command lines without going insane - https://stackoverflow.com/a/14298769
:: Cascading IF statements make an implicit conjunction - https://stackoverflow.com/a/2143203


@echo off

set "B=false"

:argparse
    IF "%~1"=="-h" GOTO help
    IF "%~1"=="-a" set "A=%~2"
    IF "%~1"=="-b" set "B=true"
    IF "%~1"=="" GOTO main
    SHIFT
    GOTO argparse

:help
    echo usage: argparse.cmd [-h] [-a A] [-b]
    echo.
    echo options:
    echo   -h, --help  show this help message and exit
    echo   -a A        gimme int
    echo   -b          just a flag
    GOTO end

:main
    echo A = %A%
    echo B = %B%
    :: GOTO end  REM fallthrough to end

:end
    exit /b 0   REM exit the current batch script instead of CMD.EXE


