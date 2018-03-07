@echo off
SET target=%1

IF NOT DEFINED target (SET /P %target%="Enter the name of the server to stop: ")

IF NOT EXIST %SERVER_HOME%\%target%\server.cfg (GOTO :notfound)
SET pidfile=%SERVER_HOME%\%target%\pid.txt
IF NOT EXIST %pidfile% (GOTO :notrunning)

SET /p pid=<%pidfile%

echo Terminating Server...
taskkill /PID %pid%
SET ERR=%ERRORLEVEL%

rem wait for a moment
timeout /T 3 > nul

rem check if the process has actually stopped
FOR /F "tokens=2" %%x IN ('tasklist /FI "PID eq %pid%"') DO (
  IF %pid%==%%x (
    echo It seems the process did not terminate correctly
    SET ERR=2
  )
)

IF %ERR% LEQ 1 (
  del %pidfile%
) ELSE (
  echo Encountered an error terminating the process
  echo Run this command again, or resolve manually then delete the pid.txt file
)
EXIT /B %ERR_SUCCESS%

:notfound
echo Server "%target%" not found
EXIT /B %ERR_NO_SERVER%

:notrunning
echo Server "%target%" is not running
rem TODO find the right exit code for this
EXIT /B %ERR_SERVER_NOT_RUNNING%
