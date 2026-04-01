@echo off

goto multiline_comment_hack
you can type whatever you want here
    apparently batch doesnt injest.
:multiline_comment_hack

echo woa, hack multiline comment

:: https://stackoverflow.com/a/31483358
setlocal enableDelayedExpansion
set NL=^


rem two empty line required
set var=this is a !NL! ^
multi !NL! ^
line !NL! ^
string !NL!

echo !var!
