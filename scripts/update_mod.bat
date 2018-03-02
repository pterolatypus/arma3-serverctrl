@echo off
@rem http://media.steampowered.com/installer/steamcmd.zip
SETLOCAL ENABLEDELAYEDEXPANSION

rem loop through arguments to set switch options]
SET MODS=
SET MODIDS=
FOR %%x IN (%*) DO (
  SET ARG=%%x
  IF NOT "!ARG:~0,1!"=="-" (
    IF "!ARG:~0,1!"=="+" (
      SET MODIDS=!MODIDS! !ARG:~1!
    ) ELSE (
      SET MODS=!MODS! %%x
    )
  )
  IF "!ARG!"=="-auto" (SET AUTO=TRUE)
  IF "!ARG!"=="-q" (SET QUIET=TRUE & SET OPTIONS=!OPTIONS! -q)
  IF "!ARG!"=="-all" (SET ALLMODS=TRUE)
)

IF DEFINED AUTO (
  CALL %SCRIPTS%\checkvars.bat
  IF NOT !ERRORLEVEL!==%ERR_SUCCESS% (
    EXIT /B
  )
)

rem if the user doesn't specify which mods to update, assume they want to update all of them
IF NOT DEFINED MODS IF NOT DEFINED MODIDS (
  SET ALLMODS=TRUE
)

rem loop through the mods file and fetch every mod in there
IF DEFINED ALLMODS (
  FOR /F %%i IN (%MODFILE%) DO (
    SET LINE=%%i
    rem ignore comments
    IF NOT "!LINE:~0,2!"=="//" (
      SET MODS=!MODS! !LINE!
    )
  )
)

IF NOT DEFINED AUTO (
  SET /P ARMADIR="Enter ArmA 3 folder [%ARMADIR%]: "
  SET /P STEAMDIR="Enter Steam folder [%STEAMDIR%]: "
  SET /P STEAMUSER="Enter Steam username [%STEAMUSER%]: "
  rem call out to powershell to hide the password on command line
  for /f "usebackq tokens=*" %%p in (`powershell -Command "$pword = read-host 'Enter Steam password' -AsSecureString ; $BSTR=[System.Runtime.InteropServices.Marshal]::SecureStringToBSTR($pword); [System.Runtime.InteropServices.Marshal]::PtrToStringAuto($BSTR)"`) do set STEAMPASS=%%p
  SET /P MODFILE="Enter mod file location [%MODFILE%]: "
)

SET ARMAPATH=%SERVER_HOME%\!ARMADIR!
SET STEAMPATH=%SERVER_HOME%\!STEAMDIR!
SET STEAMLOGIN=%STEAMUSER% %STEAMPASS%
SET MODFILEPATH=%SERVER_HOME%\!MODFILE!

IF NOT DEFINED QUIET (
  echo.
  echo     You are about to update ArmA 3 Server Mods to:
  echo        Folder: %ARMAPATH%
  echo        Steam folder: %STEAMPATH%
  echo        User: %STEAMUSER%
  echo        Mod File: %MODFILEPATH%
  echo.
  pause
)

SET cmd=%STEAMDIR%\steamcmd.exe +login %STEAMLOGIN% +force_install_dir %ARMADIR%

rem check through the file to grab the actual id and construct the command
rem loops are a bit back-to-front to reduce file I/O, but it probably doesn't matter
FOR /F "tokens=1,2" %%i IN (%MODFILEPATH%) DO (
  SET LINE=%%i
  rem only consider lines which are not comments
  IF NOT "!LINE:~0,2!"=="//" (
    FOR %%x IN (%MODS%) DO (
      IF /I "%%x"=="%%i" (
        SET cmd=!cmd! +workshop_download_item 107410 %%j validate
      )
    )
  )
)

rem also add any mods specified by id
FOR %%x IN (%MODIDS%) DO (
  SET cmd=!cmd! +workshop_download_item 107410 %%x validate
)

rem finish off and execute the command
SET cmd=%cmd% +quit
IF DEFINED QUIET (
  SET cmd=%cmd% > nul
)
%cmd%
