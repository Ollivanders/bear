#!/usr/bin/env bash
# all of our zsh and bash files

config_files=(
  ${HOME}/.aliases/*.zsh
  ${HOME}/.completions/*.zsh
)

if [[ -e "${HOME}/.devops_tools" ]]; then
  source ${HOME}/.devops_tools/*.zsh
fi

if [[ -e "${HOME}/.aliases/env.zsh" ]]; then
  source "${HOME}/.aliases/env.zsh"
fi
if [[ -e "${HOME}/.aliases/dirs.zsh" ]]; then
  source "${HOME}/.aliases/dirs.zsh"
fi

for file in "${config_files[@]}"; do
  source $file
done

function add_dir_to_path() {
  for directory in $(find "$1" -mindepth 1 -type d); do
    if [ -d $directory ]; then
      PATH=$PATH:$directory
      add_dir_to_path $directory
    fi
  done
}

add_dir_to_path "${HOME}/.homebin"
add_dir_to_path "${HOME}/.cargo/bin"

# https://stackoverflow.com/questions/45635168/vscode-how-to-run-a-command-after-each-terminal-open
# Allow parent to initialize shell
# awesome for opening terminals in VSCode.
if [[ -n $INIT_COMMAND ]]; then
  echo "Running: $INIT_COMMAND"
  eval "$INIT_COMMAND"
fi

if [[ -e ~/.localrc ]]; then
  source ~/.localrc
fi
