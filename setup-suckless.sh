#!/bin/bash

source "$(dirname "$0")/utils.sh"

__dotsetup_log INFO "Setting up suckless tools..."
__dotsetup_log INFO "Downloading suckless..."

__dotsetup_execute 'git clone --depth 1 https://github.com/smooll-d/suckless.git'

__dotsetup_log INFO "Installing dwm..."

__dotsetup_execute 'cd suckless/dwm'
__dotsetup_execute 'sudo make clean install'
__dotsetup_check_last_command
__dotsetup_execute 'cd ../../'

__dotsetup_log INFO "Installing st..."

__dotsetup_execute 'cd suckless/st'
__dotsetup_execute 'sudo make clean install'
__dotsetup_check_last_command
__dotsetup_execute 'cd ../../'

__dotsetup_log INFO "Installing dwmblocks-async and it's modules..."

__dotsetup_execute 'cd suckless/dwmblocks-async'
__dotsetup_execute 'sudo make clean install'
__dotsetup_check_last_command
__dotsetup_execute 'cd modules'
__dotsetup_execute 'source ./install.sh'
__dotsetup_check_last_command
__dotsetup_execute 'cd ../../../'
