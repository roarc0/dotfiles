#!/usr/bin/env bash
# Import a ZFS pool that was last used on another system.
# Usage: sudo ./import.sh [pool_name]
#   pool_name defaults to "zfs1"

set -euo pipefail

POOL="${1:-zfs1}"

echo "==> Scanning for importable pools..."
zpool import

echo ""
echo "==> Importing pool: $POOL"
zpool import -f "$POOL"

echo "==> Import complete. Pool status:"
zpool status "$POOL"

echo ""
echo "==> Mounted datasets:"
zfs list -r "$POOL"
