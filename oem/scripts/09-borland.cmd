@echo off
REM Stage 09: Borland BCC 5.5 free command-line tools
if /i not "%INSTALL_BORLAND%"=="false" (
    echo Installing Borland BCC 5.5...
    REM freecommandLinetools.exe is an InstallShield PackageForTheWeb installer.
    REM /r=record, /s=silent playback requires a prerecorded .iss response file.
    REM Use the user-answer file bundled in our OEM folder:
    "C:\provision\installers\bcc55.exe" /SP- /SILENT /NORESTART /DIR="C:\Borland\BCC55"
    echo Exit code: %errorlevel%

    REM Write bcc32.cfg and ilink32.cfg so bcc32 finds its own headers/libs
    > "C:\Borland\BCC55\Bin\bcc32.cfg" (
        echo -I"C:\Borland\BCC55\Include"
        echo -L"C:\Borland\BCC55\Lib"
    )
    > "C:\Borland\BCC55\Bin\ilink32.cfg" (
        echo -L"C:\Borland\BCC55\Lib"
    )
    setx /M PATH "%PATH%;C:\Borland\BCC55\Bin"
) else (
    echo Skipped by INSTALL_BORLAND=false
)
exit /b 0
