@echo off 

echo  *** %DATE%  %TIME% 

set THISDATE=%DATE:~0,4%%DATE:~5,2%%DATE:~8,2%
echo  %THISDATE%

set THISTIME=%TIME:~0,2%%TIME:~3,2%%TIME:~6,2%
echo  %THISTIME%

set THISDATETIME=%DATE:~0,4%-%DATE:~5,2%-%DATE:~8,2% %TIME:~0,2%:%TIME:~3,2%:%TIME:~6,2%
echo  %THISDATETIME%

::

pause
