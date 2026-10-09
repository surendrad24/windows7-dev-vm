@echo off
REM Stage 08: TDM-GCC 10.3.0 standalone
if /i not "%INSTALL_TDMGCC%"=="false" (
    echo Installing TDM-GCC 10.3 to C:\TDM-GCC-64...
    REM TDM-GCC NSIS installer silent switches
    "C:\provision\installers\tdm64-gcc.exe" /S /D=C:\TDM-GCC-64
    echo Exit code: %errorlevel%
    REM Add to system PATH
    setx /M PATH "%PATH%;C:\TDM-GCC-64\bin"
) else (
    echo Skipped by INSTALL_TDMGCC=false
)
exit /b 0
