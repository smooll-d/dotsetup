#!/bin/bash

source "$(dirname "$0")/utils.sh"

__dotsetup_log INFO "Setting up suckless tools..."

__dotsetup_suckless_setup

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
