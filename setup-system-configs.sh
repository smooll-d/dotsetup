#!/bin/bash

source "$(dirname "$0")/utils.sh"

__dotsetup_dotfiles_setup

__dotsetup_log INFO "Setting up system-wide configurations..."

__dotsetup_execute '__dotsetup_backup_files /etc/fstab copy'
__dotsetup_execute '__dotsetup_backup_files /etc/mkinitcpio.conf'
__dotsetup_execute '__dotsetup_backup_files /etc/pacman.conf'
__dotsetup_execute '__dotsetup_backup_files /etc/default/cpupower'
__dotsetup_execute '__dotsetup_backup_files /etc/default/grub'
__dotsetup_execute '__dotsetup_backup_files /etc/systemd/zram-generator.conf'
__dotsetup_execute '__dotsetup_backup_files /etc/X11/xorg.conf.d/20-amdgpu.conf'
__dotsetup_execute '__dotsetup_backup_files /etc/X11/xorg.conf.d/50-mouse-acceleration.conf'
__dotsetup_execute '__dotsetup_backup_files /etc/ly/config.ini'

__dotsetup_log INFO "Copying ${__dotfiles_dotfiles_directory}/etc..."

__dotsetup_execute 'sudo rsync -av ${__dotsetup_dotfiles_directory}/etc/mkinitcpio.conf /etc/mkinitcpio.conf'
__dotsetup_execute 'sudo rsync -av ${__dotsetup_dotfiles_directory}/etc/pacman.conf /etc/pacman.conf'
__dotsetup_execute 'sudo rsync -av ${__dotsetup_dotfiles_directory}/etc/default/cpupower /etc/default/cpupower'
__dotsetup_execute 'sudo rsync -av ${__dotsetup_dotfiles_directory}/etc/default/grub /etc/default/grub'
__dotsetup_execute 'sudo rsync -av ${__dotsetup_dotfiles_directory}/etc/systemd/zram-generator.conf /etc/systemd/zram-generator.conf'
__dotsetup_execute 'sudo rsync -av ${__dotsetup_dotfiles_directory}/etc/X11/xorg.conf.d/20-amdgpu.conf /etc/X11/xorg.conf.d/20-amdgpu.conf'
__dotsetup_execute 'sudo rsync -av ${__dotsetup_dotfiles_directory}/etc/X11/xorg.conf.d/50-mouse-acceleration.conf /etc/X11/xorg.conf.d/50-mouse-acceleration.conf'
__dotsetup_execute 'sudo rsync -av ${__dotsetup_dotfiles_directory}/etc/ly/config.ini /etc/ly/config.ini'

__dotsetup_execute '__dotsetup_backup_files /usr/share/xsessions'
__dotsetup_execute '__dotsetup_backup_files /usr/share/applications/steam.desktop'
__dotsetup_execute '__dotsetup_backup_files /usr/share/applications/steam-native.desktop'

__dotsetup_log INFO "Copying ${__dotsetup_dotfiles_directory}/usr..."

__dotsetup_execute 'sudo rsync -av ${__dotsetup_dotfiles_directory}/usr/share/xsessions /usr/share'

__dotsetup_execute 'sudo rsync -av ${__dotsetup_dotfiles_directory}/usr/share/applications/steam.desktop /usr/share/applications'
__dotsetup_execute 'sudo rsync -av ${__dotsetup_dotfiles_directory}/usr/share/applications/steam-native.desktop /usr/share/applications'

__dotsetup_log INFO "Setting plymouth theme..."

__dotsetup_execute 'sudo plymouth-set-default-theme -R bgrt'

__dotsetup_check_last_command

__dotsetup_log INFO "Regenerating grub config..."

__dotsetup_execute 'sudo grub-mkconfig -o /boot/grub/grub.cfg'

__dotsetup_check_last_command

__dotsetup_log INFO "Adding tmpfs mount points..."

__dotsetup_execute 'echo "tmpfs /tmp tmpfs defaults,noatime,mode=1777 0 0" | sudo tee -a /etc/fstab'
# __dotsetup_execute 'echo "tmpfs /var/log tmpfs defaults,noatime,mode=0755,size=100M 0 0" | sudo tee -a /etc/fstab'

__dotsetup_log INFO "Modifying mount options in /etc/fstab..."

__dotsetup_execute 'sudo sed -i -E "s@^(UUID=[^[:space:]]+[[:space:]]+/[[:space:]]+ext4[[:space:]]+)[^[:space:]]+@\1rw,relatime,lazytime,commit=60,journal_async_commit@" /etc/fstab'

__dotsetup_log INFO "Disabling Shift Mode in xpadneo..."

__dotsetup_execute 'echo "options hid_xpadneo disable_shift_mode=Y" | sudo tee -a /etc/modprobe.d/xpadneo.conf'

__dotsetup_log INFO "Disabling ERTM in bluetooth..."

__dotsetup_execute 'echo "options bluetooth disable_ertm=Y" | sudo tee -a /etc/modprobe.d/bluetooth.conf'

__dotsetup_log INFO "Enabling systemd services..."

__dotsetup_execute 'sudo systemctl enable bluetooth'
__dotsetup_execute 'sudo systemctl enable cpupower'
__dotsetup_execute 'sudo systemctl enable ly'
__dotsetup_execute 'sudo systemctl enable nohang-desktop'

__dotsetup_log INFO "Disabling getty@tty2 service..."

__dotsetup_execute 'sudo systemctl disable getty@tty2'
