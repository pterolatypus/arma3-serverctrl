@echo off

rem Default values of program variables
rem Users should use these to configure the utility
SET STEAMUSER=
SET STEAMPASS=
SET STEAMDIR=steam
SET ARMADIR=a3master
SET BRANCH=233780 -beta
SET MODFILE=modlist.txt
SET MODFOLDER=

rem Start the application
rem This assumes that the application is installed in a scripts folder within the current directory,
rem but it can be anywhere as long as this line points to the correct file.
CALL scripts\main.bat %*
