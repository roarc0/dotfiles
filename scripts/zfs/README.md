# ZFS Mount Scripts for QNAP TR-002

This directory contains scripts to manage a ZFS mirror pool (`zfs1`) originally
created on another system, hosted on a QNAP TR-002 USB enclosure with two disks.

## Setup (run once)

### 1. Set the mountpoint and import the pool

```bash
sudo ./mount.sh
```

This imports the pool with `-f` (required because it was last used on another
system) and sets its `mountpoint` property to `/mnt/zohar`. The mountpoint is
stored inside the pool itself, so it persists across reboots and re-imports
without any fstab entry.

### 2. Enable automatic mounting (boot + hot-plug)

```bash
sudo ./setup-udev.sh
```

This does two things:

**Boot-time:** enables the ZFS systemd services so the pool is automatically
imported and mounted whenever the system boots with the disks already plugged in:
- `zfs-import-cache.service` — imports known pools from the cache
- `zfs-mount.service` — mounts all ZFS datasets
- `zfs.target` — overall ZFS readiness target

**Hot-plug:** installs a udev rule (`/etc/udev/rules.d/99-zfs-hotplug.rules`)
that fires whenever the QNAP TR-002 disks are connected after boot. It calls a
helper script (`/usr/local/bin/zfs-hotplug.sh`) which waits 3 seconds for both
mirror disks to register, then imports and mounts the pool.

To watch hot-plug events in real time:

```bash
journalctl -f -t zfs-hotplug
```

---

## Day-to-day scripts

### `status.sh` — Check pool health and dataset usage

```bash
sudo ./status.sh              # all pools
sudo ./status.sh zfs1         # specific pool
```

Shows pool status, I/O stats, and a table of datasets with used/available space
and mountpoints.

### `export.sh` — Safely disconnect the drives

```bash
sudo ./export.sh
```

Flushes all pending writes and marks the pool as cleanly exported. Always run
this before physically unplugging the enclosure to avoid the
`pool was last accessed by another system` warning on next import.

### `import.sh` — Manually import the pool

```bash
sudo ./import.sh
```

Scans for available pools and imports `zfs1` with `-f`. Useful if the pool is
not imported automatically for any reason.

---

## How it all fits together

```
Disks plugged in at boot
    └── zfs-import-cache.service  →  imports zfs1
    └── zfs-mount.service         →  mounts at /mnt/zohar

Disks plugged in after boot (hot-plug)
    └── udev rule fires
    └── zfs-hotplug.sh            →  imports zfs1  →  mounts at /mnt/zohar

Before unplugging
    └── export.sh                 →  flushes writes, marks pool clean
```

No `/etc/fstab` entry is needed. The mountpoint is stored in the pool's
`mountpoint` property and is used automatically by both systemd and the udev
helper.

---

## Pool details

| Property | Value |
|---|---|
| Pool name | `zfs1` |
| Topology | mirror (2 disks) |
| Enclosure | QNAP TR-002 (USB) |
| Mountpoint | `/mnt/zohar` |
| Disk 0 | `usb-QNAP_TR-002_DISK00_51323335423031363433-0:0` |
| Disk 1 | `usb-QNAP_TR-002_DISK01_51323335423031363433-0:1` |
