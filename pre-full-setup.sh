#!/bin/bash

source "$(dirname "$0")/src/utils.sh"

__dotsetup_log INFO "Checking Internet connection..."

__dotsetup_execute 'ping -c 5 archlinux.org'

if [ $? -ne 0 ]; then
	__dotsetup_log ERROR "No Internet connection! Check it and retry."
	exit 1
else
	__dotsetup_log SUCCESS "Internet connection successful!"
fi

__dotsetup_log INFO "Synchronizing system clock..."

#TODO: use "parted" for partitioning
