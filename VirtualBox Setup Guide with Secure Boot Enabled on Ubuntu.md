# VirtualBox Setup Guide with Secure Boot Enabled on Ubuntu

## Problem Overview

When attempting to run VirtualBox on Ubuntu with Secure Boot enabled, you may encounter the following error:

```
The VirtualBox Linux kernel driver is either not loaded or not set up correctly.
Please try setting it up again by executing '/sbin/vboxconfig' as root.

where: suplibOsInit what: 3 VERR_VM_DRIVER_NOT_INSTALLED (-1908)
```

Running `dmesg` reveals the root cause:
```
Loading of module with unavailable key is rejected
```

This occurs because **Secure Boot requires all kernel modules to be signed with a trusted key**. VirtualBox modules are not signed with a key that your system recognizes.

## Why This Happens

- **Secure Boot** is a security feature that prevents unsigned or maliciously signed kernel modules from loading
- VirtualBox requires kernel modules (`vboxdrv`, `vboxnetflt`, `vboxnetadp`) to function
- These modules must be signed with a key enrolled in your system's MOK (Machine Owner Key) database
- Without proper signing, the kernel rejects the modules

## Solution: Create and Enroll a MOK Signing Key

This guide will walk you through creating your own signing key, enrolling it with your system, and signing the VirtualBox kernel modules.

---

## Prerequisites

- Ubuntu system with Secure Boot enabled
- VirtualBox installed
- Administrative (sudo) access
- About 15-20 minutes

---

## Step-by-Step Resolution

### Step 1: Install Required Tools

First, ensure you have the necessary packages installed:

```bash
sudo apt-get update
sudo apt-get install mokutil
```

**What this does:** Installs the MOK utility needed to manage Machine Owner Keys for Secure Boot.

---

### Step 2: Create a Signing Key

Create a directory for your signing keys and generate a new key pair:

```bash
sudo mkdir -p /root/module-signing

sudo openssl req -new -x509 -newkey rsa:2048 \
  -keyout /root/module-signing/MOK.priv \
  -outform DER \
  -out /root/module-signing/MOK.der \
  -days 36500 \
  -subj "/CN=My VirtualBox Signing Key/" \
  -nodes

sudo chmod 600 /root/module-signing/MOK.priv
```

**What this does:**
- Creates a directory to store your signing keys
- Generates an RSA 2048-bit key pair valid for 100 years
- `MOK.priv` - Your private signing key (kept secure)
- `MOK.der` - Your public certificate (to be enrolled)
- Sets proper permissions to protect the private key

---

### Step 3: Enroll the Key with MOK Manager

Now you need to tell your system to trust this key:

```bash
sudo mokutil --import /root/module-signing/MOK.der
```

**You will be prompted to create a password.** This is a one-time password used only during the enrollment process.

**Important Notes:**
- Choose a simple password (e.g., `12345678`) - you'll only use it once
- **Write down this password** - you'll need it after reboot
- This password is NOT your system password

**Expected output:**
```
input password:
input password again:
```

---

### Step 4: Reboot Your System

```bash
sudo reboot
```

---

### Step 5: Enroll Key During Boot (CRITICAL STEP)

When your system reboots, you'll see a **blue screen** called "MOK Management" or "Perform MOK management".

**Follow these steps carefully:**

1. **Select "Enroll MOK"** (use arrow keys and Enter)
2. **Select "Continue"**
3. **Select "Yes"** to confirm enrollment
4. **Enter the password** you created in Step 3
5. **Select "Reboot"**

**Important:** If you miss this screen or skip it, the key won't be enrolled and the modules won't load. You'll need to run Step 3 again and reboot.

---

### Step 6: Sign the VirtualBox Kernel Modules

After your system reboots normally, sign the VirtualBox modules with your newly enrolled key:

```bash
# Get your current kernel version
KVER=$(uname -r)

# Sign vboxdrv module
sudo /usr/src/linux-headers-${KVER}/scripts/sign-file \
  sha256 \
  /root/module-signing/MOK.priv \
  /root/module-signing/MOK.der \
  $(modinfo -n vboxdrv)

# Sign vboxnetflt module
sudo /usr/src/linux-headers-${KVER}/scripts/sign-file \
  sha256 \
  /root/module-signing/MOK.priv \
  /root/module-signing/MOK.der \
  $(modinfo -n vboxnetflt)

# Sign vboxnetadp module
sudo /usr/src/linux-headers-${KVER}/scripts/sign-file \
  sha256 \
  /root/module-signing/MOK.priv \
  /root/module-signing/MOK.der \
  $(modinfo -n vboxnetadp)
```

**What this does:**
- Uses the kernel's signing script to sign each VirtualBox module
- SHA256 is the hashing algorithm used for the signature
- Each module is signed with your private key and public certificate

**Note:** If you get an error about `vboxpci` not found, that's normal - this module is optional and may not exist on your system.

---

### Step 7: Load the Kernel Modules

Now load the signed modules into the kernel:

```bash
sudo modprobe vboxdrv
sudo modprobe vboxnetflt
sudo modprobe vboxnetadp
```

**What this does:** Loads the VirtualBox kernel modules into memory so VirtualBox can function.

---

### Step 8: Verify Success

Check that the modules are loaded correctly:

```bash
lsmod | grep vbox
```

**Expected output:**
```
vboxnetadp             28672  0
vboxnetflt             36864  0
vboxdrv               696320  2 vboxnetadp,vboxnetflt
```

If you see output similar to above, **congratulations!** VirtualBox is now working with Secure Boot enabled.

---

### Step 9: Launch VirtualBox

You can now start VirtualBox:

```bash
virtualbox
```

Or launch it from your applications menu.

---

## Handling Kernel Updates

**Important:** Whenever Ubuntu installs a kernel update, VirtualBox modules are recompiled but NOT automatically re-signed. You'll need to sign them again.

### Create an Automatic Signing Script

To make this easier, create a helper script:

```bash
sudo nano /usr/local/bin/sign-vbox-modules
```

Paste the following content:

```bash
#!/bin/bash
# VirtualBox Module Auto-Signing Script for Secure Boot

KVER=$(uname -r)

echo "Signing VirtualBox modules for kernel ${KVER}..."

for module in vboxdrv vboxnetflt vboxnetadp; do
    MODULE_PATH=$(modinfo -n $module 2>/dev/null)
    if [ -n "$MODULE_PATH" ]; then
        /usr/src/linux-headers-${KVER}/scripts/sign-file sha256 \
            /root/module-signing/MOK.priv \
            /root/module-signing/MOK.der \
            "$MODULE_PATH"
        echo "✓ Signed $module"
    else
        echo "✗ Module $module not found (may be optional)"
    fi
done

echo ""
echo "Loading VirtualBox modules..."
modprobe vboxdrv
modprobe vboxnetflt
modprobe vboxnetadp

echo ""
echo "VirtualBox modules loaded successfully!"
lsmod | grep vbox
```

Save the file (Ctrl+O, Enter, Ctrl+X) and make it executable:

```bash
sudo chmod +x /usr/local/bin/sign-vbox-modules
```

### After Any Kernel Update

When Ubuntu updates your kernel and VirtualBox fails to start, simply run:

```bash
sudo sign-vbox-modules
```

This will re-sign and load all VirtualBox modules for the new kernel.

---

## Troubleshooting

### Issue: "Loading of module with unavailable key is rejected"

**Solution:** Your MOK key is not enrolled. Repeat Steps 3-5 to enroll the key.

**Verify key enrollment:**
```bash
mokutil --list-enrolled | grep -i virtualbox
```

### Issue: VirtualBox won't start after kernel update

**Solution:** Run the signing script:
```bash
sudo sign-vbox-modules
```

### Issue: "modprobe vboxdrv failed"

**Check dmesg for details:**
```bash
sudo dmesg | grep -i vbox
```

**Common causes:**
- Modules not signed (run Step 6 again)
- Wrong kernel headers installed
- MOK key not enrolled properly

### Issue: MOK Management screen doesn't appear

**Solution:**
1. Enter BIOS/UEFI settings during boot
2. Check if Secure Boot is truly enabled
3. Try enrolling the key again: `sudo mokutil --import /root/module-signing/MOK.der`
4. Reboot and watch carefully for the blue MOK screen

### Verify Secure Boot Status

```bash
mokutil --sb-state
```

Should show: `SecureBoot enabled`

---

## Alternative Solutions

If you prefer not to manage MOK keys, consider these alternatives:

### Option 1: Use KVM/QEMU Instead
```bash
sudo apt-get install qemu-kvm libvirt-daemon-system virt-manager
sudo usermod -aG libvirt $USER
sudo usermod -aG kvm $USER
```
- Native Linux virtualization
- No Secure Boot conflicts
- Better performance on Linux

### Option 2: Use GNOME Boxes
```bash
sudo apt-get install gnome-boxes
```
- Simple interface
- Works out-of-the-box with Secure Boot
- Good for basic virtualization needs

### Option 3: Disable Secure Boot (Not Recommended)
- Only if you don't require Secure Boot for compliance/security
- Reduces system security
- Makes system vulnerable to rootkits and bootkits

---

## Security Notes

- **Keep your private key secure**: The `MOK.priv` file should only be readable by root
- **Your key is trusted**: Any module you sign with this key will be trusted by your system
- **Only sign trusted code**: Never sign modules from untrusted sources
- **Backup your keys**: Consider backing up `/root/module-signing/` to a secure location

---

## Summary

This guide walked you through:
1. ✅ Installing required tools (mokutil)
2. ✅ Creating a MOK signing key pair
3. ✅ Enrolling the key with your system's firmware
4. ✅ Signing VirtualBox kernel modules
5. ✅ Loading the modules and verifying functionality
6. ✅ Creating a helper script for kernel updates

Your VirtualBox installation now works seamlessly with Secure Boot enabled, maintaining system security while allowing virtualization.

---

## Additional Resources

- [Ubuntu Secure Boot Documentation](https://wiki.ubuntu.com/UEFI/SecureBoot)
- [VirtualBox Linux Downloads](https://www.virtualbox.org/wiki/Linux_Downloads)
- [Kernel Module Signing](https://www.kernel.org/doc/html/latest/admin-guide/module-signing.html)

---

**Document Version:** 1.0  
**Last Updated:** October 2025  
**Tested On:** Ubuntu 24.04 LTS (Noble Numbat) with VirtualBox 7.2
