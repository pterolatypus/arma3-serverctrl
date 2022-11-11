@echo off
SETLOCAL ENABLEDELAYEDEXPANSION

rem loop through arguments to set switch options

rem extracts sub-command (all args except first)
SET ARGS=;;;;;%*
SET ARGS=!ARGS:;;;;;%1 =!
rem also for the special case where there is no space
SET ARGS=!ARGS:;;;;;%1=!

SET CFGFILEPATH=%SERVER_HOME%\%CFGFILE%
rem loop through the mods file and fetch every mod in there
FOR /F "usebackq" %%i IN (`%JQ% -r ".mods|keys|.[]" %CFGFILEPATH%`) DO (
  echo %%i
)