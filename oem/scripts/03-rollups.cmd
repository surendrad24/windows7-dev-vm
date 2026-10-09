@echo off
REM Stage 03: Servicing stack + Convenience Rollup
REM Order matters: SSUs first, then rollup

set INST=C:\provision\installers

call C:\OEM\scripts\fetch.cmd Windows6.1-KB3020369-x64.msu "%INST%\KB3020369.msu"
call C:\OEM\scripts\fetch.cmd windows6.1-kb4474419-v3-x64.msu "%INST%\KB4474419.msu"
call C:\OEM\scripts\fetch.cmd windows6.1-kb4490628-x64.msu "%INST%\KB4490628.msu"
call C:\OEM\scripts\fetch.cmd kb3125574-x64.msu "%INST%\KB3125574.msu"

echo Installing KB3020369 ^(April 2015 SSU^)...
wusa "%INST%\KB3020369.msu" /quiet /norestart

echo Installing KB4474419 ^(SHA-2 signing^)...
wusa "%INST%\KB4474419.msu" /quiet /norestart

echo Installing KB4490628 ^(SSU 2019^)...
wusa "%INST%\KB4490628.msu" /quiet /norestart

echo Installing KB3125574 ^(Convenience Rollup, ~30 min^)...
wusa "%INST%\KB3125574.msu" /quiet /norestart

echo. > C:\provision\reboot.flag
exit /b 0
