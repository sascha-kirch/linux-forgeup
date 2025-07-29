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
