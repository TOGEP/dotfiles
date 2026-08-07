#!/bin/bash
set -euxo pipefail

CURRENT_DIR=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)
DOTFILES_DIR=$(dirname "${CURRENT_DIR}")

# OS Check
# Mac(intel or apple silicon)
if [ "$(uname)" == 'Darwin' ]; then
  echo 'Start setup MacOS'
  # Check for Homebrew
  if ! command -v brew >/dev/null 2>&1; then
    echo 'Install Homebrew'
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    if [ "$(uname -m)" == 'arm64' ]; then
      BREW_BIN=/opt/homebrew/bin/brew
    else
      BREW_BIN=/usr/local/bin/brew
    fi
    BREW_SHELLENV="eval \"\$(${BREW_BIN} shellenv)\""
    grep -Fqx "$BREW_SHELLENV" "$HOME/.zprofile" 2>/dev/null || echo "$BREW_SHELLENV" >> "$HOME/.zprofile"
    eval "$("$BREW_BIN" shellenv)"
  else
    echo "Already installed Homebrew"
  fi

  # Check for xcode command line tool
  if ! xcode-select --print-path &> /dev/null; then
    echo "Install xcode command line tool"
    xcode-select --install
  else
    echo "Already installed xcode command line tool"
  fi

  # Apple silicon
  if [ "$(uname -m)" == 'arm64' ]; then
    # Check for rosetta2
    if ! /usr/bin/arch -x86_64 /usr/bin/true 2>/dev/null; then
      echo "Install rosetta2"
      /usr/sbin/softwareupdate --install-rosetta --agree-to-license
    else
      echo "Already installed rosetta2"
    fi
  fi
  brew bundle --file="$DOTFILES_DIR/Brewfile"

# Linux
elif [ "$(uname -s)" == 'Linux' ]; then
  RELEASE_FILE=/etc/os-release
  # Ubuntu
  if grep '^NAME="Ubuntu' "${RELEASE_FILE}" >/dev/null; then
    echo 'Start setup UbuntuOS'
    sudo apt install language-pack-ja
    sudo update-locale LANG=ja_JP.UTF-8
    sudo apt-get install build-essential procps curl file git
    if ! command -v brew >/dev/null 2>&1; then
      echo 'Install Homebrew'
      /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
      BREW_SHELLENV="eval \"\$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)\""
      grep -Fqx "$BREW_SHELLENV" "$HOME/.bash_profile" 2>/dev/null || echo "$BREW_SHELLENV" >> "$HOME/.bash_profile"
      eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
    else
      echo "Already installed Homebrew"
    fi
  fi
  brew bundle --file="$DOTFILES_DIR/Brewfile"
  brew install zsh
  echo 'Change shell to zsh'
  sudo chsh "$USER" -s "$(command -v zsh)"
  BREW_SHELLENV="eval \"\$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)\""
  grep -Fqx "$BREW_SHELLENV" "$HOME/.zprofile" 2>/dev/null || echo "$BREW_SHELLENV" >> "$HOME/.zprofile"
  eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"

# 
else
  echo "Your platform is not supported."
  uname -a
  exit 1
fi
