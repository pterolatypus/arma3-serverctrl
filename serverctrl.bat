@echo off
title ArmA 3 ServerCtrl by Pterolatypus
rem Default values of program variables
rem Users should use these to configure the utility
SET STEAMUSER=
SET STEAMPASS=
SET STEAMDIR=steam
SET ARMADIR=arma3-ops
SET BRANCH=233780 -beta creatordlc
SET CFGFILE=serverctrl.cfg
SET MODFOLDER=mods

rem Start the application
rem This assumes that the application is installed in a scripts folder within the current directory,
rem but it can be anywhere as long as this line points to the correct file.
CALL scripts\main.bat %*
