# Kiro CLI pre block. Keep at the top of this file.
[[ -f "${HOME}/Library/Application Support/kiro-cli/shell/zshrc.pre.zsh" ]] && builtin source "${HOME}/Library/Application Support/kiro-cli/shell/zshrc.pre.zsh"

# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# 日本語を使う
export LANG=ja_JP.UTF-8

# golang
export PATH=$PATH:/opt/go/bin
export GOPATH=$HOME/Development/go
export PATH=$PATH:$GOPATH/bin

# clangd
export PATH=$PATH:/Library/Developer/CommandLineTools/usr/bin

# python
export PYENV_ROOT="$HOME/.pyenv"
export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init -)"

# history
export HISTFILE=$HOME/.zsh_history
export HISTSIZE=10000
export SAVEHIST=10000
setopt hist_ignore_dups
setopt EXTENDED_HISTORY

# beep
setopt no_beep
setopt nolistbeep
setopt nohistbeep

# auto cd
setopt auto_cd
function chpwd() { eza --icons }

# history search
bindkey "^P" history-beginning-search-backward
bindkey "^N" history-beginning-search-forward

# alias
alias ls='eza --icons'
alias cat='bat'
alias find='fd'
alias vi='vim'
alias vim='nvim'
alias tf='terraform'
alias tfmt='terraform fmt -recursive'
alias python="/opt/homebrew/bin/python3"

fpath=(
  ${HOME}/.zsh/completions
  ${fpath}
)

_kubectl_lazy_completion() {
  unfunction kubectl 2>/dev/null
  [[ $commands[kubectl] ]] && source <(command kubectl completion zsh)
}

kubectl() {
  _kubectl_lazy_completion
  command kubectl "$@"
}

# fool proof
# terraform destroy -help も使えなくなるのが玉に瑕
function terraform() {
  if [ "$1" = "destroy" ]; then
    if [[ ! "$*" =~ "-target=" ]]; then
      echo "Error: Terraform destroy requires a target. Use '-target=RESOURCE_TYPE.RESOURCE_NAME'"
      return 1
    fi
  fi
  command terraform "$@"
}

# itermのブラウザーをsplitで開く
browser() {
  osascript <<'APPLESCRIPT'
tell application "iTerm2"
  tell current window
    tell current session
      split vertically with profile "browser"
    end tell
  end tell
end tell
APPLESCRIPT
}

### Added by Zinit's installer
if [[ ! -f $HOME/.zinit/bin/zinit.zsh ]]; then
    print -P "%F{33}▓▒░ %F{220}Installing %F{33}DHARMA%F{220} Initiative Plugin Manager (%F{33}zdharma-continuum/zinit%F{220})…%f"
    command mkdir -p "$HOME/.zinit" && command chmod g-rwX "$HOME/.zinit"
    command git clone https://github.com/zdharma-continuum/zinit "$HOME/.zinit/bin" && \
        print -P "%F{33}▓▒░ %F{34}Installation successful.%f%b" || \
        print -P "%F{160}▓▒░ The clone has failed.%f%b"
fi

source "$HOME/.zinit/bin/zinit.zsh"
autoload -Uz _zinit
(( ${+_comps} )) && _comps[zinit]=_zinit

# Load a few important annexes, without Turbo
# (this is currently required for annexes)
zinit light-mode for \
    zdharma-continuum/z-a-rust \
    zdharma-continuum/z-a-as-monitor \
    zdharma-continuum/z-a-patch-dl \
    zdharma-continuum/z-a-bin-gem-node

### End of Zinit's installer chunk
# theme
zinit ice depth=1
zinit light romkatv/powerlevel10k

# Completion
zinit wait lucid for \
  zsh-users/zsh-completions \
  zdharma-continuum/fast-syntax-highlighting \
  zsh-users/zsh-history-substring-search \
  chrissicool/zsh-256color

# bind fg to ctrl+z
fg-ctrl-z(){
  if [[ $#BUFFER -eq 0 ]]; then
    BUFFER="fg"
    zle accept-line
  else
    zle push-input
    zle clear-screen
  fi
}
zle -N fg-ctrl-z
bindkey '^Z' fg-ctrl-z

# zsh completion
# bindkey '\t' menu-complete "$terminfo[kcbt]" reverse-menu-complete
# bindkey '\t' menu-select "$terminfo[kcbt]" menu-select
# bindkey -M menuselect '\t' menu-complete "$terminfo[kcbt]" reverse-menu-complete
# zstyle ':autocomplete:history-search-backward:*' list-lines 16
# zstyle ':autocomplete:history-incremental-search-backward:*' list-lines 16

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

# Iterm2 Shell integration
test -e "${HOME}/.iterm2_shell_integration.zsh" && source "${HOME}/.iterm2_shell_integration.zsh"

# The next line updates PATH for the Google Cloud SDK.
if [ -f "${HOME}/google-cloud-sdk/path.zsh.inc" ]; then . "${HOME}/google-cloud-sdk/path.zsh.inc"; fi

# The next line enables shell command completion for gcloud.
if [ -f "${HOME}/google-cloud-sdk/completion.zsh.inc" ]; then . "${HOME}/google-cloud-sdk/completion.zsh.inc"; fi

# Kiro CLI post block. Keep at the bottom of this file.
[[ -f "${HOME}/Library/Application Support/kiro-cli/shell/zshrc.post.zsh" ]] && builtin source "${HOME}/Library/Application Support/kiro-cli/shell/zshrc.post.zsh"
