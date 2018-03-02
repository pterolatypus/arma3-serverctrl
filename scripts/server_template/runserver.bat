@echo off
SETLOCAL ENABLEDELAYEDEXPANSION

rem location of this script used as server root
SET svrdir=%~dp0
SET ARMAPATH=%SERVER_HOME%\%ARMADIR%

IF EXIST %svrdir%pid.txt (
  echo Server already running ^(pid.txt exists^) run "stop [server]" first
  echo Or, if this is an error, delete the pid.txt file
EXIT /B %ERR_SERVER_ALREADY_RUNNING%
)

rem read the mods.txt file to check mods to load
SET MODS=
IF EXIST %svrdir%mods.txt (
  FOR /F %%x IN (%svrdir%mods.txt) DO (
    SET LINE=%%x
    rem ignore comments
    IF NOT "!LINE:~0,2!"=="//" (
      SET MODS=!MODS! !LINE!
    )
  )
)

rem read through the modfile to find the ids for the mods
SET MODIDS=
FOR %%x IN (%MODS%) DO (
  FOR /F "tokens=1,2" %%i IN (%MODFILEPATH%) DO (
    SET NAME=%%i
    rem ignore comments
    IF NOT "!NAME:~0,2!"=="//" (
      IF "!NAME!"=="%%x" (
        SET MODIDS=!MODIDS! %%j
      )
    )
  )
)

rem construct the modline with full paths
SET MODPATHS=
FOR %%x IN (%MODIDS%) DO (
  SET MODPATHS=!MODPATHS!;%ARMAPATH%\steamapps\workshop\content\%%x
)

echo.%MODPATHS%
echo.

rem set up the command to start the server
rem the ^ character lets you split the command across multiple lines, but you must still include the spaces to separate the parameters
SET cmd="%ARMAPATH%\arma3server.exe"^
 -profiles="%svrdir%profiles"^
 -port=2310^
 -filePatching^
 -config="%svrdir%server.cfg"^
 -nologs


echo Starting server in %svrdir%

rem execute the command and save the process ID
for /F "usebackq tokens=1,2 delims=;=%TAB% " %%i in (
    `wmic process call create "%cmd%"^, "%svrdir%"`
) do (
    if /I "%%i"=="ProcessId" (
        set pid=%%j
    )
)

rem TODO temporarily disabled this feature
rem echo.%pid% > %svrdir%\pid.txt
