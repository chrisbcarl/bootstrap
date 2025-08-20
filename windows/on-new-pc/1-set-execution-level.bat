@echo off
SET SCRIPT_DIRPATH=%~dp0
SET PS1_SCRIPT_FILEPATH="%SCRIPT_DIRPATH%execution-level.ps1"


powershell -File %PS1_SCRIPT_FILEPATH%
