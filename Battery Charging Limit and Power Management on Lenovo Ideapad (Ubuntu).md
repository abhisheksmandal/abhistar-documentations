# Complete Guide: Battery Charging Limit and Power Management on Lenovo Ideapad (Ubuntu)

## Overview

This guide explains how to manage battery charging limits and system power profiles on Lenovo Ideapad laptops running Ubuntu. It covers:

- Installing TLP or power-profiles-daemon
- Setting battery charging thresholds
- Using TLP and conservation mode
- Using powerprofilesctl and GNOME/KDE integration
- Why TLP and powerprofilesctl cannot be used together
- The effect of battery-charge-limit.service on system performance

1. Installation

---

## A. Install TLP:

TLP is not installed by default. You can install it via the terminal.

```bash
sudo apt update
sudo apt install tlp tlp-rdw
sudo systemctl enable tlp --now
```

To view battery and power stats:

```bash
sudo tlp-stat -b
```

## B. Install power-profiles-daemon:

If you prefer to use the GNOME/KDE-integrated power profiles (Performance, Balanced, Power Saver), install:

```bash
sudo apt install power-profiles-daemon
```

To check current profile:

```bash
powerprofilesctl
```

To set a profile (e.g., performance):

```bash
powerprofilesctl set performance
```

Note:

- Installing `power-profiles-daemon` removes or disables TLP.
- Installing TLP disables `power-profiles-daemon`.

2. Limiting Battery Charge to Extend Battery Life

---

Lenovo Ideapad laptops with ideapad_acpi driver allow enabling "conservation mode," limiting battery charge to ~60%.

Enable conservation mode:

```bash
echo 1 | sudo tee /sys/bus/platform/drivers/ideapad_acpi/VPC2004:00/conservation_mode
```

Disable conservation mode:

```bash
echo 0 | sudo tee /sys/bus/platform/drivers/ideapad_acpi/VPC2004:00/conservation_mode
```

Note:

- Only binary toggle is available: 60% or 100% — no custom value like 80%.

3. Automating Conservation Mode Using systemd

---

Create a service to enable conservation mode at boot:

```bash
sudo nano /etc/systemd/system/battery-charge-limit.service
```

Paste the following content:

```
[Unit]
Description=Set Lenovo Conservation Mode
After=multi-user.target

[Service]
Type=oneshot
ExecStart=/bin/sh -c 'echo 1 > /sys/bus/platform/drivers/ideapad_acpi/VPC2004:00/conservation_mode'
RemainAfterExit=true

[Install]
WantedBy=multi-user.target
```

Then enable and start the service:

```bash
sudo systemctl enable --now battery-charge-limit.service
```

4. Understanding TLP vs. powerprofilesctl

---

TLP:

- Advanced CLI tool for system power tuning.
- Configurable via `/etc/tlp.conf`
- Great for experienced users who want control.

powerprofilesctl (power-profiles-daemon):

- Desktop-integrated (GNOME/KDE) UI tool.
- Easily toggle Performance, Balanced, or Power Saver.

Why They Conflict:

- Both manage CPU frequencies, device power states, and more.
- Installing one disables the other to avoid conflict.

Choose One:

- Use **TLP** for fine-grained control and battery life optimization.
- Use **power-profiles-daemon** for GUI integration and simplicity.

5. Does battery-charge-limit.service reduce performance?

---

No. This service only sets the conservation mode to limit charge. It doesn’t:

- Continuously run in the background
- Change power/performance settings

6. Summary

---

- You can use **either** TLP **or** powerprofilesctl — not both.
- Conservation mode helps protect your battery if always plugged in.
- Automate charge limit using systemd.
- Performance remains unaffected by battery charge caps.
