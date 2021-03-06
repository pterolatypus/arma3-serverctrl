@echo off
SETLOCAL ENABLEDELAYEDEXPANSION

SET ARMAPATH=%SERVER_HOME%\%ARMADIR%
SET MODFILEPATH=%SERVER_HOME%\%MODFILE%
SET MODFOLDERPATH=%SERVER_HOME%\%MODFOLDER%

SET target=%1
IF NOT DEFINED target (SET /P target="Enter the name of the server to start: ")

SET SERVERDIR=%SERVER_HOME%\%target%
IF NOT EXIST %SERVERDIR%\ (GOTO :notfound)
echo Starting up server "%target%"

IF EXIST %SERVERDIR%\pid.txt (
  echo Server already running ^(pid.txt exists^) run "stop [server]" first
  echo Or, if this is an error, delete the pid.txt file
  EXIT /B %ERR_SERVER_ALREADY_RUNNING%
)

rem read the mods.txt file to check mods to load
SET MODS=
SET LOCALMODS=
IF EXIST %SERVERDIR%\mods.txt (
  FOR /F %%x IN (%SERVERDIR%\mods.txt) DO (
    SET LINE=%%x
    rem ignore comments
    IF NOT "!LINE:~0,2!"=="//" (
      IF "!LINE:~0,1!"=="@" (
        IF DEFINED LOCALMODS (
          SET LOCALMODS=!LOCALMODS! !LINE!
        ) ELSE (
          SET LOCALMODS=!LINE!
        )
      ) ELSE (
        IF DEFINED MODS (
          SET MODS=!MODS! !LINE!
        ) ELSE (
          SET MODS=!LINE!
        )
      )
    )
  )
)

SET SERVERMODS=
SET SERVERMODSLOCAL=
IF EXIST %SERVERDIR%\servermods.txt (
  FOR /F %%x IN (%SERVERDIR%\servermods.txt) DO (
    SET LINE=%%x
    rem ignore comments
    IF NOT "!LINE:~0,2!"=="//" (
      IF "!LINE:~0,1!"=="@" (
        IF DEFINED SERVERMODSLOCAL (
          SET SERVERMODSLOCAL=!SERVERMODSLOCAL! !LINE!
        ) ELSE (
          SET SERVERMODSLOCAL=!LINE!
        )
      ) ELSE (
        IF DEFINED SERVER (
          SET SERVERMODS=!SERVERMODS! !LINE!
        ) ELSE (
          SET SERVERMODS=!LINE!
        )
      )
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

SET SERVERMODIDS=
FOR %%x IN (%SERVERMODS%) DO (
  FOR /F "tokens=1,2" %%i IN (%MODFILEPATH%) DO (
    SET NAME=%%i
    rem ignore comments
    IF NOT "!NAME:~0,2!"=="//" (
      IF "!NAME!"=="%%x" (
        SET SERVERMODIDS=!SERVERMODIDS! %%j
      )
    )
  )
)

rem construct the modline with full paths
SET MODPATHS=
FOR %%x IN (%MODIDS%) DO (
    SET MODPATHS=!MODPATHS!%ARMAPATH%\steamapps\workshop\content\107410\%%x;
)
FOR %%x IN (%LOCALMODS%) DO (
  SET MODPATHS=!MODPATHS!%MODFOLDERPATH%\%%x;
)

rem construct the modline with full paths
SET SERVERMODPATHS=
FOR %%x IN (%SERVERMODIDS%) DO (
    SET SERVERMODPATHS=!SERVERMODPATHS!%ARMAPATH%\steamapps\workshop\content\107410\%%x;
)
FOR %%x IN (%SERVERMODSLOCAL%) DO (
  SET SERVERMODPATHS=!SERVERMODPATHS!%MODFOLDERPATH%\%%x;
)


rem set up the command to start the server
rem the ^ character lets you split the command across multiple lines, but you must still include the spaces to separate the parameters
SET cmd="%ARMAPATH%\arma3server.exe"^
 -profiles=%SERVERDIR%\profiles^
 -port=2310^
 -config=%SERVERDIR%\server.cfg^
 -filePatching


rem if there are mods, add a -mod parameter
IF DEFINED MODPATHS (
  SET cmd=%cmd% -mod=%MODPATHS%
  echo The server has mods enabled
)

echo Starting server in %SERVERDIR%\

rem execute the command and save the process ID
for /F "usebackq tokens=1,2 delims=;=%TAB% " %%i in (
    `wmic process call create "%cmd%"^, "%SERVERDIR%\"`
) do (
    if /I "%%i"=="ProcessId" (
        set pid=%%j
    )
)

rem TODO temporarily disabled this feature
rem echo.%pid% > %svrdir%\pid.txt
EXIT /B %ERR_SUCCESS%

:notfound
echo Server "%target%" not found
EXIT /B %ERR_NO_SERVER%
