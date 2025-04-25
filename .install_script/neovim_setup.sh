#!/bin/bash

# Function to check if a command exists
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Install Neovim if not installed
if ! command_exists nvim; then
    echo "Neovim not found. Installing Neovim..."
    if command_exists apt; then
        sudo apt update
        sudo apt install -y neovim
    elif command_exists pacman; then
        sudo pacman -S neovim
    elif command_exists brew; then
        brew install neovim
    else
        echo "Package manager not supported. Please install Neovim manually."
        exit 1
    fi
fi

# Install Python and pip if they are not already installed
if ! command_exists pip; then
    echo "pip not found. Installing pip..."
    if command_exists apt; then
        sudo apt install -y python3-pip
    elif command_exists pacman; then
        sudo pacman -S python-pip
    elif command_exists brew; then
        brew install python
    else
        echo "Package manager not supported. Please install pip manually."
        exit 1
    fi
fi

# Install Python dependencies (e.g., pyright for Python LSP)
echo "Installing Pyright (Python LSP)..."
pip install pyright

# Install Node.js and npm if they are not installed
if ! command_exists node; then
    echo "Node.js not found. Installing Node.js and npm..."
    if command_exists apt; then
        sudo apt update
        sudo apt install -y nodejs npm
    elif command_exists pacman; then
        sudo pacman -S nodejs npm
    elif command_exists brew; then
        brew install node
    else
        echo "Package manager not supported. Please install Node.js and npm manually."
        exit 1
    fi
fi

# Install nvim-cmp and other required npm packages
echo "Installing npm packages for nvim-cmp and LSP support..."
npm install -g pyright

# Check if Neovim configuration exists and backup if needed
CONFIG_DIR="$HOME/.config/nvim"
if [ -d "$CONFIG_DIR" ]; then
    echo "Backing up existing Neovim config..."
    mv "$CONFIG_DIR" "$HOME/.config/nvim.bak"
else
    echo "No existing Neovim config found, proceeding with setup..."
fi

# Clone the Neovim config repository
echo "Cloning the Neovim configuration repository..."
git clone https://github.com/oAstrex/init.lua.git "$CONFIG_DIR"

# Install the required Neovim plugins using lazy.nvim
echo "Installing required Neovim plugins..."
nvim +PackerSync +qall

echo "Neovim setup completed!"
