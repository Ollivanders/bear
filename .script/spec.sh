#!/usr/bin/env bash
#
# Settings for both bash and zsh

if [[ -a ~/.localrc ]]; then
  source ~/.localrc
fi

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
add_dir_to_path "~/.homebin"