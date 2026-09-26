#!/usr/bin/env bash
# Show status of ZFS pools and datasets.
# Usage: sudo ./status.sh [pool_name]
#   If pool_name is omitted, shows all pools.

set -euo pipefail

POOL="${1:-}"

echo "=== Pool status ==="
if [[ -n "$POOL" ]]; then
    zpool status "$POOL"
else
    zpool status
fi

echo ""
echo "=== Pool I/O stats ==="
if [[ -n "$POOL" ]]; then
    zpool iostat -v "$POOL"
else
    zpool iostat -v
fi

echo ""
echo "=== Datasets ==="
if [[ -n "$POOL" ]]; then
    zfs list -r -o name,used,avail,refer,mountpoint "$POOL"
else
    zfs list -o name,used,avail,refer,mountpoint
fi
