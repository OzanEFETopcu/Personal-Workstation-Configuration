# Personal Workstation Configuration

## Setup on a new machine

```bash
git clone <this-repo-url> ~/dotfiles
bash ~/dotfiles/install.sh
```

The installer prints a ✓/✗ prerequisite report with install hints for anything missing. It then symlinks `~/.zshrc`, `~/.config/nvim`, and `~/.gitconfig` into the repo, backing up any existing files to `*.backup`.

## Switching between machines

Live config files are symlinks into this repo, so syncing is plain git:

- Before leaving machine X: `cd ~/dotfiles && git add -A && git commit -m "..." && git push`
- Before starting on machine Y: `cd ~/dotfiles && git pull`

Forget to push on X and the changes won't be on Y. Edit on both without syncing and you get a normal git conflict.

## Git identity (per-machine, not tracked)

Your name and email live in `~/.gitconfig.local`, which the tracked `git/.gitconfig` pulls in via `[include]`. The installer writes a placeholder on first run — edit it with your real values. Each new machine needs this filled in once.
