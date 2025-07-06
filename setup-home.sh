#!/bin/bash

source "$(dirname "$0")/utils.sh"

__dotsetup_log INFO "Setting up ${HOME}..."

__dotsetup_dotfiles_setup

__dotsetup_execute '__dotsetup_backup_files ${HOME}/wallpapers'
__dotsetup_execute '__dotsetup_backup_files ${HOME}/.config/bleachbit'
__dotsetup_execute '__dotsetup_backup_files ${HOME}/.config/btop'
__dotsetup_execute '__dotsetup_backup_files ${HOME}/.config/nitrogen'
__dotsetup_execute '__dotsetup_backup_files ${HOME}/.config/nvim'
__dotsetup_execute '__dotsetup_backup_files ${HOME}/.config/openrazer'
__dotsetup_execute '__dotsetup_backup_files ${HOME}/.config/parcellite'
__dotsetup_execute '__dotsetup_backup_files ${HOME}/.config/picom'
__dotsetup_execute '__dotsetup_backup_files ${HOME}/.config/polychromatic'
__dotsetup_execute '__dotsetup_backup_files ${HOME}/.config/redshift'
__dotsetup_execute '__dotsetup_backup_files ${HOME}/.config/rofi'
__dotsetup_execute '__dotsetup_backup_files ${HOME}/.config/wired'
__dotsetup_execute '__dotsetup_backup_files ${HOME}/.config/mpv'
__dotsetup_execute '__dotsetup_backup_files ${HOME}/.config/ncdu'
__dotsetup_execute '__dotsetup_backup_files ${HOME}/.config/OpenTabletDriver'
__dotsetup_execute '__dotsetup_backup_files ${HOME}/.config/PCSX2'
__dotsetup_execute '__dotsetup_backup_files ${HOME}/.local/share/fonts'
__dotsetup_execute '__dotsetup_backup_files ${HOME}/.fehbg'
__dotsetup_execute '__dotsetup_backup_files ${HOME}/.zsh'
__dotsetup_execute '__dotsetup_backup_files ${HOME}/.gitconfig'
__dotsetup_execute '__dotsetup_backup_files ${HOME}/.gtkrc-2.0'
__dotsetup_execute '__dotsetup_backup_files ${HOME}/.xbindkeysrc'
__dotsetup_execute '__dotsetup_backup_files ${HOME}/.Xresources'
__dotsetup_execute '__dotsetup_backup_files ${HOME}/.zshrc'
__dotsetup_execute '__dotsetup_backup_files ${HOME}/.xinitrc'
__dotsetup_execute '__dotsetup_backup_files ${HOME}/.xprofile'

__dotsetup_log INFO "Stowing ${__dotsetup_dotfiles_directory}/home..."

__dotsetup_execute 'stow --verbose=1 --dir=${__dotsetup_dotfiles_directory} --target=${HOME} home'

__dotsetup_check_last_command

__dotsetup_log INFO "Copying powermenu.sh and launcher.sh..."

__dotsetup_execute 'sudo cp ${HOME}/.config/rofi/powermenu/type-4/powermenu.sh /usr/local/bin'
__dotsetup_execute 'sudo cp ${HOME}/.config/rofi/launchers/type-6/launcher.sh /usr/local/bin'

__dotsetup_log INFO "Creating betterlockscreen cache..."

__dotsetup_execute 'betterlockscreen -u ${__dotsetup_dotfiles_directory}/home/wallpapers/space_of_jupiter.png'

__dotsetup_log INFO "Changing default shell to zsh..."

__dotsetup_execute 'sudo chsh -s $(which zsh) ${USER}'

__dotsetup_check_last_command
