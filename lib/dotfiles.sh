#!/usr/bin/env bash
# dotfiles.sh
# Purpose: clone + stow dotfiles.
# Public: setup_dotfiles, stow_dotfiles

setup_dotfiles() {
    log_info "Setting up dotfiles..."

    DOTFILES_REPO_NAME="dotfiles"
    DOTFILES_REPO="https://github.com/sascha-kirch/$DOTFILES_REPO_NAME.git"
    DOTFILES_DIR="$HOME/$DOTFILES_REPO_NAME"

    source dotfiles.conf

    if ! is_installed stow; then
        log_error "GNU Stow is not installed, install it first"
        return
    fi

    # Check if the repository already exists
    if [ -d "$DOTFILES_DIR" ]; then
        log_warning "Directory '$DOTFILES_DIR' already exists. Skipping clone"
    else
        git clone "$DOTFILES_REPO" "$DOTFILES_DIR"
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
    else
        log_warning "No dotfiles to be stowed."
    fi

    popd
    log_info "Dotfiles stowed successfully."
}
