# Development Environment Setup

This script automates the setup of a complete development environment on Debian-based Linux systems (Ubuntu, Linux Mint, etc.).

## What It Installs

- **System Updates**: Updates and upgrades all system packages
- **Development Tools**: git, curl, wget, build-essential, htop, neofetch, zsh, tmux
- **Web Browser**: Google Chrome (with auto-updates)
- **Code Editor**: Visual Studio Code (with auto-updates)
- **API Testing**: Postman
- **Media Player**: VLC
- **Package Manager**: Flatpak with Flathub repository

## Prerequisites

- A Debian-based Linux distribution (Ubuntu, Linux Mint, etc.)
- Administrative (sudo) privileges
- Internet connection

## Usage

1. Download the script:
   ```bash
   wget -O setup-dev-env.sh https://your-hosting-url.com/setup-dev-env.sh
   ```

2. Make the script executable:
   ```bash
   chmod +x setup-dev-env.sh
   ```

3. Run the script:
   ```bash
   ./setup-dev-env.sh
   ```

4. Enter your password when prompted for sudo access.

5. Wait for the installation to complete. You'll see confirmation messages as each component is installed.

## Notes

- The script will exit if any command fails (using `set -e`)
- All installed applications will receive automatic updates
- Google Chrome and VS Code are installed via their official repositories
- Postman is installed using Snap
- Flatpak provides access to additional applications through the Flathub repository

## Customization

You can modify the script to add or remove packages based on your needs:

- To add more packages to the essential tools, modify the `apt install` line
- To install additional Snap packages, add more `sudo snap install` commands
- To install Flatpak applications, add `sudo flatpak install flathub [application-id]` commands

## Troubleshooting

If you encounter any issues:

1. Check your internet connection
2. Ensure you have sudo privileges
3. Try running individual sections of the script manually to identify where the error occurs
