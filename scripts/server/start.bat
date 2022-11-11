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
IF NOT EXIST %SERVERCFG% (GOTO :notfound)
echo Starting up server "%target%"

IF EXIST %SERVERDIR%\pid.txt (
  echo Server already running ^(pid.txt exists^) run "stop [server]" first
  echo Or, if this is an error, delete the pid.txt file
  EXIT /B %ERR_SERVER_ALREADY_RUNNING%
)

rem fetch server port from config
FOR /F "usebackq" %%x IN (`%JQ% -r ".port?" %SERVERCFG%`) DO (
SET PORT=%%x
)

rem fetch server.cfg file path from config
FOR /F "usebackq" %%x IN (`%JQ% -r ".config?" %SERVERCFG%`) DO (
  IF NOT %%x==null (
    SET CONFIGFILE=%SERVERDIR%\%%x
  )
)


rem fetch basic.cfg file path from config
FOR /F "usebackq" %%x IN (`%JQ% -r ".basic?" %SERVERCFG%`) DO (
  IF NOT %%x==null (
    SET BASICFILE=%SERVERDIR%\%%x
  )
)

rem fetch arma 3 override path from config
FOR /F "usebackq" %%x IN (`%JQ% -r ".arma3" %SERVERCFG%`) DO (
  IF NOT %%x==null (
    SET A3OVERRIDE=%%x
  )
)

rem fetch 32bit override setting from config
FOR /F "usebackq" %%x IN (`%JQ% -r ".force32?" %SERVERCFG%`) DO (
  IF %%x==true (SET FORCE32=TRUE)
)

rem fetch filepatching option from config
FOR /F "usebackq" %%x IN (`%JQ% -r ".filepatching?" %SERVERCFG%`) DO (
IF %%x==true ( SET FILEPATCHING=TRUE )
)

rem fetch mission folder path
FOR /F "usebackq delims=" %%x IN (`%JQ% -r "(.missions)?" %SERVERCFG%`) DO (
SET MISSIONS=%%x
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


SET SERVERMODS=
SET SERVERMODSLOCAL=
FOR /F "tokens=* USEBACKQ" %%x IN (`%JQ% -r ".servermods[]?" %SERVERCFG%`) DO (
  SET LINE=%%x
  IF "!LINE:~0,1!"=="@" (
    IF DEFINED SERVERMODSLOCAL (
      SET SERVERMODSLOCAL=!SERVERMODSLOCAL! !LINE!
    ) ELSE (
      SET SERVERMODSLOCAL=!LINE!
    )
  ) ELSE (
    IF DEFINED SERVERMODS (
      SET SERVERMODS=!MODS! !LINE!
    ) ELSE (
      SET SERVERMODS=!LINE!
    )
  )
)

SET CLIENTMODS=
SET CLIENTMODSLOCAL=
FOR /F "tokens=* USEBACKQ" %%x IN (`%JQ% -r ".clientmods[]?" %SERVERCFG%`) DO (
  SET LINE=%%x
  IF "!LINE:~0,1!"=="@" (
    IF DEFINED CLIENTMODSLOCAL (
      SET CLIENTMODSLOCAL=!CLIENTMODSLOCAL! !LINE!
    ) ELSE (
      SET CLIENTMODSLOCAL=!LINE!
    )
  ) ELSE (
    IF DEFINED CLIENTMODS (
      SET CLIENTMODS=!CLIENTMODS! !LINE!
    ) ELSE (
      SET CLIENTMODS=!LINE!
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


SET SERVERMODIDS=
FOR %%x IN (%SERVERMODS%) DO (
  FOR /F "usebackq" %%i IN (`%JQ% -r ".mods.%%x" %CFGFILEPATH%`) DO (
    IF DEFINED SERVERMODIDS (
      SET SERVERMODIDS=!SERVERMODIDS! %%i
    ) ELSE (
      SET SERVERMODIDS=%%i
    )
  )
)


SET CLIENTMODIDS=
FOR %%x IN (%CLIENTMODS%) DO (
  FOR /F "usebackq" %%i IN (`%JQ% -r ".mods.%%x" %CFGFILEPATH%`) DO (
    IF DEFINED CLIENTMODIDS (
      SET CLIENTMODIDS=!CLIENTMODIDS! %%i
    ) ELSE (
      SET CLIENTMODIDS=%%i
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

rem construct the modline with full paths
SET SERVERMODPATHS=
FOR %%x IN (%SERVERMODIDS%) DO (
    SET SERVERMODPATHS=!SERVERMODPATHS!%MODFOLDERPATH%\steamapps\workshop\content\107410\%%x;
)
FOR %%x IN (%SERVERMODSLOCAL%) DO (
  SET SERVERMODPATHS=!SERVERMODPATHS!%MODFOLDERPATH%\%%x;
)


IF NOT DEFINED CONFIGFILE (
 SET CONFIGFILE=%SERVERDIR%\server.cfg
)

IF DEFINED A3OVERRIDE (
 IF "%A3OVERRIDE:~0,1%" == "/" (
  SET ARMAPATH=%SERVER_HOME%\%A3OVERRIDE:~1%
 ) ELSE (
 SET ARMAPATH=%A3OVERRIDE%
 )
)

rem deploy virtual server installation
IF EXIST %SERVERDIR%\deploy (
  rmdir /s /q %SERVERDIR%\deploy
)
mkdir %SERVERDIR%\deploy

rem link files
for %%f in (%ARMAPATH%\*) do (
    mklink /H %SERVERDIR%\deploy\%%~nxf %%f
)

rem link directories except "keys"
for /D %%d in (%ARMAPATH%\*) do (
    if "%%~nxd" == "keys" (
        echo skipping keys
    ) else if "%%~nxd" == "mpmissions" (
        echo skipping mpmissions
    ) else (
        mklink /J %SERVERDIR%\deploy\%%~nxd %%d
    )
)

rem wipe keys and re-link
if exist %SERVERDIR%\deploy\keys (
 rmdir /q %SERVERDIR%\deploy\keys
)
mkdir %SERVERDIR%\deploy\keys

rem link built-in keys
mkdir %SERVERDIR%\deploy\keys
for %%f in (%ARMAPATH%\keys\*) do (
    mklink /H "%SERVERDIR%\deploy\keys\%%~nxf" "%%f"
)

rem link mod keys
echo %MODIDS%
for %%x in (%MODIDS%, %CLIENTMODIDS%) do (
  set mod=%MODFOLDERPATH%\steamapps\workshop\content\107410\%%x
  if exist !mod! (
    pushd !mod!
    for /R %%g in (*.bikey) do (
      mklink /H "%SERVERDIR%\deploy\keys\%%~nxg" "%%g"
    )
    popd
  )
)

rem link local mod keys
for %%x in (%LOCALMODS%, %CLIENTMODSLOCAL%) do (
  set mod=%MODFOLDERPATH%\%%x
  if exist !mod! (
    pushd !mod!
    for /R %%g in (*.bikey) do (
      mklink /H "%SERVERDIR%\deploy\keys\%%~nxg" "%%g"
    )
    popd
  )
)

rem link mpmissions
rem if not exist %SERVERDIR%\mpmissions (
rem     mkdir %SERVERDIR%\mpmissions
rem )
rem if not exist %SERVERDIR%\deploy\mpmissions (
rem     mkdir %SERVERDIR%\deploy\mpmissions
rem )

rem link individual mission files from serverdir
rem pushd %SERVERDIR%\mpmissions
rem for /R %%f in (*.pbo) do (
rem     mklink /H %SERVERDIR%\deploy\mpmissions\%%~nxf %%f
rem )
rem popd

rem link missions folder
if exist "%MISSIONS%" (
    mklink /J %SERVERDIR%\mpmissions "%MISSIONS%"
    mklink /J %SERVERDIR%\deploy\mpmissions "%MISSIONS%"
) else (
    mkdir %SERVERDIR%\mpmissions
    mklink /J %SERVERDIR%\deploy\mpmissions %SERVERDIR%\mpmissions
)

rem set up the command to start the server
IF DEFINED FORCE32 (
  SET cmd=\"%SERVERDIR%\deploy\arma3server.exe\" -profiles=%SERVERDIR%\profiles -config=%CONFIGFILE%
) ELSE (
  SET cmd=\"%SERVERDIR%\deploy\arma3server_x64.exe\" -profiles=%SERVERDIR%\profiles -config=%CONFIGFILE%
)


IF DEFINED BASICFILE (
 SET cmd=%cmd% -cfg=%BASICFILE%
)

IF DEFINED PORT (
 SET cmd=%cmd% -port=%PORT% -limitFPS=100
)

IF DEFINED FILEPATCHING (
 SET cmd=%cmd% -filePatching
)

rem if there are mods, add a -mod parameter
IF DEFINED MODPATHS (
  SET cmd=%cmd% -mod=%MODPATHS%
  echo The server has mods enabled
)

IF DEFINED SERVERMODPATHS (
  SET cmd=%cmd% -servermod=%SERVERMODPATHS%
  echo The server has server-only mods enabled
)

echo Starting server in %SERVERDIR%\
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
