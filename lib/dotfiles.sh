#!/usr/bin/env bash
# dotfiles.sh
# Purpose: clone + stow dotfiles.
# Public: setup_dotfiles, stow_dotfiles

setup_dotfiles() {
    log_info "Setting up dotfiles..."

    local dotfiles_repo="https://github.com/sascha-kirch/dotfiles.git"
    local dotfiles_dir="$HOME/dotfiles"

    if ! is_installed stow; then
        log_error "GNU Stow is not installed, install it first"
        return
    fi

    # Check if the repository already exists
    if [ -d "$dotfiles_dir" ]; then
        log_warning "Directory '$dotfiles_dir' already exists. Skipping clone"
    else
        git clone "$dotfiles_repo" "$dotfiles_dir"
    fi

    # Check if the clone was successful
    if [ $? -eq 0 ]; then
        log_info "Cloning the repository was successful."
    else
        log_error "Failed to clone the repository."
        return
    fi
}


# TODO: stow files individually and check for errors
stow_dotfiles() {
    local dotfiles=("$@")

    pushd "$HOME/dotfiles"

    if [ ${#dotfiles[@]} -ne 0 ]; then
        log_info "Stowing dotfiles: ${dotfiles[*]}"
        stow -R "${dotfiles[@]}"
        log_info "Dotfiles stowed successfully."
    else
        log_warning "No dotfiles to be stowed."
    fi

    popd
}
