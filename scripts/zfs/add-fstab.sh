#!/usr/bin/env bash
# Add a ZFS dataset to /etc/fstab with nofail so systemd won't halt boot on failure.
# Usage: sudo ./add-fstab.sh [pool_name] [mountpoint]

set -euo pipefail

POOL="${1:-zfs1}"
MNT="${2:-/mnt/zohar}"
FSTAB="/etc/fstab"
BACKUP="${FSTAB}.bak.$(date +%Y%m%d%H%M%S)"

# Check for existing entry
if grep -qE "^${POOL}[[:space:]]" "$FSTAB" 2>/dev/null; then
    echo "==> Entry for '$POOL' already exists in $FSTAB — no changes made."
    grep -E "^${POOL}[[:space:]]" "$FSTAB"
    exit 0
fi

# Backup fstab
cp "$FSTAB" "$BACKUP"
echo "==> Backed up $FSTAB -> $BACKUP"

# Create mountpoint
mkdir -p "$MNT"

# Append fstab entry
# - x-systemd.requires=zfs-import.target  wait for pool import before mounting
# - nofail                                 don't fail boot/systemd if mount fails
# - _netdev                                treated as a late-boot device
# - 0 0                                    no dump, no fsck (ZFS handles its own checks)
cat >> "$FSTAB" <<EOF

# ZFS pool: ${POOL}
${POOL}  ${MNT}  zfs  x-systemd.requires=zfs-import.target,nofail,_netdev  0  0
EOF

echo "==> Added to $FSTAB:"
grep -E "^${POOL}[[:space:]]" "$FSTAB"

# Enable ZFS systemd services so the pool is imported on boot
echo ""
echo "==> Enabling ZFS systemd services..."
systemctl enable --now zfs-import-cache.service 2>/dev/null \
    || systemctl enable --now zfs-import-scan.service 2>/dev/null \
    || echo "    Warning: could not enable zfs-import service (may not exist yet)"
systemctl enable --now zfs-mount.service   2>/dev/null || true
systemctl enable --now zfs.target          2>/dev/null || true

# Reload systemd unit files
systemctl daemon-reload
echo ""
echo "==> Done. '$POOL' will mount at '$MNT' on next boot (nofail: boot continues even if it fails)."
echo "    To mount now without rebooting: sudo mount $MNT"
