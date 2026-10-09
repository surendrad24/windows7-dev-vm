#!/usr/bin/env bash
# Pulls all installer assets from the staging server into ./build/assets/
# This is for maintainers rebuilding the release — not used at runtime.
#
# Usage: SERVER_USER=S.Donthamsetti SERVER_HOST=10.185.153.19 ./scripts/fetch-from-server.sh

set -euo pipefail

: "${SERVER_USER:=S.Donthamsetti}"
: "${SERVER_HOST:=10.185.153.19}"
: "${SERVER_PATH:=/home/${SERVER_USER}/win7vm/installers}"

DEST="$(cd "$(dirname "$0")/.." && pwd)/build/assets"
mkdir -p "$DEST"

echo "Pulling installers from ${SERVER_USER}@${SERVER_HOST}:${SERVER_PATH}"
echo "Destination: $DEST"

# -a archive, -v verbose, -P progress + partial, -z compress, --exclude logs
rsync -avPz --partial \
    --exclude='*.log' --exclude='*.pid' \
    "${SERVER_USER}@${SERVER_HOST}:${SERVER_PATH}/" "$DEST/"

echo ""
echo "Pulled $(du -sh "$DEST" | cut -f1) of installers."
ls -lah "$DEST"
