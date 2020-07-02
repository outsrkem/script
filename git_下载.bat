@ECHO  OFF
title Pull_Git.bat
color 0a
set DIR=%cd%
cd %DIR%
set THISDATETIME=%DATE:~0,4%-%DATE:~5,2%-%DATE:~8,2% %TIME:~0,2%:%TIME:~3,2%:%TIME:~6,2%
git fetch --all 
git reset --hard origin/master
git pull
::
TIMEOUT /T 2