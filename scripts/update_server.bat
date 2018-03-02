@echo off
@rem http://media.steampowered.com/installer/steamcmd.zip
SETLOCAL ENABLEDELAYEDEXPANSION

FOR %%x IN (%*) DO (
  SET ARG=%%x
  IF NOT "!ARG:~0,1!"=="-" IF NOT DEFINED MODNAME (SET MODNAME=%%x)
  IF "!ARG!"=="-auto" (SET AUTO=TRUE)
  IF "%%x"=="-q" (SET QUIET=TRUE)
)

IF NOT DEFINED QUIET (
  echo.
  echo     You are about to update ArmA 3 server
  echo.
)

IF NOT DEFINED AUTO (
  SET /P ARMADIR="Enter the path to install/update ArmA 3 Server to [%ARMADIR%]: "
  SET /p BRANCH="Enter the ArmA 3 branch to install/update from [%BRANCH%]: "
  SET /P STEAMDIR="Enter Steam folder [%STEAMDIR%]: "
  SET /P STEAMUSER="Enter Steam username [%STEAMUSER%]: "
  SET /P STEAMPASS="Enter Steam password [%STEAMPASS%]: "
)
SET ARMAPATH=%SERVER_HOME%\%ARMADIR%
SET STEAMPATH=%SERVER_HOME%\%STEAMDIR%
SET STEAMLOGIN=%STEAMUSER% %STEAMPASS%

echo.
echo        Steam: %STEAMPATH%
echo        ArmA: %ARMAPATH%
echo        Branch: %BRANCH%
echo.

SET /P CONFIRM="Are you sure you want to update? (y/n): "
IF /I NOT "%CONFIRM%"=="y" (
  echo Terminating
  EXIT /B %ERR_TERMINATE%
)


%STEAMPATH%\steamcmd.exe +login %STEAMLOGIN% +force_install_dir %ARMAPATH% +"app_update %BRANCH%" validate +quit
