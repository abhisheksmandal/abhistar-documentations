# Battery Charge Limit on Lenovo Ideapad (Ubuntu + TLP)

This guide explains how to manage battery charging thresholds on Lenovo Ideapad laptops using TLP and system utilities.

---

## 📦 Step 1: Install TLP (if not already installed)

### For Ubuntu/Debian:

```bash
sudo apt update
sudo apt install tlp tlp-rdw
```

Then start and enable TLP:

```bash
sudo tlp start
sudo systemctl enable tlp
```

To check status:

```bash
sudo tlp-stat -s
```

---

## ⚙️ System Info (User Output Summary)

- **Laptop:** Lenovo Ideapad
- **Battery Control Module:** `ideapad_acpi`
- **Tool Used:** TLP
- **Supported Feature:** Conservation mode only (60% or 100% charge)
- **Not Supported:** Custom thresholds like 80%

---

## ✅ Enabling Battery Conservation Mode (Limit to ~60%)

This setting prevents the battery from charging beyond ~60%, ideal for laptops plugged in 24/7.

### Command:

```bash
echo 1 | sudo tee /sys/bus/platform/drivers/ideapad_acpi/VPC2004:00/conservation_mode
```

### Check Status:

```bash
sudo tlp-stat -b
```

Look for:

```
conservation_mode = 1 (60%)
```

---

## ❌ Why 80% Limit Is Not Possible

The output of `tlp-stat` shows:

```
Parameter value range:
* STOP_CHARGE_THRESH_BAT0: 0(off), 1(on) -- battery conservation mode
```

So the only two modes supported by your firmware are:

- `0`: Charge to 100%
- `1`: Charge only up to ~60%

Custom limits (like 80%) are **not supported** on Lenovo Ideapad models.

Only **Lenovo ThinkPads** support configurable charge thresholds using TLP (e.g., `START_CHARGE_THRESH_BAT0=75`, `STOP_CHARGE_THRESH_BAT0=80`).

---

## 🔁 Make It Persistent Across Reboots

### Create a Systemd Service

```bash
sudo nano /etc/systemd/system/battery-charge-limit.service
```

Paste:

```ini
[Unit]
Description=Enable Lenovo Battery Conservation Mode
After=multi-user.target

[Service]
Type=oneshot
ExecStart=/bin/sh -c "echo 1 > /sys/bus/platform/drivers/ideapad_acpi/VPC2004:00/conservation_mode"
RemainAfterExit=true

[Install]
WantedBy=multi-user.target
```

Enable the service:

```bash
sudo systemctl daemon-reexec
sudo systemctl enable battery-charge-limit.service
```

---

## 🔄 Disable Conservation Mode (Back to 100% Charging)

```bash
echo 0 | sudo tee /sys/bus/platform/drivers/ideapad_acpi/VPC2004:00/conservation_mode
```

To prevent it from enabling on boot:

```bash
sudo systemctl disable battery-charge-limit.service
```

---

## 🛎️ Optional: Notification at 80%

Since 80% charge limits are not possible via firmware, you can use a script to notify you when the battery reaches 80%.

### Script:

```bash
#!/bin/bash

while true; do
  charge=$(cat /sys/class/power_supply/BAT1/capacity)
  status=$(cat /sys/class/power_supply/BAT1/status)
  if [[ "$charge" -ge 80 && "$status" == "Charging" ]]; then
    notify-send "Battery Alert" "Battery at ${charge}%. Unplug the charger."
  fi
  sleep 60
done
```

Save as `battery_alert.sh`, make it executable with `chmod +x battery_alert.sh`, and run it in the background.

---

## ✅ Summary

| Task               | Command or Method                     |
| ------------------ | ------------------------------------- |
| Install TLP        | `sudo apt install tlp tlp-rdw`        |
| Enable 60% limit   | `echo 1 > /sys/.../conservation_mode` |
| Disable limit      | `echo 0 > /sys/.../conservation_mode` |
| Persistent setting | Create systemd service as shown above |
| 80% limit          | ❌ Not possible on Ideapad            |
| 80% alert          | Use custom `notify-send` script       |
