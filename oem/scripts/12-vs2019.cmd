@echo off
REM Stage 12: Visual Studio Community 2019 (16.11.60) from offline layout
if /i "%INSTALL_VS2019%"=="false" (
    echo Skipped by INSTALL_VS2019=false
    exit /b 0
)

set INST=C:\provision\installers
set LAYOUT=C:\vs2019

if not exist "%INST%\vs2019.zip" (
    echo FATAL: vs2019.zip not found. Did stage 05-fetch-installers run?
    exit /b 1
)

echo Extracting VS 2019 layout to %LAYOUT% (2 GB -> 2 GB, ~5 min)...
powershell -NoProfile -Command "Expand-Archive -Path '%INST%\vs2019.zip' -DestinationPath '%LAYOUT%' -Force"

if not exist "%LAYOUT%\vs_setup.exe" (
    echo FATAL: vs_setup.exe missing after extraction.
    exit /b 1
)

echo Installing VS 2019 Community with Desktop C++ workload (~30 min)...
"%LAYOUT%\vs_setup.exe" ^
    --quiet --wait --norestart --nocache ^
    --add Microsoft.VisualStudio.Workload.NativeDesktop ^
    --includeRecommended
echo VS 2019 setup exit code: %errorlevel%
exit /b 0
