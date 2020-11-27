# Awesome Dotfiles

## Installation
Warning: If you want to give these dotfiles a try, you should first fork this
repository, review the code, and remove things you don’t want or need. Don’t
blindly use my settings unless you know what that entails. Use at your own risk!

Inspiration from:
- [mathiasbyans/dotfiles](https://github.com/mathiasbynens/dotfiles)
- [webpro/awesome-dotfiles](https://github.com/webpro/awesome-dotfiles)

### Using Git and the bootstrap script
You can clone the repository wherever you want. (I like to keep it in ~/Projects/dotfiles,
with ~/dotfiles as a symlink.) The bootstrapper script will pull in the latest
version and copy the files to your home folder.

```
git clone https://github.com/mathiasbynens/dotfiles.git && cd dotfiles && source bootstrap.sh
```

To update, cd into your local dotfiles repository and then:

```
source bootstrap.sh
```

Alternatively, to update while avoiding the confirmation prompt:

```
set -- -f; source bootstrap.sh
```
