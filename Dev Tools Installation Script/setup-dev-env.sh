#!/bin/bash

# Exit script on error
set -e

# Function to print success messages
function print_done() {
    echo -e "\e[32m✔ Done: $1\e[0m"
}

echo "🚀 Starting Development Environment Setup..."

# Update & Upgrade
echo "Updating system..."
sudo apt update && sudo apt upgrade -y
print_done "System updated"

# Install Essential Development Tools
echo "Installing essential development tools..."
sudo apt install -y curl wget git vlc flatpak htop neofetch zsh vim tmux build-essential figlet toilet toilet-fonts
print_done "Essential tools installed"

# Install Google Chrome (with auto-updates)
echo "Adding Google Chrome repository..."
wget -qO- https://dl.google.com/linux/linux_signing_key.pub | sudo gpg --dearmor -o /usr/share/keyrings/google-chrome-keyring.gpg
echo "deb [arch=amd64 signed-by=/usr/share/keyrings/google-chrome-keyring.gpg] http://dl.google.com/linux/chrome/deb/ stable main" | sudo tee /etc/apt/sources.list.d/google-chrome.list >/dev/null
sudo apt update
sudo apt install -y google-chrome-stable
print_done "Google Chrome installed (with updates enabled)"

# Install VS Code (with auto-updates)
echo "Adding VS Code repository..."
wget -qO- https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor | sudo tee /usr/share/keyrings/packages.microsoft.gpg >/dev/null
echo "deb [arch=amd64 signed-by=/usr/share/keyrings/packages.microsoft.gpg] https://packages.microsoft.com/repos/code stable main" | sudo tee /etc/apt/sources.list.d/vscode.list >/dev/null
sudo apt update
sudo apt install -y code
print_done "VS Code installed (with updates enabled)"

# Install Postman via Snap
echo "Installing Postman..."
sudo snap install postman
print_done "Postman installed"

# Install VLC
echo "Installing VLC..."
sudo apt install -y vlc
print_done "VLC installed"

# Install Flatpak and Add Flathub Repository
echo "Installing Flatpak..."
sudo apt install -y flatpak
sudo flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
print_done "Flatpak installed and Flathub repository added"

# Final Message - Big Font
echo -e "\n🎉 \e[1;32mAll development tools have been installed successfully!\e[0m 🚀\n"

# Print fancy thank you message
echo -e "\e[1;35m"
toilet -f big -F metal "AbhiStar"
echo -e "\e[0m💡 😎 You can thank AbhiStar later! 🚀✨\n"
