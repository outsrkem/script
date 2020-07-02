@echo off
title upDataGit.bat
color 0a
set DIR=%cd%
cd %DIR%
::echo %DIR%
set THISDATETIME=%DATE:~0,4%-%DATE:~5,2%-%DATE:~8,2% %TIME:~0,2%:%TIME:~3,2%:%TIME:~6,2%
::set /p user_input=Please enter a describe:
git add -A
::git commit -m "%user_input%"
git commit -m "%THISDATETIME%"
git push origin master
::end
::rem
TIMEOUT /T 1
::pause
