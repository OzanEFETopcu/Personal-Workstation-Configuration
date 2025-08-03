# Personal-Workstation-Configuration
Personal configuration files for my development environment.

## Contents
- zsh/: ZSH shell configuration

## Installation
1. Clone this repository:
```
git clone git@github.com:OzanEFETopcu/Personal-Workstation-Configuration.git ~/ws_conf
```

2. Run the installation script (This will create symlink from all the config files in this reposiory to your tools' expected config locations):
```
cd ~/ws_conf
./install.sh
```
3. Resart your shell, you can possibly run these config files one by one but it is easier to forget a certain config file so to be safe always restart the whole shell

## Adding New Configurations

1. Move the config file to the appropriate directory in ~/ws_conf/
2. Add a symlink creation command to install.sh, this will be almost identical to the ones already existing in the installation file so you can follow that
3. Run ./install.sh to create the symlink
4. In case you are using version control service don't forget to update the latest changes!

## Structure
```
ws_conf/
├── install.sh          # Installation script
├── README.md          # This file
├── zsh/
│   └── .zshrc         # ZSH configuration
├── nvim/              # Neovim configuration
│   ├── init.lua
│   └── lua/
└── git/
    └── .gitconfig     # Git configuration
```

## Important Notes
- In case there were existing config files for the tools, these original files replaced by the installation script are backed up with a .backup extension in the same location
- The installation script is idempotent
- Symlinks allow changes to be immediately reflected in the repository
