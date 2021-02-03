#!/usr/bin/env bash

function doIt() {
	ln -s  `pwd`/.aliases ~;
	ln -s  `pwd`/.exports ~;
	ln -s  `pwd`/.extra ~;
	ln -s  `pwd`/.functions ~;
	ln -s  `pwd`/.path ~;
	ln -s  `pwd`/.vimrc ~;
	ln -s  `pwd`/.zshrc ~;
	ln -s  `pwd`/.tmux.conf ~;
	ln -s  `pwd`/.gitconfig ~;
	ln -s  `pwd`/.gitignore_global ~;
}

if [ "$1" = "--force" -o "$1" = "-f" ]; then
	doIt;
else
	read -p "This may overwrite existing files in your home directory. Are you sure? (y/n) " REPLY;
	echo "";
	if [[ $REPLY =~ ^[Yy]$ ]]; then
		doIt;
	fi;
fi;
unset doIt;
