#!/usr/bin/env bash
#
# Settings for both bash and zsh

# all of our zsh and bash files
config_files=(~/.aliases/*.bzsh)

for file in "${config_files[@]}"; do
  source $file
done

function add_dir_to_path() {
  # add subdirecDocuments/projects/dotfiles/bintories from bin to path
  for directory in $(find "$1" -mindepth 1 -type d); do
    if [ -d "$directory" ]; then
      PATH=$PATH:$directory
      add_dir_to_path $directory
    fi
  done
  # symlink directories too
  for directory in $(find "$1" -mindepth 1 -type l); do
    if [ -d "$directory" ]; then
      PATH=$PATH:$directory
      add_dir_to_path $directory
    fi
  done
}

# add homebin to path
add_dir_to_path "${HOME}/.homebin"

# https://stackoverflow.com/questions/45635168/vscode-how-to-run-a-command-after-each-terminal-open
#
# Allow parent to initialize shell
#
# This is awesome for opening terminals in VSCode.
#
if [[ -n $INIT_COMMAND ]]; then
  echo "Running: $INIT_COMMAND"
  eval "$INIT_COMMAND"
fi

export PATH="$HOME/.yarn/bin:$HOME/.config/yarn/global/node_modules/.bin:$PATH"

if [[ -e ~/.localrc ]]; then
  source ~/.localrc
fi
