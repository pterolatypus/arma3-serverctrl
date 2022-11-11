@echo off
SETLOCAL ENABLEDELAYEDEXPANSION

FOR /L %%i IN (1,1,%NVARS%) DO (
  IF /I "%2" EQU "!VARS[%%i]!" (
    SET ARG=!VARS[%%i]!
  )
)

ENDLOCAL & SET ARG=%ARG%

IF DEFINED ARG (
  SET %ARG%=%3
) ELSE (
  echo Invalid program variable "%2"
)
