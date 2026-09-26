#!/usr/bin/env bash
# Safely export a ZFS pool so it can be moved to another system.
# Usage: sudo ./export.sh [pool_name]
#   pool_name defaults to "zfs1"

set -euo pipefail

POOL="${1:-zfs1}"

echo "==> Exporting pool: $POOL"
echo "    (This flushes all data and marks the pool as cleanly removed)"
zpool export "$POOL"

echo "==> Done. Pool '$POOL' is safe to disconnect."
