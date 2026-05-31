#!/bin/bash

# Dotfiles installation script
# Creates symbolic links from your home directory to this repo,
# wherever the repo happens to live on disk.

# Resolve the directory this script lives in, following symlinks.
SOURCE="${BASH_SOURCE[0]}"
while [ -L "$SOURCE" ]; do
    DIR="$(cd -P "$(dirname "$SOURCE")" && pwd)"
    SOURCE="$(readlink "$SOURCE")"
    [[ $SOURCE != /* ]] && SOURCE="$DIR/$SOURCE"
done
DOTFILES_DIR="$(cd -P "$(dirname "$SOURCE")" && pwd)"

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

CHECK="${GREEN}✓${NC}"
CROSS="${RED}✗${NC}"

# ---------- Prerequisite check ----------
echo -e "${BLUE}Checking prerequisites...${NC}"

missing=0

check_cmd() {
    local name="$1"
    local cmd="$2"
    local hint="$3"
    if command -v "$cmd" >/dev/null 2>&1; then
        echo -e "  $CHECK $name"
    else
        echo -e "  $CROSS $name — not installed. $hint"
        missing=$((missing + 1))
    fi
}

check_path() {
    local name="$1"
    local path="$2"
    local hint="$3"
    if [ -e "$path" ]; then
        echo -e "  $CHECK $name"
    else
        echo -e "  $CROSS $name — missing at $path. $hint"
        missing=$((missing + 1))
    fi
}

check_cmd "Homebrew"   "brew"        "Install: /bin/bash -c \"\$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)\""
check_cmd "git"        "git"         "Install: brew install git"
check_cmd "zsh"        "zsh"         "Install: brew install zsh"
check_cmd "Neovim"     "nvim"        "Install: brew install neovim"
check_cmd "lazydocker" "lazydocker"  "Install: brew install lazydocker (used by 'lzd' alias)"
check_path "Oh My Zsh" "$HOME/.oh-my-zsh"     "Install: sh -c \"\$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)\""
check_path "NVM"       "$HOME/.nvm/nvm.sh"    "Install: brew install nvm (then mkdir ~/.nvm)"

ZSH_CUSTOM_DIR="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}"
check_path "zsh-syntax-highlighting plugin" "$ZSH_CUSTOM_DIR/plugins/zsh-syntax-highlighting" \
    "Install: git clone https://github.com/zsh-users/zsh-syntax-highlighting $ZSH_CUSTOM_DIR/plugins/zsh-syntax-highlighting"
check_path "zsh-autosuggestions plugin"     "$ZSH_CUSTOM_DIR/plugins/zsh-autosuggestions" \
    "Install: git clone https://github.com/zsh-users/zsh-autosuggestions $ZSH_CUSTOM_DIR/plugins/zsh-autosuggestions"
check_path "you-should-use plugin"          "$ZSH_CUSTOM_DIR/plugins/you-should-use" \
    "Install: git clone https://github.com/MichaelAquilina/zsh-you-should-use.git $ZSH_CUSTOM_DIR/plugins/you-should-use"

if [ "$missing" -gt 0 ]; then
    echo -e "${YELLOW}$missing prerequisite(s) missing. Symlinks will still be created, but ~/.zshrc may error on first load until they're installed.${NC}"
else
    echo -e "${GREEN}All prerequisites present.${NC}"
fi
echo

# ---------- Symlink helper ----------
create_symlink() {
    local source="$1"
    local target="$2"

    mkdir -p "$(dirname "$target")"

    if [[ -e "$target" && ! -L "$target" ]]; then
        echo -e "${YELLOW}Backing up existing $target to $target.backup${NC}"
        mv "$target" "$target.backup"
    fi

    if [[ -L "$target" ]]; then
        rm "$target"
    fi

    ln -s "$source" "$target"
    echo -e "${GREEN}✓ Linked $source → $target${NC}"
}

# ---------- Linking ----------
echo -e "${BLUE}Setting up dotfiles from $DOTFILES_DIR...${NC}"

if [[ -f "$DOTFILES_DIR/zsh/.zshrc" ]]; then
    create_symlink "$DOTFILES_DIR/zsh/.zshrc" "$HOME/.zshrc"
fi

if [[ -d "$DOTFILES_DIR/nvim" ]]; then
    create_symlink "$DOTFILES_DIR/nvim" "$HOME/.config/nvim"
fi

if [[ -f "$DOTFILES_DIR/git/.gitconfig" ]]; then
    create_symlink "$DOTFILES_DIR/git/.gitconfig" "$HOME/.gitconfig"
    # User identity is kept out of version control; write a template if missing.
    if [[ ! -f "$HOME/.gitconfig.local" ]]; then
        cat > "$HOME/.gitconfig.local" <<'EOF'
[user]
	email = your-email@example.com
	name = Your Name
EOF
        echo -e "${YELLOW}Created template $HOME/.gitconfig.local — edit it with your real name and email.${NC}"
    fi
fi

echo -e "${GREEN}Dotfiles installation complete!${NC}"
echo "Restart your terminal to make sure all the changes are active"
