#!/bin/bash

source "$(dirname "$0")/utils.sh"

if [ ! -e "${HOME}/dotfiles" ]; then
    __dotsetup_log WARNING "dotfiles not found, downloading..."
    __dotsetup_execute 'git clone --depth 1 --recursive https://github.com/smooll-d/dotfiles.git ${HOME}/dotfiles'
fi

__dotsetup_log INFO "Setting up ${HOME}..."

__dotsetup_execute '__dotsetup_backup_files ${HOME}/wallpapers'
__dotsetup_execute '__dotsetup_backup_files ${HOME}/.config/bleachbit'
__dotsetup_execute '__dotsetup_backup_files ${HOME}/.config/btop'
__dotsetup_execute '__dotsetup_backup_files ${HOME}/.config/gtk-3.0'
__dotsetup_execute '__dotsetup_backup_files ${HOME}/.config/gtk-4.0'
__dotsetup_execute '__dotsetup_backup_files ${HOME}/.config/nitrogen'
__dotsetup_execute '__dotsetup_backup_files ${HOME}/.config/nvim'
__dotsetup_execute '__dotsetup_backup_files ${HOME}/.config/openrazer'
__dotsetup_execute '__dotsetup_backup_files ${HOME}/.config/parcellite'
__dotsetup_execute '__dotsetup_backup_files ${HOME}/.config/picom'
__dotsetup_execute '__dotsetup_backup_files ${HOME}/.config/polychromatic'
__dotsetup_execute '__dotsetup_backup_files ${HOME}/.config/redshift'
__dotsetup_execute '__dotsetup_backup_files ${HOME}/.config/rofi'
__dotsetup_execute '__dotsetup_backup_files ${HOME}/.config/wired'
__dotsetup_execute '__dotsetup_backup_files ${HOME}/.config/thorium-flags.conf'
__dotsetup_execute '__dotsetup_backup_files ${HOME}/.local/share/fonts'
__dotsetup_execute '__dotsetup_backup_files ${HOME}/.zsh'
__dotsetup_execute '__dotsetup_backup_files ${HOME}/.gitconfig'
__dotsetup_execute '__dotsetup_backup_files ${HOME}/.gtkrc-2.0'
__dotsetup_execute '__dotsetup_backup_files ${HOME}/.xbindkeysrc'
__dotsetup_execute '__dotsetup_backup_files ${HOME}/.Xresources'
__dotsetup_execute '__dotsetup_backup_files ${HOME}/.zshrc'
__dotsetup_execute '__dotsetup_backup_files ${HOME}/.xinitrc'
__dotsetup_execute '__dotsetup_backup_files ${HOME}/.xprofile'

__dotsetup_log INFO "Stowing ${HOME}/dotfiles/home..."

__dotsetup_execute 'stow --verbose=1 -R -d ${HOME}/dotfiles -t ${HOME} home'

__dotsetup_check_last_command

__dotsetup_log INFO "Copying powermenu.sh and launcher.sh..."

__dotsetup_execute 'sudo cp ${HOME}/.config/rofi/powermenu/type-4/powermenu.sh /usr/local/bin'
__dotsetup_execute 'sudo cp ${HOME}/.config/rofi/launchers/type-6/launcher.sh /usr/local/bin'

__dotsetup_log INFO "Installing nitch"

__dotsetup_execute 'wget "https://github.com/unxsh/nitch/releases/download/0.1.6/nitchNerd"'
__dotsetup_execute 'chmod +x nitchNerd'
__dotsetup_execute 'sudo mv nitchNerd /usr/local/bin/nitch'

__dotsetup_log INFO "Changing default shell to zsh..."

__dotsetup_execute 'sudo chsh -s $(which zsh) ${USER}'

__dotsetup_check_last_command
