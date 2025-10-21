#!/usr/bin/env bash
# installers.sh
# Purpose: thin wrappers providing defaults for specific tools.
# Public: install_* functions

install_starship_prompt() {
    local version="${1:-v1.23.0}"
    install_gh_binary "starship/starship" "$version" "starship-x86_64-unknown-linux-musl" true
}

install_eza() {
    local version="${1:-v0.23.4}"
    install_gh_binary "eza-community/eza" "$version" "eza_x86_64-unknown-linux-musl" true
}

install_navi() {
    local version="${1:-v2.24.0}"
    install_gh_binary "denisidoro/navi" "$version" "navi-$version-x86_64-unknown-linux-musl" true
}

install_fzf(){
    local version="${1:-v0.66.0}"
    install_gh_binary "junegunn/fzf" "$version" "fzf-${version:1}-linux_amd64" true
}

install_ripgrep(){
    local version="${1:-14.1.1}"
    install_gh_package "BurntSushi/ripgrep" "$version" "ripgrep-${version}-x86_64-unknown-linux-musl" true 1 "rg"
}


install_dust(){
    local version="${1:-v1.2.3}"
    install_gh_package "bootandy/dust" "$version" "dust-${version}-x86_64-unknown-linux-musl" true 1
}

install_lazygit(){
    local version="${1:-v0.55.1}" # Default version if not provided
    install_gh_package "jesseduffield/lazygit" "$version" "lazygit_${version:1}_linux_x86_64" true
}

install_nvim() {
    local version="${1:-v0.11.4}"

    # remove any preinstalled version (e.g. those coming from ubuntu or apt)
    if is_installed neovim; then
        log_warning "Removing preinstalled neovim package"
        sudo apt remove -y neovim
    fi

    if [ -d "/usr/bin/nvim" ]; then
        log_warning "Removing preinstalled /usr/bin/nvim"
        sudo rm -rf /usr/bin/nvim
    fi

    install_gh_package "neovim/neovim" "$version" "nvim-linux-x86_64" true 1 "nvim" "bin/"
}

install_rust() {
    if command -v rustc &> /dev/null; then
        log_warning "Rust is already installed."
    else
        log_info "Installing Rust..."

        # the shell script will launch a guided installer!
        curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
        source $HOME/.cargo/env
        log_info "Rust installed successfully."
    fi
}

uninstall_rust() {
    if command -v rustc &> /dev/null; then
        log_info "Uninstalling Rust..."
        rustup self uninstall -y
        log_info "Rust uninstalled successfully."
    else
        log_warning "Rust is not installed."
    fi
}

install_lazydocker() {

    INSTALL_DIR="$HOME/.local/bin/lazydocker"

    if [ -f "$INSTALL_DIR" ]; then
        log_warning "lazydocker is already installed in $INSTALL_DIR"
    else
        log_info "Installing lazydocker..."
        sh -c "$(curl -fsSL https://raw.githubusercontent.com/jesseduffield/lazydocker/master/scripts/install_update_linux.sh)"
    fi

    # Note it is installed into .local/bin so make sure it is added to the $PATH. e.g. inside of ~/.profile
}

install_zoxide() {

    INSTALL_DIR="$HOME/.local/bin/zoxide"

    if [ -f "$INSTALL_DIR" ]; then
        log_warning "zoxide is already installed in $INSTALL_DIR"
    else
        log_info "Installing zoxide..."
        sh -c "$(curl -fsSL https://raw.githubusercontent.com/ajeetdsouza/zoxide/main/install.sh)"
    fi

    # Note it is installed into .local/bin so make sure it is added to the $PATH. e.g. inside of ~/.profile
}

install_ollama() {
    log_info "Installing/Updating ollama..."

    # Check if the user has sudo privileges and adjust configuration accordingly
    if [ ! "$(can_sudo)" ]; then
        log_warning "User $(whoami) is not in sudoers group. Not installing ollama."
        return 1
    fi

    sh -c "$(curl -fsSL https://ollama.com/install.sh)"

    # Update configs of ollama service
    # Note that the override.conf is merged with the default service file
    local ollama_service_dir="/etc/systemd/system/ollama.service.d"

    if [ ! -d "$ollama_service_dir" ]; then
        log_info "Creating directory for ollama service overrides..."
        sudo mkdir -p "$ollama_service_dir"
    else
        log_warning "Directory for ollama service overrides already exists."
    fi


    # using tee to be able to combine it with sudo
    log_info "Setting up proxy for ollama service..."
    echo "[Service]" | sudo tee $ollama_service_dir/override.conf # this will overwrite an existing file
    echo "Environment=\"https_proxy=$HTTP_PROXY\"" | sudo tee -a $ollama_service_dir/override.conf # -a for appending

    # restart service
    log_info "Restarting ollama service..."
    sudo systemctl daemon-reload
    sudo systemctl restart ollama.service
}
