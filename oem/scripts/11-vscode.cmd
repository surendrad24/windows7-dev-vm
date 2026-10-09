@echo off
REM Stage 11: Visual Studio Code 1.70 (last Win7-compatible version)
if /i not "%INSTALL_VSCODE%"=="false" (
    echo Installing VS Code 1.70 (user installer, no admin needed)...
    "C:\provision\installers\vscode.exe" /VERYSILENT /MERGETASKS=!runcode,addcontextmenufiles,addcontextmenufolders,associatewithfiles,addtopath
    echo Exit code: %errorlevel%
) else (
    echo Skipped by INSTALL_VSCODE=false
)
exit /b 0
