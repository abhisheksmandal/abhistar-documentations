# 🚀 Development Environment Setup

[![Shell Script](https://img.shields.io/badge/Shell-Bash-blue?logo=gnu-bash&logoColor=white)](https://www.gnu.org/software/bash/)
[![Platform](https://img.shields.io/badge/Platform-Ubuntu%20%7C%20Debian-brightgreen?logo=ubuntu)](https://ubuntu.com/)
[![License](https://img.shields.io/badge/License-MIT-green.svg)](LICENSE)
[![Maintained](https://img.shields.io/badge/Maintained-Yes-success)]()
[![Made with ❤️ by AbhiStar](https://img.shields.io/badge/Made%20with%E2%9D%A4%EF%B8%8F-by%20AbhiStar-purple)]()

Automate the setup of a **complete development environment** on Debian-based Linux systems (Ubuntu, Linux Mint, Pop!_OS, etc.) — pre-configured with all the tools a developer needs.  

---

## ⚡ Quick Install

Copy and paste this **one-liner** in your terminal 👇  

```bash
bash <(wget -qO- https://raw.githubusercontent.com/abhisheksmandal/abhistar-documentations/main/Dev%20Tools%20Installation%20Script/setup-dev-env.sh)
```

> 💡 The script will automatically install and configure everything — no manual steps needed.

---

## 🧩 What It Installs

### 🧰 Core System Tools
- System update and upgrade
- `git`, `curl`, `wget`, `build-essential`, `zsh`, `vim`, `tmux`
- `htop`, `neofetch`, `figlet`, `toilet`, `toilet-fonts`

### 🖥️ Terminal & CLI Utilities
| Category | Tools |
|-----------|-------|
| Archive | `zip`, `unzip`, `tar` |
| Network | `net-tools`, `dnsutils`, `lsof`, `nmap`, `netcat-openbsd`, `traceroute`, `whois` |
| File/System | `tree`, `ncdu`, `fzf`, `exa`, `bat`, `jq` |

### 🌐 Web & Development Applications
- **Google Chrome** (auto-updating via official repo)  
- **Visual Studio Code** (auto-updating via official repo)  
- **Postman** (via Snap)  
- **FileZilla** (FTP/SFTP GUI client)  
- **OpenSSH Server** (installed, enabled, and started)  
- **VLC Media Player**  
- **Flatpak** with the **Flathub** repository pre-added  

---

## ⚙️ Prerequisites

- Debian-based Linux distro (Ubuntu, Mint, Pop!_OS, etc.)
- `sudo` privileges  
- Active internet connection  

---

## 🪄 Manual Installation (Optional)

If you prefer to download and execute manually:

```bash
wget -O setup-dev-env.sh https://raw.githubusercontent.com/abhisheksmandal/abhistar-documentations/main/Dev%20Tools%20Installation%20Script/setup-dev-env.sh
chmod +x setup-dev-env.sh
./setup-dev-env.sh
```

---

## 💡 Notes

- The script stops immediately on any error (`set -e`)
- All software from official repositories will **auto-update**
- **Postman** and other Snap apps update automatically  
- **SSH Server** is enabled and starts on boot  
- Safe to rerun — existing tools will be skipped  

---

## 🧠 Customization

You can easily tailor the script to your setup:

- Add more APT packages:
  ```bash
  sudo apt install -y <package-name>
  ```
- Add Snap apps:
  ```bash
  sudo snap install <app-name>
  ```
- Add Flatpak apps:
  ```bash
  sudo flatpak install flathub <app-id>
  ```

---

## 🧰 Troubleshooting

If something doesn’t work:

1. Check your internet connection  
2. Ensure you have sudo privileges  
3. Fix broken dependencies:
   ```bash
   sudo apt update && sudo apt --fix-broken install
   ```
4. Re-run individual sections of the script manually  

---

## 🎉 Credits

Created with ❤️ by **[AbhiStar](https://github.com/abhisheksmandal)**  
💡 “You can thank AbhiStar later! 🚀✨”  

---

### 📄 License
This project is licensed under the [MIT License](LICENSE).
