#!/usr/bin/env bash

source "$(dirname "$0")/utils.sh"

check_diffs()
{
    diff ~/dotfiles/etc/$1 /etc/$1
}

__dotfiles_log INFO "Checking default..."
check_diffs default/cpupower
check_diffs default/grub

__dotfiles_log INFO "Checking ly..."
check_diffs ly/config.ini

__dotfiles_log INFO "Checking systemd..."
check_diffs systemd/zram-generator.conf

__dotfiles_log INFO "Checking X11..."
check_diffs X11/xorg.conf.d/20-amdgpu.conf
check_diffs X11/xorg.conf.d/50-mouse-acceleration.conf
