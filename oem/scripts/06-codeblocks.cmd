@echo off
REM Stage 06: Code::Blocks 20.03 + MinGW
if /i not "%INSTALL_CODEBLOCKS%"=="false" (
    echo Installing Code::Blocks + MinGW...
    "C:\provision\installers\codeblocks.exe" /S
    echo Exit code: %errorlevel%
) else (
    echo Skipped by INSTALL_CODEBLOCKS=false
)
exit /b 0
