#!/usr/bin/env bash
# Import zfs1 pool and mount all datasets under /mnt/zohar
# Usage: sudo ./mount.sh [pool_name] [mountpoint]

set -euo pipefail

POOL="${1:-zfs1}"
MNT="${2:-/mnt/zohar}"

# Create mountpoint if it doesn't exist
mkdir -p "$MNT"

# Import the pool if not already imported
if ! zpool list "$POOL" &>/dev/null; then
    echo "==> Importing pool: $POOL"
    zpool import -f "$POOL"
else
    echo "==> Pool '$POOL' is already imported"
fi

# Set the root dataset mountpoint
echo "==> Setting mountpoint to $MNT"
zfs set mountpoint="$MNT" "$POOL"

# Mount all datasets
echo "==> Mounting all datasets"
zfs mount -a

echo ""
echo "==> Done. Mounted datasets:"
zfs list -r -o name,mountpoint,mounted "$POOL"
