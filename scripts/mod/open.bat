@echo off
@rem http://media.steampowered.com/installer/steamcmd.zip
SETLOCAL ENABLEDELAYEDEXPANSION

rem loop through arguments to set switch options]
SET MODS=
SET MODIDS=

rem extracts sub-command (all args except first)
SET ARGS=;;;;;%*
SET ARGS=!ARGS:;;;;;%1 =!
rem also for the special case where there is no space
SET ARGS=!ARGS:;;;;;%1=!

FOR %%x IN (%ARGS%) DO (
  SET ARG=%%x
  IF NOT "!ARG:~0,1!"=="-" (
    IF "!ARG:~0,1!"=="+" (
      SET MODIDS=!MODIDS! !ARG:~1!
    ) ELSE (
      SET MODS=!MODS! %%x
    )
  )
  IF "!ARG!"=="-auto" (SET AUTO=TRUE)
  IF "!ARG!"=="-q" (SET QUIET=TRUE)
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

rem hardcoded to auto mode for now
SET AUTO=true

rem if not auto mode, ask for user configuration
IF NOT DEFINED AUTO (
  SET /P ARMADIR="Enter ArmA 3 folder [%ARMADIR%]: "
  SET /P STEAMDIR="Enter Steam folder [%STEAMDIR%]: "
  SET /P STEAMUSER="Enter Steam username [%STEAMUSER%]: "
)

SET STEAMPATH=%SERVER_HOME%\!STEAMDIR!
SET MODFOlDERPATH=%SERVER_HOME%\!MODFOLDER!
SET CFGFILEPATH=%SERVER_HOME%\%CFGFILE%

IF NOT DEFINED QUIET (
  echo.
  echo     You are about to update ArmA 3 Server Mods to:
  echo        Folder: %MODFOLDERPATH%
  echo        Steam folder: %STEAMPATH%
  echo        User: %STEAMUSER%
  echo        Cfg File: %CFGFILEPATH%
  echo.
  IF NOT DEFINED AUTO (
    pause
  )
)


rem loop through the mods file and fetch every mod in there
IF DEFINED ALLMODS (
  FOR /F "usebackq" %%i IN (`%JQ% -r ".mods|keys|.[]" %CFGFILEPATH%`) DO (
    SET LINE=%%i
    SET MODS=!MODS! !LINE!
  )
)

rem if password is set, use it. otherwise it will prompt
IF DEFINED STEAMPASS (
    SET STEAMLOGIN=%STEAMUSER% %STEAMPASS%
) ELSE (
    SET STEAMLOGIN=%STEAMUSER%
)

SET cmd=%STEAMDIR%\steamcmd.exe +login %STEAMLOGIN% +force_install_dir %MODFOLDERPATH%


rem read through the modfile to find the ids for the mods
FOR %%x IN (%MODS%) DO (
  FOR /F "usebackq" %%i IN (`%JQ% -r ".mods.%%x" %CFGFILEPATH%`) DO (
    start !MODFOLDERPATH!\steamapps\workshop\content\107410\%%i
  )
)
