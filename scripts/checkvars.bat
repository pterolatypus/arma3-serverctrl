@echo off
SETLOCAL ENABLEDELAYEDEXPANSION

FOR /L %%i IN (1,1,%NVARS%) DO (
  SET VAR=!VARS[%%i]!
  IF NOT DEFINED !VAR! (
    SET DIRTY=!DIRTY! !VAR!
  )
  IF DEFINED DIRTY (
    echo One or more program variables are not defined:
    echo !DIRTY!
    EXIT /B %ERR_NO_VAR%
  )
)
