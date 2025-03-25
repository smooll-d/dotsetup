#!/bin/bash

source "$(dirname "$0")/src/utils.sh"

__dotsetup_log INFO "Checking yay installation..."

# Check if yay is installed. If not, install it
if ! command -v yay &> /dev/null; then
    __dotsetup_log WARNING "yay not found. Installing..."

    __dotsetup_execute 'sudo pacman -Sy --noconfirm --needed git base-devel'
    __dotsetup_execute 'git clone https://aur.archlinux.org/yay-bin.git /tmp/yay-bin'
    __dotsetup_execute 'cd /tmp/yay-bin'
    __dotsetup_execute 'makepkg -si --noconfirm'
    __dotsetup_execute 'cd - && rm -rf /tmp/yay-bin'
fi

__dotsetup_log INFO "Installing packages from packages-pacman.txt..."

# Install all packages from core, extra, multilib and testing repos
__dotsetup_execute 'sudo pacman -Sy --noconfirm --needed vulkan-radeon lib32-vulkan-radeon virtualbox-host-modules-arch man-db - < "$(dirname "$0")/packages/packages-pacman.txt"'

__dotsetup_log INFO "Installing packages from packages-aur.txt..."

# Install all AUR packages
__dotsetup_execute 'yay -S --noconfirm --needed - < "$(dirname "$0")/packages/packages-aur.txt"'

__dotsetup_log INFO "Installing pre-commit..."

__dotsetup_execute 'pipx install pre-commit'

# Add user to groups plugdev (needed for openrazer to work) and docker (needed for docker to work without sudo)
__dotsetup_execute 'sudo gpasswd -a $USER plugdev'
__dotsetup_execute 'sudo gpasswd -a $USER docker'
