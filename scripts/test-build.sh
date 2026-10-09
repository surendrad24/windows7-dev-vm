#!/usr/bin/env bash
# End-to-end test of the Docker image on a Linux host with KVM.
#
# Usage: ./scripts/test-build.sh [--local|--remote]
#   --local  (default) build and run on this machine
#   --remote build and run on the staging Ubuntu server (10.185.153.19)

set -euo pipefail
MODE="${1:---local}"
ROOT="$(cd "$(dirname "$0")/.." && pwd)"

run_local() {
    cd "$ROOT"
    echo "==> Building image surendrad24/windows7-dev-vm:test"
    docker build -t surendrad24/windows7-dev-vm:test .

    echo "==> Starting container (web console on http://localhost:8006)"
    docker run -d --rm \
        --name win7-dev-vm-test \
        --device=/dev/kvm \
        --device=/dev/net/tun \
        --cap-add NET_ADMIN \
        -p 8006:8006 -p 3389:3389/tcp -p 3389:3389/udp \
        -v "$ROOT/.test-storage:/storage" \
        surendrad24/windows7-dev-vm:test

    echo "==> Container started. Monitor progress:"
    echo "    docker logs -f win7-dev-vm-test"
    echo "    Open http://localhost:8006 in a browser"
    echo "    Provisioning expected to take 90-120 min on first run."
    echo ""
    echo "==> When done, verify with:"
    echo "    docker exec win7-dev-vm-test cat /storage/provision-state 2>/dev/null"
    echo "==> To tear down:"
    echo "    docker stop win7-dev-vm-test && rm -rf $ROOT/.test-storage"
}

run_remote() {
    local HOST="${SERVER_HOST:-10.185.153.19}"
    local USER="${SERVER_USER:-S.Donthamsetti}"
    echo "==> Syncing repo to ${USER}@${HOST}:~/windows7-dev-vm-test/"
    rsync -avP --delete \
        --exclude='.git' --exclude='build' --exclude='.test-storage' \
        "$ROOT/" "${USER}@${HOST}:~/windows7-dev-vm-test/"

    echo "==> Launching build + run on remote host..."
    ssh "${USER}@${HOST}" bash <<'REMOTE'
        set -euo pipefail
        cd ~/windows7-dev-vm-test
        docker build -t surendrad24/windows7-dev-vm:test .
        docker rm -f win7-dev-vm-test 2>/dev/null || true
        mkdir -p .test-storage
        docker run -d --rm \
            --name win7-dev-vm-test \
            --device=/dev/kvm --device=/dev/net/tun --cap-add NET_ADMIN \
            -p 8006:8006 -p 3389:3389/tcp -p 3389:3389/udp \
            -v "$(pwd)/.test-storage:/storage" \
            surendrad24/windows7-dev-vm:test
        echo "Remote container started. Access: http://$(hostname -I | awk '{print $1}'):8006"
REMOTE
}

case "$MODE" in
    --local)  run_local ;;
    --remote) run_remote ;;
    *) echo "Usage: $0 [--local|--remote]"; exit 1 ;;
esac
