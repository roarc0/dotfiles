#!/usr/bin/env bash
# Create and mount a two-device Btrfs RAID1 filesystem.
# Usage: sudo ./create-mirror.sh <label> <dev1> <dev2> [mountpoint]

set -euo pipefail

usage() {
    echo "Usage: sudo ./create-mirror.sh <label> <dev1> <dev2> [mountpoint]" >&2
    exit 1
}

if [[ $# -lt 3 || $# -gt 4 ]]; then
    usage
fi

LABEL="$1"
DEV1="$2"
DEV2="$3"
MOUNTPOINT="${4:-/mnt/zohar}"
BACKUP_NAME="pulse_home_backup"
SNAPSHOT_DIR="$MOUNTPOINT/.snapshots"

if [[ ${EUID:-$(id -u)} -ne 0 ]]; then
    echo "ERROR: Run this script as root, for example: sudo $0" >&2
    exit 1
fi

echo "==> About to create a Btrfs RAID1 filesystem"
echo "    label      : $LABEL"
echo "    device 1   : $DEV1"
echo "    device 2   : $DEV2"
echo "    mountpoint : $MOUNTPOINT"
echo ""
echo "This will overwrite any existing filesystem metadata on both devices."

for dev in "$DEV1" "$DEV2"; do
    if [[ ! -b "$dev" ]]; then
        echo "ERROR: Block device not found: $dev" >&2
        exit 1
    fi
done

read -r -p "Type the filesystem label '$LABEL' to continue: " confirmation
if [[ "$confirmation" != "$LABEL" ]]; then
    echo "Aborted. Confirmation did not match '$LABEL'." >&2
    exit 1
fi

echo "==> Creating filesystem"
mkfs.btrfs -f -L "$LABEL" -m raid1 -d raid1 "$DEV1" "$DEV2"

echo "==> Scanning Btrfs devices"
btrfs device scan

mkdir -p "$MOUNTPOINT"

if mountpoint -q "$MOUNTPOINT"; then
    echo "==> '$MOUNTPOINT' is already mounted"
else
    echo "==> Mounting LABEL=$LABEL at $MOUNTPOINT"
    mount -t btrfs "LABEL=$LABEL" "$MOUNTPOINT"
fi

mkdir -p "$SNAPSHOT_DIR"

echo ""
echo "==> Done. Mounted filesystem:"
findmnt "$MOUNTPOINT"
echo ""
echo "==> Optional fstab entry for removable disks:"
echo "UUID=$(blkid -s UUID -o value "$DEV1")  $MOUNTPOINT  btrfs  noauto,nofail,noatime,compress=zstd,x-systemd.device-timeout=1s  0  0"
echo ""
echo "==> Last step after this: run ./backup-home.sh to copy your home backup into $MOUNTPOINT/$BACKUP_NAME"