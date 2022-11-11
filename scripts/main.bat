@echo off
SETLOCAL ENABLEDELAYEDEXPANSION

rem allow passing the server_home as a parameter to the script
FOR %%x IN (%*) DO (
  SET ARG=%%~x
  IF "!ARG:~0,1!"=="+" (
    SET CMD=!ARG:~1!
  ) ELSE (
    SET SERVER_HOME=%~1
  )
)

rem default server_home is current working directory
IF NOT DEFINED SERVER_HOME (
  SET SERVER_HOME=%cd%
)

rem save the location of this file as the script root
SET SCRIPTS=%~dp0
SET SCRIPTS=!SCRIPTS:~0,-1!

CALL %SCRIPTS%\cfg.bat

rem if a command was passed in, execute it then quit
IF DEFINED CMD (
  call :docmd %CMD%
  EXIT /B
)

SET IPROMPT=:^>

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
SET filename=%SCRIPTS%\%1.bat
IF EXIST !filename! (
  CALL !filename! %*
) ELSE IF EXIST %SCRIPTS%\%1\main.bat (
  CALL  %SCRIPTS%\%1\main.bat %*
) ELSE (
  EXIT /B %ERR_NO_CMD%
)
EXIT /B %ERR_SUCCESS%

rem separate subroutine to handle variable-related commands
:vars
SET subcmd=;;;;;%*
SET subcmd=!subcmd:;;;;;%1 =!
IF /I "%1"=="set" (
  CALL %SCRIPTS%\set_variable.bat !subcmd!
) ELSE IF /I [%1]==[] (
  CALL :vars list
) ELSE IF /I "%1"=="list" (
  CALL %SCRIPTS%\list_variables.bat
) ELSE (
  echo Command "var %1" not found, try help
)
EXIT /B %ERR_SUCCESS%
