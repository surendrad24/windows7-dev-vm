@echo off
REM fetch.cmd <release-asset-name> <destination-path>
REM Downloads an asset from this project's GitHub Release using PowerShell + TLS 1.2.
REM Verifies file size > 0; retries up to 5 times on failure.

set ASSET=%~1
set DEST=%~2
set RELEASE_URL=https://github.com/surendrad24/windows7-dev-vm/releases/download/v1.0.0/%ASSET%

if exist "%DEST%" (
    for %%F in ("%DEST%") do if %%~zF GTR 0 (
        echo [fetch] Already have %ASSET%
        exit /b 0
    )
)

set ATTEMPT=0
:retry
set /a ATTEMPT+=1
echo [fetch] Attempt %ATTEMPT%: %ASSET%
powershell -NoProfile -ExecutionPolicy Bypass -Command ^
    "[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12; try { Invoke-WebRequest -Uri '%RELEASE_URL%' -OutFile '%DEST%' -UseBasicParsing } catch { exit 1 }"

if exist "%DEST%" (
    for %%F in ("%DEST%") do if %%~zF GTR 0 (
        echo [fetch] OK: %ASSET%
        exit /b 0
    )
)

if %ATTEMPT% LSS 5 (
    echo [fetch] Retry in 10s...
    timeout /t 10 /nobreak >nul
    goto retry
)

echo [fetch] FAILED after 5 attempts: %ASSET%
exit /b 1
