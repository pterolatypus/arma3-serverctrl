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
CALL scripts\main.bat %*
