#!/usr/bin/env bash

set -euo pipefail

REPO_URL="https://github.com/lnvitesace/dotfiles.git"
DOTFILES_DIR="${DOTFILES_DIR:-$HOME/.dotfiles}"

APT_BOOTSTRAP_PKGS=(ca-certificates software-properties-common)
# Only base tools from apt; CLI tools are installed latest via cargo-binstall / GitHub releases
APT_PKGS=(build-essential fish git passwd unzip)

log() { printf '\033[1;34m==>\033[0m %s\n' "$*"; }

# ---------- 1. Install Ubuntu packages ----------
log "Updating package lists..."
sudo apt-get update

log "Installing package prerequisites..."
sudo apt-get install -y --no-install-recommends "${APT_BOOTSTRAP_PKGS[@]}"

# Fish's official PPA provides fish 4.x; git-core PPA provides latest git.
log "Adding fish-shell/release-4 and git-core/ppa PPAs..."
sudo add-apt-repository -ny ppa:fish-shell/release-4
sudo add-apt-repository -ny ppa:git-core/ppa
sudo apt-get update

log "Installing packages..."
sudo apt-get install -y --no-install-recommends "${APT_PKGS[@]}"

# ---------- 2. Install user-local tools ----------
mkdir -p "$HOME/.local/bin"

nvim_arch="$(uname -m)"
[[ "$nvim_arch" == "aarch64" || "$nvim_arch" == "arm64" ]] && nvim_arch="arm64"

log "Installing latest Neovim..."
curl -fsSL \
    "https://github.com/neovim/neovim/releases/latest/download/nvim-linux-${nvim_arch}.tar.gz" \
    -o /tmp/nvim.tar.gz
tar -xzf /tmp/nvim.tar.gz -C "$HOME/.local"
ln -sf "$HOME/.local/nvim-linux-${nvim_arch}/bin/nvim" "$HOME/.local/bin/nvim"
rm -f /tmp/nvim.tar.gz

# tmux official builds: tarball contains a single static `tmux` binary
log "Installing latest tmux..."
tmux_arch="$(uname -m)"
[[ "$tmux_arch" == "aarch64" ]] && tmux_arch="arm64"
tmux_url="$(curl -fsSL https://api.github.com/repos/tmux/tmux-builds/releases/latest \
    | grep browser_download_url | grep "linux-${tmux_arch}.tar.gz" | cut -d '"' -f4)"
curl -fsSL "$tmux_url" | tar -xzf - -C "$HOME/.local/bin"

log "Installing latest uv..."
curl -LsSf https://astral.sh/uv/install.sh | sh

# fzf is Go, not Rust: install official release tarball (single binary)
log "Installing latest fzf..."
fzf_arch="$(uname -m)"
[[ "$fzf_arch" == "x86_64" ]] && fzf_arch="amd64"
[[ "$fzf_arch" == "aarch64" ]] && fzf_arch="arm64"
fzf_url="$(curl -fsSL https://api.github.com/repos/junegunn/fzf/releases/latest \
    | grep browser_download_url | grep "linux_${fzf_arch}.tar.gz" | cut -d '"' -f4)"
curl -fsSL "$fzf_url" | tar -xzf - -C "$HOME/.local/bin"

log "Installing Rust..."
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
. "$HOME/.cargo/env"

log "Installing cargo-binstall..."
curl -L --proto '=https' --tlsv1.2 -sSf \
    https://raw.githubusercontent.com/cargo-bins/cargo-binstall/main/install-from-binstall-release.sh | bash

# Latest Rust CLI tools via prebuilt binaries
log "Installing bat, fd, ripgrep, zoxide, eza, tree-sitter-cli..."
cargo binstall -y bat fd-find ripgrep zoxide eza tree-sitter-cli

# ---------- 3. Clone dotfiles ----------
log "Cloning dotfiles..."
git clone "$REPO_URL" "$DOTFILES_DIR"
git -C "$DOTFILES_DIR" submodule update --init --recursive

# ---------- 4. Link dotfiles ----------
mkdir -p "$HOME/.config"
ln -s "$DOTFILES_DIR/fish"       "$HOME/.config/fish"
ln -s "$DOTFILES_DIR/nvim"       "$HOME/.config/nvim"
ln -s "$DOTFILES_DIR/.tmux.conf" "$HOME/.tmux.conf"

# ---------- 5. Login to tmux ----------
cat >> "$HOME/.bashrc" <<'EOF'
    if command -v tmux >/dev/null 2>&1 && [ -z "${TMUX:-}" ]; then
       exec tmux new-session -A -s main
    fi
EOF

log "Complete!"

