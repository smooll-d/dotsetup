#!/bin/bash

source "$(dirname "$0")/utils.sh"

if [ ! -e "${HOME}/dotfiles" ]; then
    __dotsetup_log WARNING "dotfiles not found, downloading..."
    __dotsetup_execute 'git clone --depth 1 --recursive https://github.com/smooll-d/dotfiles.git ${HOME}/dotfiles'
fi

__dotsetup_log INFO "Setting up system-wide configurations..."

__dotsetup_execute '__dotsetup_backup_files /etc/mkinitcpio.conf'
__dotsetup_execute '__dotsetup_backup_files /etc/pacman.conf'
__dotsetup_execute '__dotsetup_backup_files /etc/default/cpupower'
__dotsetup_execute '__dotsetup_backup_files /etc/default/grub'
__dotsetup_execute '__dotsetup_backup_files /etc/systemd/zram-generator.conf'
__dotsetup_execute '__dotsetup_backup_files /etc/X11/xorg.conf.d/20-amdgpu.conf'
__dotsetup_execute '__dotsetup_backup_files /etc/X11/xorg.conf.d/50-mouse-acceleration.conf'
__dotsetup_execute '__dotsetup_backup_files /etc/ly/config.ini'

__dotsetup_log INFO "Copying ${HOME}/dotfiles/etc..."

__dotsetup_execute 'sudo rsync -av ${HOME}/dotfiles/etc/mkinitcpio.conf /etc/mkinitcpio.conf'
__dotsetup_execute 'sudo rsync -av ${HOME}/dotfiles/etc/pacman.conf /etc/pacman.conf'
__dotsetup_execute 'sudo rsync -av ${HOME}/dotfiles/etc/default/cpupower /etc/default/cpupower'
__dotsetup_execute 'sudo rsync -av ${HOME}/dotfiles/etc/default/grub /etc/default/grub'
__dotsetup_execute 'sudo rsync -av ${HOME}/dotfiles/etc/systemd/zram-generator.conf /etc/systemd/zram-generator.conf'
__dotsetup_execute 'sudo rsync -av ${HOME}/dotfiles/etc/X11/xorg.conf.d/20-amdgpu.conf /etc/X11/xorg.conf.d/20-amdgpu.conf'
__dotsetup_execute 'sudo rsync -av ${HOME}/dotfiles/etc/X11/xorg.conf.d/50-mouse-acceleration.conf /etc/X11/xorg.conf.d/50-mouse-acceleration.conf'
__dotsetup_execute 'sudo rsync -av ${HOME}/dotfiles/etc/ly/config.ini /etc/ly/config.ini'

__dotsetup_execute '__dotsetup_backup_files /usr/share/xsessions'
__dotsetup_execute '__dotsetup_backup_files /usr/share/applications/steam.desktop'
__dotsetup_execute '__dotsetup_backup_files /usr/share/applications/steam-native.desktop'

__dotsetup_log INFO "Copying ${HOME}/dotfiles/usr..."

__dotsetup_execute 'sudo rsync -av ${HOME}/dotfiles/usr/share/xsessions /usr/share'
# __dotsetup_execute 'sudo chmod 755 /usr/share/xsessions'
# __dotsetup_execute 'sudo chmod 644 /usr/share/xsessions/dwm.desktop'

__dotsetup_execute 'sudo rsync -av ${HOME}/dotfiles/usr/share/applications/steam.desktop /usr/share/applications'
__dotsetup_execute 'sudo rsync -av ${HOME}/dotfiles/usr/share/applications/steam-native.desktop /usr/share/applications'
# __dotsetup_execute 'sudo chmod 644 /usr/share/applications/steam.desktop'
# __dotsetup_execute 'sudo chmod 644 /usr/share/applications/steam-native.desktop'

__dotsetup_log INFO "Setting plymouth theme..."

__dotsetup_execute 'sudo plymouth-set-default-theme -R bgrt'

__dotsetup_check_last_command

__dotsetup_log INFO "Regenerating grub config..."

__dotsetup_execute 'sudo grub-mkconfig -o /boot/grub/grub.cfg'

__dotsetup_check_last_command

__dotsetup_log INFO "Enabling systemd services..."

__dotsetup_execute 'sudo systemctl enable bluetooth'
__dotsetup_execute 'sudo systemctl enable cpupower'
__dotsetup_execute 'sudo systemctl enable systemd-oomd'
__dotsetup_execute 'sudo systemctl enable ly'

__dotsetup_log INFO "Disabling getty@tty2 service..."
__dotsetup_execute 'sudo systemctl disable getty@tty2'
