#!/bin/bash

source "$(dirname "$0")/utils.sh"

__dotsetup_suckless_directory=""

__dotsetup_log INFO "Setting up suckless tools..."

if __dotsetup_detect_personal; then
    __dotsetup_suckless_directory="/personal/suckless"
else
    if [ ! -e "suckless/" ]; then
        __dotsetup_log INFO "Downloading suckless..."
        __dotsetup_execute 'git clone --depth 1 https://github.com/smooll-d/suckless.git'
        __dotsetup_suckless_directory="./suckless"
    fi
fi

__dotsetup_log INFO "Installing dwm..."

__dotsetup_execute 'cd ${__dotsetup_suckless_directory}/dwm'
__dotsetup_execute 'sudo make clean install'
__dotsetup_check_last_command
__dotsetup_execute 'cd ../../'

__dotsetup_log INFO "Installing st..."

__dotsetup_execute 'cd ${__dotsetup_suckless_directory}/st'
__dotsetup_execute 'sudo make clean install'
__dotsetup_check_last_command
__dotsetup_execute 'cd ../../'

__dotsetup_log INFO "Installing dwmblocks-async and it's modules..."

__dotsetup_execute 'cd ${__dotsetup_suckless_directory}/dwmblocks-async'
__dotsetup_execute 'sudo make clean install'
__dotsetup_check_last_command
__dotsetup_execute 'cd modules'
__dotsetup_execute 'source ./install.sh'
__dotsetup_check_last_command
__dotsetup_execute 'cd ../../../'
