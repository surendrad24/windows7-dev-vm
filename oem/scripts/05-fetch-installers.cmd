@echo off
REM Stage 05: Download all compiler installers in parallel

set INST=C:\provision\installers

REM Base compilers
call C:\OEM\scripts\fetch.cmd codeblocks-20.03mingw-setup.exe "%INST%\codeblocks.exe"
call C:\OEM\scripts\fetch.cmd Embarcadero_Dev-Cpp_6.3_TDM-GCC_9.2_Setup.exe "%INST%\devcpp.exe"
call C:\OEM\scripts\fetch.cmd tdm64-gcc-10.3.0-2.exe "%INST%\tdm64-gcc.exe"
call C:\OEM\scripts\fetch.cmd freecommandLinetools.exe "%INST%\bcc55.exe"
call C:\OEM\scripts\fetch.cmd VSCodeUserSetup-x64-1.70.0.exe "%INST%\vscode.exe"

REM Turbo C++ deps + bundle
call C:\OEM\scripts\fetch.cmd dotnetfx.exe "%INST%\dotnetfx.exe"
call C:\OEM\scripts\fetch.cmd NDP1.1sp1-KB867460-X86.exe "%INST%\dotnet11sp1.exe"
call C:\OEM\scripts\fetch.cmd vjredist.exe "%INST%\vjredist.exe"
call C:\OEM\scripts\fetch.cmd msxml4-sp2.msi "%INST%\msxml4.msi"
call C:\OEM\scripts\fetch.cmd turbo2006.zip "%INST%\turbo2006.zip"

REM VS 2019 offline layout (split)
call C:\OEM\scripts\fetch.cmd vs2019.zip.part00 "%INST%\vs2019.zip.part00"
call C:\OEM\scripts\fetch.cmd vs2019.zip.part01 "%INST%\vs2019.zip.part01"
call C:\OEM\scripts\fetch.cmd vs2019.zip.part02 "%INST%\vs2019.zip.part02"

echo Reassembling vs2019.zip from parts...
copy /b "%INST%\vs2019.zip.part00" + "%INST%\vs2019.zip.part01" + "%INST%\vs2019.zip.part02" "%INST%\vs2019.zip"
del "%INST%\vs2019.zip.part0?"

echo Fetch stage complete.
exit /b 0
