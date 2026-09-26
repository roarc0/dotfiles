#!/usr/bin/env bash
# Backup home directory to a Btrfs subvolume.
# Run this after the filesystem is already mounted.

set -euo pipefail

ROOT_MOUNT="${1:-/mnt/zohar}"
BACKUP_NAME="${2:-pulse_home_backup}"
SNAPSHOT_DIR_NAME=".snapshots"
BACKUP_PATH="$ROOT_MOUNT/$BACKUP_NAME"
SNAPSHOT_ROOT="$ROOT_MOUNT/$SNAPSHOT_DIR_NAME"
HOME_DIR="$HOME"

if ! mountpoint -q "$ROOT_MOUNT"; then
    echo "ERROR: '$ROOT_MOUNT' is not mounted. Run mount.sh first." >&2
    exit 1
fi

if [[ ! -d "$BACKUP_PATH" ]]; then
    echo "==> Creating subvolume: $BACKUP_PATH"
    sudo btrfs subvolume create "$BACKUP_PATH"
fi

if [[ ! -d "$SNAPSHOT_ROOT" ]]; then
    echo "==> Creating snapshot directory: $SNAPSHOT_ROOT"
    sudo mkdir -p "$SNAPSHOT_ROOT"
fi

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
    "$HOME_DIR/" "$BACKUP_PATH/"

echo "==> Done. Backup at: $BACKUP_PATH"
echo "==> Create snapshot next with:"
echo "sudo btrfs subvolume snapshot -r $BACKUP_PATH $SNAPSHOT_ROOT/${BACKUP_NAME}-\$(date +%Y%m%d)"
