# Awesome Dotfiles
> Warning: If you want to give these dotfiles a try, you should first fork this
> repository, review the code, and remove things you don’t want or need. Don’t
> blindly use my settings unless you know what that entails. Use at your own risk!

## Steps to Bootstrap a New Mac
1. Install Apples Command Line Tools, which are prerequisits for Git and Homebrew.

```
xcode-select --install
```

2. Clone repo into new hidden directory.

```
# Clone the dotfiles to ~/Development/dotfiles.
git clone git@github.com:dcryan/dotfiles.git ~/Development/dotfiles
```

3 Symlink all dot files.

```
# this will add a symbolic link for all hidden files here to the $HOME directory.
./bootstrap.sh
```

4. Install Homebrew and packages.

```
# this will install Homebrew, and `brew install` all packages and casks.
./brew.sh
```

To update, cd into your local dotfiles repository and then:

```
source bootstrap.sh
```

Alternatively, to update while avoiding the confirmation prompt:

```
set -- -f; source bootstrap.sh
```
