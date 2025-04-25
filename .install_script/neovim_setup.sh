#!/bin/bash

# Function to check if a command exists
command_exists() {
    command -v "$1" &>/dev/null
}

# Check if Neovim is installed, install if not
if ! command_exists nvim; then
    echo "Neovim is not installed. Installing..."
    # Install Neovim based on the distribution
    if [[ "$(uname)" == "Darwin" ]]; then
        # macOS
        brew install neovim
    elif [[ -f /etc/os-release ]]; then
        # Linux
        if grep -q "Ubuntu" /etc/os-release || grep -q "Debian" /etc/os-release; then
            sudo apt update
            sudo apt install -y neovim
        elif grep -q "Fedora" /etc/os-release; then
            sudo dnf install -y neovim
        elif grep -q "Arch" /etc/os-release; then
            sudo pacman -S --noconfirm neovim
        fi
    else
        echo "Unsupported OS. Please install Neovim manually."
        exit 1
    fi
else
    echo "Neovim is already installed."
fi

# Check if the Neovim config folder exists in $HOME/.config/nvim
NVIM_CONFIG_DIR="$HOME/.config/nvim"
if [ -d "$NVIM_CONFIG_DIR" ]; then
    echo "Neovim config folder found at $NVIM_CONFIG_DIR. Moving it to $HOME/.config/nvim.bak..."
    mv "$NVIM_CONFIG_DIR" "$HOME/.config/nvim.bak"
else
    echo "No existing Neovim config folder found at $NVIM_CONFIG_DIR."
fi

# Clone the Git repository containing your init.lua config
echo "Cloning the init.lua repository..."
git clone https://github.com/oAstrex/init.lua.git "$NVIM_CONFIG_DIR"

# Inform the user to install the required plugins
echo "Neovim config has been cloned. Please install the required plugins inside Neovim by running :PlugInstall or your plugin manager's install command."

# Done
echo "Setup complete. Neovim should be ready with your configuration."
