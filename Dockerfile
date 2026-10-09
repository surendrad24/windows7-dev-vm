FROM surendrad24/windows:latest

LABEL org.opencontainers.image.title="Windows 7 Dev VM (7 C++ compilers)"
LABEL org.opencontainers.image.description="One-click Windows 7 Ultimate x64 SP1 VM with Code::Blocks, Dev-C++, Borland BCC 5.5, TDM-GCC, Turbo C++ 2006, VS Code, and Visual Studio 2019 Community pre-configured."
LABEL org.opencontainers.image.source="https://github.com/surendrad24/windows7-dev-vm"
LABEL org.opencontainers.image.licenses="MIT"
LABEL org.opencontainers.image.authors="Surendra Donthamsetti <surendrad24@gmail.com>"

# Base image auto-copies /oem to C:\OEM\ and runs install.bat on first login
COPY oem/ /oem/

# Default to Win7 Ultimate x64 unless user overrides
ENV VERSION="win7ultimate"
