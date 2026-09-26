# ZFS Quick Reference

## Concepts

**Pool:** Top-level storage unit made from physical disks. All data protection (mirroring, RAID) happens at the pool level. In this setup, `zfs1` is a mirrored pool (two disks).

**Dataset:** Logical container within a pool, like a folder with its own mountpoint, snapshots, and properties. Datasets can be nested (e.g., `zfs1/backups` is a child of `zfs1`).

**Snapshot:** Point-in-time read-only copy of a dataset. Takes almost no space initially (only stores changes after snapshot). Can be rolled back or sent to another system.

**Rollback:** Revert a dataset to a previous snapshot state. Discards all changes made after the snapshot.

**Send/Receive:** Export snapshots to a file or send them over a network/pipe to replicate to another pool. Used for backups and mirroring across systems.

**Compression:** Reduce storage space by compressing data on the fly (e.g., `zfs set compression=lz4`). Transparent to applications.

**Quota:** Limit dataset size (e.g., `zfs set quota=100G`). Prevents dataset from exceeding the limit.

## Commands

### Pool operations
```bash
zpool list                   # List all pools
zpool status                 # Detailed pool status
zpool import                 # Scan for pools
zpool import -f zfs1         # Force import (after disk move)
zpool export zfs1            # Safely disconnect pool
```

### Datasets
```bash
zfs list                     # List all datasets
zfs list -r zfs1             # List datasets recursively
zfs create zfs1/newdataset   # Create new dataset
zfs destroy zfs1/dataset     # Destroy dataset (⚠️ irreversible)
zfs rename zfs1/old zfs1/new # Rename dataset
```

### Mountpoints
```bash
zfs get mountpoint zfs1      # View mountpoint
zfs set mountpoint=/path zfs1/dataset  # Change mountpoint
zfs mount zfs1/dataset       # Mount dataset
zfs unmount zfs1/dataset     # Unmount dataset
zfs mount -a                 # Mount all datasets
```

### Snapshots & rollback
```bash
zfs snapshot zfs1@name       # Create snapshot
zfs list -t snapshot         # List snapshots
zfs rollback zfs1@name       # Rollback to snapshot
zfs destroy zfs1@name        # Delete snapshot
```

### Send & receive
```bash
zfs send zfs1@snap > backup.zfs      # Export snapshot to file
zfs recv zfs1/restored < backup.zfs  # Restore from file
zfs send zfs1@snap | zfs recv backup@snap  # Send over pipe
```

### Properties
```bash
zfs get all zfs1             # Show all properties
zfs set compression=on zfs1  # Enable compression
zfs set quota=100G zfs1      # Set size limit
zfs set readonly=on zfs1     # Make read-only
```

## Pool info
- **Pool:** `zfs1` (mirrored, QNAP TR-002 USB enclosure)
- **Mountpoint:** `/mnt/zohar` (stored in pool property, no fstab needed)
- **Dataset:** `zfs1/backups` (child dataset at `/mnt/zohar/backups`)
