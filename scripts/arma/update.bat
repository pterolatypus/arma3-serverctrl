@echo off
@rem http://media.steampowered.com/installer/steamcmd.zip
SETLOCAL ENABLEDELAYEDEXPANSION

rem extracts sub-command (all args except first)
SET ARGS=;;;;;%*
SET ARGS=!ARGS:;;;;;%1 =!
rem also for the special case where there is no space
SET ARGS=!ARGS:;;;;;%1=!

FOR %%x IN (%ARGS%) DO (
  IF "%%x"=="-auto" (SET AUTO=TRUE)
  IF "%%x"=="-q" (SET QUIET=TRUE)
)

IF NOT DEFINED QUIET (
  echo.
  echo     You are about to update ArmA 3 server
  echo.
)

SET ARMADIR=%2
IF NOT DEFINED ARMADIR (
 SET /P ARMADIR="Enter the name of the A3 installation to update: "
)

SET ARMAPATH=%SERVER_HOME%\%ARMADIR%
SET STEAMPATH=%SERVER_HOME%\%STEAMDIR%

IF NOT DEFINED QUIET (
echo.
echo        Steam: %STEAMPATH%
echo        Arma: %ARMAPATH%
echo        Branch: %BRANCH%
echo.
)

IF DEFINED AUTO (
  SET CONFIRM=y
) else (
  SET /P CONFIRM="Are you sure you want to update? (y/n): "
)
IF /I NOT "%CONFIRM%"=="y" (
  echo Terminating
  EXIT /B %ERR_TERMINATE%
)

IF DEFINED STEAMPASS (
  SET STEAMLOGIN=%STEAMUSER% %STEAMPASS%
) ELSE (
  SET STEAMLOGIN=%STEAMUSER%
)

%STEAMPATH%\steamcmd.exe +force_install_dir %ARMAPATH% +login %STEAMLOGIN% +"app_update %BRANCH%" validate +quit
