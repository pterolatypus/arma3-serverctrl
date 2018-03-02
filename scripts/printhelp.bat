@echo off
SETLOCAL ENABLEDELAYEDEXPANSION

rem the tabbing looks weird here but renders correctly in the terminal
IF [%1] == [] (
echo Valid commands:
echo    exit, x, quit, q			quit this application
echo    start [servername]			start a server
echo    stop [servername]			stop a running server ^(currently broken^)
echo    update-server			update the arma 3 server application
echo    update-mods [modname]		update a specific workshop mod
echo    update-mods				update all workshop mods
echo    var list				list program variables and their values
echo    var set [variable] [value]		set a program variable
echo    help, h				show this help screen
echo    clear, cls				clear the terminal
) ELSE IF "%1"=="var" (
  echo The 'var' command is used to manipulate program variables
  echo Note that if any of these variables are undefined, AUTO mode will be unavailable
  echo.
  echo Valid subcommands:
  echo    var list				list program variables and their values
  echo    var set [variable] [value]		set a program variable
) ELSE (
  echo There doesn't seem to be a help page for "%1"
)
