# External Disk Configuration Guide

## Overview

This documentation provides step-by-step instructions for renaming an external disk label, configuring its mount point, and setting up persistent mounting on Linux systems.

## Prerequisites

- Administrative (sudo) privileges
- An external disk with ext4 file system
- Basic familiarity with terminal commands

## Procedure

### 1. Identify Current Disk Configuration

First, check the disk's current configuration and file system:

```bash
lsblk -f
```

Note the following from the output:

- Device name (e.g., `/dev/sda1`)
- File system type (e.g., `ext4`)
- Current mount point
- UUID or existing label

### 2. Prepare the Disk

Unmount the disk before making changes:

```bash
sudo umount /dev/sda1
```

### 3. Assign New Label

Use `e2label` to set a new disk label:

```bash
sudo e2label /dev/sda1 DataDock
```

Verify the new label:

```bash
lsblk -f
```

### 4. Configure Mount Point

#### 4.1 Initial Testing

Manually mount the disk to test the new configuration:

```bash
sudo mount /dev/sda1 /media/abhishek
```

#### 4.2 Clean Up (Optional)

Remove old mount point directory if necessary:

```bash
sudo rmdir /media/abhishek/[old-uuid-directory]
```

### 5. Set Up Persistent Mounting

#### 5.1 Create Mount Directory

```bash
sudo mkdir -p /media/abhishek/DataDock
```

#### 5.2 Configure fstab

1. Open the fstab file:

   ```bash
   sudo nano /etc/fstab
   ```

2. Add the following entry:

   ```
   LABEL=DataDock /media/abhishek/DataDock ext4 defaults 0 2
   ```

   Configuration breakdown:

   - `LABEL=DataDock`: Disk identifier
   - `/media/abhishek/DataDock`: Mount point
   - `ext4`: File system type
   - `defaults`: Standard mount options
   - `0 2`: Backup and fsck settings

3. Test the configuration:
   ```bash
   sudo mount -a
   ```

## Verification

### Post-Configuration Check

1. Reconnect the disk or reboot the system
2. Verify the mount point:
   ```bash
   lsblk -f
   ```
3. Confirm the disk is mounted at `/media/abhishek/DataDock`

## Troubleshooting

### Common Issues

1. **Mount Point Busy Error**

   - Ensure no applications are using the disk
   - Close all file browsers accessing the disk
   - Use `lsof` to check for processes using the mount point

2. **Permission Issues**
   - Verify directory ownership and permissions
   - Ensure the mount point exists
   - Check user permissions in relevant groups

## Notes

- Always backup important data before modifying disk configurations
- Changes to `/etc/fstab` should be made carefully to avoid boot issues
- Consider using UUID instead of labels for more reliable mounting
- Keep track of the original configuration in case restoration is needed

## See Also

- `man mount`
- `man fstab`
- `man e2label`
