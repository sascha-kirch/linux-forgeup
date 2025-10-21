#!/usr/bin/env bash
# core.sh
# Purpose: fundamental helpers (sudo, package presence, file existence).
# Public: can_sudo, is_installed, file_exists, fatal

can_sudo(){
    groups "$(id -un)" 2>/dev/null | grep -q sudo
    if [ $? -ne 0 ]; then
        log_warning "User $(id -un) is not in the sudo group."
        return 1
    else
        log_info "User $(id -un) is in the sudo group."
        return 0
    fi
}

# Function to check if a package is installed
is_installed() {
    dpkg -s "$1" &> /dev/null
}

file_exists(){
    if [ ! -f "$1" ]; then
        log_error "File $1 does not found!"
        return 1
    else
        log_info "File $1 found."
        return 0
    fi
}

fatal(){
    log_error "FATAL: ${1}"
    exit 1
}
