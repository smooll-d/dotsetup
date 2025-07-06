#!/bin/bash

source "$(dirname "$0")/utils.sh"

__dotsetup_execute '__dotsetup_backup_files /etc/makepkg.conf copy'

__dotsetup_log INFO "Disabling debug symbols in makepkg.conf..."

__dotsetup_execute 'sed -i "/^OPTIONS=/ {
  /[[:space:]]debug[[:space:]]/ s/\bdebug\b/!debug/g
  /[[:space:]]!debug[[:space:]]/! s/^\(OPTIONS=(.*\))/\1 !debug)/
}" /etc/makepkg.conf'

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

__dotsetup_execute 'sudo pacman -Sy --noconfirm --needed - < "$(dirname "$0")/packages-pacman.txt"'

__dotsetup_log INFO "Installing packages from packages-aur.txt..."

__dotsetup_execute 'yay -S --noconfirm --needed - < "$(dirname "$0")/packages-aur.txt"'

__dotsetup_log INFO "Adding user to groups..."

__dotsetup_execute 'sudo gpasswd -a $USER plugdev'
__dotsetup_execute 'sudo gpasswd -a $USER docker'
__dotsetup_execute 'sudo gpasswd -a $USER informant'
