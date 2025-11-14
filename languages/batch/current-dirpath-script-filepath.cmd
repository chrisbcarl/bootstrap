:: https://stackoverflow.com/a/33656038
:: Basically you can add whatever shit you like
:: %dpnx0 is the full script filepath
@echo off

echo Everything, dpnx0:             %~dpnx0
echo Full path and filename:        %~f0
echo Drive:                         %~d0
echo Path:                          %~p0
echo Drive and path:                %~dp0
echo Filename without extension:    %~n0
echo Filename with    extension:    %~nx0
echo Extension:                     %~x0
echo As given on cli:               %0
echo As given on cli minus quotes:  %~0

SET drv=%~d0
SET pth=%~p0
SET fpath=%~dp0
SET fname=%~n0
SET ext=%~x0

echo Simply Constructed name:       %fpath%%fname%%ext%
echo Fully  Constructed name:       %drv%%pth%%fname%%ext%

@echo on
