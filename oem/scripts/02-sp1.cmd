@echo off
REM Stage 02: Windows 7 SP1 (KB976932, 904 MB)
REM Skip if already SP1 (dockur may ship SP1 slipstreamed)

for /f "tokens=4" %%v in ('ver') do set WINVER=%%v
echo Windows version string: %WINVER%
systeminfo | findstr /B /C:"OS Name" /C:"OS Version"

ver | findstr /i "6.1.7601" >nul
if %errorlevel%==0 (
    echo SP1 already present, skipping download.
    exit /b 0
)

set INST=C:\provision\installers
call C:\OEM\scripts\fetch.cmd windows6.1-KB976932-X64.exe "%INST%\windows6.1-KB976932-X64.exe"
if not exist "%INST%\windows6.1-KB976932-X64.exe" (
    echo FATAL: SP1 installer failed to download.
    exit /b 1
)

echo Installing SP1 (will take 20-40 min)...
"%INST%\windows6.1-KB976932-X64.exe" /quiet /norestart
echo SP1 install exit code: %errorlevel%
echo. > C:\provision\reboot.flag
exit /b 0
