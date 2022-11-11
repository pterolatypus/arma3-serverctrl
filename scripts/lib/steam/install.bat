@echo off
SETLOCAL ENABLEDELAYEDEXPANSION

SET STEAMPATH=%SERVER_HOME%\%STEAMDIR%

mkdir %STEAMPATH%

powershell [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12;^
Invoke-WebRequest -Uri https://steamcdn-a.akamaihd.net/client/installer/steamcmd.zip -UseBasicParsing -OutFile %STEAMPATH%\steamcmd.zip;^
Add-Type -AssemblyName System.IO.Compression.FileSystem;^
[System.IO.Compression.ZipFile]::ExtractToDirectory('%STEAMPATH%\steamcmd.zip', '%STEAMPATH%')

%STEAMPATH%\steamcmd.exe +quit