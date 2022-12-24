# .dotfiles
> Warning: If you want to give these dotfiles a try, you should first fork this
> repository, review the code, and remove things you don’t want or need. Don’t
> blindly use my settings unless you know what that entails. Use at your own risk!

## Pre-requirements
- `git`
- [`brew`](https://brew.sh/)
- GNU [`stow`](https://www.gnu.org/software/stow/manual/stow.html) (`brew install stow`)
- Apple Commandline Tools (`xcode-select --install`)

### Brew

Install Brew [`here`](https://brew.sh/).

Once brew is installed run these commands. This will add brew to the path.
```
echo '# Set PATH, MANPATH, etc., for Homebrew.' >> /Users/danielryan/.zprofile
echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> /Users/danielryan/.zprofile
eval "$(/opt/homebrew/bin/brew shellenv)"
```

Install `stow`
```
brew install stow
```


## Steps to Bootstrap a New Mac
1. Clone repo

```
# Clone the dotfiles to ~/.dotfiles.
$ git clone git@github.com:dcryan/.dotfiles.git ~/.dotfiles
```

2. Symlink all dot files.

```
# this will add a symbolic link for all hidden files here to the $HOME directory.
$ stow */ # Everything (the '/' ignores the README)
```

3. Install Homebrew and packages.

```
# this will install Homebrew, and `brew install` all packages and casks.
$ ./brew.sh
```

## Steps to Create a Brewfile

```
# Overwrites the Brewfile
brew bundle --force dump
```

### Remove the clutter from the Brewfile
The `autoremove` command removes all the hanging, no longer needed packages
from your computer. So say goodbye to unneeded dependencies and messy brew list output.

```
brew autoremove
```

If you want to take your tidy-up routine to the next level, you can also
run `brew cleanup`. This command removes downloads for outdated formulas and casks.

```
brew cleanup
```

### Access iCloud Development folder
This has all the pre-install requirements such as:
* ssh keys

```
cd /Users/danielryan/Library/Mobile\ Documents/com~apple~CloudDocs/Development
stow */
```
