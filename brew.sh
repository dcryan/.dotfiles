#!/usr/bin/env bash

# Check for Homebrew and install if we don't have it
if test ! $(which brew); then
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi

brew update
brew upgrade
brew tap homebrew/bundle
brew bundle


rm -rf $HOME/.zshrc
ln -s ./.zshrc $HOME/.zshrc

rm -rf $HOME/.tmux.conf
ln -s ./.tmux.conf $HOME/.tmux.conf


# TODO:  Add SystemConfig folders from iCloud Drive
