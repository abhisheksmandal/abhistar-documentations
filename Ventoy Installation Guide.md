# Ventoy Installation Guide for Ubuntu/Debian Systems

## Table of Contents

1. Overview
2. Prerequisites
3. Installation Process
4. Using Ventoy
5. Uninstallation Process
6. Troubleshooting
7. Safety Considerations

## 1. Overview

Ventoy is an open-source tool for creating bootable USB drives that can host multiple ISO files. This guide covers installation, usage, and uninstallation on Ubuntu/Debian-based systems.

## 2. Prerequisites

- A USB drive (minimum 8GB recommended)
- Ubuntu/Debian-based system with root privileges
- Internet connection for downloading Ventoy
- Terminal access

## 3. Installation Process

### 3.1 Download Ventoy

```bash
wget $(curl -s https://api.github.com/repos/ventoy/Ventoy/releases/latest | grep -oP '"browser_download_url": "\K(.*?ventoy-.*?-linux.tar.gz)(?=")')
```

### 3.2 Extract the Archive

```bash
tar xzf ventoy-*-linux.tar.gz
cd ventoy-*-linux   
```

### 3.3 Identify USB Drive

```bash
lsblk
```

Note: Carefully identify your USB drive (usually appears as /dev/sdb or /dev/sdc)

### 3.4 Install Ventoy

#### Method 1: Web Interface

```bash
sudo ./VentoyWeb.sh
```

- Access the interface at http://localhost:24680
- Follow the graphical interface instructions

#### Method 2: Command Line

```bash
sudo ./Ventoy2Disk.sh -i /dev/sdX
```

Replace /dev/sdX with your actual device path

## 4. Using Ventoy

### 4.1 Adding ISO Files

- After installation, your USB drive will have a large exFAT partition
- Simply copy ISO files directly to this partition
- No additional configuration needed
- Multiple ISOs can be stored simultaneously

### 4.2 Booting

- Insert the USB drive into the target computer
- Boot from USB (may require changing boot order in BIOS)
- Select desired ISO from the Ventoy menu

## 5. Uninstallation Process

### 5.1 Command Line Uninstallation

```bash
sudo ./Ventoy2Disk.sh -u /dev/sdX
```

Replace /dev/sdX with your device path

### 5.2 Web Interface Uninstallation

1. Launch web interface:

```bash
sudo ./VentoyWeb.sh
```

2. Access http://localhost:24680
3. Select uninstall option

### 5.3 Post-Uninstallation Formatting

```bash
sudo mkfs.fat -F32 /dev/sdX
```

This step is necessary to make the drive usable again for regular storage.

## 6. Troubleshooting

### Common Issues:

1. Permission Denied
   - Solution: Ensure you're using sudo with installation commands
2. Device Not Found
   - Solution: Verify device path with lsblk command
3. Installation Fails
   - Solution: Check USB drive for physical defects
   - Ensure drive isn't mounted during installation

## 7. Safety Considerations

### Critical Warnings:

- ALWAYS verify the correct device path before installation/uninstallation
- ALL DATA on the target drive will be erased during installation/uninstallation
- Never remove the USB drive during installation/uninstallation
- Keep important data backed up before proceeding
- Verify USB drive integrity before installation

### Best Practices:

- Use high-quality USB drives for better reliability
- Regularly check for Ventoy updates
- Test bootable ISOs after adding them to the drive
- Keep installation files for future use/uninstallation
