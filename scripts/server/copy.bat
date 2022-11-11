@echo off
SETLOCAL ENABLEDELAYEDEXPANSION


SET source=%2
IF NOT DEFINED source (SET /P source="Enter name of the server to copy: ")

SET target=%3
IF NOT DEFINED target (SET /P target="Enter the name of the copy to be created: ")

IF "%3"=="-cmd" (SET DUMPCMD=true)

SET SOURCEDIR=%SERVER_HOME%\%source%
IF NOT EXIST %SOURCEDIR% (GOTO :notfound)

SET TARGETDIR=%SERVER_HOME%\%target%
IF EXIST %TARGETDIR% (GOTO :already)

echo Creating server "%target%" as a copy of %source%

xcopy /s /e /y /i %SOURCEDIR% %TARGETDIR%

EXIT /B %ERR_SUCCESS%

:notfound
echo Server "%source%" not found
EXIT /B %ERR_NO_SERVER%

:already
echo Cannot create server "%target%" as it already exists
EXIT /B %ERR_NO_SERVER%
