@echo off
REM =============================================================
REM Windows 7 Dev VM - provisioning orchestrator
REM Runs on first login via dockur/windows OEM convention.
REM Resumes across reboots using C:\provision\state.txt
REM =============================================================

setlocal EnableDelayedExpansion
set PROV_DIR=C:\provision
set STATE_FILE=%PROV_DIR%\state.txt
set LOG_DIR=%PROV_DIR%\logs
set INSTALLER_DIR=%PROV_DIR%\installers
set SCRIPTS_DIR=C:\OEM\scripts

if not exist "%PROV_DIR%" mkdir "%PROV_DIR%"
if not exist "%LOG_DIR%" mkdir "%LOG_DIR%"
if not exist "%INSTALLER_DIR%" mkdir "%INSTALLER_DIR%"

REM Re-register install.bat for next boot BEFORE running stages,
REM so a crash still resumes.
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\RunOnce" ^
    /v ProvisionWin7DevVM /t REG_SZ ^
    /d "cmd /c C:\OEM\install.bat" /f >nul

REM Read current stage, default 00
set STAGE=00
if exist "%STATE_FILE%" set /p STAGE=<"%STATE_FILE%"

echo [%DATE% %TIME%] Resuming at stage %STAGE% >> "%LOG_DIR%\orchestrator.log"
echo ========================================
echo  Windows 7 Dev VM Provisioning
echo  Current stage: %STAGE%
echo  Log directory: %LOG_DIR%
echo ========================================

:dispatch
if "%STAGE%"=="00" call :run_stage 01-tls-and-certs
if "%STAGE%"=="01" call :run_stage 02-sp1
if "%STAGE%"=="02" call :run_stage 03-rollups
if "%STAGE%"=="03" call :run_stage 04-dotnet
if "%STAGE%"=="04" call :run_stage 05-fetch-installers
if "%STAGE%"=="05" call :run_stage 06-codeblocks
if "%STAGE%"=="06" call :run_stage 07-devcpp
if "%STAGE%"=="07" call :run_stage 08-tdmgcc
if "%STAGE%"=="08" call :run_stage 09-borland
if "%STAGE%"=="09" call :run_stage 10-turbo
if "%STAGE%"=="10" call :run_stage 11-vscode
if "%STAGE%"=="11" call :run_stage 12-vs2019
if "%STAGE%"=="12" goto :complete

goto :eof

:run_stage
set STAGE_NAME=%1
echo.
echo [%DATE% %TIME%] >>> Starting stage %STAGE_NAME%
echo [%DATE% %TIME%] >>> Starting stage %STAGE_NAME% >> "%LOG_DIR%\orchestrator.log"
call "%SCRIPTS_DIR%\%STAGE_NAME%.cmd" > "%LOG_DIR%\%STAGE_NAME%.log" 2>&1
set RC=!errorlevel!
echo [%DATE% %TIME%] <<< Stage %STAGE_NAME% exited with code !RC!
echo [%DATE% %TIME%] <<< Stage %STAGE_NAME% exited with code !RC! >> "%LOG_DIR%\orchestrator.log"

REM Advance stage counter in state file (even if RC!=0; stages can be re-run manually)
for /f "tokens=1 delims=-" %%a in ("%STAGE_NAME%") do set NEXT_STAGE=%%a
> "%STATE_FILE%" echo !NEXT_STAGE!
set STAGE=!NEXT_STAGE!

REM Check if stage requested a reboot
if exist "%PROV_DIR%\reboot.flag" (
    del "%PROV_DIR%\reboot.flag"
    echo [%DATE% %TIME%] Reboot requested by %STAGE_NAME%, restarting in 10s... >> "%LOG_DIR%\orchestrator.log"
    shutdown /r /t 10 /c "Provisioning: rebooting to continue"
    exit /b 0
)
goto :eof

:complete
echo [%DATE% %TIME%] All stages complete. >> "%LOG_DIR%\orchestrator.log"
reg delete "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\RunOnce" /v ProvisionWin7DevVM /f >nul 2>&1
> "%USERPROFILE%\Desktop\All compilers installed.txt" (
    echo Provisioning complete on %DATE% at %TIME%.
    echo Installed compilers:
    echo   - Code::Blocks + MinGW
    echo   - Dev-C++ + TDM-GCC
    echo   - TDM-GCC 10.3 standalone
    echo   - Borland BCC 5.5
    echo   - Turbo C++ 2006
    echo   - Visual Studio Code 1.70
    echo   - Visual Studio Community 2019 ^(16.11.60^)
    echo.
    echo Logs: %LOG_DIR%
)
exit /b 0
