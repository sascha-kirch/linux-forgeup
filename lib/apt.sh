#!/usr/bin/env bash
# apt.sh
# Purpose: APT package installation.
# Public: install_apt_packages (idempotent)

install_apt_packages() {
    local packages=("$@")
    local to_install=()

    for pkg in "${packages[@]}"; do
        if ! is_installed "$pkg"; then
            to_install+=("$pkg")
        fi
    done

    if [ ${#to_install[@]} -ne 0 ]; then
        log_info "Installing: ${to_install[*]}"
        sudo apt-get install -y "${to_install[@]}"
    else
        log_warning "No package to be installed."
    fi
}
