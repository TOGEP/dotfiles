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

link_config_path() {
  local source_path=$1
  local destination_path=$2

  if [ -e "$destination_path" ] && [ ! -L "$destination_path" ]; then
    echo "Error: refusing to replace existing config path: $destination_path" >&2
    exit 1
  fi

  ln -fnsv "$source_path" "$destination_path"
}

NVIM_CONFIG_DIR="$HOME/.config/nvim"
mkdir -p "$NVIM_CONFIG_DIR"

link_config_path "$DOTFILES_DIR/nvim/init.lua" "$NVIM_CONFIG_DIR/init.lua"
link_config_path "$DOTFILES_DIR/nvim/lua" "$NVIM_CONFIG_DIR/lua"
link_config_path "$DOTFILES_DIR/nvim/lazy-lock.json" "$NVIM_CONFIG_DIR/lazy-lock.json"
link_config_path "$DOTFILES_DIR/nvim/.stylua.toml" "$NVIM_CONFIG_DIR/.stylua.toml"

HERDR_CONFIG_DIR="$HOME/.config/herdr"
mkdir -p "$HERDR_CONFIG_DIR"
link_config_path "$DOTFILES_DIR/herdr/config.toml" "$HERDR_CONFIG_DIR/config.toml"

if [ ! -e "$HOME/.config/karabiner/karabiner.json" ]; then
  mkdir -p "$HOME/.config/karabiner/" && touch "$HOME/.config/karabiner/karabiner.json"
fi
ln -fnsv "$DOTFILES_DIR/karabiner/karabiner.json" "$HOME/.config/karabiner/karabiner.json"
