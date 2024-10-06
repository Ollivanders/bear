export ZSH="$HOME/.oh-my-zsh"

# Better history
# Credits to https://coderwall.com/p/jpj_6q/zsh-better-history-searching-with-arrow-keys
autoload -U up-line-or-beginning-search
autoload -U down-line-or-beginning-search
zle -N up-line-or-beginning-search
zle -N down-line-or-beginning-search
bindkey "^[[A" up-line-or-beginning-search # Up
bindkey "^[[B" down-line-or-beginning-search # Down
autoload -U compinit && compinit

# # initialize autocomplete here, otherwise functions won't be loaded
# autoload -U compinit
# compinit


# Uncomment the following line to enable command auto-correction.
ENABLE_CORRECTION="true"
# Uncomment the following line to display red dots whilst waiting for completion.
COMPLETION_WAITING_DOTS="true"
ZSH_CUSTOM="${HOME}/.zsh-custom"
ZSH_CACHE_DIR="${HOME}/.zsh-cache"

plugins=(
  alias-finder
  extract
  docker
  docker
  git 
  history-substring-search
  # sudo
  zsh-autosuggestions
  zsh-autocomplete
  zsh-syntax-highlighting 
  git-open
  # vi-mode
  git z 
)


ZSH_THEME="agnoster" # (this is one of the fancy ones)

# ZSH_THEME="powerlevel10k/powerlevel10k"

### Fix slowness of pastes with zsh-syntax-highlighting.zsh
pasteinit() {
  OLD_SELF_INSERT=${${(s.:.)widgets[self-insert]}[2,3]}
  zle -N self-insert url-quote-magic # I wonder if you'd need `.url-quote-magic`?
}
pastefinish() {
  zle -N self-insert $OLD_SELF_INSERT
}
zstyle :bracketed-paste-magic paste-init pasteinit
zstyle :bracketed-paste-magic paste-finish pastefinish

# source central scripts
source ~/.script/spec.sh

export NVM_DIR="$HOME/.nvm"
  [ -s "/usr/local/opt/nvm/nvm.sh" ] && \. "/usr/local/opt/nvm/nvm.sh"  # This loads nvm
  [ -s "/usr/local/opt/nvm/etc/bash_completion.d/nvm" ] && \. "/usr/local/opt/nvm/etc/bash_completion.d/nvm"  # This loads nvm bash_completion
