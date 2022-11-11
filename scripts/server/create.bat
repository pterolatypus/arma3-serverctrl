@echo off
SETLOCAL ENABLEDELAYEDEXPANSION

SET ARMAPATH=%SERVER_HOME%\%ARMADIR%
SET CFGFILEPATH=%SERVER_HOME%\%CFGFILE%
SET MODFOLDERPATH=%SERVER_HOME%\%MODFOLDER%

SET target=%2
IF NOT DEFINED target (SET /P target="Enter the name of the server to start: ")

IF "%3"=="-cmd" (SET DUMPCMD=true)

SET SERVERDIR=%SERVER_HOME%\%target%
SET SERVERCFG=%SERVERDIR%\serverctrl.cfg
IF EXIST %SERVERCFG% (GOTO :already)

echo Creating server "%target%"
rem copy existing files
xcopy /s /e /b /y /i %SERVER_HOME%\scripts\server\template %SERVERDIR%


EXIT /B %ERR_SUCCESS%

:already
echo Cannot create server "%target%" as it already exists
EXIT /B %ERR_NO_SERVER%
