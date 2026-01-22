##################
# Global Aliases (zsh and bash)
##################

# git init --bare $HOME/.cfg

alias config='/usr/bin/git --git-dir=$HOME/.cfg/ --work-tree=$HOME'
alias cfg='/usr/bin/git --git-dir=$HOME/.cfg/ --work-tree=$HOME'
alias cfgs='cfg status'
alias cfgd='cfg diff'
alias cfgp='cfg pull'
alias cfgu='cfg add ~/.config/nvim/ && cfg add -u && cfg commit -m "update" && cfg push'

# Search, find, grep and other locating
alias grep='grep --color=auto'
alias fgrep='fgrep --color=auto'
alias egrep='egrep --color=auto'
alias hg='history | grep'
alias hf='history | fzf'

alias eza="eza --icons"
alias lg="eza --long --header --icons --git --git-ignore"
alias ls="eza -F --color --icons"
alias l="eza -lAh"
alias ll="eza --color --reverse --sort=size"
alias la='eza -A --color'
alias lt='eza -T --color --level=3'

# Reload
alias reload!='. ~/.script/re-source.sh' # reload zshrc file
alias rel='reload!'                      # reload zshrc file
alias reload="exec ${SHELL} -l"          # restart shell

# Paths
alias pwd='echo ${PWD}'

# General
alias cope="copy echo "
alias cls='clear'
alias c='clear'
alias chm="chmod 777 "
alias pp='python3'
alias g='git'
alias rf='rm -rf'

# IP addresses and remote Management
alias certscan="openssl s_client -showcerts"
alias remoteip="dig +short myip.opendns.com @resolver1.opendns.com"
alias localip="ipconfig getifaddr en0"
alias ips="ifconfig -a | grep -o 'inet6\? \(addr:\)\?\s\?\(\(\([0-9]\+\.\)\{3\}[0-9]\+\)\|[a-fA-F0-9:]\+\)' | awk '{ sub(/inet6? (addr:)? ?/, \"\"); print }'"

# Shortcuts
alias cdown="cd ~/Downloads"
alias cdesk="cd ~/Desktop"
alias p="cd ${PROJECTS_DIR}"
alias ch="cd ~/"
alias cscratch="cd $SCRATCH_DIR"
alias cs="cd $SCRATCH_DIR"
alias gupdate="dot -u"
alias ca="cursor-agent"

alias dotenv='export $(xargs -L 1 <.env)'
alias grt='cd $(git rev-parse --show-toplevel)'

alias pc='cd $(find ~/projects -type d -maxdepth 1 | fzf)'
alias po='nvim $(find ~/projects -type d -maxdepth 1 | fzf)'
alias pcode='code $(find ~/projects -type d -maxdepth 1 | fzf)'

alias docgen="python3 <(curl https://raw.githubusercontent.com/Ollivanders/adam/master/main.py)"
alias cheese="python3 ~/.script/cheese.py"
alias org="gh gist edit '68faaea880a95eb3a3c66c717d1f9224'"

alias virmc="${EDITOR} ~/.config/nvim/init.vim"
alias ealiases="${EDITOR} ~/.aliases/local.bzsh"
alias n='nvim -c "lua vim.schedule(function() require(\"persistence\").load() end)"'
alias nn='nvim'
alias nc='cd ~/ && nvim ~/.config/nvim'
alias lg="lazygit"
alias co='codex'

alias au='auggie'
alias aus='auggie sesson continue'

alias path='echo -e ${PATH//:/\\n}'
alias emptytrash="sudo rm -rfv /Volumes/*/.Trashes; sudo rm -rfv ~/.Trash; sudo rm -rfv /private/var/log/asl/*.asl; sqlite3 ~/Library/Preferences/com.apple.LaunchServices.QuarantineEventsV* 'delete from LSQuarantineEvent'"

alias softwareupdate='sudo softwareupdate -i -a'
alias update='cfg pull; ${HOME}/.script/installBrew.sh; npm install npm -g; npm update -g;'
alias gemupdate='sudo gem update --system; sudo gem update; sudo gem cleanup'
alias bd="brew bundle dump --force --file ~/.homebrew/Brewfile"
alias bupdate="${HOME}/.script/installBrew.sh"

alias pwdc='pwd | copy'

alias spotify_current='osascript -e '\''tell application "Spotify" to if player state is playing then artist of current track & " – " & name of current track'\'''
