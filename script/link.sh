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

if [ ! -e "$HOME/.config/nvim/init.vim" ]; then
  mkdir -p "$HOME/.config/nvim/" && touch "$HOME/.config/nvim/init.vim"
fi
ln -fnsv "$DOTFILES_DIR/nvim/init.vim" "$HOME/.config/nvim/init.vim"

if [ ! -e "$HOME/.config/karabiner/karabiner.json" ]; then
  mkdir -p "$HOME/.config/karabiner/" && touch "$HOME/.config/karabiner/karabiner.json"
fi
ln -fnsv "$DOTFILES_DIR/karabiner/karabiner.json" "$HOME/.config/karabiner/karabiner.json"
