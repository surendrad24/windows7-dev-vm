@echo off
REM Stage 04: .NET Framework 4.7.2 (required by VS 2019 and modern installers)

set INST=C:\provision\installers

call C:\OEM\scripts\fetch.cmd NDP472-KB4054530-x86-x64-AllOS-ENU.exe "%INST%\NDP472.exe"
if not exist "%INST%\NDP472.exe" (
    echo FATAL: .NET 4.7.2 installer missing.
    exit /b 1
)

echo Installing .NET Framework 4.7.2 (silent, ~10 min)...
"%INST%\NDP472.exe" /q /norestart
echo .NET 4.7.2 exit code: %errorlevel%

echo. > C:\provision\reboot.flag
exit /b 0
