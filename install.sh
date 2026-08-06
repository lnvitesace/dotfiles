#!/usr/bin/env bash

REPO_URL="https://github.com/lnvitesace/dotfiles.git"
DOTFILES_DIR="${DOTFILES_DIR:-$HOME/.dotfiles}"

# Package needed
BREW_PKGS=(git fish make unzip fd fzf rg nvim)
APT_PKGS=(git fish make unzip fd fzf rg nvim)
DNF_PKGS=(git fish make unzip fd fzf rg nvim)

log()  { printf '\033[1;34m==>\033[0m %s\n' "$*"; }
warn() { printf '\033[1;33m[!]\033[0m %s\n' "$*" >&2; }
die()  { printf '\033[1;31m[x]\033[0m %s\n' "$*" >&2; exit 1; }

# ---------- 1. Install packages ----------
install_packages() {
    if [[ "$OSTYPE" == darwin* ]]; then
        if ! command -v brew >/dev/null 2>&1; then
            log "Installing Homebrew..."
            /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
            [[ -x /opt/homebrew/bin/brew ]] && eval "$(/opt/homebrew/bin/brew shellenv)"
        fi
        log "Installing packages: ${BREW_PKGS[*]}"
        brew install "${BREW_PKGS[@]}"
    elif command -v apt-get >/dev/null 2>&1; then
        log "Installing packages: ${APT_PKGS[*]}"
        sudo apt-get update
        sudo apt-get install -y "${APT_PKGS[@]}"
    elif command -v dnf >/dev/null 2>&1; then
        log "Installing packages: ${DNF_PKGS[*]}"
        sudo dnf install -y "${DNF_PKGS[@]}"
    else
        warn "Invalid package manager"
    fi

    # uv
    log "Installing uv: "
    curl -LsSf https://astral.sh/uv/install.sh | sh
    # Rust
    log "Installing rust: "
    curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh

    # Treesitter
    log "Installing treesitter: "
    cargo binstall tree-sitter-cli
}

# ---------- 2. Clone dotfiles repo ----------
clone_repo() {
    if [[ -d "$DOTFILES_DIR/.git" ]]; then
        log "Updating repo... $DOTFILES_DIR"
        git -C "$DOTFILES_DIR" pull --ff-only
    else
        log "Cloning repo... $REPO_URL -> $DOTFILES_DIR"
        git clone "$REPO_URL" "$DOTFILES_DIR"
    fi
}

# ---------- 3. Link dotfiles ----------
link() {
    local src="$1" dst="$2"
    mkdir -p "$(dirname "$dst")"
    if [[ -e "$dst" || -L "$dst" ]]; then
        local backup="$dst.bak.$(date +%Y%m%d%H%M%S)"
        warn "Exist $dst,backup to $backup"
        mv "$dst" "$backup"
    fi
    log "Linking $dst -> $src"
    ln -s "$src" "$dst"
}

link_configs() {
    link "$DOTFILES_DIR/fish"            "$HOME/.config/fish"
    link "$DOTFILES_DIR/.alacritty.toml" "$HOME/.alacritty.toml"
    link "$DOTFILES_DIR/nvim"            "$HOME/.config/nvim"
    link "$DOTFILES_DIR/.tmux.conf"      "$HOME/.tmux.conf"
}

main() {
    install_packages
    clone_repo
    link_configs
    log "Complete!"
}

main "$@"
