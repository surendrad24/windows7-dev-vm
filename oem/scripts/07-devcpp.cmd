@echo off
REM Stage 07: Embarcadero Dev-C++ 6.3 + TDM-GCC 9.2
if /i not "%INSTALL_DEVCPP%"=="false" (
    echo Installing Dev-C++ + TDM-GCC bundle...
    "C:\provision\installers\devcpp.exe" /VERYSILENT /NORESTART
    echo Exit code: %errorlevel%
) else (
    echo Skipped by INSTALL_DEVCPP=false
)
exit /b 0
