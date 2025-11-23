@echo off
net session >nul 2>&1 || (
    :: echo elevating
    if "%*" == "" (
        powershell -Command "Start-Process '%~f0' -Verb RunAs"
    ) else (
        powershell -Command "Start-Process '%~f0' -ArgumentList '%*' -Verb RunAs"
    )

    exit /b
)

:: ss64
:: fsutil dirty query %SYSTEMDRIVE% >nul 2>&1
:: if %errorLevel% NEQ 0 (
::    echo Failure, please rerun this script from an elevated command prompt. Exiting...
::    ping 127.0.0.1 2>&1 > nul
::    exit /B 1
:: )
echo elevated
pause
