@echo off

SET target=%1
IF NOT DEFINED target (SET /P target="Enter the name of the server to start: ")

IF NOT EXIST %SERVER_HOME%\%target%\runserver.bat (GOTO :notfound)
echo Starting up server "%target%"
CALL %SERVER_HOME%\%target%\runserver.bat
EXIT /B %ERR_SUCCESS%

:notfound
echo Server "%target%" not found
EXIT /B %ERR_NO_FILE%
