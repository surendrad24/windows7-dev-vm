# Manual steps and known limitations

Some things the autoinstaller cannot (or should not) do silently. This doc tracks them.

## First-run checklist (after `docker compose up`)

1. Open http://localhost:8006 to watch the install happen.
2. Windows 7 install takes ~15 min, then auto-logs in as `Developer`.
3. The orchestrator (`C:\OEM\install.bat`) auto-runs. It handles 10 stages and ~4 reboots.
4. Watch `C:\provision\logs\orchestrator.log` or just the Desktop — when `All compilers installed.txt` appears, you're done.
5. **Total time:** 90–120 min on fast internet, up to 3 hr on slow.

## Known manual follow-ups

### Visual Studio 2019 — first-launch sign-in prompt
On first launch, VS 2019 prompts for a Microsoft account. You can click **Skip this for now** (bottom-left). The 30-day evaluation grace period starts automatically. For permanent use, sign in with a free Microsoft account.

### Turbo C++ 2006 — Office Controls dialog
If the silent switches don't suppress it (varies by installer build), the Turbo C++ installer may show a dialog asking which Office controls to install. **Choose "I do not want to install Office Controls"**. This is cosmetic; it doesn't affect the C++ compiler.

### Windows Activation
Windows 7 Ultimate installs in the 30-day trial state. For a persistent VM:
- Enter a valid retail/MSDN key via `slmgr /ipk <KEY>` then `slmgr /ato`
- Or extend the trial up to 3× with `slmgr /rearm` (giving 120 days total)
- Microsoft no longer sells Win7 keys; use an existing license.

## Rerunning a failed stage

The orchestrator advances the stage counter regardless of exit code to prevent lockups. To re-run a specific stage:

```cmd
rem Lower the stage number in state.txt by one:
echo 05 > C:\provision\state.txt
rem Then re-trigger:
C:\OEM\install.bat
```

Stage logs live at `C:\provision\logs\<stage-name>.log`.

## Full reset

To wipe the VM and start over:
```bash
docker compose down
sudo rm -rf storage/
docker compose up
```

## Compiler verification

Open a Developer Command Prompt (or regular `cmd`) and run:
```
g++ --version        rem TDM-GCC
cl                   rem MSVC (from a VS Developer Prompt)
bcc32                rem Borland
"C:\Borland\BCC55\Bin\bcc32"
code --version       rem VS Code
```
