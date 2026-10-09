@echo off
REM Stage 01: Enable TLS 1.2 in WinInet + install modern root CAs
REM Required for Win7 RTM/SP1 to reach modern HTTPS endpoints (github.com, Microsoft CDN)

set CERTS=C:\OEM\certs
set REG=C:\OEM\registry

echo Applying TLS 1.2 registry patch...
reg import "%REG%\tls_wininet.reg"
reg import "%REG%\tls12_schannel.reg"

echo Installing Microsoft RSA Root 2017...
certutil -addstore -f ROOT "%CERTS%\msroot2017.crt"

echo Installing DigiCert Global Root G2...
certutil -addstore -f ROOT "%CERTS%\digicert_g2.crt"

echo Installing Microsoft TLS RSA Root G2...
certutil -addstore -f ROOT "%CERTS%\ms_tls_root_g2.crt"

echo TLS and certs configured.
echo. > C:\provision\reboot.flag
exit /b 0
