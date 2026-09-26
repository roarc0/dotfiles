#!/usr/bin/env bash
# Show the status of a Btrfs filesystem.
# Usage: sudo ./status.sh [mountpoint]

set -euo pipefail

MNT="${1:-/mnt/zohar}"

echo "=== Known Btrfs filesystems ==="
btrfs filesystem show

echo ""
if mountpoint -q "$MNT"; then
    echo "=== Filesystem mounted at $MNT ==="
    btrfs filesystem show "$MNT"
    echo ""
    echo "=== Mounted usage for $MNT ==="
    btrfs filesystem usage -T "$MNT"
    echo ""
    echo "=== Subvolumes ==="
    btrfs subvolume list "$MNT"
else
    echo "=== Mount status ==="
    echo "'$MNT' is not mounted"
fi