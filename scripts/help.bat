@echo off
SETLOCAL ENABLEDELAYEDEXPANSION

rem the tabbing looks weird here but renders correctly in the terminal
IF [%2] == [] (
echo Valid commands:
echo    exit, x, quit, q			quit this application
echo    start [servername]			start a server
echo    stop [servername]			stop a running server ^(currently broken^)
echo    arma update			update the arma 3 server application
echo    mod update [modname]		update a specific workshop mod
echo    mod update				update all workshop mods
echo    var list				list program variables and their values
echo    var set [variable] [value]		set a program variable
echo    help, h				show this help screen
echo    clear, cls				clear the terminal
) ELSE IF "%2"=="var" (
  echo The 'var' command is used to manipulate program variables
  echo Note that if any of these variables are undefined, AUTO mode will be unavailable
  echo.
  echo Valid subcommands:
  echo    var list				list program variables and their values
  echo    var set [variable] [value]		set a program variable
) ELSE IF "%2"=="update-mods" (
  echo The 'update-mods' command is used to download or update files from the Steam Workshop using steamcmd.exe
  echo It has various forms:
  echo    "update-mods" with no parameters will attempt to update all the mods listed in the modfile
  echo    "update-mods modname [modname2 modname3...]" will attempt to update a subset of mods listed in the file
  echo    "update-mods [modname1 modname2...] +modid1 [+modid2 +modid3...]" will update ^(optionally^) any number of mods listed in the modfile, as well as a selection of mods referred to by their Workshop ID and not necessarily listed in the file.
  echo    "update-mods -all +modid [+modid2 +modid3...]" will update all mods listed in the modfile, as well as a selection of mods by Workshop ID
) ELSE (
  echo There doesn't seem to be a help page for "%2"
)
