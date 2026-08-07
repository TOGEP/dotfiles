#!/bin/bash
set -euxo pipefail

CURRENT_DIR=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)
DOTFILES_DIR=$(dirname "${CURRENT_DIR}")

for dotfile in "${DOTFILES_DIR}"/.??*; do
  [[ $dotfile = "${DOTFILES_DIR}/.git" ]] && continue
  [[ $dotfile = "${DOTFILES_DIR}/.github" ]] && continue
  [[ $dotfile = "${DOTFILES_DIR}/.DS_Store" ]] && continue
  echo "$dotfile"

  ln -fnsv "$dotfile" "$HOME"
done

NVIM_CONFIG_DIR="$HOME/.config/nvim"
mkdir -p "$NVIM_CONFIG_DIR"

legacy_nvim_init="$NVIM_CONFIG_DIR/init.vim"
if [ -L "$legacy_nvim_init" ] && [ "$(readlink "$legacy_nvim_init")" = "$DOTFILES_DIR/nvim/init.vim" ]; then
  rm "$legacy_nvim_init"
fi

link_nvim_path() {
  local source_path=$1
  local destination_path=$2

  if [ -e "$destination_path" ] && [ ! -L "$destination_path" ]; then
    echo "Error: refusing to replace existing Neovim path: $destination_path" >&2
    exit 1
  fi

  ln -fnsv "$source_path" "$destination_path"
}

link_nvim_path "$DOTFILES_DIR/nvim/init.lua" "$NVIM_CONFIG_DIR/init.lua"
link_nvim_path "$DOTFILES_DIR/nvim/lua" "$NVIM_CONFIG_DIR/lua"
link_nvim_path "$DOTFILES_DIR/nvim/lazy-lock.json" "$NVIM_CONFIG_DIR/lazy-lock.json"
link_nvim_path "$DOTFILES_DIR/nvim/.stylua.toml" "$NVIM_CONFIG_DIR/.stylua.toml"

if [ ! -e "$HOME/.config/karabiner/karabiner.json" ]; then
  mkdir -p "$HOME/.config/karabiner/" && touch "$HOME/.config/karabiner/karabiner.json"
fi
ln -fnsv "$DOTFILES_DIR/karabiner/karabiner.json" "$HOME/.config/karabiner/karabiner.json"
