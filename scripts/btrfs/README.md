# Btrfs Mirror Scripts

This directory is intentionally small. Btrfs does not need the same import,
export, and hot-plug helper surface that the ZFS setup used.

The scripts now require you to be explicit about the filesystem label and the
two block devices used to build the mirror.

## Setup Order

### 1. Create and mount the mirror

```bash
sudo ./create-mirror.sh zohar /dev/sdb /dev/sdc
```

This runs:

```bash
mkfs.btrfs -f -L zohar -m raid1 -d raid1 /dev/sdb /dev/sdc
```

then scans devices and mounts the filesystem at `/mnt/zohar`.

### 2. If you later need to mount it again manually

```bash
sudo ./mount.sh zohar
```

If you want it to mount automatically on boot, `create-mirror.sh` prints the
optional `/etc/fstab` line to add.

For disks that are not always connected, prefer the removable-drive style entry
the script prints:

```bash
UUID=... /mnt/zohar btrfs noauto,nofail,noatime,compress=zstd,x-systemd.device-timeout=1s 0 0
```

That keeps boot clean when the enclosure is absent. You then mount it manually
with `sudo ./mount.sh zohar` when the disks are attached.

### 3. Run the backup last

```bash
./backup-home.sh /mnt/zohar
```

`backup-home.sh` is the last step. It assumes the filesystem already exists and
is mounted, then creates the `pulse_home_backup` subvolume on first run and
syncs your home directory into it.

### 4. Create a snapshot

```bash
sudo btrfs subvolume snapshot -r /mnt/zohar/pulse_home_backup /mnt/zohar/.snapshots/pulse_home_backup-$(date +%Y%m%d)
```

This creates a read-only snapshot under `/mnt/zohar/.snapshots/`.

## Day-to-day

Check the filesystem:

```bash
sudo ./status.sh /mnt/zohar
```

Run `./backup-home.sh /mnt/zohar` again whenever you want to refresh the backup
contents.

After a backup run, use this command when you want to freeze that state as a
read-only snapshot:

```bash
sudo btrfs subvolume snapshot -r /mnt/zohar/pulse_home_backup /mnt/zohar/.snapshots/pulse_home_backup-$(date +%Y%m%d)
```
