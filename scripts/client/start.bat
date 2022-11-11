@echo off
SETLOCAL ENABLEDELAYEDEXPANSION

SET ARMAPATH=%SERVER_HOME%\%ARMADIR%
SET CFGFILEPATH=%SERVER_HOME%\%CFGFILE%
SET MODFOLDERPATH=%SERVER_HOME%\%MODFOLDER%

SET target=%2
IF NOT DEFINED target (SET /P target="Enter the name of the server to connect to: ")

SET hcprofile=%3
IF NOT DEFINED hcprofile (SET /P hcprofile="Enter the HC name to use: ")

IF "%4"=="-cmd" (
 SET DUMPCMD=true
) ELSE (
 SET password=%4
)

IF "%5"=="-cmd" (SET DUMPCMD=true)

SET SERVERDIR=%SERVER_HOME%\%target%
SET SERVERCFG=%SERVERDIR%\serverctrl.cfg
IF NOT EXIST %SERVERCFG% (GOTO :notfound)
echo Starting client "%hcprofile%" for server "%target%"


rem fetch server port from config
FOR /F "usebackq" %%x IN (`%JQ% -r ".port?" %SERVERCFG%`) DO (
SET PORT=%%x
)

rem fetch arma 3 override path from config
FOR /F "usebackq" %%x IN (`%JQ% -r ".arma3" %SERVERCFG%`) DO (
  IF NOT %%x==null (
    SET A3OVERRIDE=%%x
  )
)

rem read the server.cfg file to check mods to load
SET MODS=
SET LOCALMODS=
SET CREATORDLC=
FOR /F "tokens=* USEBACKQ" %%x IN (`%JQ% -r ".mods[]?" %SERVERCFG%`) DO (
  SET LINE=%%x
  IF "!LINE:~0,1!"=="@" (
    IF DEFINED LOCALMODS (
      SET LOCALMODS=!LOCALMODS! !LINE!
    ) ELSE (
      SET LOCALMODS=!LINE!
    )
  ) ELSE (
    IF "!LINE:~0,1!"==":" (
      IF DEFINED CREATORDLC (
        SET CREATORDLC=!CREATORDLC! !LINE:~1!
      ) ELSE (
        SET CREATORDLC=!LINE:~1!
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


rem read through the modfile to find the ids for the mods
SET MODIDS=
FOR %%x IN (%MODS%) DO (
  FOR /F "usebackq" %%i IN (`%JQ% -r ".mods.%%x" %CFGFILEPATH%`) DO (
    IF DEFINED MODIDS (
      SET MODIDS=!MODIDS! %%i
    ) ELSE (
      SET MODIDS=%%i
    )
  )
)

rem construct the modline with full paths
SET MODPATHS=
FOR %%x IN (%CREATORDLC%) DO (
    SET MODPATHS=!MODPATHS!%%x;
)
FOR %%x IN (%MODIDS%) DO (
    SET MODPATHS=!MODPATHS!%MODFOLDERPATH%\steamapps\workshop\content\107410\%%x;
)
FOR %%x IN (%LOCALMODS%) DO (
  SET MODPATHS=!MODPATHS!%MODFOLDERPATH%\%%x;
)

IF DEFINED A3OVERRIDE (
 IF "%A3OVERRIDE:~0,1%" == "/" (
  SET ARMAPATH=%SERVER_HOME%%A3OVERRIDE%
 ) ELSE (
 SET ARMAPATH=%A3OVERRIDE%
 )
)

set cmd=\"%ARMAPATH%\arma3server_x64.exe\" -client -connect=127.0.0.1 -profiles=%SERVERDIR%\hcprofiles\%hcprofile% -name=%hcprofile%

IF DEFINED PASSWORD (
 SET cmd=%cmd% -password=%password%
)

IF DEFINED PORT (
 SET cmd=%cmd% -port=%PORT%
)

rem if there are mods, add a -mod parameter
IF DEFINED MODPATHS (
  SET cmd=%cmd% -mod=%MODPATHS%
  echo The server has mods enabled
)

echo Starting client in %SERVERDIR%\
rem dump command if switch is set
IF DEFINED DUMPCMD (
  echo %cmd%
)
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
