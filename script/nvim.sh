#!/bin/bash
set -euxo pipefail

CURRENT_DIR=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)
DOTFILES_DIR=$(dirname "${CURRENT_DIR}")

if ! command -v nvim >/dev/null 2>&1; then
  for brew_bin in \
    /opt/homebrew/bin/brew \
    /usr/local/bin/brew \
    /home/linuxbrew/.linuxbrew/bin/brew; do
    if [ -x "$brew_bin" ]; then
      eval "$("$brew_bin" shellenv)"
      break
    fi
  done
fi

if ! command -v nvim >/dev/null 2>&1; then
  echo "Error: nvim is not installed or not available in PATH." >&2
  exit 1
fi

nvim --headless "+Lazy! restore" "+qa"
nvim --headless "+MasonToolsInstallSync" "+qa"
nvim --headless "+lua assert(vim.g.mapleader == ' ')" "+qa"

STYLUA_BIN="${XDG_DATA_HOME:-$HOME/.local/share}/nvim/mason/bin/stylua"
"$STYLUA_BIN" --check "$DOTFILES_DIR/nvim"
