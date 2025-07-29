#!/bin/bash

# Function to check if a package is installed
is_installed() {
    dpkg -s "$1" &> /dev/null
}

# Function to install packages if not already installed
install_packages() {
    local packages=("$@")
    local to_install=()

    for pkg in "${packages[@]}"; do
        if ! is_installed "$pkg"; then
            to_install+=("$pkg")
        fi
    done

    if [ ${#to_install[@]} -ne 0 ]; then
        echo "Installing: ${to_install[*]}"
        sudo apt-get install -y "${to_install[@]}"
    else
        echo "No package to be installed."
    fi
}

install_starship_prompt() {
    if ! is_installed "starship"; then
        echo "Installing Starship prompt..."
        sudo sh -c "$(curl -fsSL https://starship.rs/install.sh)" -- --yes

        # Add initialization to .bashrc. I will not add it automatically since I want to use GNU Stow
        #echo 'eval "$(starship init bash)"' >> ~/.bashrc

        # Preset Starship configuration - this will create a new file at ~/.config/starship.toml. I want to use GNU Stow
        # starship preset catppuccin-powerline -o ~/.config/starship.toml

        echo "Starship prompt installed successfully."
    else
        echo "Starship prompt is already installed."
    fi
}

install_lazydocker() {

    LAZYDOCKER_DIR="$HOME/.local/bin"

    if [ -d "$LAZYDOCKER_DIR" ]; then
        echo "TPM is already installed in $LAZYDOCKER_DIR"
    else
        echo "Installing lazydocker..."
        curl -sS https://raw.githubusercontent.com/jesseduffield/lazydocker/master/scripts/install_update_linux.sh | bash
    fi

    # Note it is installed into .local/bin so make sure it is added to the $PATH. e.g. inside of ~/.profile
}


install_tmux_plugin_manager() {

    if ! is_installed tmux; then
        echo "tmux is not installed."
        exit 1
    fi

    TPM_DIR="$HOME/.tmux/plugins/tpm"

    # Check if TPM is already installed
    if [ -d "$TPM_DIR" ]; then
        echo "TPM is already installed in $TPM_DIR"
    else
        echo "Installing Tmux Plugin Manager (TPM)..."
        git clone https://github.com/tmux-plugins/tpm $TPM_DIR
    fi

    echo "TPM installed successfully!"
}

install_tmux_catppuccin(){
    CATPPUCCIN_DIR=~/.config/tmux/plugins/catppuccin

    if [ -d "$TPM_DIR" ]; then
        echo "Catppuccin is already installed in $CATPPUCCIN_DIR"
    else
        echo "Installing Tmux Catppuccin theme..."
        mkdir -p $CATPPUCCIN_DIR
        git clone -b v2.1.3 https://github.com/catppuccin/tmux.git $CATPPUCCIN_DIR/tmux
    fi
}

# When seting up tmux there is some manual cloning of repositories involved. The dotfiles are not managed by GNU Stow
setup_tmux(){
    install_tmux_plugin_manager
    install_tmux_catppuccin
}

setup_dotfiles() {
    echo "Setting up dotfiles..."

    DOTFILES_REPO_NAME="dotfiles"
    DOTFILES_REPO="https://github.com/sascha-kirch/$DOTFILES_REPO_NAME.git"
    DOTFILES_DIR="$HOME/$DOTFILES_REPO_NAME"

    source dotfiles.conf

    if ! is_installed stow; then
        echo "Install stow first"
        exit 1
    fi

    # Check if the repository already exists
    if [ -d "$DOTFILES_DIR" ]; then
        echo "Directory '$DOTFILES_DIR' already exists. Skipping clone"
    else
        git clone "$DOTFILES_REPO"
    fi

    # Check if the clone was successful
    if [ $? -eq 0 ]; then
        echo "Cloning the repository was successful."
    else
        echo "Failed to clone the repository."
        exit 1
    fi
}


stow_dotfiles() {
    local dotfiles=("$@")

    if [ ${#dotfiles[@]} -ne 0 ]; then
        echo "Stowing dotfiles: ${dotfiles[*]}"
        stow -R "${dotfiles[@]}"
    else
        echo "No dotfiles to be stowed."
    fi
}
