#!/usr/bin/env bash
# vim.sh
# Purpose: vim plugin manager and plugin installation.
# Public: install_vim_pluginmanager, install_vim_plugins

install_vim_pluginmanager() {
    if ! is_installed vim; then
        log_error "vim is not installed. Please install vim first."
        return
    fi

    log_info "Installing vim-plug plugin manager..."
    curl -fLo ~/.vim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

}

install_vim_plugins() {
    if ! is_installed vim; then
        log_error "vim is not installed. Please install vim first."
        return
    fi

    # Check if vim-plug is installed
    if [ ! -f ~/.vim/autoload/plug.vim ]; then
        log_error "vim-plug is not installed. Please run install_vim_pluginmanager first."
        return
    fi

    # Install plugins using vim-plug
    log_info "Installing vim plugins..."
    vim +PlugInstall +qall
}
