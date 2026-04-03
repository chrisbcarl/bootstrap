@echo off

:: https://stackoverflow.com/a/20696885
echo "has quotes"
echo does not have quotes
echo below is three empties
echo[
echo.
echo(
echo back to normal

:: echo to stderr - https://stackoverflow.com/a/6359438
echo WARNING 1>&2

:: stdout + stderr same file
python -c "import sys, time; print('stdout', time.time()); print('stderr', time.time(), file=sys.stderr)" >> file.log 2>&1

cmd /c echo open .\file.log for some appended results!

