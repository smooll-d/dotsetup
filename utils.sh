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

__dotsetup_version="v1.3.1"

__dotsetup_dotfiles_directory=""
__dotsetup_suckless_directory=""

__dotsetup_cli()
{
    if [ "$1" = "--help" ] || [ "$1" = "-h" ]; then
        __dotsetup_help
        exit 0
    elif [ "$1" = "--version" ] || [ "$1" = "-v" ]; then
        __dotsetup_version
        exit 0
    elif [ "$1" = "--dry-run" ] || [ "$1" = "-d" ]; then
        __dotsetup_log WARNING "Dry running...\n"
        __dotsetup_dry_ran=true
        __dotsetup_main
    elif [ "$1" = "--rerun" ] || [ "$1" = "-r" ]; then
        if echo "$@" | grep -q "\--dry-run" || echo "$@" | grep -q "\-d"; then
            __dotsetup_log WARNING "Dry running...\n"
            __dotsetup_dry_ran=true
        else
            __dotsetup_dry_ran=false
        fi

        shift

        if [ "$1" = "packages" ]; then
            __dotsetup_log INFO "Rerunning package installation..."
            __dotsetup_rerun "install-packages.sh"
        elif [ "$1" = "system" ]; then
            __dotsetup_log INFO "Rerunning system-wide configuration..."
            __dotsetup_rerun "setup-system-configs.sh"
        elif [ "$1" = "home" ]; then
            __dotsetup_log INFO "Rerunning home configuration..."
            __dotsetup_rerun "setup-home.sh"
        elif [ "$1" = "suckless" ]; then
            __dotsetup_log INFO "Rerunning suckless configuration..."
            __dotsetup_rerun "setup-suckless.sh"
        else
            __dotsetup_log ERROR "Invalid step ID! Exiting..."
            __dotsetup_log INFO "Available IDs: packages, system, home, suckless."
        fi

        exit 0
    else
        __dotsetup_dry_ran=false
        __dotsetup_main
    fi
}

__dotsetup_main()
{
    __dotsetup_setup_sudoers_file

    __dotsetup_start_measuring_time

    source "$(dirname "$0")/install-packages.sh"
    source "$(dirname "$0")/setup-system-configs.sh"
    source "$(dirname "$0")/setup-home.sh"
    source "$(dirname "$0")/setup-suckless.sh"

    __dotsetup_end_measuring_time

    __dotsetup_calculate_time

    __dotsetup_delete_backups

    __dotsetup_cleanup
}

__dotsetup_rerun()
{
    __dotsetup_setup_sudoers_file

    __dotsetup_start_measuring_time

    source "$(dirname "$0")/$1"

    __dotsetup_end_measuring_time

    __dotsetup_calculate_time

    __dotsetup_delete_backups
}

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

__dotsetup_detect_personal()
{
    if findmnt --mountpoint "/personal" > /dev/null; then
        __dotsetup_log INFO "Found mounted personal partition..."
        return 0
    else
        __dotsetup_log INFO "Mounted personal partition not found, using fallback..."
        return 1
    fi
}

__dotsetup_dotfiles_setup()
{
    if __dotsetup_detect_personal; then
        __dotsetup_dotfiles_directory="/personal/dotfiles"
    else
        __dotsetup_dotfiles_directory="${HOME}/dotfiles"
        if [ ! -e "${HOME}/dotfiles" ]; then
            __dotsetup_log WARNING "dotfiles not found, downloading..."
            __dotsetup_execute 'git clone --depth 1 --recursive https://github.com/smooll-d/dotfiles.git ${HOME}/dotfiles'
        fi
    fi
}

__dotsetup_suckless_setup()
{
    if __dotsetup_detect_personal; then
        __dotsetup_suckless_directory="/personal/suckless"
    else
        __dotsetup_suckless_directory="./suckless"
        if [ ! -e "suckless/" ]; then
            __dotsetup_log INFO "Downloading suckless..."
            __dotsetup_execute 'git clone --depth 1 https://github.com/smooll-d/suckless.git'
        fi
    fi
}

__dotsetup_backup_files()
{
    local path="$1"
    local copy="$2"

    if [ -f "${path}" ] || [ -d "${path}" ]; then
        local owner
        owner=$(stat -c "%U" "${path}")

        if [ "${owner}" != "$(whoami)" ]; then
            __dotsetup_log WARNING "Backing up ${path}..."
            if [ "${copy}" == "copy" ]; then
                __dotsetup_execute 'sudo cp "${path}" "${path}.bak"'
            else
                __dotsetup_execute 'sudo mv "${path}" "${path}.bak"'
            fi
            __dotsetup_backups+=("${path}.bak")
        else
            __dotsetup_log WARNING "Backing up ${path}..."
            if [ "${copy}" == "copy" ]; then
                __dotsetup_execute 'cp "${path}" "${path}.bak"'
            else
                __dotsetup_execute 'mv "${path}" "${path}.bak"'
            fi
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
                        __dotsetup_check_last_command
                        __dotsetup_log SUCCESS "Successfully deleted ${__dotsetup_backup}!"
                    else
                        __dotsetup_log ERROR "${__dotsetup_backup} does not exist!"
                    fi
                done
            fi
            ;;
        [Nn]|*)
            __dotsetup_log INFO "Not deleting backups."
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

__dotsetup_execute()
{
    if ${__dotsetup_dry_ran}; then
        echo "$1"
    else
        eval "$1"
    fi
}

__dotsetup_start_measuring_time()
{
    __dotsetup_execute 'sudo hwclock --systohc'
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
    __dotsetup_log WARNING "To execute commands which require elevated permissions and keep dotsetup"
    __dotsetup_log WARNING "running without sudo interrupting, it requires your password at the start"
    __dotsetup_log WARNING "to keep the sudo session running, dotsetup will then add your user to"
    __dotsetup_log WARNING "the /etc/sudeors file so sudo will not interrupt in the middle of"
    __dotsetup_log WARNING "execution. Don't worry, /etc/sudoers will be reset to its previous"
    __dotsetup_log WARNING "state after dotsetup is finished."

    __dotsetup_execute 'echo "${__dotsetup_sudo_user}" | sudo -E -- tee -a /etc/sudoers >/dev/null'

    trap __dotsetup_reset_sudoers_file EXIT
}

__dotsetup_reset_sudoers_file()
{
    __dotsetup_log INFO "Resetting /etc/sudoers..."

    __dotsetup_execute 'sudo -E -- sed -i "/^${__dotsetup_sudo_user}/d" /etc/sudoers'

    __dotsetup_log SUCCESS "Finished in ${__dotsetup_duration}!"
}

__dotsetup_cleanup()
{
    read -p "Delete dotsetup? [y/N]: " __dotsetup_delete

    case "${__dotsetup_delete}" in
        [yY])
            __dotsetup_log INFO "Deleting dotsetup files..."

            local __dotsetup_files=("dotsetup" "packages-pacman.txt" "packages-aur.txt" "install-packages.sh" "setup-system-configs.sh" "setup-home.sh" "setup-suckless.sh" "utils.sh" "dotsetup.log")

            for __dotsetup_file in "${__dotsetup_files[@]}"; do
                if [ -e "${PWD}/${__dotsetup_file}" ]; then
                    __dotsetup_execute 'rm ${PWD}/${__dotsetup_file}'
                    __dotsetup_check_last_command
                    __dotsetup_log SUCCESS "Successfully deleted ${__dotsetup_file}!"
                else
                    __dotsetup_log ERROR "${__dotsetup_file} does not exist!"
                fi
            done
            ;;
        [nN]|*)
            __dotsetup_log INFO "Not deleting dotsetup."
            ;;
    esac
}

__dotsetup_help()
{
    echo -e "Usage: dotsetup [-h || -v || -d || -r <packages || system || home || suckless> [-d]]"
    echo
    echo -e "Options:"
    echo -e "\t--help,    -h    Print this message and exit."
    echo -e "\t--version, -v    Print dotsetup version and exit."
    echo -e "\t--dry-run, -d    Print setup commands, do not execute them."
    echo -e "\t--rerun,   -r    Rerun specified step and quit."
}

__dotsetup_version()
{
    echo -e "dotsetup ${__dotsetup_version}"
    echo -e "Made with ${__dotsetup_red}<3${__dotsetup_reset} by smooll-d!"
}
