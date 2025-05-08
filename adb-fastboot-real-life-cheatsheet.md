# 📱 ADB & Fastboot Command Cheat Sheet with Real-Life Examples

This guide includes practical examples to help you understand how each ADB and Fastboot command is used in real scenarios.

---

## 🔌 ADB (Android Debug Bridge)

### 📍 Device Connection

| Command          | Example          | Description                                                  |
| ---------------- | ---------------- | ------------------------------------------------------------ |
| adb devices      | adb devices      | List connected devices to check ADB connectivity             |
| adb kill-server  | adb kill-server  | Stop the ADB server (useful for resolving connection issues) |
| adb start-server | adb start-server | Start ADB server again                                       |
| adb reconnect    | adb reconnect    | Restart the ADB connection (helpful after USB reconnect)     |

---

### 📁 File Management

| Command                   | Example                              | Description                     |
| ------------------------- | ------------------------------------ | ------------------------------- |
| adb push <local> <remote> | adb push hello.txt /sdcard/Download/ | Upload file to phone's storage  |
| adb pull <remote> <local> | adb pull /sdcard/DCIM/photo.jpg ./   | Download a file from the device |

---

### 📱 App Management

| Command                             | Example                                      | Description                 |
| ----------------------------------- | -------------------------------------------- | --------------------------- |
| adb install <apk>                   | adb install myapp.apk                        | Install APK to the phone    |
| adb uninstall <package>             | adb uninstall com.facebook.katana            | Uninstall Facebook          |
| adb shell pm list packages          | adb shell pm list packages                   | List all installed packages |
| adb shell pm disable-user <package> | adb shell pm disable-user com.miui.analytics | Disable system bloatware    |
| adb shell pm enable <package>       | adb shell pm enable com.miui.analytics       | Re-enable an app            |

---

### 💻 Shell & Debugging

| Command       | Example                    | Description                                      |
| ------------- | -------------------------- | ------------------------------------------------ |
| adb shell     | adb shell                  | Open shell to run commands directly on the phone |
| adb logcat    | adb logcat                 | View real-time logs from the device              |
| adb bugreport | adb bugreport > report.zip | Save bug report to file for analysis             |

---

## 🔁 ADB Sideload

| Command                 | Example                 | Description                                               |
| ----------------------- | ----------------------- | --------------------------------------------------------- |
| adb sideload <file>.zip | adb sideload update.zip | Sideload a custom ROM or OTA update when in recovery mode |

🛠 Example Use:

- Boot device to recovery mode (TWRP/stock)
- On phone: tap “Apply update” > “ADB sideload”
- On PC: run adb sideload update.zip

---

## ⚡ Fastboot

### 📍 Device Communication

| Command                    | Example                    | Description                                             |
| -------------------------- | -------------------------- | ------------------------------------------------------- |
| fastboot devices           | fastboot devices           | Verify fastboot mode and connection                     |
| fastboot reboot            | fastboot reboot            | Reboot phone from fastboot mode                         |
| fastboot reboot-bootloader | fastboot reboot-bootloader | Reboot to bootloader from fastboot                      |
| fastboot oem unlock        | fastboot oem unlock        | Unlock bootloader (older devices, wipes all data)       |
| fastboot flashing unlock   | fastboot flashing unlock   | Unlock bootloader on modern devices (confirm on screen) |
| fastboot flashing lock     | fastboot flashing lock     | Re-lock bootloader (optional after restoring stock)     |

🛑 Unlocking wipes all data. Always backup first!

---

### 📥 Flashing Images

| Command                              | Example                                                                  | Description                                       |
| ------------------------------------ | ------------------------------------------------------------------------ | ------------------------------------------------- |
| fastboot flash boot boot.img         | fastboot flash boot boot.img                                             | Flash a patched Magisk boot image                 |
| fastboot flash recovery recovery.img | fastboot flash recovery twrp.img                                         | Flash TWRP or custom recovery                     |
| fastboot flash system system.img     | fastboot flash system system.img                                         | Flash a system partition image (e.g., custom ROM) |
| fastboot flash vbmeta vbmeta.img     | fastboot flash vbmeta vbmeta.img --disable-verity --disable-verification | Avoid bootloop by skipping verification           |
| fastboot flash dtbo dtbo.img         | fastboot flash dtbo dtbo.img                                             | Flash DTBO image (display/boot related)           |
| fastboot flash vendor vendor.img     | fastboot flash vendor vendor.img                                         | Flash vendor partition (common in GSI setups)     |

---

### 🧹 Erase & Format

| Command                       | Example                       | Description                          |
| ----------------------------- | ----------------------------- | ------------------------------------ |
| fastboot erase userdata       | fastboot erase userdata       | Erase user data (factory reset)      |
| fastboot erase cache          | fastboot erase cache          | Clear cached data                    |
| fastboot format:ext4 userdata | fastboot format:ext4 userdata | Format userdata with ext4 filesystem |

---

## 🔄 Recovery-Specific Commands

| Command                        | Example                                        | Description                                        |
| ------------------------------ | ---------------------------------------------- | -------------------------------------------------- |
| adb reboot recovery            | adb reboot recovery                            | Reboot device to recovery (useful before flashing) |
| adb push rom.zip /sdcard/      | adb push evolution-x.zip /sdcard/              | Push ROM file to flash using TWRP                  |
| adb shell twrp install rom.zip | adb shell twrp install /sdcard/evolution-x.zip | Install ZIP directly using TWRP CLI                |

---

✅ Pro Tips:

- Always use an original USB cable and ensure drivers are installed.
- Use platform-tools from Google's official source.
- Enable Developer Options > USB Debugging on your phone for ADB.
