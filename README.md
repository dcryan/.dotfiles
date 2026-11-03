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

This will add a symbolic link for all hidden files here to the $HOME directory.
The '/' targets only the directories, and ignores all first root directory
files. The `--restow` will do a cleanup before doing another stow.

```
$ stow --restow */ 

```

> **Note: the `agents` package** (Claude Code, Codex and Pi config, shared skills
> and `AGENTS.md`) is a submodule, so fetch it first:
> `git submodule update --init agents`. Then create the tools' home dirs
> **before** stowing. Each one holds runtime state (sessions, auth, caches); if a
> dir is missing, stow folds it into a single symlink and that state gets written
> into the repo:
>
> ```
> $ mkdir -p ~/.claude ~/.codex ~/.pi/agent ~/.agents && stow --restow agents
> ```
>
> Submodules check out without a branch; put `agents` on `main` so commits made
> on the machine land on a branch and push normally:
> `git -C agents checkout main`.
>
> **Servers are the default.** On the VPS or any other Linux box, the plain
> `stow --restow agents` above is all it takes.
>
> **The MacBook is the exception.** Its Claude settings (tmux-agentbar hooks)
> and Codex config, rules and hooks are `*.mac*` files that the package's
> `.stow-local-ignore` never stows. Skip the server defaults and link the Mac
> files over them by hand (stow's `--ignore` matches the END of the path, so no
> `^/` anchor):
>
> ```
> $ stow --restow \
>     --ignore='\.claude/settings\.json' --ignore='\.codex/config\.toml' \
>     --ignore='\.codex/rules' agents
> $ ln -sfn ../.dotfiles/agents/.claude/settings.mac.json ~/.claude/settings.json
> $ ln -sfn ../.dotfiles/agents/.codex/config.mac.toml   ~/.codex/config.toml
> $ ln -sfn ../.dotfiles/agents/.codex/rules.mac         ~/.codex/rules
> $ ln -sfn ../.dotfiles/agents/.codex/hooks.mac.json    ~/.codex/hooks.json
> ```

3. Install Homebrew and packages.

This will install Homebrew, and `brew install` all packages and casks.

```
$ ./brew.sh
```

## Steps to Create a Brewfile

Overwrites the Brewfile

```
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
