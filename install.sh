#!/usr/bin/env bash

# Define structural configuration paths
TARGET_DIR="${HOME}/.config/Aethr"
BACKUP_DIR="${HOME}/.config/Aethr.bak.$(date +%F_%T)"

# Install official repository dependencies
echo "📦 Installing system dependencies via pacman..."
sudo pacman -S --needed --noconfirm \
    hyprland \
    satty \
    bluez \
    bluez-utils \
    networkmanager \
    quickshell \
    qt6-declarative \
    qt6-5compat \
    qt6-svg

# Detect and install quickshell from the AUR if available
if command -v paru &> /dev/null; then
    paru -S --needed --noconfirm quickshell-git
elif command -v yay &> /dev/null; then
    yay -S --needed --noconfirm quickshell-git
else
    echo "⚠️ AUR helper (yay/paru) not found. Please install 'quickshell' manually."
fi

# Safely handle existing configuration directory conflicts
if [ -d "$TARGET_DIR" ]; then
    echo "⚠️ Existing configuration found. Backing up to $BACKUP_DIR"
    mv "$TARGET_DIR" "$BACKUP_DIR"
fi

# Establish symlink from current repository context to active config target
echo "📁 Deploying Aethr configuration layout..."
mkdir -p "${HOME}/.config"
ln -s "$(pwd)" "$TARGET_DIR"

echo "✨ Aethr Shell components and dependencies successfully deployed!"
