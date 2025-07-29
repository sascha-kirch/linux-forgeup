#!/bin/bash

# Print the logo
print_logo() {
    cat << "EOF"
 _       _________ _                                     _______  _______  _______  _______  _______           _______
( \      \__   __/( (    /||\     /||\     /|           (  ____ \(  ___  )(  ____ )(  ____ \(  ____ \|\     /|(  ____ )
| (         ) (   |  \  ( || )   ( |( \   / )           | (    \/| (   ) || (    )|| (    \/| (    \/| )   ( || (    )|
| |         | |   |   \ | || |   | | \ (_) /    _____   | (__    | |   | || (____)|| |      | (__    | |   | || (____)|
| |         | |   | (\ \) || |   | |  ) _ (    (_____)  |  __)   | |   | ||     __)| | ____ |  __)   | |   | ||  _____)
| |         | |   | | \   || |   | | / ( ) \            | (      | |   | || (\ (   | | \_  )| (      | |   | || (
| (____/\___) (___| )  \  || (___) |( /   \ )           | )      | (___) || ) \ \__| (___) || (____/\| (___) || )
(_______/\_______/|/    )_)(_______)|/     \|           |/       (_______)|/   \__/(_______)(_______/(_______)|/

Linux System Setup Tool
by: Sascha Kirch

EOF
}

# Clear screen and show logo
clear
print_logo

# Exit on any error
set -e

# Source utility functions
source utils.sh

# Source the package list
if [ ! -f "packages.conf" ]; then
  echo "Error: packages.conf not found!"
  exit 1
fi

source packages.conf

# Update the system first
echo "Updating system..."
sudo apt update && sudo apt upgrade -y

# Install packages by category
echo "Installing system utilities..."
install_packages "${SYSTEM_UTILS[@]}"

echo "Installing development tools..."
install_packages "${DEV_TOOLS[@]}"

echo "Installing system maintenance tools..."
install_packages "${MAINTENANCE[@]}"

echo "Installing desktop environment..."
install_packages "${DESKTOP[@]}"

echo "Installing desktop environment..."
install_packages "${OFFICE[@]}"

echo "Installing media packages..."
install_packages "${MEDIA[@]}"

echo "Installing fonts..."
install_packages "${FONTS[@]}"

echo "Installing other packages..."
install_starship_prompt
install_lazydocker

# Enable services
echo "Configuring services..."
for service in "${SERVICES[@]}"; do
  if ! systemctl is-enabled "$service" &> /dev/null; then
    echo "Enabling $service..."
    sudo systemctl enable "$service"
  else
    echo "$service is already enabled"
  fi
done

echo "Setup complete! You may want to reboot your system."
