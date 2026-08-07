#!/bin/bash
set -euxo pipefail

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

# TODO vim-plugはOSによってインストールスクリプトが異なる
sh -c 'curl -fLo "${XDG_DATA_HOME:-$HOME/.local/share}"/nvim/site/autoload/plug.vim --create-dirs \
       https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'

nvim -E -s <<-EOF
:source $HOME/.config/nvim/init.vim
:PlugInstall
:PlugClean
:qa
EOF
