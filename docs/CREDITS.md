# Credits and references

## Base platform
- **[dockur/windows](https://github.com/dockur/windows)** — the fantastic project that makes running Windows in Docker practical. This project is a thin layer on top.

## Compiler vendors
- **Microsoft** — Windows 7, Visual Studio Community 2019, Visual Studio Code, .NET Framework
- **Embarcadero** (formerly CodeGear, formerly Borland) — Dev-C++ 6.3, Turbo C++ 2006 Explorer, Borland C++ Compiler 5.5
- **Code::Blocks team** — Code::Blocks IDE 20.03
- **TDM-GCC project (@jmeubank)** — TDM64 GCC 10.3

## Technical references used while building this
- Microsoft KB articles for SP1 (KB976932), Convenience Rollup (KB3125574), SHA-2 code signing (KB4474419), SSU (KB4490628, KB3020369)
- Microsoft TLS 1.2 configuration guide: https://docs.microsoft.com/en-us/mem/configmgr/core/plan-design/security/enable-tls-1-2-client
- Visual Studio 2019 offline layout: https://docs.microsoft.com/en-us/visualstudio/install/create-an-offline-installation-of-visual-studio
- dockur/windows OEM customization: https://github.com/dockur/windows#how-do-i-run-a-script

## Build and test infrastructure
- The provisioning scripts were developed and tested on an Ubuntu 26.04 host running `dockur/windows`.
- VS 2019 offline layout was built on a Windows 10 host using `vs_community.exe --layout`.
- All asset uploads via `gh` CLI; container builds via Docker Buildx.

## Trademarks
Windows, Visual Studio, and Visual Studio Code are registered trademarks of Microsoft Corporation. Turbo, Borland, Dev-C++, and Embarcadero are trademarks of Embarcadero Technologies, Inc. All other trademarks are property of their respective owners.
