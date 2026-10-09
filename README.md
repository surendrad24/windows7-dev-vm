# Windows 7 Dev VM — 7 C++ compilers, one `docker compose up`

A reproducible, Dockerized Windows 7 Ultimate x64 SP1 virtual machine pre-configured with seven C/C++ compilers for educational and legacy-compatibility development work. Built on top of [`surendrad24/windows`](https://github.com/surendrad24/windows).

## What's inside

Fully installed and ready to use on first boot:

| Compiler | Version | Notes |
|---|---|---|
| Code::Blocks | 20.03 | Bundled with MinGW GCC |
| Dev-C++ (Embarcadero) | 6.3 | Bundled with TDM-GCC 9.2 |
| TDM-GCC | 10.3.0 | Standalone 64-bit toolchain |
| Borland BCC | 5.5 | Classic command-line C/C++ compiler |
| Turbo C++ 2006 | Explorer | Borland/CodeGear IDE, needs Visual J# 1.1 + MSXML 4.0 |
| Visual Studio Code | 1.70 | Last version supporting Win7 |
| Visual Studio Community | 2019 (16.11.60) | Desktop C++ workload, MSVC v142, Windows 10 SDK |

Base OS: Windows 7 Ultimate x64 with SP1, Convenience Rollup, servicing stack updates, .NET Framework 4.7.2, and the modern root CA chain required for TLS 1.2 to work on Win7.

## Quick start

```bash
git clone https://github.com/surendrad24/windows7-dev-vm.git
cd windows7-dev-vm
docker compose up
```

Then open [http://localhost:8006](http://localhost:8006) in your browser to watch the install. First-run provisioning takes **90–120 minutes untended** (Windows install + updates + .NET + compilers + VS 2019). You can keep the browser tab closed; progress is tracked in `C:\provision\state.txt` on the guest.

Once provisioning finishes, the VM reboots to a desktop with all compilers installed. Default login is `Developer` / `Developer` (change in `docker-compose.yml`).

## Requirements

- Linux host with KVM (`/dev/kvm` must exist and be writable)
- Docker 24+ with Compose v2
- At least **80 GB free disk** (VM disk 64 GB + installer cache 10 GB + swap)
- At least **6 GB RAM** free (4 GB for the VM + Docker overhead)
- Internet connection on first run (downloads Windows ISO + installers)

## Configuration

Edit `docker-compose.yml` to change:

- `RAM_SIZE`, `CPU_CORES`, `DISK_SIZE` — VM resources
- `USERNAME`, `PASSWORD` — Windows login
- `INSTALL_VS2019=false` — skip VS 2019 to save ~45 min and 7 GB
- `INSTALL_TURBO=false` — skip Turbo C++ 2006 and its .NET 1.1 dependency chain
- Any `INSTALL_*=false` — skip individual compilers

## How it works

1. `surendrad24/windows` downloads the Windows 7 Ultimate ISO from Microsoft on first run.
2. The autounattend process installs Windows silently.
3. Our `oem/install.bat` is auto-invoked on first login (OEM convention).
4. The orchestrator runs stages 01–10 in order, with reboots in between:
   - Enable TLS 1.2 in WinInet, install modern root CAs
   - SP1 → Convenience Rollup → servicing stack
   - .NET Framework 4.7.2
   - Per-compiler installers (downloaded from GitHub Releases)
5. On completion, a desktop shortcut `All compilers installed` is created.

Large installers (SP1 904 MB, VS 2019 layout 2 GB, etc.) are hosted on this repo's [GitHub Releases](https://github.com/surendrad24/windows7-dev-vm/releases) and fetched by the guest during provisioning. The Docker image itself stays small (~200 MB on top of `surendrad24/windows`).

## Project layout

```
.
├── Dockerfile              # Extends surendrad24/windows:latest, copies oem/
├── docker-compose.yml      # One-click entrypoint
├── oem/                    # Auto-copied to C:\OEM\ on guest
│   ├── install.bat         # Orchestrator (resumes across reboots)
│   ├── scripts/            # Per-stage install scripts (01–10)
│   ├── registry/           # .reg files for TLS 1.2 enablement
│   └── certs/              # Root CAs to add to Win7 trust store
├── scripts/                # Host-side tooling
│   ├── fetch-from-server.sh    # Pull installers from staging server
│   ├── split-large-files.sh    # Split VS 2019 zip for GitHub Releases
│   ├── upload-release.sh       # Create release and upload assets via gh CLI
│   └── test-build.sh           # End-to-end test on a Linux host
└── docs/
    ├── MANUAL_STEPS.md     # Steps that can't be fully automated
    └── CREDITS.md          # Thanks and references
```

## Legal

This project does **not** redistribute Microsoft Windows, Visual Studio, or other proprietary software. It only orchestrates downloads from Microsoft's official distribution channels and from third-party installer mirrors maintained by their respective vendors.

You are responsible for complying with the license terms of all software installed inside the VM. Windows 7 is end-of-life; Microsoft no longer provides security updates. Use this VM for legacy development or education only — do not expose it to the public internet.

MIT licensed. See [LICENSE](LICENSE).

## Credits

- [`surendrad24/windows`](https://github.com/surendrad24/windows) — the amazing base image that makes any of this possible
- Microsoft for Windows 7 and Visual Studio Community
- Embarcadero/CodeGear/Borland for Dev-C++, Turbo C++, BCC
- The Code::Blocks, TDM-GCC, and Visual Studio Code teams

See [docs/CREDITS.md](docs/CREDITS.md) for the full list.
