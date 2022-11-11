@echo off
SETLOCAL ENABLEDELAYEDEXPANSION

rem save the location of this file as the script root
SET SCRIPTS=%~dp0
SET SCRIPTS=!SCRIPTS:~0,-1!


SET ME=%1
SET IPROMPT=!IPROMPT!!ME!^>

rem extracts sub-command (all args except first)
SET CMD=;;;;;%*
SET CMD=!CMD:;;;;;%1 =!
rem also for the special case where there is no space
SET CMD=!CMD:;;;;;%1=!

rem if a command was passed in, execute it then quit
IF DEFINED CMD (
  call :docmd %CMD%
  EXIT /B
)

rem otherwise start in interactive mode
rem input handling loop
:getinput
echo.
SET /P command="!IPROMPT!"
echo.
call :docmd %command%
rem if a terminate code is returned, exit
if %ERRORLEVEL%==%ERR_TERMINATE% (EXIT /B %ERR_SUCCESS%)
goto :getinput

rem subroutine to check and execute commands
:docmd
IF /I "%1"=="q" (
  EXIT /B %ERR_TERMINATE%
)
ENDLOCAL
SET filename=%SCRIPTS%\%1.bat
IF EXIST !filename! (
  CALL !filename! %*
) ELSE IF EXIST %SCRIPTS%\%1\main.bat (
  CALL  %SCRIPTS%\%1\main.bat %*
) ELSE (
  EXIT /B %ERR_NO_CMD%
)
EXIT /B %ERR_SUCCESS%
