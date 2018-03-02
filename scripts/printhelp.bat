@echo off
SETLOCAL ENABLEDELAYEDEXPANSION

rem the tabbing looks weird here but renders correctly in the terminal
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
EXIT /B %ERR_SUCCESS%
