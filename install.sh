#!/usr/bin/env bash

# Exit immediately if any command returns a non-zero status
set -e

QUICKSHELL_DIR="$HOME/.config/quickshell/Aethr"

# 📦 1. Install official repository dependencies (including fish)
echo "Installing system dependencies..."
sudo pacman -S --needed --noconfirm \
    hyprland \
    satty \
    bluez \
    bluez-utils \
    networkmanager \
    wireplumber \
    pipewire \
    pipewire-audio \
    pipewire-pulse \
    pipewire-alsa \
    base-devel \
    git \
    fish

# 🧬 2. Force bootstrap yay if missing
if ! command -v yay &>/dev/null; then
    echo "yay not found. Bootstrapping yay from the AUR..."
    BUILD_DIR=$(mktemp -d)
    git clone https://aur.archlinux.org/yay.git "$BUILD_DIR"
    (cd "$BUILD_DIR" && makepkg -si --noconfirm)
    rm -rf "$BUILD_DIR"
fi

# 🛸 3. Build quickshell-git exclusively with yay
echo "Installing quickshell-git via yay..."
yay -S --aur --noconfirm --needed quickshell-git

# 📂 4. Setup quickshell directory and clone the repository
echo "Deploying repository workspace..."
mkdir -p "$HOME/.config/quickshell"

if [ -d "$QUICKSHELL_DIR" ]; then
    echo "Updating existing workspace..."
    (cd "$QUICKSHELL_DIR" && git reset --hard HEAD && git pull)
else
    echo "Cloning Aethr into target directory..."
    git clone https://github.com/natepayn3/Aethr.git "$QUICKSHELL_DIR"
fi

# ⚙️ 5. Hand execution over to fish for the remaining configurations
echo "Switching context to fish to finalize configuration..."
exec fish -c "
    # Activate hardware runtime daemons and user audio engines
    echo 'Initializing service engines...'
    sudo systemctl enable --now bluetooth.service NetworkManager.service
    systemctl --user enable --now pipewire.service pipewire-pulse.service wireplumber.service

    # Append Aethr startup daemons to hyprland.lua if not already present
    set HYPRLAND_LUA '\$HOME/.config/hypr/hyprland.lua'

    if test -f \$HYPRLAND_LUA
        if not grep -q 'qs -c Aethr' \$HYPRLAND_LUA
            echo 'Adding Aethr startup hooks to hyprland.lua...'
            printf '\nhl.on(\"hyprland.start\", function () \n  hl.exec_cmd(\"qs -c Aethr\")\n  hl.exec_cmd(\"awww-daemon\")\nend)\n' >> \$HYPRLAND_LUA
        else
            echo 'Aethr startup hooks already present in hyprland.lua. Skipping...'
        end
    else
        echo '⚠️ hyprland.lua not found at '\$HYPRLAND_LUA'. Skipping configuration append.'
    end

    echo 'Done! Aethr workspace deployment complete.'
"
