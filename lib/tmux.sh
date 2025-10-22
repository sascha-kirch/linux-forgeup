#!/usr/bin/env bash
# tmux.sh
# Purpose: tmux plugin manager & optional theme.
# Public: install_tmux_plugin_manager, install_tmux_catppuccin, setup_tmux

install_tmux_plugin_manager() {

    if ! is_installed tmux; then
        log_error "tmux is not installed. Please install tmux first."
        return
    fi

    local tpm_dir="$HOME/.tmux/plugins/tpm"

    # Check if TPM is already installed
    if [ -d "$tpm_dir" ]; then
        log_warning "TPM is already installed in $tpm_dir"
    else
        log_info "Installing Tmux Plugin Manager (TPM)..."
        git clone https://github.com/tmux-plugins/tpm "$tpm_dir"
    fi

    log_info "TPM installed successfully!"
}

install_tmux_catppuccin(){
    local catppuccin_dir=~/.config/tmux/plugins/catppuccin

    if [ -d "$catppuccin_dir" ]; then
        log_warning "Catppuccin is already installed in $catppuccin_dir"
    else
        log_info "Installing Tmux Catppuccin theme..."
        mkdir -p $catppuccin_dir
        git clone -b v2.1.3 https://github.com/catppuccin/tmux.git "$catppuccin_dir/tmux"
    fi
}

# When seting up tmux there is some manual cloning of repositories involved. The dotfiles are not managed by GNU Stow
setup_tmux(){
    install_tmux_plugin_manager
    # install_tmux_catppuccin
}
