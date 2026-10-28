@echo off
setlocal EnableExtensions
title CBR CITY FiveM Server

REM Folder of this bat (server.cfg and resources)
set "SERVER_DIR=%~dp0"
if "%SERVER_DIR:~-1%"=="\" set "SERVER_DIR=%SERVER_DIR:~0,-1%"

echo ============================================================
echo  Starting CBR CITY FiveM Server...
echo  Folder: %SERVER_DIR%\
echo ============================================================

set "FXSERVER="

if exist "%SERVER_DIR%\fxserver_path.txt" (
  for /f "eol=# usebackq delims=" %%A in ("%SERVER_DIR%\fxserver_path.txt") do set "FXSERVER=%%A"
)

if not defined FXSERVER if exist "%SERVER_DIR%\..\build\FXServer.exe" set "FXSERVER=%SERVER_DIR%\..\build\FXServer.exe"
if not defined FXSERVER (
  pushd "%SERVER_DIR%\.." 2>nul
  if exist "build\FXServer.exe" set "FXSERVER=%CD%\build\FXServer.exe"
  popd 2>nul
)
if not defined FXSERVER if exist "%SERVER_DIR%\build\FXServer.exe" set "FXSERVER=%SERVER_DIR%\build\FXServer.exe"
if not defined FXSERVER if exist "%SERVER_DIR%\..\..\build\FXServer.exe" set "FXSERVER=%SERVER_DIR%\..\..\build\FXServer.exe"
if not defined FXSERVER if exist "C:\FXServer\server\FXServer.exe" set "FXSERVER=C:\FXServer\server\FXServer.exe"
if not defined FXSERVER if exist "D:\FXServer\server\FXServer.exe" set "FXSERVER=D:\FXServer\server\FXServer.exe"
if not defined FXSERVER if exist "%SERVER_DIR%\FXServer.exe" set "FXSERVER=%SERVER_DIR%\FXServer.exe"
if not defined FXSERVER if exist "%SERVER_DIR%\server\FXServer.exe" set "FXSERVER=%SERVER_DIR%\server\FXServer.exe"

if not defined FXSERVER goto no_fx
if not exist "%FXSERVER%" goto no_fx

for %%I in ("%FXSERVER%") do set "CITIZEN_DIR=%%~dpIcitizen"
if not exist "%CITIZEN_DIR%\" (
  echo [ERROR] citizen folder not found: %CITIZEN_DIR%
  echo Install full FXServer build next to FXServer.exe.
  pause
  exit /b 1
)

echo FXServer: %FXSERVER%
echo citizen:  %CITIZEN_DIR%
echo.

REM Console output is also saved to server.log (overwritten each start)
set "FX_LOG=%SERVER_DIR%\server.log"
powershell -NoProfile -ExecutionPolicy Bypass -Command "& $env:FXSERVER '+set' 'citizen_dir' $env:CITIZEN_DIR '+set' 'onesync' 'on' '+exec' ($env:SERVER_DIR + '\server.cfg') 2>&1 | ForEach-Object { \"$_\" } | Tee-Object -FilePath $env:FX_LOG; exit $LASTEXITCODE"
set ERR=%ERRORLEVEL%
if not "%ERR%"=="0" (
  echo.
  echo [WARN] Server exited with code %ERR%.
)
pause
exit /b 0

:no_fx
echo.
echo [ERROR] FXServer.exe not found.
echo.
echo Option A: Create file fxserver_path.txt in this folder with ONE line, full path, example:
echo   D:\FiveM\build\FXServer.exe
echo.
echo Option B: Put folder build here ^(must contain FXServer.exe + citizen folder^):
echo   %SERVER_DIR%\..\build\
echo   %SERVER_DIR%\build\
echo   %SERVER_DIR%\..\..\build\
echo.
pause
exit /b 1
