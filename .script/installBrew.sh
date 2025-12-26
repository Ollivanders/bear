#!/bin/sh
#
# Homebrew
#
# This installs some of the common dependencies needed (or at least desired)
# using Homebrew.

/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
cd ~/.homebrew

echo "Running Brew bundle for local brew file, update, upgrade and cleanup"
brew bundle install --file ~/.homebrew/Brewfile
brew update
brew upgrade
brew cleanup
brew doctor

exit 0
