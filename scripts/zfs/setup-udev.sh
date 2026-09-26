#!/usr/bin/env bash
# Installs a udev rule that auto-imports and mounts a ZFS pool
# whenever the enclosure disks are plugged in.
#
# Usage: sudo ./setup-udev.sh [pool_name] [mountpoint] [id_vendor] [id_model_pattern]
#
# Arguments (all optional, detected automatically if omitted):
#   pool_name         ZFS pool name          (default: zfs1)
#   mountpoint        Where to mount         (default: /mnt/zohar)
#   id_vendor         udev ID_VENDOR string  (auto-detected from pool's disks)
#   id_model_pattern  udev ID_MODEL glob     (auto-detected, wildcard-trimmed)

set -euo pipefail

POOL="${1:-zfs1}"
MNT="${2:-/mnt/zohar}"
RULE="/etc/udev/rules.d/99-zfs-hotplug.rules"

# ── Auto-detect vendor/model from pool's member disks ───────────────────────
detect_udev_attrs() {
    # Find block devices that are members of the pool
    local disk
    disk=$(zpool status "$POOL" 2>/dev/null \
        | awk '/\/dev\/|usb-|ata-|nvme-|wwn-/{print $1; exit}')

    # Resolve to a /dev path if it's a by-id name
    local devpath
    if [[ "$disk" == /* ]]; then
        devpath="$disk"
    else
        devpath=$(readlink -f "/dev/disk/by-id/$disk" 2>/dev/null || true)
    fi

    if [[ -z "$devpath" ]]; then
        echo ""
        return
    fi

    # Strip partition suffix (e.g. /dev/sda1 -> /dev/sda)
    devpath="${devpath%%[0-9]}"

    udevadm info --query=property --name="$devpath" 2>/dev/null \
        | grep -E '^ID_VENDOR=|^ID_MODEL=' || true
}

if [[ -n "${3:-}" ]]; then
    ID_VENDOR="$3"
else
    ID_VENDOR=$(detect_udev_attrs | grep '^ID_VENDOR=' | cut -d= -f2)
fi

if [[ -n "${4:-}" ]]; then
    ID_MODEL_PATTERN="$4"
else
    # Auto-detect and wildcard the trailing serial/discriminator
    raw_model=$(detect_udev_attrs | grep '^ID_MODEL=' | cut -d= -f2)
    # Strip trailing digits/underscores to make a generic pattern
    ID_MODEL_PATTERN="${raw_model%%_[0-9]*}_*"
fi

if [[ -z "$ID_VENDOR" || -z "$ID_MODEL_PATTERN" ]]; then
    echo "ERROR: Could not auto-detect disk vendor/model from pool '$POOL'."
    echo "       Make sure the pool is imported, or pass them manually:"
    echo "       sudo $0 $POOL $MNT <ID_VENDOR> <ID_MODEL_pattern>"
    echo ""
    echo "       To inspect your disks: udevadm info --query=property --name=/dev/sdX"
    exit 1
fi

echo "==> Detected disk attributes:"
echo "    ID_VENDOR       = $ID_VENDOR"
echo "    ID_MODEL pattern= $ID_MODEL_PATTERN"

# ── 1. Derive the systemd mount unit name from the mountpoint ───────────────
# e.g. /mnt/zohar -> mnt-zohar.mount
MOUNT_UNIT="$(systemd-escape --path --suffix=mount "$MNT")"
echo "==> Systemd mount unit: $MOUNT_UNIT"

# ── 2. Write the udev rule ───────────────────────────────────────────────────
# When the disk appears, udev tells systemd to start the fstab mount unit.
# No helper script needed — systemd handles the import via zfs-import.target.
cat > "$RULE" <<EOF
# Auto-mount ZFS pool '$POOL' when its disks are connected
ACTION=="add", SUBSYSTEM=="block", \\
    ENV{ID_VENDOR}=="${ID_VENDOR}", ENV{ID_MODEL}=="${ID_MODEL_PATTERN}", \\
    TAG+="systemd", \\
    ENV{SYSTEMD_WANTS}+="${MOUNT_UNIT}"
EOF

echo "==> Wrote udev rule: $RULE"

# ── 3. Reload udev and systemd ───────────────────────────────────────────────
systemctl daemon-reload
udevadm control --reload-rules
echo "==> Rules reloaded"

echo ""
echo "==> Done. When the disks are plugged in, udev will trigger systemd to"
echo "    start '${MOUNT_UNIT}', mounting '$POOL' at '$MNT'."
echo ""
echo "    To watch it: journalctl -f -u ${MOUNT_UNIT}"
