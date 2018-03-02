@echo off
SETLOCAL ENABLEDELAYEDEXPANSION

rem allow passing the server_home as a parameter to the script
IF NOT [%~1]==[] (
  SET SERVER_HOME=%~1
) ELSE (
  SET SERVER_HOME=%cd%
)

rem save the location of this file as the script root
SET SCRIPTS=%~dp0
SET SCRIPTS=!SCRIPTS:~0,-1!

CALL %SCRIPTS%\cfg.bat

rem input handling loop
:getinput
echo.
SET /P command=":>"
echo.
call :docmd %command%
rem if a terminate code is returned, exit
if %ERRORLEVEL%==-1 (EXIT /B %ERR_SUCCESS%)
goto :getinput

rem subroutine to check and execute commands
:docmd
rem extracts sub-command (all args except first)
SET subcmd=;;;;;%*
SET subcmd=!subcmd:;;;;;%1 =!
rem also for the special case where there is no space
SET subcmd=!subcmd:;;;;;%1=!
IF /I "%1"=="start" (
  CALL %SCRIPTS%\start_server.bat !subcmd!
) ELSE IF /I "%1"=="stop" (
  echo This command is currently broken
  rem CALL %SCRIPTS%\stop_server.bat %2
) ELSE IF /I "%1"=="update-server" (
  CALL %SCRIPTS%\update_server.bat !subcmd!
)ELSE IF /I "%1"=="update-mods" (
  CALL %SCRIPTS%\update_mod.bat !subcmd!
) ELSE IF /I "%1"=="var" (
  CALL :vars !subcmd!
) ELSE IF /I "%1"=="help" (
  CALL %SCRIPTS%\printhelp.bat
) ELSE IF /I "%1"=="x" (
  rem return the terminate code
  EXIT /B %ERR_TERMINATE%
) ELSE IF "%1"=="h" (
  CALL :docmd help
) ELSE IF "%1"=="exit" (
  rem return the terminate code
  EXIT /B %ERR_TERMINATE%
) ELSE IF "%1"=="quit" (
  rem return the terminate code
  EXIT /B %ERR_TERMINATE%
) ELSE IF "%1"=="q" (
  rem return the terminate code
  EXIT /B %ERR_TERMINATE%
) ELSE IF "%1"=="clear" (
  cls
) ELSE IF "%1"=="cls" (
  cls
) ELSE (
  echo Command "%1" not found, try "help"
)
EXIT /B %ERR_SUCCESS%

rem separate subroutine to handle variable-related commands
:vars
SET subcmd=;;;;;%*
SET subcmd=!subcmd:;;;;;%1 =!
IF /I "%1"=="set" (
  CALL %SCRIPTS%\set_variable.bat !subcmd!
) ELSE IF /I "%1"=="list" (
  CALL %SCRIPTS%\list_variables.bat
) ELSE (
  echo Command "var %1" not found, try help
)
EXIT /B %ERR_SUCCESS%
