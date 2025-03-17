#!/bin/bash

__dotsetup_reset="\033[0m"
__dotsetup_red="\033[31m"
__dotsetup_green="\033[32m"
__dotsetup_yellow="\033[33m"
__dotsetup_cyan="\033[36m"

if [ -z "${__dotsetup_backups[*]}" ]; then
    __dotsetup_backups=()
fi

__dotsetup_sudo_user="${USER} ALL=(ALL) NOPASSWD: ALL"

__dotsetup_version="v1.2.3"

__dotsetup_log()
{
    local level="$1"
    shift
    local message="$*"

    case "${level}" in
        SUCCESS) echo -e "${__dotsetup_green}V ${message}${__dotsetup_reset}" ;;
        INFO) echo -e "${__dotsetup_cyan}* ${message}${__dotsetup_reset}" ;;
        WARNING) echo -e "${__dotsetup_yellow}! ${message}${__dotsetup_reset}" ;;
        ERROR) echo -e "${__dotsetup_red}X ${message}${__dotsetup_reset}" ;;
        *) echo -e "${message}" ;;
    esac
}

__dotsetup_backup_files()
{
    local path="$1"

    if [ -f "${path}" ] || [ -d "${path}" ]; then
        local owner
        owner=$(stat -c "%U" "${path}")

        if [ "${owner}" != "$(whoami)" ]; then
            __dotsetup_log WARNING "Backing up ${path}..."
            __dotsetup_execute 'sudo mv "${path}" "${path}.bak"'
            __dotsetup_backups+=("${path}.bak")
        else
            __dotsetup_log WARNING "Backing up ${path}..."
            __dotsetup_execute 'mv "${path}" "${path}.bak"'
            __dotsetup_backups+=("${path}.bak")
        fi
    fi
}

__dotsetup_delete_backups()
{
    read -p "Delete backed up files? [y/N]: " __dotsetup_delete_backups

    if [ -z "${__dotsetup_delete_backups}" ]; then
        __dotsetup_delete_backups="n"
    fi

    case "${__dotsetup_delete_backups}" in
        [Yy])
            if [ -z "${__dotsetup_backups[*]}" ]; then
                __dotsetup_log INFO "No backups detected. Not deleting."
            else
                __dotsetup_log INFO "Deleting backups..."
                for __dotsetup_backup in "${__dotsetup_backups[@]}"; do
                    if [ -e "${__dotsetup_backup}" ]; then
                        __dotsetup_execute 'sudo rm -rf "${__dotsetup_backup}"'
                        __dotsetup_log SUCCESS "Successfully deleted ${__dotsetup_backup}!"
                    else
                        __dotsetup_log INFO "${__dotsetup_backup} does not exist."
                    fi
                done
            fi
            ;;
        [Nn])
            __dotsetup_log INFO "Not deleting backups."
            ;;
        *)
            __dotsetup_log INFO "Invalid input. Not deleting backups."
            ;;
    esac
}

__dotsetup_check_last_command()
{
    if [ $? -ne 0 ]; then
        __dotsetup_log ERROR "Previous command failed, exiting..."
        exit 1
    fi
}

__dotsetup_dry_run()
{
    if [ "$1" = "--dry-run" ] || [ "$1" = "-d" ]; then
        __dotsetup_log WARNING "Dry running...\n"
        __dotsetup_dry_ran=true
    else
        __dotsetup_dry_ran=false
    fi
}

__dotsetup_execute()
{
    if ${__dotsetup_dry_ran}; then
        echo "$1"
    else
        eval "$1"
    fi
}

__dotsetup_start_measuring_time() {
    __dotsetup_start_time=$(date +%s)
}

__dotsetup_end_measuring_time() {
    __dotsetup_end_time=$(date +%s)
}

__dotsetup_calculate_time()
{
    local elapsed_time=$((__dotsetup_end_time - __dotsetup_start_time))

    printf -v __dotsetup_duration "%02d:%02d:%02d" $((elapsed_time / 3600)) $(((elapsed_time % 3600) / 60)) $((elapsed_time % 60))
}

__dotsetup_setup_sudoers_file()
{
    __dotsetup_execute 'echo "${__dotsetup_sudo_user}" | sudo -E -- tee -a /etc/sudoers >/dev/null'

    trap __dotsetup_reset_sudoers_file EXIT
}

__dotsetup_reset_sudoers_file()
{
    __dotsetup_log INFO "Resetting /etc/sudoers..."

    __dotsetup_execute 'sudo -E -- sed -i "/^${__dotsetup_sudo_user}/d" /etc/sudoers'

    __dotsetup_log SUCCESS "Finished in ${__dotsetup_duration}!"
}

__dotsetup_help()
{
    echo -e "Usage: ./dotsetup [OPTIONS]"
    echo
    echo -e "OPTIONS:"
    echo -e "\t--help,    -h    Print this message and exit."
    echo -e "\t--version, -v    Print dotsetup version and exit."
    echo -e "\t--dry-run, -d    Print setup commands, do not execute them."
}

__dotsetup_version()
{
    echo -e "dotsetup ${__dotsetup_version}"
    echo -e "Made with ${__dotsetup_red}<3${__dotsetup_reset} by smooll-d!"
}
