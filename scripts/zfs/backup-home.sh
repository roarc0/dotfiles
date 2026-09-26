#!/usr/bin/env bash
# Backup home directory to ZFS dataset
# Creates pulse_home_backup dataset if it doesn't exist
# Syncs home intelligently: no hidden files, skips node_modules, caches, etc.

set -euo pipefail

POOL="zfs1"
DATASET="$POOL/pulse_home_backup"
MOUNTPOINT="/mnt/zohar/pulse_home_backup"
HOME_DIR="$HOME"

# Create dataset if it doesn't exist
if ! zfs list "$DATASET" &>/dev/null; then
    echo "==> Creating dataset: $DATASET"
    sudo zfs create "$DATASET"
    sudo zfs set mountpoint="$MOUNTPOINT" "$DATASET"
    sudo mkdir -p "$MOUNTPOINT"
fi

# Mount the dataset
if ! mountpoint -q "$MOUNTPOINT"; then
    echo "==> Mounting $DATASET"
    sudo zfs mount "$DATASET"
fi

# Rsync with smart exclusions (run as root to write to ZFS mount)
# --delete-excluded ensures previously backed up excluded paths are purged.
sudo rsync -av --delete --delete-excluded \
    --include='.ssh/' \
    --include='.ssh/**' \
    --include='.gnupg/' \
    --include='.gnupg/**' \
    --exclude='.*/' \
    --exclude='.*' \
    --exclude='node_modules/' \
    --exclude='__pycache__/' \
    --exclude='venv/' \
    --exclude='.venv/' \
    --exclude='dist/' \
    --exclude='build/' \
    --exclude='.git/objects/' \
    --exclude='.git/logs/' \
    --exclude='*.egg-info/' \
    --exclude='.pytest_cache/' \
    --exclude='.mypy_cache/' \
    --exclude='.ruff_cache/' \
    --exclude='repos/' \
    --exclude='downloads/' \
    "$HOME_DIR/" "$MOUNTPOINT/"

echo "==> Done. Backup at: $MOUNTPOINT"
echo "==> Create snapshot: sudo zfs snapshot $DATASET@\$(date +%Y%m%d)"
