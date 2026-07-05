#!/usr/bin/env bash

# Define configuration directory targets
TARGET_DIR="${HOME}/.config/Aethr"
BACKUP_DIR="${HOME}/.config/Aethr.bak.$(date +%F_%T)"

# Install core pacman dependencies required for system and yay compilation
echo "📦 Installing system dependencies..."
sudo pacman -S --needed --noconfirm \
    hyprland \
    satty \
    bluez \
    bluez-utils \
    networkmanager \
    qt6-declarative \
    qt6-5compat \
    qt6-svg \
    base-devel \
    git

# Check for yay or automate its installation from the AUR
if ! command -v yay &> /dev/null; then
    echo "🔍 'yay' not found. Provisioning AUR helper..."
    BUILD_DIR=$(mktemp -d)
    
    # Clone and compile yay within a temporary sandbox
    git clone https://aur.archlinux.org/yay.git "$BUILD_DIR"
    cd "$BUILD_DIR" || exit 1
    makepkg -si --noconfirm
    
    # Return to repository context and cleanup sandbox
    cd - || exit 1
    rm -rf "$BUILD_DIR"
fi

# Deploy quickshell using the verified AUR helper
echo "🧬 Installing quickshell-git via yay..."
yay -S --needed --noconfirm quickshell-git

# Manage legacy configuration rollbacks safely
if [ -d "$TARGET_DIR" ]; then
    echo "⚠️ Existing configuration found. Archiving to $BACKUP_DIR"
    mv "$TARGET_DIR" "$BACKUP_DIR"
fi

# Symlink development workspace into target configuration hierarchy
echo "📁 Mapping active repository to ~/.config/Aethr..."
mkdir -p "${HOME}/.config"
ln -s "$(pwd)" "$TARGET_DIR"

echo "✨ Aethr Shell environment preparation completed!"
