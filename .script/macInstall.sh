#!/usr/local/bin/zsh
#
# Downloads and configures iterm and updates base software

if test ! "$(uname)" = "Darwin"; then
  exit 0
fi

#------------------------------------------------------------------------------
# Update Software
echo "› sudo softwareupdate -i -a"
sudo softwareupdate -i -a
#softwareupdate --all --install --force
