@echo off
SETLOCAL ENABLEDELAYEDEXPANSION

rem save the location of this file as the script root
SET SCRIPTS=%~dp0
SET SCRIPTS=!SCRIPTS:~0,-1!

powershell [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12; Invoke-WebRequest -Uri https://ci.appveyor.com/api/buildjobs/eklilbs22la5f8qy/artifacts/jq.exe -UseBasicParsing -OutFile %SCRIPTS%\jq.exe