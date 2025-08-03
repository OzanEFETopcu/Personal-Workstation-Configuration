#!/bin/bash

# Dotfiles installation script
# This script creates symbolic links from your home directory to your dotfiles repo

DOTFILES_DIR="$HOME/ws_conf"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Function to create symlink with backup
create_symlink() {
    local source="$1"
    local target="$2"
    
    # Create target directory if it doesn't exist
    mkdir -p "$(dirname "$target")"
    
    # If target exists and is not a symlink, back it up
    if [[ -e "$target" && ! -L "$target" ]]; then
        echo -e "${YELLOW}Backing up existing $target to $target.backup${NC}"
        mv "$target" "$target.backup"
    fi
    
    # Remove existing symlink if it exists
    if [[ -L "$target" ]]; then
        rm "$target"
    fi
    
    # Create the symlink
    ln -s "$source" "$target"
    echo -e "${GREEN}✓ Linked $source → $target${NC}"
}

echo "Setting up dotfiles..."

# ZSH configuration
if [[ -f "$DOTFILES_DIR/zsh/.zshrc" ]]; then
    create_symlink "$DOTFILES_DIR/zsh/.zshrc" "$HOME/.zshrc"
fi

# Neovim configuration
if [[ -d "$DOTFILES_DIR/nvim" ]]; then
    create_symlink "$DOTFILES_DIR/nvim" "$HOME/.config/nvim"
fi

# Git configuration
if [[ -f "$DOTFILES_DIR/git/.gitconfig" ]]; then
    create_symlink "$DOTFILES_DIR/git/.gitconfig" "$HOME/.gitconfig"
fi

# Add more configurations as needed
# Example for other common dotfiles:
# if [[ -f "$DOTFILES_DIR/bash/.bashrc" ]]; then
#     create_symlink "$DOTFILES_DIR/bash/.bashrc" "$HOME/.bashrc"
# fi

echo -e "${GREEN}Dotfiles installation complete!${NC}"
echo "Restart your terminal to make sure all the changes are active"
