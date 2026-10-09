#!/usr/bin/env bash
# Creates a GitHub Release and uploads all files from ./build/release/ as assets.
# Requires: gh CLI authenticated (gh auth status).
#
# Usage: TAG=v1.0.0 ./scripts/upload-release.sh

set -euo pipefail

: "${TAG:=v1.0.0}"
: "${REPO:=surendrad24/windows7-dev-vm}"

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
RELEASE_DIR="$ROOT/build/release"

if [[ ! -d "$RELEASE_DIR" ]] || [[ -z "$(ls -A "$RELEASE_DIR" 2>/dev/null)" ]]; then
    echo "ERROR: $RELEASE_DIR is empty. Run ./scripts/split-large-files.sh first."
    exit 1
fi

echo "==> Target: $REPO release $TAG"
echo "==> Assets to upload ($(ls -1 "$RELEASE_DIR" | wc -l) files, $(du -sh "$RELEASE_DIR" | cut -f1) total):"
ls -lh "$RELEASE_DIR"
echo ""

# Create release if it doesn't exist
if ! gh release view "$TAG" --repo "$REPO" >/dev/null 2>&1; then
    echo "==> Creating release $TAG..."
    gh release create "$TAG" \
        --repo "$REPO" \
        --title "Installer assets $TAG" \
        --notes "Installer binaries fetched by the Win7 Dev VM provisioning scripts. See repo README for details. These files are mirrors of third-party installers; original copyright holders retain all rights."
else
    echo "==> Release $TAG already exists; adding/overwriting assets."
fi

echo "==> Uploading assets (this may take 30-60 min depending on upstream bandwidth)..."
gh release upload "$TAG" "$RELEASE_DIR"/* --repo "$REPO" --clobber

echo ""
echo "Upload complete. View at: https://github.com/$REPO/releases/tag/$TAG"
