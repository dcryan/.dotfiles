#!/usr/bin/env bash

# Check for Homebrew and install if we don't have it
if test ! $(which brew); then
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi

# Then pass in the Brewfile location
brew bundle --file ~/Development/dotfiles/Brewfile

# TODO:  Add SystemConfig folders from iCloud Drive
