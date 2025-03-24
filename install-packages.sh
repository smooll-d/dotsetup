#!/bin/bash

source "$(dirname "$0")/utils.sh"

__dotsetup_log INFO "Checking yay installation..."

if ! command -v yay &> /dev/null; then
    __dotsetup_log WARNING "yay not found. Installing..."

    __dotsetup_execute 'sudo pacman -Sy --noconfirm --needed git base-devel'
    __dotsetup_execute 'git clone https://aur.archlinux.org/yay-bin.git /tmp/yay-bin'
    __dotsetup_execute 'cd /tmp/yay-bin'
    __dotsetup_execute 'makepkg -si --noconfirm'
    __dotsetup_execute 'cd - && rm -rf /tmp/yay-bin'
fi

__dotsetup_log INFO "Installing packages from packages-pacman.txt..."

__dotsetup_execute 'sudo pacman -Sy --noconfirm --needed vulkan-radeon lib32-vulkan-radeon virtualbox-host-modules-arch man-db - < "$(dirname "$0")/packages-pacman.txt"'

__dotsetup_log INFO "Installing packages from packages-aur.txt..."

__dotsetup_execute 'yay -S --noconfirm --needed - < "$(dirname "$0")/packages-aur.txt"'

__dotsetup_log INFO "Installing pre-commit..."

__dotsetup_execute 'pipx install pre-commit'

__dotsetup_execute 'sudo gpasswd -a $USER plugdev'
__dotsetup_execute 'sudo gpasswd -a $USER docker'
