# .dotfiles
> Warning: If you want to give these dotfiles a try, you should first fork this
> repository, review the code, and remove things you don’t want or need. Don’t
> blindly use my settings unless you know what that entails. Use at your own risk!

## Pre-requirements
- `git`
- [`brew`](https://brew.sh/)
- GNU [`stow`](https://www.gnu.org/software/stow/manual/stow.html) (`brew install stow`)
- Apple Commandline Tools (`xcode-select --install`)

## Steps to Bootstrap a New Mac
1. Clone repo

```
# Clone the dotfiles to ~/.dotfiles.
git clone git@github.com:dcryan/dotfiles.git ~/.dotfiles
```

2. Symlink all dot files.

```
# this will add a symbolic link for all hidden files here to the $HOME directory.
stow */ # Everything (the '/' ignores the README)
```

3. Install Homebrew and packages.

```
# this will install Homebrew, and `brew install` all packages and casks.
./brew.sh
```
