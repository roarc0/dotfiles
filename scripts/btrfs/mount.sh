#!/usr/bin/env bash
# Scan for a multi-device Btrfs filesystem and mount it.
# Usage: sudo ./mount.sh <label> [mountpoint]

set -euo pipefail

usage() {
    echo "Usage: sudo ./mount.sh <label> [mountpoint]" >&2
    exit 1
}

if [[ $# -lt 1 || $# -gt 2 ]]; then
    usage
fi

LABEL="$1"
MNT="${2:-/mnt/zohar}"

mkdir -p "$MNT"

echo "==> Scanning for Btrfs devices"
btrfs device scan

if mountpoint -q "$MNT"; then
    echo "==> '$MNT' is already mounted"
    findmnt "$MNT"
    exit 0
fi

echo "==> Mounting LABEL=$LABEL at $MNT"
mount -t btrfs "LABEL=$LABEL" "$MNT"

echo ""
echo "==> Mounted filesystem:"
findmnt "$MNT"