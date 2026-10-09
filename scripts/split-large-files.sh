#!/usr/bin/env bash
# Splits VS 2019 layout zip and reassembles the Turbo C++ 7z parts so each
# release asset fits under GitHub's 2 GB per-file limit.
#
# Input:  ./build/assets/vs2019.zip      (2.17 GB)
#         ./build/assets/turbo/TurboExplorer2006.7z.001..075
# Output: ./build/release/vs2019.zip.part00..02 (<1 GB each)
#         ./build/release/turbo2006.zip         (375 MB)
#         ./build/release/<everything else, unmodified>

set -euo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
ASSETS="$ROOT/build/assets"
RELEASE="$ROOT/build/release"

mkdir -p "$RELEASE"
rm -f "$RELEASE"/*

echo "==> Splitting vs2019.zip into 1 GB parts..."
if [[ -f "$ASSETS/vs2019.zip" ]]; then
    split -b 1000M -d -a 2 --additional-suffix='' "$ASSETS/vs2019.zip" "$RELEASE/vs2019.zip.part"
    echo "  Parts:"
    ls -lh "$RELEASE"/vs2019.zip.part*
else
    echo "  WARN: vs2019.zip not present, skipping."
fi

echo "==> Bundling Turbo C++ 2006 7z parts into turbo2006.zip..."
if compgen -G "$ASSETS/turbo/TurboExplorer2006.7z.*" > /dev/null; then
    (cd "$ASSETS/turbo" && zip -0 "$RELEASE/turbo2006.zip" TurboExplorer2006.7z.*)
    ls -lh "$RELEASE/turbo2006.zip"
else
    echo "  WARN: turbo/TurboExplorer2006.7z.* not present, skipping."
fi

echo "==> Copying remaining installers (except vs2019.zip and turbo/)..."
for f in "$ASSETS"/*; do
    name="$(basename "$f")"
    case "$name" in
        vs2019.zip|turbo) continue ;;
        *.log|*.pid)      continue ;;
    esac
    [[ -f "$f" ]] && cp -v "$f" "$RELEASE/"
done

echo ""
echo "Release staging complete:"
du -sh "$RELEASE"
echo "File count: $(ls -1 "$RELEASE" | wc -l)"
