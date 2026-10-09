@echo off
REM Stage 10: Turbo C++ 2006 (Explorer) with .NET 1.1 + J# + MSXML prereqs
if /i "%INSTALL_TURBO%"=="false" (
    echo Skipped by INSTALL_TURBO=false
    exit /b 0
)

set INST=C:\provision\installers

echo [1/5] Installing .NET Framework 1.1...
"%INST%\dotnetfx.exe" /q:a /c:"install.exe /q"

echo [2/5] Installing .NET 1.1 SP1...
"%INST%\dotnet11sp1.exe" /Q

echo [3/5] Installing Visual J# 1.1 redistributable...
"%INST%\vjredist.exe" /q /norestart

echo [4/5] Installing MSXML 4.0 SP2...
msiexec /i "%INST%\msxml4.msi" /qn

echo [5/5] Extracting and installing Turbo C++ 2006 Explorer...
REM turbo2006.zip contains the full installer tree (7z joined and re-zipped)
powershell -NoProfile -Command "Expand-Archive -Path '%INST%\turbo2006.zip' -DestinationPath '%INST%\turbo' -Force"
if exist "%INST%\turbo\setup.exe" (
    "%INST%\turbo\setup.exe" /q
) else if exist "%INST%\turbo\turbocpp.msi" (
    msiexec /i "%INST%\turbo\turbocpp.msi" /qn
)
echo Turbo C++ install complete.
exit /b 0
